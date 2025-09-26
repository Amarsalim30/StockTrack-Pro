import 'package:dartz/dartz.dart' hide Unit;
import '../../../entities/general/unit.dart';
import '../../../repositories/unit_repository.dart';
import '../../../../core/error/failures.dart';

class SearchUnitsUseCase {
  final UnitRepository repository;

  SearchUnitsUseCase(this.repository);

  Future<Either<Failure, List<Unit>>> call(String query) async {
    return await repository.searchUnits(query);
  }
}