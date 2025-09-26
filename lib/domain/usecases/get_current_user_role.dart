import 'package:stocktrack_pro/domain/entities/auth/role.dart';
import 'package:dartz/dartz.dart';
import '../repositories/auth_repository.dart';

class GetCurrentUserRole {
  final AuthRepository repository;

  GetCurrentUserRole(this.repository);

  Future<Either<Exception, Role>> call() async {
    final result = await repository.getCurrentUser();
    return result.fold((error) => Left(error), (user) => Right(user.role));
  }
}
