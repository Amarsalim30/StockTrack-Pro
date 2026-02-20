import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/catalog/product.dart';
import '../../../di/injection.dart';
import 'product_state.dart';
import 'product_view_model.dart';

class ProductStatisticsWidget extends ConsumerWidget {
  const ProductStatisticsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsState = ref.watch(productViewModelProvider);
    final products = productsState.allProducts;

    final totalProducts = products.length;
    final activeProducts = products.where((p) => p.isActive).length;
    final inactiveProducts = totalProducts - activeProducts;
    final productsWithPrice = products.where((p) => p.price != null).length;
    final productsWithCostPrice = products
        .where((p) => p.costPrice != null)
        .length;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.analytics, color: const Color(0xFF0E2330), size: 24),
                const SizedBox(width: 12),
                const Text(
                  'Product Statistics',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0E2330),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: 'Total Products',
                    value: totalProducts.toString(),
                    color: Colors.blue,
                    icon: Icons.inventory_2,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    title: 'Active',
                    value: activeProducts.toString(),
                    color: Colors.green,
                    icon: Icons.check_circle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: 'Inactive',
                    value: inactiveProducts.toString(),
                    color: Colors.red,
                    icon: Icons.cancel,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    title: 'With Price',
                    value: productsWithPrice.toString(),
                    color: Colors.orange,
                    icon: Icons.attach_money,
                  ),
                ),
              ],
            ),
            if (productsWithCostPrice > 0) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      title: 'With Cost Price',
                      value: productsWithCostPrice.toString(),
                      color: Colors.purple,
                      icon: Icons.account_balance_wallet,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      title: 'Profit Margin',
                      value: _calculateAverageProfitMargin(products),
                      color: Colors.teal,
                      icon: Icons.trending_up,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _calculateAverageProfitMargin(List<Product> products) {
    final productsWithBothPrices = products
        .where(
          (p) =>
              p.price != null &&
              p.costPrice != null &&
              p.price! > 0 &&
              p.costPrice! > 0,
        )
        .toList();

    if (productsWithBothPrices.isEmpty) return 'N/A';

    double totalMargin = 0;
    for (final product in productsWithBothPrices) {
      final margin =
          ((product.price! - product.costPrice!) / product.costPrice!) * 100;
      totalMargin += margin;
    }

    final averageMargin = totalMargin / productsWithBothPrices.length;
    return '${averageMargin.toStringAsFixed(1)}%';
  }
}
