import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../di/injection.dart';
import '../../domain/entities/catalog/supplier.dart';
import 'supplier_view_model.dart';

class SupplierPage extends ConsumerWidget {
  const SupplierPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suppliersState = ref.watch(supplierViewModelProvider); // ⬅ state (list)
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
      body: suppliersState.suppliers.isEmpty
          ? const Center(child: Text('No suppliers found.'))
          : ListView.builder(
              itemCount: suppliersState.suppliers.length,
              itemBuilder: (context, index) {
                final supplier = suppliersState.suppliers[index];
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Suppliers'),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Enter supplier name...',
            prefixIcon: Icon(Icons.search),
          ),
          onSubmitted: (query) {
            Navigator.of(context).pop();
            if (query.isNotEmpty) {
              viewModel.searchSuppliers(query);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showFilterOptions(BuildContext context, SupplierViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter by Status',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('All Suppliers'),
              onTap: () {
                Navigator.of(context).pop();
                viewModel.clearFilters();
              },
            ),
            ListTile(
              title: const Text('Active Only'),
              onTap: () {
                Navigator.of(context).pop();
                viewModel.filterByStatus(true);
              },
            ),
            ListTile(
              title: const Text('Inactive Only'),
              onTap: () {
                Navigator.of(context).pop();
                viewModel.filterByStatus(false);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSortOptions(BuildContext context, SupplierViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sort By',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Name (A-Z)'),
              onTap: () {
                Navigator.of(context).pop();
                viewModel.sortBy('name_asc');
              },
            ),
            ListTile(
              title: const Text('Name (Z-A)'),
              onTap: () {
                Navigator.of(context).pop();
                viewModel.sortBy('name_desc');
              },
            ),
            ListTile(
              title: const Text('Date Created (Newest)'),
              onTap: () {
                Navigator.of(context).pop();
                viewModel.sortBy('date_desc');
              },
            ),
            ListTile(
              title: const Text('Date Created (Oldest)'),
              onTap: () {
                Navigator.of(context).pop();
                viewModel.sortBy('date_asc');
              },
            ),
          ],
        ),
      ),
    );
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
    viewModel.removeSupplier(supplier.id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Supplier deleted')),
    );
  }
}
