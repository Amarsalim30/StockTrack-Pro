import 'package:clean_arch_app/domain/entities/auth/user.dart';
import 'package:clean_arch_app/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';

class GetCurrentUserUseCase {
  final AuthRepository _authRepository;

  GetCurrentUserUseCase(this._authRepository);

  Future<Either<Exception, User>> call() async {
    return await _authRepository.getCurrentUser();
  }
}
