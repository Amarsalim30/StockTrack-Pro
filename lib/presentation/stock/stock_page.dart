import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/stock/stock_model.dart';
import '../../domain/repositories/stock_repository.dart';
import '../../domain/repositories/auth_repository.dart';
import 'stock_view_model.dart';
import 'widgets/stock_item_card.dart';
import 'widgets/stock_filter_sheet.dart';
import 'widgets/stock_adjustment_dialog.dart';

class StockPage extends ConsumerWidget {
  const StockPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const StockView(); // StockView will watch `stockViewModelProvider`
  }
}

class StockView extends ConsumerWidget {
  const StockView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(stockViewModelProvider);
    final viewModel = ref.read(stockViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: viewModel.refresh,
          ),
          if (viewModel.canCreateStock) ...[
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _showAddStockDialog(context),
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          _buildFilterBar(context, ref),
          Expanded(child: _buildStockList(context, ref)),
          if (state.selectedStockIds.isNotEmpty)
            _buildBulkActions(context, ref),
        ],
      ),
    );
  }

  Widget _buildFilterBar(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(stockViewModelProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search...',
              ),
              onChanged: viewModel.setSearchQuery,
            ),
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () => _showFilterSheet(context),
          ),
        ],
      ),
    );
  }

  Widget _buildStockList(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(stockViewModelProvider.notifier);

    if (viewModel.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (viewModel.error != null) {
      return Center(child: Text('Error: ${viewModel.error}'));
    }

    if (viewModel.stocks.isEmpty) {
      return Center(child: Text('No stocks available'));
    }

    return ListView.builder(
      itemCount: viewModel.stocks.length,
      itemBuilder: (context, index) {
        final stock = viewModel.stocks[index];
        return StockItemCard(
          stock: stock,
          isSelected: viewModel.selectedStockIds.contains(stock.id),
          onTap: () => viewModel.toggleStockSelection(stock.id),
          onViewDetails: () => _showStockDetailsDialog(context, stock),
        );
      },
    );
  }

  Widget _buildBulkActions(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(stockViewModelProvider.notifier);

    return Container(
      padding: EdgeInsets.all(8.0),
      color: Colors.grey[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${viewModel.selectedCount} selected'),
          Row(
            children: [
              if (viewModel.canDeleteStock) ...[
                TextButton(
                  onPressed: viewModel.bulkDelete,
                  child: Text('Delete'),
                ),
              ],
              if (viewModel.canEditStock) ...[
                TextButton(
                  onPressed: () => _showBulkStatusUpdateDialog(context),
                  child: Text('Update Status'),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  void _showAddStockDialog(BuildContext context) {
    // Implement the dialog to add a new stock item
  }

  void _showStockDetailsDialog(BuildContext context, StockModel stock) {
    showDialog(
      context: context,
      builder: (context) => StockAdjustmentDialog(stock: stock),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => StockFilterSheet(),
    );
  }

  void _showBulkStatusUpdateDialog(BuildContext context) {
    // Implement the dialog to update status for multiple items
  }
}
