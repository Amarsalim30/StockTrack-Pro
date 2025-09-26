import 'package:dartz/dartz.dart' hide Unit;
import '../../../entities/general/unit.dart';
import '../../../repositories/unit_repository.dart';
import '../../../../core/error/failures.dart';

class GetAllUnitsUseCase {
  final UnitRepository repository;

  GetAllUnitsUseCase(this.repository);

  Future<Either<Failure, List<Unit>>> call() async {
    return await repository.getAllUnits();
  }
}