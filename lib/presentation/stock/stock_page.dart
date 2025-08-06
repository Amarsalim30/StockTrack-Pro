import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/enums/stock_status.dart';
import '../../di/injection.dart';
import '../../domain/entities/stock/stock.dart';
import '../common/widgets/loading_indicator.dart';
import 'widgets/stock_item_card.dart';
import 'widgets/stock_filter_sheet.dart';
import 'widgets/stock_adjustment_dialog.dart';
import 'stock_state.dart';

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
              tooltip: 'Add Stock',
            ),
          ],
          PopupMenuButton(
            itemBuilder: (context) =>
            [
              if (viewModel.canViewStockReports) ...[
                const PopupMenuItem(
                  value: 'reports',
                  child: ListTile(
                    leading: Icon(Icons.analytics),
                    title: Text('Reports'),
                  ),
                ),
              ],
              const PopupMenuItem(
                value: 'settings',
                child: ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                ),
              ),
            ],
            onSelected: (value) {
              switch (value) {
                case 'reports':
                // Navigate to reports
                  break;
                case 'settings':
                // Navigate to settings
                  break;
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterBar(context, ref),
          Expanded(child: _buildStockList(context, ref)),
          if (state.isBulkSelectionMode && state.selectedStockIds.isNotEmpty)
            _buildBulkActions(context, ref),
        ],
      ),
    );
  }

  Widget _buildFilterBar(BuildContext context, WidgetRef ref) {
    final state = ref.watch(stockViewModelProvider);
    final viewModel = ref.read(stockViewModelProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search stocks...',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: viewModel.setSearchQuery,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () => _showFilterSheet(context, ref),
                tooltip: 'Filter',
              ),
              PopupMenuButton<SortBy>(
                icon: const Icon(Icons.sort),
                tooltip: 'Sort',
                onSelected: (sortBy) => viewModel.setSortBy(sortBy),
                itemBuilder: (context) =>
                [
                  PopupMenuItem(
                    value: SortBy.name,
                    child: Row(
                      children: [
                        Icon(state.sortBy == SortBy.name
                            ? (state.sortOrder == SortOrder.ascending ? Icons
                            .arrow_upward : Icons.arrow_downward)
                            : Icons.sort_by_alpha),
                        const SizedBox(width: 8),
                        const Text('Name'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: SortBy.quantity,
                    child: Row(
                      children: [
                        Icon(state.sortBy == SortBy.quantity
                            ? (state.sortOrder == SortOrder.ascending ? Icons
                            .arrow_upward : Icons.arrow_downward)
                            : Icons.numbers),
                        const SizedBox(width: 8),
                        const Text('Quantity'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: SortBy.lastUpdated,
                    child: Row(
                      children: [
                        Icon(state.sortBy == SortBy.lastUpdated
                            ? (state.sortOrder == SortOrder.ascending ? Icons
                            .arrow_upward : Icons.arrow_downward)
                            : Icons.schedule),
                        const SizedBox(width: 8),
                        const Text('Last Updated'),
                      ],
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(state.isBulkSelectionMode
                    ? Icons.check_box
                    : Icons.check_box_outline_blank),
                onPressed: viewModel.toggleBulkSelectionMode,
                tooltip: 'Toggle bulk selection',
              ),
            ],
          ),
          if (state.isBulkSelectionMode && state.stocks.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                TextButton(
                  onPressed: viewModel.selectAll,
                  child: const Text('Select All'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: viewModel.clearSelection,
                  child: const Text('Clear Selection'),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStockList(BuildContext context, WidgetRef ref) {
    final state = ref.watch(stockViewModelProvider);
    final viewModel = ref.read(stockViewModelProvider.notifier);

    return switch (state.status) {
      StockStateStatus.loading =>
      const Center(
        child: LoadingIndicator(message: 'Loading stocks...'),
      ),
      StockStateStatus.error => _buildErrorView(context, ref),
      _ => _buildStockListContent(context, ref),
    };
  }

  Widget _buildErrorView(BuildContext context, WidgetRef ref) {
    final state = ref.watch(stockViewModelProvider);
    final viewModel = ref.read(stockViewModelProvider.notifier);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            'Error: ${state.errorMessage ?? 'Unknown error'}',
            style: Theme
                .of(context)
                .textTheme
                .titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              viewModel.clearError();
              viewModel.loadStocks();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildStockListContent(BuildContext context, WidgetRef ref) {
    final state = ref.watch(stockViewModelProvider);
    final viewModel = ref.read(stockViewModelProvider.notifier);

    if (state.filteredStocks.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No stocks available',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: viewModel.refresh,
      child: ListView.builder(
        itemCount: state.filteredStocks.length,
        itemBuilder: (context, index) {
          final stock = state.filteredStocks[index];
          return StockItemCard(
            stock: stock,
            isSelected: state.selectedStockIds.contains(stock.id),
            showSelectionCheckbox: state.isBulkSelectionMode,
            onTap: state.isBulkSelectionMode
                ? () => viewModel.toggleStockSelection(stock.id)
                : () => _showStockDetailsDialog(context, stock),
            onViewDetails: () => _showStockDetailsDialog(context, stock),
            onEdit: viewModel.canEditStock
                ? () => _showEditStockDialog(context, stock)
                : null,
            onDelete: viewModel.canDeleteStock
                ? () => _showDeleteConfirmation(context, stock.id, ref)
                : null,
          );
        },
      ),
    );
  }

  Widget _buildBulkActions(BuildContext context, WidgetRef ref) {
    final state = ref.watch(stockViewModelProvider);
    final viewModel = ref.read(stockViewModelProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme
            .of(context)
            .colorScheme
            .surfaceVariant,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${state.selectedStockIds.length} selected',
            style: Theme
                .of(context)
                .textTheme
                .titleMedium,
          ),
          Row(
            children: [
              if (viewModel.canDeleteStock) ...[
                TextButton.icon(
                  onPressed: () => _showBulkDeleteConfirmation(context, ref),
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete'),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                ),
              ],
              if (viewModel.canEditStock) ...[
                TextButton.icon(
                  onPressed: () => _showBulkStatusUpdateDialog(context, ref),
                  icon: const Icon(Icons.update),
                  label: const Text('Update Status'),
                ),
              ],
              TextButton.icon(
                onPressed: viewModel.clearSelection,
                icon: const Icon(Icons.clear),
                label: const Text('Clear'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddStockDialog(BuildContext context) {
    // Navigate to add product page or show dialog
    Navigator.pushNamed(context, '/add-product');
  }

  void _showEditStockDialog(BuildContext context, Stock stock) {
    // Navigate to edit product page with stock data
    Navigator.pushNamed(context, '/edit-product', arguments: stock);
  }

  void _showStockDetailsDialog(BuildContext context, Stock stock) {
    showDialog(
      context: context,
      builder: (context) => StockAdjustmentDialog(stock: stock),
    );
  }

  void _showFilterSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const StockFilterSheet(),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String stockId,
      WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text('Delete Stock'),
            content: const Text(
                'Are you sure you want to delete this stock item?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  ref.read(stockViewModelProvider.notifier).deleteStock(
                      stockId);
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }

  void _showBulkDeleteConfirmation(BuildContext context, WidgetRef ref) {
    final selectedCount = ref
        .read(stockViewModelProvider)
        .selectedStockIds
        .length;

    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text('Delete Multiple Items'),
            content: Text(
                'Are you sure you want to delete $selectedCount stock items?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  ref.read(stockViewModelProvider.notifier).bulkDelete();
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete All'),
              ),
            ],
          ),
    );
  }

  void _showBulkStatusUpdateDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text('Update Status'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Select new status for selected items:'),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  children: StockStatus.values.map((status) {
                    return ActionChip(
                      label: Text(_getStatusText(status)),
                      onPressed: () {
                        Navigator.of(context).pop();
                        ref
                            .read(stockViewModelProvider.notifier)
                            .bulkUpdateStatus(status);
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ],
          ),
    );
  }

  String _getStatusText(StockStatus status) {
    switch (status) {
      case StockStatus.available:
        return 'Available';
      case StockStatus.inStock:
        return 'In Stock';
      case StockStatus.lowStock:
        return 'Low Stock';
      case StockStatus.outOfStock:
        return 'Out of Stock';
      case StockStatus.reserved:
        return 'Reserved';
      case StockStatus.damaged:
        return 'Damaged';
      case StockStatus.expired:
        return 'Expired';
      case StockStatus.inTransit:
        return 'In Transit';
      case StockStatus.discontinued:
        return 'Discontinued';
    }
  }
}
