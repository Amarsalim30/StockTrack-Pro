import 'package:dartz/dartz.dart';
import '../../../repositories/unit_repository.dart';
import '../../../../core/error/failures.dart';

class DeleteUnitUseCase {
  final UnitRepository repository;

  DeleteUnitUseCase(this.repository);

  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteUnit(id);
  }
}