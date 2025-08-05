import 'package:dartz/dartz.dart';
import '../../domain/entities/auth/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/auth_api.dart';
import '../../core/error/exceptions.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApi _authApi;

  AuthRepositoryImpl(this._authApi);

  @override
  Future<Either<Exception, User>> login(String email, String password) async {
    try {
      final userModel = await _authApi.login(email, password);
      return Right(userModel as User);
    } catch (e) {
      return Left(_mapToException(e));
    }
  }

  @override
  Future<Either<Exception, void>> logout() async {
    try {
      await _authApi.logout();
      return const Right(null);
    } catch (e) {
      return Left(_mapToException(e));
    }
  }

  @override
  Future<Either<Exception, User>> getCurrentUser() async {
    try {
      final userModel = await _authApi.getCurrentUser();
      return Right(userModel as User);
    } catch (e) {
      return Left(_mapToException(e));
    }
  }

  @override
  Future<Either<Exception, bool>> isLoggedIn() async {
    try {
      final isLogged = await _authApi.isLoggedIn();
      return Right(isLogged);
    } catch (e) {
      return Left(_mapToException(e));
    }
  }

  @override
  Future<Either<Exception, void>> changePassword(
    String oldPassword,
    String newPassword,
  ) async {
    try {
      await _authApi.changePassword(oldPassword, newPassword);
      return const Right(null);
    } catch (e) {
      return Left(_mapToException(e));
    }
  }

  @override
  Future<Either<Exception, void>> resetPassword(String email) async {
    try {
      await _authApi.resetPassword(email);
      return const Right(null);
    } catch (e) {
      return Left(_mapToException(e));
    }
  }

  @override
  Future<Either<Exception, String>> getAuthToken() async {
    try {
      final token = await _authApi.getAuthToken();
      return Right(token);
    } catch (e) {
      return Left(_mapToException(e));
    }
  }

  @override
  Future<Either<Exception, void>> refreshToken() async {
    try {
      await _authApi.refreshToken();
      return const Right(null);
    } catch (e) {
      return Left(_mapToException(e));
    }
  }

  Exception _mapToException(dynamic e) {
    // You can expand this later with proper error mapping
    return e is Exception ? e : ServerException(e.toString());
  }
}
