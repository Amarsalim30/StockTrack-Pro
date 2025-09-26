import 'package:dartz/dartz.dart' hide Unit;
import '../../../entities/general/unit.dart';
import '../../../repositories/unit_repository.dart';
import '../../../../core/error/failures.dart';

class CreateUnitUseCase {
  final UnitRepository repository;

  CreateUnitUseCase(this.repository);

  Future<Either<Failure, Unit>> call(Unit unit) async {
    return await repository.createUnit(unit);
  }
}