import 'package:clean_arch_app/domain/entities/stock/stock.dart';
import 'package:flutter/material.dart';
import '../../../core/enums/stock_status.dart';


class StockItemCard extends StatelessWidget {
  final Stock stock;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onViewDetails;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showSelectionCheckbox;

  const StockItemCard({
    Key? key,
    required this.stock,
    this.isSelected = false,
    this.onTap,
    this.onViewDetails,
    this.onEdit,
    this.onDelete,
    this.showSelectionCheckbox = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: isSelected ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSelected
            ? BorderSide(color: Theme.of(context).primaryColor, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (showSelectionCheckbox)
                    Checkbox(
                      value: isSelected,
                      onChanged: (_) => onTap?.call(),
                    ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text(
            stock.name ?? '-',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'SKU: ${stock.sku ?? '-'}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
                      ],
                    ),
                  ),
                  _buildStatusChip(context),
                ],
              ),
              SizedBox(height: 12),
              if (stock.description != null) ...[
                Text(
                  stock.description!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                SizedBox(height: 8),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [_buildQuantityInfo(), _buildPriceInfo()],
              ),
              SizedBox(height: 12),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    Color statusColor;
    IconData statusIcon;

    switch (stock.status) {
      case StockStatus.inStock:
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case StockStatus.lowStock:
        statusColor = Colors.orange;
        statusIcon = Icons.warning;
        break;
      case StockStatus.outOfStock:
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      case StockStatus.discontinued:
        statusColor = Colors.grey;
        statusIcon = Icons.block;
        break;
      case StockStatus.available:
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case StockStatus.reserved:
        statusColor = Colors.blue;
        statusIcon = Icons.lock;
        break;
      case StockStatus.damaged:
        statusColor = Colors.red;
        statusIcon = Icons.broken_image;
        break;
      case StockStatus.expired:
        statusColor = Colors.purple;
        statusIcon = Icons.schedule;
        break;
      case StockStatus.inTransit:
        statusColor = Colors.orange;
        statusIcon = Icons.local_shipping;
        break;
      case StockStatus.good:
        // TODO: Handle this case.
        throw UnimplementedError();
      case StockStatus.critical:
        // TODO: Handle this case.
        throw UnimplementedError();
      case StockStatus.low:
        // TODO: Handle this case.
        throw UnimplementedError();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, size: 16, color: statusColor),
          SizedBox(width: 4),
          Text(
            _getStatusText(stock.status),
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityInfo() {
    final isLowStock = stock.isLowStock;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quantity',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        Row(
          children: [Text(
            '${stock.quantity} ${stock.unit ?? ''}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isLowStock ? Colors.orange : null,
            ),
          ),
            if (isLowStock) ...[
              SizedBox(width: 4),
              Icon(Icons.warning, size: 16, color: Colors.orange),
            ],
          ],
        ),if (stock.reorderPoint != null && stock.quantity <= stock.reorderPoint!)
          Text(
            'Reorder at: ${stock.reorderPoint}',
            style: TextStyle(fontSize: 11, color: Colors.grey[500]),
          ),
      ],
    );
  }

  Widget _buildPriceInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text('Price', style: TextStyle(fontSize: 12, color: Colors.grey[600])),Text(
          stock.price != null ? '\$${stock.price!.toStringAsFixed(2)}' : '-',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.green[700],
          ),
        ),
        if (stock.price != null)
          Text(
            'Total: \$${(stock.price! * stock.quantity).toStringAsFixed(2)}',
            style: TextStyle(fontSize: 11, color: Colors.grey[500]),
          ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (onViewDetails != null)
          TextButton.icon(
            onPressed: onViewDetails,
            icon: Icon(Icons.visibility, size: 18),
            label: Text('View'),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 12),
            ),
          ),
        if (onEdit != null)
          TextButton.icon(
            onPressed: onEdit,
            icon: Icon(Icons.edit, size: 18),
            label: Text('Edit'),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 12),
            ),
          ),
        if (onDelete != null)
          TextButton.icon(
            onPressed: onDelete,
            icon: Icon(Icons.delete, size: 18),
            label: Text('Delete'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
              padding: EdgeInsets.symmetric(horizontal: 12),
            ),
          ),
      ],
    );
  }

  String _getStatusText(StockStatus status) {
    switch (status) {
      case StockStatus.inStock:
        return 'In Stock';
      case StockStatus.lowStock:
        return 'Low Stock';
      case StockStatus.outOfStock:
        return 'Out of Stock';
      case StockStatus.discontinued:
        return 'Discontinued';
      case StockStatus.available:
        return 'Available';
      case StockStatus.reserved:
        return 'Reserved';
      case StockStatus.damaged:
        return 'Damaged';
      case StockStatus.expired:
        return 'Expired';
      case StockStatus.inTransit:
        return 'In Transit';
      case StockStatus.good:
        // TODO: Handle this case.
        throw UnimplementedError();
      case StockStatus.critical:
        // TODO: Handle this case.
        throw UnimplementedError();
      case StockStatus.low:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }
}
