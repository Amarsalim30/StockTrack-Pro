import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/catalog/product.dart';
import 'product_state.dart';
import 'product_view_model.dart';
import 'product_details_page.dart';
import 'product_form_page.dart';

class EnhancedProductCard extends ConsumerWidget {
  final Product product;
  final ProductState state;
  final ProductViewModel vm;

  const EnhancedProductCard({
    super.key,
    required this.product,
    required this.state,
    required this.vm,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: state.isProductSelected(product.id)
              ? Border.all(color: const Color(0xFF0E2330), width: 2)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with selection and actions
            _buildHeader(context),

            // Product content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product name and SKU
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0E2330),
                          ),
                        ),
                      ),
                      if (!product.isActive)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Inactive',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'SKU: ${product.sku}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      fontFamily: 'monospace',
                    ),
                  ),

                  // Description
                  if (product.description != null &&
                      product.description!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      product.description!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],

                  const SizedBox(height: 12),

                  // Price and cost information
                  Row(
                    children: [
                      if (product.price != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '\$${product.price!.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      if (product.costPrice != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Cost: \$${product.costPrice!.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  // Tags
                  if (product.tags != null && product.tags!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: product.tags!
                          .map(
                            (tag) => Chip(
                              label: Text(tag),
                              backgroundColor: Colors.grey.shade100,
                              labelStyle: const TextStyle(fontSize: 12),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                          )
                          .toList(),
                    ),
                  ],

                  const SizedBox(height: 12),

                  // Action buttons
                  _buildActionButtons(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: state.isProductSelected(product.id)
            ? const Color(0xFF0E2330).withOpacity(0.1)
            : Colors.grey.shade50,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          // Selection checkbox
          Checkbox(
            value: state.isProductSelected(product.id),
            onChanged: (value) => vm.toggleProductSelection(product.id),
            activeColor: const Color(0xFF0E2330),
          ),

          // Product ID and timestamps
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ID: ${product.id}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontFamily: 'monospace',
                  ),
                ),
                if (product.createdAt != null)
                  Text(
                    'Created: ${_formatDate(product.createdAt!)}',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                  ),
              ],
            ),
          ),

          // Status indicator
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: product.isActive ? Colors.green : Colors.red,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        // View Details button
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _viewProductDetails(context),
            icon: const Icon(Icons.visibility, size: 16),
            label: const Text('View'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.blue,
              side: const BorderSide(color: Colors.blue),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),

        const SizedBox(width: 8),

        // Edit button
        Expanded(
          child: OutlinedButton.icon(
            onPressed: state.isUpdating ? null : () => _editProduct(context),
            icon: const Icon(Icons.edit, size: 16),
            label: const Text('Edit'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF0E2330),
              side: const BorderSide(color: Color(0xFF0E2330)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),

        const SizedBox(width: 8),

        // Delete button
        Expanded(
          child: OutlinedButton.icon(
            onPressed: state.isDeleting ? null : () => _deleteProduct(context),
            icon: Icon(
              state.isProductDeleting(product.id)
                  ? Icons.hourglass_empty
                  : Icons.delete,
              size: 16,
            ),
            label: Text(
              state.isProductDeleting(product.id) ? 'Deleting...' : 'Delete',
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _viewProductDetails(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductDetailsPage(product: product),
      ),
    );
  }

  void _editProduct(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            ProductFormPage(product: product, isEditing: true),
      ),
    );
  }

  void _deleteProduct(BuildContext context) {
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
            onPressed: () {
              Navigator.of(context).pop();
              vm.deleteProduct(product.id);
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
