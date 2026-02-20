import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stocktrack_pro/presentation/catalog/product/product_view_model.dart';
import '../../domain/entities/catalog/product.dart';
import '../../di/injection.dart';
import 'product/product_form_page.dart';
import 'product/product_state.dart';
import 'product/responsive_product_grid.dart';
import 'product/modern_search_filter_bar.dart';
import 'product/professional_statistics_dashboard.dart';
import 'product/professional_action_toolbar.dart';
import 'product/professional_empty_state.dart';

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
        // Professional Statistics Dashboard
        const ProfessionalStatisticsDashboard(),

        // Modern Search & Filter Bar
        const ModernSearchFilterBar(),

        // Professional Action Toolbar
        const ProfessionalActionToolbar(),

        // Error Banner
        if (hasError)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              border: Border.all(color: Colors.red.shade200),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red.shade600, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Error',
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        error!,
                        style: TextStyle(
                          color: Colors.red.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                OutlinedButton(
                  onPressed: vm.clearError,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red.shade700,
                    side: BorderSide(color: Colors.red.shade300),
                  ),
                  child: const Text('Dismiss'),
                ),
              ],
            ),
          ),

        // Responsive Product Grid
        Expanded(
          child: RefreshIndicator(
            onRefresh: vm.fetchAllProducts,
            child: ResponsiveProductGrid(
              products: products,
              state: productsState,
              vm: vm,
              isLoading: productsState.loadingState == ProductLoadingState.loading,
              onProductTap: (product) => _navigateToProductDetail(context, product),
              onProductEdit: (product) => _navigateToProductEdit(context, product),
              onProductDelete: (product) => _showDeleteConfirmation(context, product, vm),
              onAddProduct: () => _navigateToAddProduct(context),
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToProductDetail(BuildContext context, Product product) {
    // TODO: Navigate to product detail page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Product details for ${product.name}'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _navigateToProductEdit(BuildContext context, Product product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductFormPage(product: product, isEditing: true),
      ),
    );
  }

  void _navigateToAddProduct(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ProductFormPage(),
      ),
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
