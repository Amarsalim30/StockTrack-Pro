import 'package:clean_arch_app/di/injection.dart';
import 'package:clean_arch_app/presentation/common/widgets/loading_indicator.dart';
import 'package:clean_arch_app/presentation/stock/stock_state.dart' show SortOrder, SortBy;
import 'package:clean_arch_app/presentation/stock/stock_view_model.dart' show StockViewModel;
import 'package:clean_arch_app/presentation/stock/widgets/stock_item_card.dart' show StockItemCard;
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/enums/stock_status.dart';

class StockPage extends ConsumerWidget {
  const StockPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stockState = ref.watch(stockViewModelProvider);
    final stockViewModel = ref.read(stockViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
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
            _buildSearchFilterSort(context, ref, stockState, stockViewModel),
            const SizedBox(height: 12),
            Expanded(
              child: stockState.isLoading
                  ? const LoadingIndicator(message: 'Loading stocks...')
                  : stockState.filteredStocks.isEmpty
                  ? const Center(
                child: Text(
                  'No stocks available',
                  style: TextStyle(color: Colors.grey),
                ),
              )
                  : ListView.builder(
                itemCount: stockState.filteredStocks.length,
                itemBuilder: (_, i) => StockItemCard(
                  stock: stockState.filteredStocks[i],
                  showSelectionCheckbox: stockState.isBulkSelectionMode,
                  isSelected: stockState.selectedStockIds.contains(
                      stockState.filteredStocks[i].id),
                  onTap: () => stockState.isBulkSelectionMode
                      ? stockViewModel.toggleStockSelection(
                      stockState.filteredStocks[i].id)
                      : null,
                  onEdit: stockViewModel.canEditStock
                      ? () => stockViewModel.edit(stockState.filteredStocks[i])
                      : null,
                  onDelete: stockViewModel.canDeleteStock
                      ? () => stockViewModel.deleteStock(
                      stockState.filteredStocks[i].id)
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: stockViewModel.canCreateStock
          ? FloatingActionButton(
        onPressed: stockViewModel.addNewStock,
        backgroundColor: Colors.black,
        child: const Icon(Icons.add),
      )
          : null,
    );
  }

  Widget _buildSearchFilterSort(BuildContext context, WidgetRef ref, stockState, StockViewModel vm) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 40,
            child: TextField(
              onChanged: vm.setSearchQuery,
              style: const TextStyle(fontSize: 15, color: Colors.black),
              decoration: InputDecoration(
                hintText: 'Search inventory...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.black, width: 1.0),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        _buildFilterMenu(context, vm),
        const SizedBox(width: 6),
        _buildSortMenu(vm, stockState)
      ],
    );
  }

  Widget _buildFilterMenu(BuildContext context, StockViewModel vm) {
    return SizedBox(
      height: 40,
      child: PopupMenuButton<String>(
        onSelected: vm.setStatusFilter,
        itemBuilder: (context) => [
          const PopupMenuItem(value: 'all', child: Text('All')),
          ...StockStatus.values.map((s) => PopupMenuItem(
            value: s.name,
            child: Text(s.name.replaceAll('_', ' ').toUpperCase()),
          ))
        ],
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
              Icon(LucideIcons.filter, size: 18, color: Colors.black87),
              SizedBox(width: 6),
              Icon(LucideIcons.chevron_down, size: 18, color: Colors.black54),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSortMenu(StockViewModel vm, stockState) {
    return PopupMenuButton<SortBy>(
      onSelected: (SortBy selected) {
        final isSame = selected == stockState.sortBy;
        vm.setSortBy(selected);
        if (isSame) vm.toggleSortOrder(selected);
      },
      itemBuilder: (context) => SortBy.values
          .map((sortBy) => PopupMenuItem(
        value: sortBy,
        child: Row(
          children: [
            Text(sortBy.name.toUpperCase()),
            const Spacer(),
            if (stockState.sortBy == sortBy)
              Icon(
                stockState.sortOrder == SortOrder.ascending
                    ? LucideIcons.arrow_up
                    : LucideIcons.arrow_down,
                size: 16,
              ),
          ],
        ),
      ))
          .toList(),
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
              stockState.sortOrder == SortOrder.ascending
                  ? LucideIcons.arrow_up
                  : LucideIcons.arrow_down,
              size: 18,
              color: Colors.black87,
            ),
            const SizedBox(width: 6),
            Text(stockState.sortBy.toString()),
            const SizedBox(width: 6),
            const Icon(LucideIcons.chevron_down, size: 18, color: Colors.black54),
          ],
        ),
      ),
    );
  }
}
