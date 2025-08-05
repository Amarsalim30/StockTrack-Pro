import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../../models/auth/user_model.dart';

abstract class AuthApi {
  Future<Map<String, dynamic>> login(String email, String password);

  Future<void> logout();

  Future<UserModel> getCurrentUser();

  Future<void> changePassword(String oldPassword, String newPassword);

  Future<void> resetPassword(String email);

  Future<Map<String, dynamic>> refreshToken();

  Future isLoggedIn() async {}

  Future getAuthToken() async {}
}

class AuthApiImpl implements AuthApi {
  final ApiClient _apiClient;

  AuthApiImpl(this._apiClient);

  @override
  Future isLoggedIn() async {}

  @override
  Future getAuthToken() async {}

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/auth/login',
      data: {'email': email, 'password': password},
    );
    return response;
  }

  @override
  Future<void> logout() async {
    await _apiClient.post('/auth/logout');
  }

  @override
  Future<UserModel> getCurrentUser() async {
    final response = await _apiClient.get<Map<String, dynamic>>('/auth/me');
    return UserModel.fromJson(response);
  }

  @override
  Future<void> changePassword(String oldPassword, String newPassword) async {
    await _apiClient.post(
      '/auth/change-password',
      data: {'oldPassword': oldPassword, 'newPassword': newPassword},
    );
  }

  @override
  Future<void> resetPassword(String email) async {
    await _apiClient.post('/auth/reset-password', data: {'email': email});
  }

  @override
  Future<Map<String, dynamic>> refreshToken() async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/auth/refresh',
    );
    return response;
  }
}
