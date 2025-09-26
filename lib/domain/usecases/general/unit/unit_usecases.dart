import 'get_all_units_usecase.dart';
import 'get_unit_by_id_usecase.dart';
import 'create_unit_usecase.dart';
import 'update_unit_usecase.dart';
import 'delete_unit_usecase.dart';
import 'search_units_usecase.dart';
import '../../../repositories/unit_repository.dart';

class UnitUseCases {
  final GetAllUnitsUseCase getAllUnits;
  final GetUnitByIdUseCase getUnitById;
  final CreateUnitUseCase createUnit;
  final UpdateUnitUseCase updateUnit;
  final DeleteUnitUseCase deleteUnit;
  final SearchUnitsUseCase searchUnits;

  UnitUseCases({
    required this.getAllUnits,
    required this.getUnitById,
    required this.createUnit,
    required this.updateUnit,
    required this.deleteUnit,
    required this.searchUnits,
  });

  factory UnitUseCases.fromRepository(UnitRepository repository) {
    return UnitUseCases(
      getAllUnits: GetAllUnitsUseCase(repository),
      getUnitById: GetUnitByIdUseCase(repository),
      createUnit: CreateUnitUseCase(repository),
      updateUnit: UpdateUnitUseCase(repository),
      deleteUnit: DeleteUnitUseCase(repository),
      searchUnits: SearchUnitsUseCase(repository),
    );
  }
}