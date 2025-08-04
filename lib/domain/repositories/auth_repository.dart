import 'package:dartz/dartz.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Exception, User>> login(String email, String password);

  Future<Either<Exception, void>> logout();

  Future<Either<Exception, User>> getCurrentUser();

  Future<Either<Exception, bool>> isLoggedIn();

  Future<Either<Exception, void>> changePassword(
    String oldPassword,
    String newPassword,
  );

  Future<Either<Exception, void>> resetPassword(String email);

  Future<Either<Exception, String>> getAuthToken();

  Future<Either<Exception, void>> refreshToken();
}
