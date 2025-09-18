import 'package:stocktrack_pro/core/error/failures.dart';
import 'package:stocktrack_pro/domain/entities/auth/user.dart';
import 'package:stocktrack_pro/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  Future<Either<Exception, User>> call(String username, String password) async {
    return await _authRepository.login(username, password);
  }
}
