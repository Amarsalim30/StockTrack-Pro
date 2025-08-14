import '../../domain/entities/catalog/supplier.dart';

enum SortOption { name, recent, location }
enum Status { active, inactive }

class SupplierState {
  final List<Supplier> suppliers;
  final bool isLoading;
  final String? error;
  final SortOption sortOption;
  final Status? filterStatus;

  const SupplierState({
    required this.suppliers,
    this.isLoading = false,
    this.error,
    this.sortOption = SortOption.name,
    this.filterStatus,
  });

  bool get isEmpty => suppliers.isEmpty;

  SupplierState copyWith({
    List<Supplier>? suppliers,
    bool? isLoading,
    String? error,
    SortOption? sortOption,
    Status? filterStatus,
  }) {
    return SupplierState(
      suppliers: suppliers ?? this.suppliers,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      sortOption: sortOption ?? this.sortOption,
      filterStatus: filterStatus ?? this.filterStatus,
    );
  }
}
