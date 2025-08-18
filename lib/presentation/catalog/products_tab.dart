import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/catalog/product.dart';
import '../../di/injection.dart';
import '../stock/stock_view_model.dart'; // for reference if needed

class ProductsTab extends ConsumerWidget {
  const ProductsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Replace with your actual provider
    final productsState = ref.watch(productViewModelProvider);
    final vm = ref.read(productViewModelProvider.notifier);

    final isLoading = productsState.isLoading;
    final products = productsState.products;

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
                    prefixIcon: const Icon(Icons.search, size: 20),
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
              IconButton(
                icon: const Icon(Icons.filter_list_rounded),
                onPressed: () {
                  // TODO: open filter modal
                },
              ),
            ],
          ),
        ),

        // Add Product Button (FAB-style)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add Product'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0E2330),
                  textStyle: const TextStyle(fontWeight: FontWeight.w600),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                ),
                onPressed: () {
                  // TODO: navigate to add product page/dialog
                },
              ),
            ],
          ),
        ),

        // Product List / Cards
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : products.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
              itemCount: products.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final product = products[index];
                return _productCard(context, product, vm);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _productCard(BuildContext context, Product product, dynamic vm) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Product Name + Actions
            Row(
              children: [
                Expanded(
                  child: Text(
                    product.name ?? '-',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      // TODO: edit product
                    } else if (value == 'delete') {
                      // TODO: delete product
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                  icon: const Icon(Icons.more_vert, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Metadata Row: SKU, Category, Unit, Supplier
            Wrap(
              spacing: 12,
              runSpacing: 6,
              children: [
                _chipLabel('SKU', product.sku),
                _chipLabel('Category', product.categoryId),
                // _chipLabel('Unit', product.),
                _chipLabel('Supplier', product.supplierId),
              ],
            ),

            if (product.description != null && product.description!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                product.description!,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _chipLabel(String label, String? value) {
    return Chip(
      label: Text(
        '$label: ${value ?? "-"}',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
      backgroundColor: const Color(0xFFF3F4F6),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text('No products found', style: TextStyle(fontSize: 16, color: Colors.grey.shade700, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text('Add products to your catalog to get started', style: TextStyle(color: Colors.grey.shade500)),
        ],
      ),
    );
  }
}

