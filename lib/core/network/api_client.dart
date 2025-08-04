import 'dart:convert';
import 'package:dio/dio.dart';
import '../error/exceptions.dart';
import '../../data/datasources/local/cache_service.dart';

class ApiClient {
  final Dio dio;
  final CacheService? _cacheService;

  ApiClient({Dio? dio, CacheService? cacheService})
    : dio = dio ?? Dio(),
      _cacheService = cacheService {
    this.dio.options.baseUrl = 'http://localhost:8080/api';
    this.dio.options.connectTimeout = const Duration(seconds: 30);
    this.dio.options.receiveTimeout = const Duration(seconds: 30);
    this.dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Add interceptors
    this.dio.interceptors.addAll([
      // Request interceptor to add auth token
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add auth token if available
          if (_cacheService != null) {
            final token = await _cacheService!.getString(CacheKeys.authToken);
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          // Handle 401 Unauthorized errors
          if (error.response?.statusCode == 401 && _cacheService != null) {
            // Try to refresh token
            final refreshToken = await _cacheService!.getString(
              CacheKeys.refreshToken,
            );
            if (refreshToken != null) {
              try {
                final newToken = await _refreshToken(refreshToken);
                if (newToken != null) {
                  // Retry original request with new token
                  error.requestOptions.headers['Authorization'] =
                      'Bearer $newToken';
                  final response = await this.dio.fetch(error.requestOptions);
                  return handler.resolve(response);
                }
              } catch (e) {
                // Refresh token failed, clear tokens and propagate error
                await _cacheService!.remove(CacheKeys.authToken);
                await _cacheService!.remove(CacheKeys.refreshToken);
              }
            }
          }
          handler.next(error);
        },
      ),
      // Logging interceptor
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        error: true,
        logPrint: (log) => print('API: $log'),
      ),
    ]);
  }

  void setAuthToken(String token) {
    dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void removeAuthToken() {
    dio.options.headers.remove('Authorization');
  }

  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data as T;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<T> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data as T;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<T> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data as T;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<T> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data as T;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException('Connection timeout');
      case DioExceptionType.connectionError:
        return NetworkException('No internet connection');
      case DioExceptionType.badResponse:
        return _handleStatusCode(error.response);
      case DioExceptionType.cancel:
        return NetworkException('Request cancelled');
      default:
        return NetworkException('Unknown error occurred');
    }
  }

  Exception _handleStatusCode(Response? response) {
    if (response == null) {
      return ServerException('No response from server');
    }

    final message = _getErrorMessage(response.data);

    switch (response.statusCode) {
      case 400:
        return ValidationException(message ?? 'Bad request');
      case 401:
        return UnauthorizedException(message ?? 'Unauthorized');
      case 404:
        return NotFoundException(message ?? 'Resource not found');
      case 409:
        return ConflictException(message ?? 'Conflict error');
      case 500:
      case 502:
      case 503:
        return ServerException(message ?? 'Server error');
      default:
        return ServerException(message ?? 'Unknown error');
    }
  }

  String? _getErrorMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data.containsKey('message')) {
        return data['message'] as String?;
      } else if (data.containsKey('error')) {
        return data['error'] as String?;
      }
    } else if (data is String) {
      return data;
    }
    return null;
  }

  Future<String?> _refreshToken(String refreshToken) async {
    try {
      final response = await dio.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      if (response.data != null && response.data!.containsKey('accessToken')) {
        final newToken = response.data!['accessToken'] as String;
        if (_cacheService != null) {
          await _cacheService!.setString(CacheKeys.authToken, newToken);
          if (response.data!.containsKey('refreshToken')) {
            await _cacheService!.setString(
              CacheKeys.refreshToken,
              response.data!['refreshToken'] as String,
            );
          }
        }
        return newToken;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
