import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stocktrack_pro/presentation/catalog/product/product_view_model.dart';
import '../../domain/entities/catalog/product.dart';
import '../../di/injection.dart';
import 'product/add_product_dialog.dart';
import 'product/edit_product_dialog.dart';
import 'product/product_filter_dialog.dart';
import 'product/product_state.dart';
import 'product/csv_import_export_dialog.dart';
import 'product/enhanced_product_card.dart';

class ProductsTab extends ConsumerWidget {
  const ProductsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsState = ref.watch(productViewModelProvider);
    final vm = ref.read(productViewModelProvider.notifier);

    final products = productsState.filteredAndSortedProducts;
    final hasError = productsState.hasError;
    final error = productsState.error;

    return Column(
      children: [
        // Search & Filter Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: vm.updateSearch,
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    prefixIcon: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(Icons.search, size: 20),
                        if (productsState.loadingState ==
                            ProductLoadingState.loading)
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                      ],
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.filter_list_rounded),
                    onPressed: () async {
                      final result = await showDialog<ProductFilterOptions>(
                        context: context,
                        builder: (context) => ProductFilterDialog(
                          currentFilters: productsState.filters,
                        ),
                      );
                      if (result != null) {
                        vm.applyFilters(result);
                      }
                    },
                  ),
                  if (productsState.hasFilters)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),

        // Error Banner
        if (hasError)
          Container(
            width: 150,
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red[50],
              border: Border.all(color: Colors.red[200]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red[600], size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    error!,
                    style: TextStyle(color: Colors.red[700], fontSize: 12),
                  ),
                ),
                TextButton(
                  onPressed: vm.clearError,
                  child: Text(
                    'Dismiss',
                    style: TextStyle(color: Colors.red[700]),
                  ),
                ),
              ],
            ),
          ),

        // Action Buttons
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // CSV Actions
              Row(
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.upload_file),
                    label: const Text('Import CSV'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(fontWeight: FontWeight.w600),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const CsvImportExportDialog(
                          products: [],
                          isExport: false,
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.download),
                    label: const Text('Export CSV'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(fontWeight: FontWeight.w600),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    onPressed: productsState.hasProducts
                        ? () {
                            showDialog(
                              context: context,
                              builder: (context) => CsvImportExportDialog(
                                products: productsState.products,
                                isExport: true,
                              ),
                            );
                          }
                        : null,
                  ),
                ],
              ),

              // Add Product Button
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add Product'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0E2330),
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontWeight: FontWeight.w600),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const AddProductDialog(),
                  );
                },
              ),
            ],
          ),
        ),

        // Bulk Actions Bar
        if (productsState.hasSelectedProducts)
          _buildBulkActionsBar(context, vm, productsState),

        // Product List / Cards
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: RefreshIndicator(
              onRefresh: vm.fetchAllProducts,
              child:
                  productsState.loadingState == ProductLoadingState.loading &&
                      products.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : products.isEmpty
                  ? _buildEmptyState(context, vm)
                  : ListView.separated(
                      itemCount: products.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return EnhancedProductCard(
                          product: product,
                          state: productsState,
                          vm: vm,
                        );
                      },
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBulkActionsBar(
    BuildContext context,
    ProductViewModel vm,
    ProductState state,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0E2330).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF0E2330).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: const Color(0xFF0E2330), size: 20),
          const SizedBox(width: 8),
          Text(
            '${state.selectedProductsCount} products selected',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF0E2330),
            ),
          ),
          const Spacer(),
          Row(
            children: [
              // Select All button
              TextButton.icon(
                onPressed: () => vm.selectAllProducts(),
                icon: const Icon(Icons.select_all, size: 16),
                label: const Text('Select All'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF0E2330),
                ),
              ),
              const SizedBox(width: 8),
              // Clear Selection button
              TextButton.icon(
                onPressed: () => vm.clearSelection(),
                icon: const Icon(Icons.clear, size: 16),
                label: const Text('Clear'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey.shade600,
                ),
              ),
              const SizedBox(width: 8),
              // Delete Selected button
              ElevatedButton.icon(
                onPressed: state.isBulkOperating
                    ? null
                    : () => _confirmBulkDelete(context, vm),
                icon: const Icon(Icons.delete, size: 16),
                label: const Text('Delete Selected'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmBulkDelete(BuildContext context, ProductViewModel vm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Selected Products'),
        content: Text(
          'Are you sure you want to delete ${vm.state.selectedProductsCount} products? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              vm.deleteSelectedProducts();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, dynamic vm) {
    return ListView(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.2),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 48,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 12),
              Text(
                'No products found',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Add products to your catalog to get started',
                style: TextStyle(color: Colors.grey.shade500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add First Product'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0E2330),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const AddProductDialog(),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    Product product,
    dynamic vm,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Product'),
          content: Text('Are you sure you want to delete "${product.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                vm.deleteProduct(product.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${product.name} deleted'),
                    backgroundColor: Colors.orange,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
