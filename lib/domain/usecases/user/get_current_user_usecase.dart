import 'package:clean_arch_app/domain/entities/auth/user.dart';
import 'package:clean_arch_app/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';

class GetCurrentUserUseCase {
  final UserRepository repository;
  GetCurrentUserUseCase(this.repository);

  Future<Either<Exception, User>> call() async {
    try{
    return await repository.getCurrentUser();
  }
  catch (e) {
      return Left(Exception('Failed to get current user: $e'.toString()));
    }
  }
}