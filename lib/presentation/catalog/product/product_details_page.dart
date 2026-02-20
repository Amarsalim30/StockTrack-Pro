import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/catalog/product.dart';
import '../../../di/injection.dart';
import 'product_view_model.dart';
import 'product_form_page.dart';

class ProductDetailsPage extends ConsumerWidget {
  final Product product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(productViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          product.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF0E2330),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => _editProduct(context),
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Product',
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'toggle_status':
                  _toggleProductStatus(context, vm);
                  break;
                case 'delete':
                  _deleteProduct(context, vm);
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'toggle_status',
                child: Row(
                  children: [
                    Icon(
                      product.isActive
                          ? Icons.visibility_off
                          : Icons.visibility,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(product.isActive ? 'Deactivate' : 'Activate'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red, size: 20),
                    SizedBox(width: 8),
                    Text('Delete', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Header Card
            _buildProductHeaderCard(),
            const SizedBox(height: 16),

            // Basic Information Card
            _buildBasicInfoCard(),
            const SizedBox(height: 16),

            // Pricing Information Card
            _buildPricingCard(),
            const SizedBox(height: 16),

            // Additional Information Card
            _buildAdditionalInfoCard(),
            const SizedBox(height: 16),

            // Timestamps Card
            _buildTimestampsCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildProductHeaderCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              const Color(0xFF0E2330),
              const Color(0xFF0E2330).withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.inventory_2,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'SKU: ${product.sku}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.8),
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: product.isActive ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    product.isActive ? 'Active' : 'Inactive',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            if (product.description != null &&
                product.description!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                product.description!,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                  height: 1.5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoCard() {
    return _buildInfoCard(
      title: 'Basic Information',
      icon: Icons.info_outline,
      children: [
        _buildInfoRow('Product ID', product.id),
        _buildInfoRow('SKU', product.sku),
        _buildInfoRow('Category ID', product.categoryId),
        _buildInfoRow('Supplier ID', product.supplierId),
        if (product.unitId != null) _buildInfoRow('Unit ID', product.unitId!),
      ],
    );
  }

  Widget _buildPricingCard() {
    return _buildInfoCard(
      title: 'Pricing Information',
      icon: Icons.attach_money,
      children: [
        if (product.price != null)
          _buildInfoRow(
            'Selling Price',
            '\$${product.price!.toStringAsFixed(2)}',
            valueColor: Colors.green,
          ),
        if (product.costPrice != null)
          _buildInfoRow(
            'Cost Price',
            '\$${product.costPrice!.toStringAsFixed(2)}',
            valueColor: Colors.blue,
          ),
        if (product.price != null && product.costPrice != null)
          _buildInfoRow(
            'Profit Margin',
            '${((product.price! - product.costPrice!) / product.costPrice! * 100).toStringAsFixed(1)}%',
            valueColor: Colors.orange,
          ),
      ],
    );
  }

  Widget _buildAdditionalInfoCard() {
    return _buildInfoCard(
      title: 'Additional Information',
      icon: Icons.more_horiz,
      children: [
        if (product.tags != null && product.tags!.isNotEmpty) ...[
          _buildInfoRow('Tags', product.tags!.join(', ')),
          const SizedBox(height: 8),
        ],
        _buildInfoRow('Status', product.isActive ? 'Active' : 'Inactive'),
      ],
    );
  }

  Widget _buildTimestampsCard() {
    return _buildInfoCard(
      title: 'Timestamps',
      icon: Icons.access_time,
      children: [
        if (product.createdAt != null)
          _buildInfoRow('Created At', _formatDateTime(product.createdAt!)),
        if (product.updatedAt != null)
          _buildInfoRow('Updated At', _formatDateTime(product.updatedAt!)),
      ],
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFF0E2330), size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0E2330),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: valueColor ?? Colors.grey.shade900,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _editProduct(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            ProductFormPage(product: product, isEditing: true),
      ),
    );
  }

  void _toggleProductStatus(BuildContext context, ProductViewModel vm) {
    final updatedProduct = product.copyWith(
      isActive: !product.isActive,
      updatedAt: DateTime.now(),
    );
    vm.updateProduct(updatedProduct);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Product ${product.isActive ? 'deactivated' : 'activated'} successfully',
        ),
        backgroundColor: product.isActive ? Colors.orange : Colors.green,
      ),
    );
  }

  void _deleteProduct(BuildContext context, ProductViewModel vm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text(
          'Are you sure you want to delete "${product.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await vm.deleteProduct(product.id);
              if (context.mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Product deleted successfully'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
