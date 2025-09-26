import 'package:dartz/dartz.dart' hide Unit;
import '../../../entities/general/unit.dart';
import '../../../repositories/unit_repository.dart';
import '../../../../core/error/failures.dart';

class GetUnitByIdUseCase {
  final UnitRepository repository;

  GetUnitByIdUseCase(this.repository);

  Future<Either<Failure, Unit>> call(String id) async {
    return await repository.getUnitById(id);
  }
}