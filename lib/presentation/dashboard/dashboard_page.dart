import 'package:clean_arch_app/presentation/dashboard/widgets/build_action_chip.dart';
import 'package:clean_arch_app/presentation/stock/stock_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../core/constants/colors.dart';
import '../../di/injection.dart' as di;
import '../stock/stock_state.dart';
import 'dashboard_view_model.dart';
import 'dashboard_state.dart';
import 'widgets/stock_list.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(di.dashboardViewModelProvider);
    final viewModel = ref.watch(di.dashboardViewModelProvider.notifier);
    final stockState = ref.watch(stockViewModelProvider);
    final stockViewModel = ref.watch(di.stockViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.slate[900],
        elevation: 0,
        titleSpacing: 16.0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'StockTrackPro',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Professional Inventory Management',
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        centerTitle: false,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: Icon(Icons.notifications_none, color: Colors.white),
          ),
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.account_circle_rounded, color: Colors.white),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Stock Inventory',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  '${stockState.stocks.length} items',
                  style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInventoryHeader(viewModel, stockViewModel),
            const SizedBox(height: 12),
            Expanded(child: StockList(stocks: stockState.stocks)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: viewModel.addNewProduct,
        backgroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildInventoryHeader(DashboardViewModel vm, StockViewModel stockVm) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Search Field (consistent black/grey style, no shadow)
        Expanded(
          child: SizedBox(
            height: 40,
            child: TextField(
              textAlign: TextAlign.start,
              onChanged: stockVm.setSearchQuery,
              style: const TextStyle(fontSize: 15, color: Colors.black),
              decoration: InputDecoration(
                hintText: 'Search inventory...',
                hintStyle: TextStyle(color: Colors.grey[700]),
                prefixIcon: const Icon(
                  Icons.search, color: Colors.grey, size: 20,),
                filled: true,
                fillColor: Colors.white,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 0,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Colors.black,
                    style: BorderStyle.solid,
                    width: 1.0,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8,),
        SizedBox(
          height: 40,
          child: PopupMenuButton<String>(
            onSelected: (value) {
              // handle the selected filter value
              vm.setFilter(value);
            },
            itemBuilder: (context) =>
            [
              PopupMenuItem(value: 'All', child: Text('All')),
              PopupMenuItem(value: 'Available', child: Text('Available')),
              PopupMenuItem(value: 'Out of Stock', child: Text('Out of Stock')),
            ],
            offset: Offset(0, 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    LucideIcons.filter,
                    size: 18,
                    color: Colors.black87,
                  ),
                  SizedBox(width: 6),
                  Icon(
                    LucideIcons.chevron_down,
                    size: 18,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 6,),

        PopupMenuButton<SortBy>(
          onSelected: (SortBy selected) {
            final isSame = selected == stockVm.sortBy;
            stockVm.setSortBy(selected);
            if (isSame) {
              stockVm.toggleSortOrder(
                  selected); // If same item tapped again, toggle order
            }
          },
          itemBuilder: (context) =>
              SortBy.values.map((sortBy) {
                return PopupMenuItem(
                  value: sortBy,
                  child: Row(
                    children: [
                      Text(describeEnum(sortBy).toUpperCase()),
                      const Spacer(),
                      if (stockVm.sortBy == sortBy)
                        Icon(
                          stockVm.sortOrder == SortOrder.ascending
                              ? LucideIcons.arrow_up
                              : LucideIcons.arrow_down,
                          size: 16,
                        ),
                    ],
                  ),
                );
              }).toList(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  stockVm.sortOrder == SortOrder.ascending
                      ? LucideIcons.arrow_up
                      : LucideIcons.arrow_down,
                  size: 18,
                  color: Colors.black87,
                ),
                const SizedBox(width: 6),
                Text(describeEnum(stockVm.sortBy).toUpperCase()),
                const SizedBox(width: 6),
                const Icon(
                  LucideIcons.chevron_down,
                  size: 18,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),

      ],
    );
  }
}
