import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../di/injection.dart';
import '../../../../domain/entities/catalog/product.dart';
import '../design_system/product_design_tokens.dart';
import '../design_system/product_theme.dart';
import '../product_state.dart';
import '../product_view_model.dart';
import '../modern_search_filter_bar.dart';
import '../professional_statistics_dashboard.dart';
import 'improved_action_toolbar.dart';
import 'unified_product_card.dart';
import '../professional_empty_state.dart';

/// Refactored Products Tab demonstrating the new design system
/// This shows how the old components should be updated to use the unified design system
class RefactoredProductsTab extends ConsumerWidget {
  const RefactoredProductsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsState = ref.watch(productViewModelProvider);
    final vm = ref.read(productViewModelProvider.notifier);

    return Column(
      children: [
        // Professional Statistics Dashboard (keeping existing)
        const ProfessionalStatisticsDashboard(),

        // Improved Search & Filter Bar (keeping existing)
        const ModernSearchFilterBar(),

        // NEW: Improved Action Toolbar
        const ImprovedActionToolbar(),

        // Error Banner with improved design
        if (productsState.hasError) _buildErrorBanner(context, productsState, vm),

        // Product Grid or Empty State
        Expanded(
          child: RefreshIndicator(
            onRefresh: vm.fetchAllProducts,
            color: ProductDesignTokens.primaryColor,
            backgroundColor: ProductDesignTokens.surfacePrimary,
            child: _buildProductContent(context, productsState, vm),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorBanner(
    BuildContext context,
    ProductState state,
    ProductViewModel vm,
  ) {
    return Container(
      margin: ProductDesignTokens.responsivePadding(
        context,
        mobile: const EdgeInsets.symmetric(
          horizontal: ProductDesignTokens.spaceMD,
          vertical: ProductDesignTokens.spaceSM,
        ),
      ),
      padding: const EdgeInsets.all(ProductDesignTokens.spaceLG),
      decoration: ProductTheme.errorIndicator,
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: ProductDesignTokens.errorColor,
            size: 20,
          ),
          const SizedBox(width: ProductDesignTokens.spaceMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Error',
                  style: ProductTheme.getTextStyle(context, 'labelLarge')?.copyWith(
                    color: ProductDesignTokens.errorColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: ProductDesignTokens.spaceXS),
                Text(
                  state.error!,
                  style: ProductTheme.getTextStyle(context, 'bodySmall')?.copyWith(
                    color: ProductDesignTokens.errorColor,
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: vm.clearError,
            style: ProductTheme.getButtonStyle('secondary').copyWith(
              foregroundColor: MaterialStateProperty.all(ProductDesignTokens.errorColor),
              side: MaterialStateProperty.all(
                const BorderSide(color: ProductDesignTokens.errorColor),
              ),
            ),
            child: const Text('Dismiss'),
          ),
        ],
      ),
    );
  }

  Widget _buildProductContent(
    BuildContext context,
    ProductState state,
    ProductViewModel vm,
  ) {
    final products = state.filteredAndSortedProducts;

    if (products.isEmpty) {
      return const ProfessionalEmptyState(); // Keep existing empty state
    }

    return _buildProductGrid(context, products, state, vm);
  }

  Widget _buildProductGrid(
    BuildContext context,
    List<Product> products,
    ProductState state,
    ProductViewModel vm,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive grid based on screen size
        int crossAxisCount;
        double childAspectRatio;

        if (ProductDesignTokens.isDesktop(context)) {
          crossAxisCount = constraints.maxWidth > 1400 ? 4 : 3;
          childAspectRatio = 0.8;
        } else if (ProductDesignTokens.isTablet(context)) {
          crossAxisCount = 2;
          childAspectRatio = 0.85;
        } else {
          crossAxisCount = 1;
          childAspectRatio = 1.2;
        }

        return GridView.builder(
          padding: ProductDesignTokens.responsivePadding(context),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: ProductDesignTokens.spaceMD,
            mainAxisSpacing: ProductDesignTokens.spaceMD,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return _buildProductCard(context, product, state, vm);
          },
        );
      },
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    Product product,
    ProductState state,
    ProductViewModel vm,
  ) {
    // Determine card variant based on screen size
    ProductCardVariant variant = ProductCardVariant.standard;

    if (ProductDesignTokens.isMobile(context)) {
      variant = ProductCardVariant.compact;
    } else if (ProductDesignTokens.isDesktop(context)) {
      variant = ProductCardVariant.detailed;
    }

    return UnifiedProductCard(
      product: product,
      variant: variant,
      isSelected: state.isProductSelected(product.id),
      isLoading: state.isProductDeleting(product.id),
      showSelection: state.hasSelectedProducts,
      onTap: () => _navigateToProductDetail(context, product),
      onEdit: () => _navigateToProductEdit(context, product),
      onDelete: () => _showDeleteConfirmation(context, product, vm),
      onSelect: () => vm.toggleProductSelection(product.id),
    );
  }

  // Navigation methods (same as original but with improved UX)
  void _navigateToProductDetail(BuildContext context, Product product) {
    // TODO: Navigate to product detail page using proper routing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Product details for ${product.name}'),
        backgroundColor: ProductDesignTokens.infoColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ProductDesignTokens.radiusMD),
        ),
      ),
    );
  }

  void _navigateToProductEdit(BuildContext context, Product product) {
    // TODO: Navigate to product edit page using proper routing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit ${product.name}'),
        backgroundColor: ProductDesignTokens.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ProductDesignTokens.radiusMD),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    Product product,
    ProductViewModel vm,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ProductDesignTokens.radiusLG),
          ),
          title: Text(
            'Delete Product',
            style: ProductTheme.getTextStyle(context, 'titleLarge'),
          ),
          content: Text(
            'Are you sure you want to delete "${product.name}"? This action cannot be undone.',
            style: ProductTheme.getTextStyle(context, 'bodyMedium'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ProductTheme.textButtonTheme,
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                vm.deleteProduct(product.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${product.name} deleted'),
                    backgroundColor: ProductDesignTokens.warningColor,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ProductDesignTokens.radiusMD),
                    ),
                  ),
                );
              },
              style: ProductTheme.destructiveButtonTheme,
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}