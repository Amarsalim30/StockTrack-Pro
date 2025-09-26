import 'package:dartz/dartz.dart' hide Unit;
import '../../../domain/entities/general/unit.dart';
import '../../../domain/repositories/unit_repository.dart';
import '../../../core/error/failures.dart';
import '../../datasources/remote/general/unit_firebase_data_source.dart';
import '../../mappers/general/unit_mapper.dart';

class UnitRepositoryImpl implements UnitRepository {
  final UnitFirebaseDataSource _firebaseDataSource;

  UnitRepositoryImpl(this._firebaseDataSource);

  @override
  Future<Either<Failure, List<Unit>>> getAllUnits() async {
    final result = await _firebaseDataSource.getAllUnits();
    return result.fold(
      (exception) => Left(ServerFailure(message: exception.toString())),
      (models) => Right(models.map(UnitMapper.toEntity).toList()),
    );
  }

  @override
  Future<Either<Failure, Unit>> getUnitById(String id) async {
    final result = await _firebaseDataSource.getUnitById(id);
    return result.fold(
      (exception) => Left(ServerFailure(message: exception.toString())),
      (model) => Right(UnitMapper.toEntity(model)),
    );
  }

  @override
  Future<Either<Failure, Unit>> createUnit(Unit unit) async {
    final model = UnitMapper.fromEntity(unit);
    final result = await _firebaseDataSource.createUnit(model);
    return result.fold(
      (exception) => Left(ServerFailure(message: exception.toString())),
      (model) => Right(UnitMapper.toEntity(model)),
    );
  }

  @override
  Future<Either<Failure, Unit>> updateUnit(Unit unit) async {
    final model = UnitMapper.fromEntity(unit);
    final result = await _firebaseDataSource.updateUnit(model);
    return result.fold(
      (exception) => Left(ServerFailure(message: exception.toString())),
      (model) => Right(UnitMapper.toEntity(model)),
    );
  }

  @override
  Future<Either<Failure, void>> deleteUnit(String id) async {
    final result = await _firebaseDataSource.deleteUnit(id);
    return result.fold(
      (exception) => Left(ServerFailure(message: exception.toString())),
      (success) => const Right(null),
    );
  }

  @override
  Future<Either<Failure, List<Unit>>> searchUnits(String query) async {
    final result = await _firebaseDataSource.searchUnits(query);
    return result.fold(
      (exception) => Left(ServerFailure(message: exception.toString())),
      (models) => Right(models.map(UnitMapper.toEntity).toList()),
    );
  }
}