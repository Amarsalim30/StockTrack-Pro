import 'package:stocktrack_pro/domain/usecases/catalog/supplier/supplier_usecases.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/catalog/supplier.dart';
import 'supplier_state.dart';

class SupplierViewModel extends StateNotifier<SupplierState> {
  final SupplierUseCases useCases;

  SupplierViewModel({required this.useCases})
      : super(const SupplierState(suppliers: [])) {
    loadSuppliers();
  }

  Future<void> loadSuppliers() async {
    state = state.copyWith(isLoading: true);
    final result = await useCases.getAllSuppliers();
    result.fold(
          (failure) => state = state.copyWith(isLoading: false, error: failure.toString()),
          (suppliers) => state = state.copyWith(isLoading: false, suppliers: suppliers),
    );
  }

  Future<void> addNewSupplier(Supplier supplier) async {
    final result = await useCases.createSupplier(supplier);
    // result.fold(
    //       (failure) => state = state.copyWith(error: failure.message),
          (_) => loadSuppliers();
    // );
  }

  Future<void> updateSupplier(String id, Supplier updatedSupplier) async {
    final result = await useCases.updateSupplier( updatedSupplier);
    // result.fold(
    //       (failure) => state = state.copyWith(error: failure.message),
          (_) => loadSuppliers();
    // );
  }

  Future<void> removeSupplier(String id) async {
    final result = await useCases.deleteSupplier(id);
    // result.fold(
    //       (failure) => state = state.copyWith(error: failure.message),
           loadSuppliers();
    // );
  }

  Future<void> search(String query) async {
    final result = await useCases.searchSuppliers(query);
    result.fold(
          (failure) => state = state.copyWith(error: failure.toString()),
          (suppliers) => state = state.copyWith(suppliers: suppliers),
    );
  }

  void sortBy(String sortOption) {
    final sorted = [...state.suppliers];

    switch (sortOption) {
      case 'name_asc':
        sorted.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'name_desc':
        sorted.sort((a, b) => b.name.compareTo(a.name));
        break;
      case 'date_asc':
        sorted.sort((a, b) => a.id.compareTo(b.id)); // Placeholder for createdAt
        break;
      case 'date_desc':
        sorted.sort((a, b) => b.id.compareTo(a.id)); // Placeholder for createdAt
        break;
    }

    state = state.copyWith(suppliers: sorted);
  }

  Future<void> searchSuppliers(String query) async {
    state = state.copyWith(isLoading: true);
    final result = await useCases.searchSuppliers(query);
    result.fold(
      (failure) => state = state.copyWith(isLoading: false, error: failure.toString()),
      (suppliers) => state = state.copyWith(isLoading: false, suppliers: suppliers),
    );
  }

  void filterByStatus(bool isActive) {
    // Since Supplier doesn't have isActive field, we'll implement this filter logic
    // based on other criteria or add the field to the entity later
    // For now, just return all suppliers
    final filtered = state.suppliers;
    state = state.copyWith(suppliers: filtered);
  }

  void clearFilters() {
    loadSuppliers(); // Reload all suppliers
  }
}


