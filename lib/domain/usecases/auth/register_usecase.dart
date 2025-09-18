import 'package:stocktrack_pro/domain/entities/auth/user.dart';
import 'package:stocktrack_pro/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
class RegisterUseCase {
  final AuthRepository _authRepository;

  RegisterUseCase(this._authRepository);

  Future<Either<Exception, User>> call({
    required String username,
    required String email,
    required String password,
  }) async {
    return await _authRepository.register(username, email, password);
  }
}
