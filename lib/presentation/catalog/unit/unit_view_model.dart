import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/general/unit.dart';
import '../../../domain/usecases/general/unit/unit_usecases.dart';
import 'unit_state.dart';

class UnitViewModel extends StateNotifier<UnitState> {
  final UnitUseCases _useCases;

  UnitViewModel(this._useCases) : super(const UnitState()) {
    _init();
  }

  void _init() {
    fetchAllUnits();
  }

  Future<void> fetchAllUnits() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _useCases.getAllUnits();

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.toString(),
      ),
      (units) => state = state.copyWith(
        isLoading: false,
        units: units,
        error: null,
      ),
    );
  }

  Future<void> createUnit(Unit unit) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _useCases.createUnit(unit);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.toString(),
      ),
      (newUnit) {
        final updatedUnits = [...state.units, newUnit];
        state = state.copyWith(
          isLoading: false,
          units: updatedUnits,
          error: null,
        );
      },
    );
  }

  Future<void> updateUnit(Unit unit) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _useCases.updateUnit(unit);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.toString(),
      ),
      (updatedUnit) {
        final updatedUnits = state.units
            .map((unit) => unit.id == updatedUnit.id ? updatedUnit : unit)
            .toList();
        state = state.copyWith(
          isLoading: false,
          units: updatedUnits,
          error: null,
        );
      },
    );
  }

  Future<void> deleteUnit(String id) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _useCases.deleteUnit(id);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.toString(),
      ),
      (_) {
        final updatedUnits = state.units
            .where((unit) => unit.id != id)
            .toList();
        state = state.copyWith(
          isLoading: false,
          units: updatedUnits,
          error: null,
        );
      },
    );
  }

  void updateSearch(String query) {
    state = state.copyWith(searchQuery: query);

    if (query.isEmpty) {
      state = state.copyWith(filteredUnits: []);
    } else {
      final filtered = state.units
          .where((unit) =>
              unit.name.toLowerCase().contains(query.toLowerCase()) ||
              (unit.description?.toLowerCase().contains(query.toLowerCase()) ?? false))
          .toList();
      state = state.copyWith(filteredUnits: filtered);
    }
  }

  void selectUnit(Unit? unit) {
    state = state.copyWith(selectedUnit: unit);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}