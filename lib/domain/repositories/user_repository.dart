import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/auth/user.dart';

abstract class UserRepository {
  Future<Either<Failure, List<User>>> getAllUsers();

  Future<Either<Failure, User>> getUserById(String id);

  Future<Either<Failure, void>> createUser(User user);

  Future<Either<Failure, void>> updateUser(User user);

  Future<Either<Failure, void>> updateUserPermissions(
    String id,
    List<String> permissions,
  );

  Future<Either<Failure, void>> resetUserPassword(String id);

  Future<Either<Failure, List<User>>> fetchUsers();

  Future<Either<Failure, User>> toggleUserStatus(String id);

  Future<Either<Failure, void>> deleteUser(String id);

  Future<Either<Exception, List<User>>> searchUsers(String query);

  Future<Either<Exception ,User>> getCurrentUser() ;
}
