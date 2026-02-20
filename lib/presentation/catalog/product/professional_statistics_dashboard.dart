import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../di/injection.dart';
import 'product_state.dart';

class ProfessionalStatisticsDashboard extends ConsumerWidget {
  const ProfessionalStatisticsDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(productViewModelProvider);
    final vm = ref.read(productViewModelProvider.notifier);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          // Main statistics cards
          _buildMainStatistics(context, state),

          const SizedBox(height: 16),

          // Quick actions and filters
          _buildQuickActions(context, state, vm),
        ],
      ),
    );
  }

  Widget _buildMainStatistics(BuildContext context, ProductState state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.analytics_outlined,
                color: const Color(0xFF0E2330),
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Product Overview',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0E2330),
                ),
              ),
              const Spacer(),
              _buildRefreshButton(state),
            ],
          ),

          const SizedBox(height: 20),

          // Statistics grid
          _buildStatisticsGrid(context, state),
        ],
      ),
    );
  }

  Widget _buildRefreshButton(ProductState state) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        onPressed: state.isLoading ? null : () {
          // Refresh data
        },
        icon: AnimatedRotation(
          turns: state.isLoading ? 1 : 0,
          duration: const Duration(milliseconds: 1000),
          child: Icon(
            Icons.refresh,
            color: state.isLoading ? Colors.grey : const Color(0xFF0E2330),
            size: 20,
          ),
        ),
        tooltip: 'Refresh data',
      ),
    );
  }

  Widget _buildStatisticsGrid(BuildContext context, ProductState state) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 768;

    if (isWideScreen) {
      return Row(
        children: [
          Expanded(child: _buildStatCard(
            'Total Products',
            state.totalProductsCount.toString(),
            Icons.inventory_2_outlined,
            const Color(0xFF0E2330),
            _getGrowthIndicator('+12%', true),
          )),
          const SizedBox(width: 16),
          Expanded(child: _buildStatCard(
            'Active Products',
            state.activeProductsCount.toString(),
            Icons.check_circle_outline,
            Colors.green,
            _getGrowthIndicator('+5%', true),
          )),
          const SizedBox(width: 16),
          Expanded(child: _buildStatCard(
            'Inactive Products',
            state.inactiveProductsCount.toString(),
            Icons.pause_circle_outline,
            Colors.orange,
            _getGrowthIndicator('-2%', false),
          )),
          const SizedBox(width: 16),
          Expanded(child: _buildStatCard(
            'Selected',
            state.selectedProductsCount.toString(),
            Icons.checklist,
            Colors.blue,
            null,
          )),
        ],
      );
    } else {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildStatCard(
                'Total',
                state.totalProductsCount.toString(),
                Icons.inventory_2_outlined,
                const Color(0xFF0E2330),
                _getGrowthIndicator('+12%', true),
              )),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard(
                'Active',
                state.activeProductsCount.toString(),
                Icons.check_circle_outline,
                Colors.green,
                _getGrowthIndicator('+5%', true),
              )),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildStatCard(
                'Inactive',
                state.inactiveProductsCount.toString(),
                Icons.pause_circle_outline,
                Colors.orange,
                _getGrowthIndicator('-2%', false),
              )),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard(
                'Selected',
                state.selectedProductsCount.toString(),
                Icons.checklist,
                Colors.blue,
                null,
              )),
            ],
          ),
        ],
      );
    }
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    Widget? growth,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
              if (growth != null) growth,
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getGrowthIndicator(String percentage, bool isPositive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isPositive ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive ? Icons.trending_up : Icons.trending_down,
            size: 12,
            color: isPositive ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 2),
          Text(
            percentage,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isPositive ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, ProductState state, vm) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0E2330),
            ),
          ),
          const SizedBox(height: 12),
          _buildQuickActionButtons(context, state, vm),
        ],
      ),
    );
  }

  Widget _buildQuickActionButtons(BuildContext context, ProductState state, vm) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 600;

    final buttons = [
      _buildQuickActionButton(
        'All Products',
        Icons.all_inclusive,
        state.totalProductsCount > 0,
        () => vm.fetchAllProducts(),
      ),
      _buildQuickActionButton(
        'Active Only',
        Icons.check_circle,
        state.activeProductsCount > 0,
        () => vm.fetchActiveProducts(),
      ),
      _buildQuickActionButton(
        'Low Stock',
        Icons.warning_amber,
        true,
        () => vm.filterByPriceRange(null, 100), // Example filter
      ),
      _buildQuickActionButton(
        'Export CSV',
        Icons.file_download,
        state.hasProducts,
        () => _exportProducts(context, vm, state),
      ),
    ];

    if (isWideScreen) {
      return Row(
        children: buttons
            .map((button) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: button,
                  ),
                ))
            .toList(),
      );
    } else {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: Padding(
                padding: const EdgeInsets.only(right: 4),
                child: buttons[0],
              )),
              Expanded(child: Padding(
                padding: const EdgeInsets.only(left: 4),
                child: buttons[1],
              )),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: Padding(
                padding: const EdgeInsets.only(right: 4),
                child: buttons[2],
              )),
              Expanded(child: Padding(
                padding: const EdgeInsets.only(left: 4),
                child: buttons[3],
              )),
            ],
          ),
        ],
      );
    }
  }

  Widget _buildQuickActionButton(
    String label,
    IconData icon,
    bool isEnabled,
    VoidCallback onPressed,
  ) {
    return OutlinedButton.icon(
      onPressed: isEnabled ? onPressed : null,
      icon: Icon(icon, size: 16),
      label: Text(
        label,
        style: const TextStyle(fontSize: 12),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: isEnabled ? const Color(0xFF0E2330) : Colors.grey,
        side: BorderSide(
          color: isEnabled ? const Color(0xFF0E2330).withOpacity(0.3) : Colors.grey.shade300,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      ),
    );
  }

  void _exportProducts(BuildContext context, vm, ProductState state) {
    if (state.hasProducts) {
      vm.exportProductsToCsv(state.products);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Products exported to CSV'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}