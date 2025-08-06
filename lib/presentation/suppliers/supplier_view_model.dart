import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'mock_data.dart'; // contains List<Supplier> mockSuppliers
import '../../domain/entities/catalog/supplier.dart';

// Sorting & Status enums
enum SortOption { name, recent, location }
enum Status { active, inactive }


// ViewModel
class SupplierViewModel extends StateNotifier<List<Supplier>> {
  SupplierViewModel() : super(mockSuppliers);

  void addSupplier(Supplier supplier) {
    state = [...state, supplier];
  }

  void editSupplier(String id, Supplier updatedSupplier) {
    state = [
      for (final supplier in state)
        if (supplier.id == id) updatedSupplier else supplier,
    ];
  }

  void deleteSupplier(String id) {
    state = state.where((supplier) => supplier.id != id).toList();
  }

  void searchSuppliers(String query) {
    final q = query.toLowerCase();
    final filtered = state.where((supplier) {
      final contactPerson = supplier.contactInfo?['contactPerson'] ?? '';
      final email = supplier.contactInfo?['email'] ?? '';
      return supplier.name.toLowerCase().contains(q) ||
          contactPerson.toLowerCase().contains(q) ||
          email.toLowerCase().contains(q);
    }).toList();

    state = filtered;
  }

  void filterByStatus(Status status) {
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
        sorted.sort((a, b) {
          final locationA = a.contactInfo?['city'] ?? '';
          final locationB = b.contactInfo?['city'] ?? '';
          return locationA.compareTo(locationB);
        });
        break;
    }

    state = sorted;
  }
}

// Provider
final supplierViewModelProvider =
StateNotifierProvider<SupplierViewModel, List<Supplier>>((ref) {
      return SupplierViewModel();
    });
