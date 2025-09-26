import 'package:equatable/equatable.dart';
import '../../../domain/entities/general/unit.dart';

class UnitState extends Equatable {
  final List<Unit> units;
  final bool isLoading;
  final String searchQuery;
  final List<Unit> filteredUnits;
  final String? error;
  final Unit? selectedUnit;

  const UnitState({
    this.units = const [],
    this.isLoading = false,
    this.searchQuery = '',
    this.filteredUnits = const [],
    this.error,
    this.selectedUnit,
  });

  bool get hasError => error != null;
  bool get hasUnits => units.isNotEmpty;

  List<Unit> get displayUnits =>
    searchQuery.isEmpty ? units : filteredUnits;

  UnitState copyWith({
    List<Unit>? units,
    bool? isLoading,
    String? searchQuery,
    List<Unit>? filteredUnits,
    String? error,
    Unit? selectedUnit,
  }) {
    return UnitState(
      units: units ?? this.units,
      isLoading: isLoading ?? this.isLoading,
      searchQuery: searchQuery ?? this.searchQuery,
      filteredUnits: filteredUnits ?? this.filteredUnits,
      error: error ?? this.error,
      selectedUnit: selectedUnit ?? this.selectedUnit,
    );
  }

  @override
  List<Object?> get props => [
    units,
    isLoading,
    searchQuery,
    filteredUnits,
    error,
    selectedUnit
  ];
}