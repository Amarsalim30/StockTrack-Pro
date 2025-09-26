import 'package:dartz/dartz.dart' hide Unit;
import '../../core/error/failures.dart';
import '../../domain/entities/general/unit.dart';
import '../../domain/repositories/unit_repository.dart';
import '../datasources/remote/unit_api.dart';
import '../mappers/general/unit_mapper.dart';

class UnitRepositoryImpl implements UnitRepository {
  final UnitApi api;

  UnitRepositoryImpl(this.api);

  @override
  Future<Either<Failure, List<Unit>>> getAllUnits() async {
    try {
      final models = await api.getAllUnits();
      final entities = models.map((model) => UnitMapper.toEntity(model)).toList();
      return Right(entities);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> getUnitById(String id) async {
    try {
      final model = await api.getUnitById(id);
      return Right(UnitMapper.toEntity(model));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Unit>>> searchUnits(String query) async {
    try {
      final models = await api.searchUnits(query);
      final entities = models.map((model) => UnitMapper.toEntity(model)).toList();
      return Right(entities);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> createUnit(Unit unit) async {
    try {
      final model = UnitMapper.fromEntity(unit);
      final result = await api.createUnit(model);
      return Right(UnitMapper.toEntity(result));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateUnit(Unit unit) async {
    try {
      final model = UnitMapper.fromEntity(unit);
      final result = await api.updateUnit(unit.id, model);
      return Right(UnitMapper.toEntity(result));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUnit(String id) async {
    try {
      await api.deleteUnit(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}