import 'package:clean_arch_app/domain/usecases/catalog/supplier/supplier_usecases.dart';
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

  void sortBy(SortOption option) {
    final sorted = [...state.suppliers];

    switch (option) {
      case SortOption.name:
        sorted.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortOption.recent:
        sorted.sort((a, b) => a.id.compareTo(b.id)); // Placeholder for createdAt
        break;
      case SortOption.location:
        sorted.sort((a, b) {
          final locationA = a.contactInfo?['city'] ?? '';
          final locationB = b.contactInfo?['city'] ?? '';
          return locationA.compareTo(locationB);
        });
        break;
    }

    state = state.copyWith(suppliers: sorted, sortOption: option);
  }
}


