// lib/presentation/stock/widgets/stock_row_mobile.dart

import 'package:flutter/material.dart';
import 'styles.dart';
import '../../../domain/entities/stock/stock.dart';
import '../../../core/enums/stock_status.dart';

class StockRowMobile extends StatelessWidget {
  final Stock stock;
  final bool isSelected;
  final ValueChanged<bool?> onSelect;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onViewDetails;
  final bool enableSwipeActions;

  const StockRowMobile({
    Key? key,
    required this.stock,
    required this.isSelected,
    required this.onSelect,
    required this.onEdit,
    required this.onDelete,
    required this.onViewDetails,
    this.enableSwipeActions = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rowContent = _buildRowContent(context);

    if (enableSwipeActions) {
      // Optional: implement swipe-to-edit/delete
      return Dismissible(
        key: ValueKey(stock.id),
        background: _swipeBackground(StockStyles.statusInStock, Icons.edit),
        secondaryBackground: _swipeBackground(StockStyles.statusOutOfStock, Icons.delete),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            onEdit();
            return false;
          } else {
            onDelete();
            return true;
          }
        },
        child: rowContent,
      );
    }

    return rowContent;
  }

  Widget _buildRowContent(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: StockStyles.borderColor),
        ),
        color: StockStyles.background,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: StockStyles.spaceLG,
        vertical: StockStyles.spaceMD,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: isSelected,
            onChanged: onSelect,
          ),
          const SizedBox(width: StockStyles.spaceSM),
          Expanded(
            child: GestureDetector(
              onTap: onViewDetails,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(stock.name, style: StockStyles.body.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: StockStyles.spaceXS),
                  _buildQuantityBar(),
                  const SizedBox(height: StockStyles.spaceXS),
                  _buildStatusPill(stock.status),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, size: 20),
            onPressed: () => _showActionMenu(context),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityBar() {
    final progress = stock.quantity / stock.minimumStock;
    final clampedProgress = progress > 1 ? 1.0 : progress;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Qty: ${stock.quantity} / Min: ${stock.minimumStock}',
          style: StockStyles.caption,
        ),
        const SizedBox(height: StockStyles.spaceXS),
        ClipRRect(
          borderRadius: BorderRadius.circular(StockStyles.radiusSM),
          child: LinearProgressIndicator(
            value: clampedProgress,
            backgroundColor: StockStyles.qtyBarBackground,
            valueColor: AlwaysStoppedAnimation<Color>(
              progress >= 1
                  ? StockStyles.statusInStock
                  : progress >= 0.5
                  ? StockStyles.statusLowStock
                  : StockStyles.statusOutOfStock,
            ),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusPill(StockStatus status) {
    final color = _statusColor(status);
    final label = _statusLabel(status);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: StockStyles.spaceSM,
        vertical: StockStyles.spaceXS,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(StockStyles.radiusMD),
      ),
      child: Text(
        label,
        style: StockStyles.caption.copyWith(color: color, fontWeight: FontWeight.w500),
      ),
    );
  }

  Color _statusColor(StockStatus status) {
    switch (status) {
      case StockStatus.inStock:
        return StockStyles.statusInStock;
      case StockStatus.lowStock:
        return StockStyles.statusLowStock;
      case StockStatus.outOfStock:
        return StockStyles.statusOutOfStock;
    }
  }

  String _statusLabel(StockStatus status) {
    switch (status) {
      case StockStatus.inStock:
        return 'In Stock';
      case StockStatus.lowStock:
        return 'Low Stock';
      case StockStatus.outOfStock:
        return 'Out of Stock';
    }
  }

  Widget _swipeBackground(Color color, IconData icon) {
    return Container(
      color: color,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: StockStyles.spaceLG),
      child: Icon(icon, color: Colors.white),
    );
  }

  void _showActionMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(StockStyles.radiusLG)),
      ),
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit'),
                onTap: () {
                  Navigator.pop(context);
                  onEdit();
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete'),
                onTap: () {
                  Navigator.pop(context);
                  onDelete();
                },
              ),
              ListTile(
                leading: const Icon(Icons.close),
                title: const Text('Close'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }
}
