import 'package:dartz/dartz.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class GetCurrentUserRole {
  final AuthRepository repository;

  GetCurrentUserRole(this.repository);

  Future<Either<Exception, UserRole>> call() async {
    final result = await repository.getCurrentUser();
    return result.fold((error) => Left(error), (user) => Right(user.role));
  }
}
