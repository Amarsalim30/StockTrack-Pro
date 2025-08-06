import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/catalog/supplier_model.dart';
import 'mock_data.dart'; // contains List<Supplier> mockSuppliers
import '../../domain/entities/catalog/supplier.dart';

// Sorting & Status enums
enum SortOption { name, recent, location }
enum Status { active, inactive }


// ViewModelclass SupplierViewModel extends StateNotifier<List<SupplierModel>> {
  SupplierViewModel(): super
(
mockSuppliers.map((e) => SupplierModel.fromDomain(e)).toList());void addSupplier(Supplier supplier) {
final newSupplier = SupplierModel.fromDomain(supplier);
    state = [...state, newSupplier];
  }

  void editSupplier(String id, Supplier updatedSupplier) {
final updatedModel = SupplierModel.fromDomain(updatedSupplier);
    state = [
      for (final supplier in state)
        if (supplier.id == id) updatedModel else supplier,
    ];
  }

  void deleteSupplier(String id) {
    state = state.where((supplier) => supplier.id != id).toList();
}void searchSuppliers(String query) {
    final q = query.toLowerCase();
    final filtered = state.where((supplier) {
final contactPerson = supplier.contactInfo?['contactPerson'] ?? '';
final email = supplier.contactInfo?['email'] ?? '';
      return supplier.name.toLowerCase().contains(q) ||
contactPerson.toLowerCase().contains(q) ||
email.toLowerCase().contains(q);
    }).toList();

    state = filtered;
}void filterByStatus(Status status) {
// Note: Status filtering would need to be added to the Supplier entity
// For now, this is a placeholder
state = state.where((supplier) => true).toList();
  }

  void sortBy(SortOption option) {
    final sorted = [...state];

    switch (option) {
      case SortOption.name:
        sorted.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortOption.recent:
// Note: createdAt would need to be added to the Supplier entity
// For now, sorting by name as fallback
sorted.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortOption.location:
final locationA = a.contactInfo?['city'] ?? '';
final locationB = b.contactInfo?['city'] ?? '';
sorted.sort((a, b) => locationA.compareTo(locationB));
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
