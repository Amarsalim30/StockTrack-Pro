import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/auth/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../models/auth/user_model.dart';
import '../datasources/remote/user_api.dart';

class UserRepositoryImpl implements UserRepository {
  final UserApi _userApi;

  UserRepositoryImpl(this._userApi);

  @override
  Future<Either<Failure, List<User>>> getAllUsers() async {
    try {
      final models = await _userApi.getAllUsers();
      final users = models.map((model) => model.toEntity()).toList();
      return Right(users);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getUserById(String id) async {
    try {
      final model = await _userApi.getUserById(id);
      return Right(model.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createUser(User user) async {
    try {
      final model = UserModel.fromEntity(user);
      await _userApi.createUser(model);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateUser(User user) async {
    try {
      final model = UserModel.fromEntity(user);
      await _userApi.updateUser(model);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser(String id) async {
    try {
      await _userApi.deleteUser(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserPermissions(
    String id,
    List<String> permissions,
  ) async {
    try {
      await _userApi.updateUserPermissions(id, permissions);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<User>>> fetchUsers() async {
    try {
      final models = await _userApi.getAllUsers();
      final users = models.map((model) => model.toEntity()).toList();
      return Right(users);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetUserPassword(String id) async {
    try {
      await _userApi.resetUserPassword(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Exception, List<User>>> searchUsers(String query) async {
    try {
      final models = await _userApi.searchUsers(query);
      final users = models.map((model) => model.toEntity()).toList();
      return Right(users);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> toggleUserStatus(String id) async {
    try {
      final model = await _userApi.toggleUserStatus(id);
      return Right(model.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // Add more methods as needed like toggleUserStatus, getStats, etc.
}
