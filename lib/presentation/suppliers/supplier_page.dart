import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/catalog/supplier.dart';
import 'supplier_view_model.dart';

class SupplierPage extends ConsumerWidget {
  const SupplierPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suppliers = ref.watch(supplierViewModelProvider); // ⬅ state (list)
    final viewModel = ref.watch(supplierViewModelProvider.notifier); // ⬅ logic

    return Scaffold(
      appBar: AppBar(
        title: const Text('Suppliers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearch(context, viewModel),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterOptions(context, viewModel),
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () => _showSortOptions(context, viewModel),
          ),
        ],
      ),
      body: suppliers.isEmpty
          ? const Center(child: Text('No suppliers found.'))
          : ListView.builder(
              itemCount: suppliers.length,
              itemBuilder: (context, index) {
                final supplier = suppliers[index];
                return ListTile(
                  title: Text(supplier.name),
                  subtitle: Text(supplier.contactInfo?['contactPerson'] ?? '—'),
                  trailing: _buildActions(context, viewModel, supplier),
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addSupplier(context, viewModel),
        child: const Icon(Icons.add),
      ),
    );
  }

  // Actions
  void _showSearch(BuildContext context, SupplierViewModel viewModel) {
    // TODO: Implement search UI and call viewModel.searchSuppliers()
  }

  void _showFilterOptions(BuildContext context, SupplierViewModel viewModel) {
    // TODO: Implement filter UI and call viewModel.filterByStatus()
  }

  void _showSortOptions(BuildContext context, SupplierViewModel viewModel) {
    // TODO: Implement sort UI and call viewModel.sortBy()
  }

  Widget _buildActions(
    BuildContext context,
    SupplierViewModel viewModel,
    Supplier supplier,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => _editSupplier(context, viewModel, supplier),
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => _deleteSupplier(context, viewModel, supplier),
        ),
      ],
    );
  }

  void _addSupplier(BuildContext context, SupplierViewModel viewModel) {
    // TODO: Implement add form or dialog
  }

  void _editSupplier(
    BuildContext context,
    SupplierViewModel viewModel,
    Supplier supplier,
  ) {
    // TODO: Implement edit logic
  }

  void _deleteSupplier(BuildContext context,
      SupplierViewModel viewModel,
    Supplier supplier,
  ) {
    viewModel.deleteSupplier(supplier.id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Supplier deleted')),
    );
  }
}
