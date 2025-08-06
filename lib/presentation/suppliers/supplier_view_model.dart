import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/catalog/supplier_model.dart';
import 'mock_data.dart'; // contains List<Supplier> mockSuppliers
import '../../domain/entities/catalog/supplier.dart';

// Sorting & Status enums
enum SortOption { name, recent, location }
enum Status { active, inactive }


// ViewModel
class SupplierViewModel extends StateNotifier<List<SupplierModel>> {
  SupplierViewModel()
    : super(mockSuppliers.map((e) => SupplierModel.fromEntity(e)).toList());

  void addSupplier(Supplier supplier) {
    final newSupplier = SupplierModel.fromEntity(supplier);
    state = [...state, newSupplier];
  }

  void editSupplier(String id, Supplier updatedSupplier) {
    final updatedModel = SupplierModel.fromEntity(updatedSupplier);
    state = [
      for (final supplier in state)
        if (supplier.id == id) updatedModel else supplier,
    ];
  }

  void deleteSupplier(String id) {
    state = state.where((supplier) => supplier.id != id).toList();
  }

  void searchSuppliers(String query) {
    final q = query.toLowerCase();
    final filtered = state.where((supplier) {
      return supplier.name.toLowerCase().contains(q) ||
          supplier.contactPerson!.toLowerCase().contains(q) ||
          supplier.email!.toLowerCase().contains(q);
    }).toList();

    state = filtered;
  }

  void filterByStatus(Status status) {
    state = state.where((supplier) => supplier.status == status.name).toList();
  }

  void sortBy(SortOption option) {
    final sorted = [...state];

    switch (option) {
      case SortOption.name:
        sorted.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortOption.recent:
        sorted.sort((a, b) => b.createdAt!.compareTo(a.createdAt!.toLocal()));
        break;
      case SortOption.location:
        sorted.sort((a, b) => a.location.compareTo(b.location));
        break;
    }

    state = sorted;
  }
}

// Provider
final supplierViewModelProvider =
StateNotifierProvider<SupplierViewModel, List<SupplierModel>>((ref) {
      return SupplierViewModel();
    });
