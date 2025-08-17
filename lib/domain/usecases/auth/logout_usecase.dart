import 'package:clean_arch_app/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class LogoutUseCase {
  final AuthRepository _authRepository;

  LogoutUseCase(this._authRepository);

  Future<Either<Exception, void>> call() async {
    return await _authRepository.logout();
  }
}
