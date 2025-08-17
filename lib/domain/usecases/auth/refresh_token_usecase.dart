import 'package:clean_arch_app/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class RefreshTokenUseCase {
  final AuthRepository _authRepository;

  RefreshTokenUseCase(this._authRepository);

  Future<Either<Exception, void>> call(String refreshToken) async {
    return await _authRepository.refreshToken();
  }
}
