import 'package:dartz/dartz.dart' hide Unit;
import '../entities/general/unit.dart';
import '../../core/error/failures.dart';

abstract class UnitRepository {
  Future<Either<Failure, List<Unit>>> getAllUnits();
  Future<Either<Failure, Unit>> getUnitById(String id);
  Future<Either<Failure, List<Unit>>> searchUnits(String query);
  Future<Either<Failure, Unit>> createUnit(Unit unit);
  Future<Either<Failure, Unit>> updateUnit(Unit unit);
  Future<Either<Failure, void>> deleteUnit(String id);
}