import 'package:clean_arch_app/di/injection.dart';
import 'package:clean_arch_app/presentation/purchase_order/purchase_order_state.dart';
import 'package:clean_arch_app/presentation/purchase_order/widgets/purchase_order_search_bar.dart';
import 'package:clean_arch_app/presentation/stock/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/enums/purchase_order_status.dart';
import 'purchase_order_view_model.dart';
import 'widgets/purchase_order_card.dart';
import 'widgets/purchase_order_stats.dart';

class PurchaseOrdersScreen extends ConsumerWidget {
  const PurchaseOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(purchaseOrderViewModelProvider);
    final viewModel = ref.read(purchaseOrderViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: const ProductionTopAppBar(),
      body: RefreshIndicator(
        onRefresh: viewModel.refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Purchase Orders',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Manage your procurement workflow',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 20),

              /// Stats Grid
              PurchaseOrderStats(state: state),

              const SizedBox(height: 20),

              /// Search + Filters
              PurchaseOrderSearchBar(),
              // _buildSearchAndFilter(context, viewModel, state),
              const SizedBox(height: 16),

              /// Loading State
              if (state.status == PurchaseOrderStateStatus.loading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
                ),

              /// Error State
              if (state.status == PurchaseOrderStateStatus.error)
                Center(
                  child: Text(
                    state.errorMessage ?? "Error loading orders",
                    style: const TextStyle(color: Colors.red),
                  ),
                ),

              /// Success State
              if (state.status == PurchaseOrderStateStatus.success)
                ...state.purchaseOrders.map(
                      (order) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: PurchaseOrderCard(
                      order: order,
                      viewModel: viewModel,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: state.currentUser != null &&
          viewModel.canCreatePurchaseOrder
          ? FloatingActionButton(
        onPressed: () {
          // Navigate to create purchase order page
        },
        backgroundColor: const Color(0xFF2563EB),
        child: const Icon(Icons.add, color: Colors.white),
      )
          : null,
    );
  }

}
