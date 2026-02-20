import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/catalog/product.dart';
import 'professional_product_card.dart';
import 'product_state.dart';
import 'product_view_model.dart';
import 'product_skeleton_loader.dart';
import 'professional_empty_state.dart';

class ResponsiveProductGrid extends ConsumerWidget {
  final List<Product> products;
  final ProductState state;
  final ProductViewModel vm;
  final bool isLoading;
  final Function(Product)? onProductTap;
  final Function(Product)? onProductEdit;
  final Function(Product)? onProductDelete;
  final VoidCallback? onAddProduct;

  const ResponsiveProductGrid({
    super.key,
    required this.products,
    required this.state,
    required this.vm,
    this.isLoading = false,
    this.onProductTap,
    this.onProductEdit,
    this.onProductDelete,
    this.onAddProduct,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isLoading && products.isEmpty) {
      return _buildSkeletonGrid(context);
    }

    if (products.isEmpty) {
      return _buildEmptyState(context);
    }

    return _buildProductGrid(context);
  }

  Widget _buildSkeletonGrid(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = _getCrossAxisCount(constraints.maxWidth);
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: _getChildAspectRatio(context, crossAxisCount),
          ),
          itemCount: 6, // Show 6 skeleton cards
          itemBuilder: (context, index) => const ProductSkeletonLoader(),
        );
      },
    );
  }

  Widget _buildProductGrid(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = _getCrossAxisCount(constraints.maxWidth);

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: _getChildAspectRatio(context, crossAxisCount),
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: ProfessionalProductCard(
                key: ValueKey(product.id),
                product: product,
                state: state,
                vm: vm,
                onTap: onProductTap != null ? () => onProductTap!(product) : null,
                onEdit: onProductEdit != null ? () => onProductEdit!(product) : null,
                onDelete: onProductDelete != null ? () => onProductDelete!(product) : null,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return ProfessionalEmptyState(
      onAddProduct: onAddProduct,
      searchQuery: state.searchQuery,
    );
  }

  int _getCrossAxisCount(double width) {
    if (width > 1400) return 4;
    if (width > 1000) return 3;
    if (width > 600) return 2;
    return 1;
  }

  double _getChildAspectRatio(BuildContext context, int crossAxisCount) {
    // Adjust aspect ratio based on screen size and number of columns
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 1200) {
      return 0.75; // Desktop - more square cards
    } else if (screenWidth > 600) {
      return 0.7; // Tablet - slightly taller
    } else {
      return 0.65; // Mobile - taller cards for better content display
    }
  }

}