// lib/presentation/stock/widgets/stock_table_mobile.dart

import 'package:flutter/material.dart';
import '../../../domain/entities/stock/stock.dart';
import '../../../core/enums/stock_status.dart';
import 'stock_row_mobile.dart';
import 'styles.dart';

class StockTableMobile extends StatelessWidget {
  final List<Stock> stocks;
  final Set<String> selectedStockIds;
  final bool isAllSelected;
  final ValueChanged<bool?> onSelectAll;
  final ValueChanged<String> onSelectRow;
  final VoidCallback onBulkDelete;
  final VoidCallback onBulkEdit;
  final void Function(Stock) onEditStock;
  final void Function(Stock) onDeleteStock;
  final void Function(Stock) onViewDetails;
  final bool enableSwipeActions;

  const StockTableMobile({
    Key? key,
    required this.stocks,
    required this.selectedStockIds,
    required this.isAllSelected,
    required this.onSelectAll,
    required this.onSelectRow,
    required this.onBulkDelete,
    required this.onBulkEdit,
    required this.onEditStock,
    required this.onDeleteStock,
    required this.onViewDetails,
    this.enableSwipeActions = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        const Divider(height: 1, color: StockStyles.borderColor),
        Expanded(
          child: ListView.builder(
            itemCount: stocks.length,
            itemBuilder: (context, index) {
              final stock = stocks[index];
              return StockRowMobile(
                stock: stock,
                isSelected: selectedStockIds.contains(stock.id),
                onSelect: (_) => onSelectRow(stock.id),
                onEdit: () => onEditStock(stock),
                onDelete: () => onDeleteStock(stock),
                onViewDetails: () => onViewDetails(stock),
                enableSwipeActions: enableSwipeActions,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: StockStyles.spaceLG,
        vertical: StockStyles.spaceSM,
      ),
      color: StockStyles.headerBackground,
      child: Row(
        children: [
          Checkbox(
            value: isAllSelected,
            onChanged: onSelectAll,
          ),
          const SizedBox(width: StockStyles.spaceSM),
          Expanded(
            child: Text(
              'Item',
              style: StockStyles.caption.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            'Qty',
            style: StockStyles.caption.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: StockStyles.spaceLG),
          Text(
            'Status',
            style: StockStyles.caption.copyWith(fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: _showBulkActions,
          ),
        ],
      ),
    );
  }

  void _showBulkActions() {
    // This will be called from the header's 3-dot menu
    // Bulk edit/delete menu
    // In production you can pass context via callback
  }
}
