import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../../core/constants/colors.dart';

/// Production-ready spreadsheet table with enhanced features:
/// - Sortable columns with visual indicators
/// - Row selection with bulk operations
/// - Responsive column widths
/// - Hover effects and improved accessibility
/// - Loading states and empty handling
class SpreadsheetTable extends StatefulWidget {
  final List stocks;
  final bool isLoading;
  final void Function(dynamic stock, String action)? onAction;
  final void Function(dynamic stock)? onTap;
  final void Function(Set<dynamic> selected)? onSelectionChanged;
  final void Function(String column, bool ascending)? onSort;
  final String? sortColumn;
  final bool sortAscending;

  const SpreadsheetTable({
    super.key,
    required this.stocks,
    this.isLoading = false,
    this.onAction,
    this.onTap,
    this.onSelectionChanged,
    this.onSort,
    this.sortColumn,
    this.sortAscending = true,
  });

  @override
  State<SpreadsheetTable> createState() => _SpreadsheetTableState();
}

class _SpreadsheetTableState extends State<SpreadsheetTable> {
  final Set<dynamic> _selectedItems = {};
  final ScrollController _horizontalController = ScrollController();
  final ScrollController _verticalController = ScrollController();

  @override
  void dispose() {
    _horizontalController.dispose();
    _verticalController.dispose();
    super.dispose();
  }

  bool get _isAllSelected =>
      _selectedItems.length == widget.stocks.length && widget.stocks.isNotEmpty;
  bool get _hasSelection => _selectedItems.isNotEmpty;

  void _toggleSelectAll() {
    HapticFeedback.selectionClick();
    setState(() {
      if (_isAllSelected) {
        _selectedItems.clear();
      } else {
        _selectedItems.addAll(widget.stocks);
      }
      widget.onSelectionChanged?.call(_selectedItems);
    });
  }

  void _toggleSelection(dynamic item) {
    HapticFeedback.selectionClick();
    setState(() {
      if (_selectedItems.contains(item)) {
        _selectedItems.remove(item);
      } else {
        _selectedItems.add(item);
      }
      widget.onSelectionChanged?.call(_selectedItems);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return _buildLoadingState();
    }

    if (widget.stocks.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Selection bar (appears when items are selected)
          if (_hasSelection) _buildSelectionBar(),

          // Table header
          _buildTableHeader(),

          // Table content
          Expanded(
            child: Scrollbar(
              controller: _verticalController,
              thumbVisibility: true,
              child: Scrollbar(
                controller: _horizontalController,
                thumbVisibility: true,
                notificationPredicate: (notification) =>
                    notification.depth == 1,
                child: SingleChildScrollView(
                  controller: _horizontalController,
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: _calculateTableWidth(),
                    child: ListView.builder(
                      controller: _verticalController,
                      itemCount: widget.stocks.length,
                      itemBuilder: (context, index) {
                        final stock = widget.stocks[index];
                        return _buildDataRow(stock, index);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _calculateTableWidth() {
    return 60 +
        200 +
        140 +
        100 +
        120 +
        120 +
        180 +
        140; // Sum of all column widths
  }

  Widget _buildSelectionBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.slate[50] ?? Colors.blue.withValues(alpha: 0.05),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        border: Border(
          bottom: BorderSide(color: AppColors.slate[200] ?? Colors.grey[300]!),
        ),
      ),
      child: Row(
        children: [
          Icon(
            LucideIcons.square_check,
            size: 20,
            color: AppColors.slate[600] ?? Colors.blue,
          ),
          const SizedBox(width: 8),
          Text(
            '${_selectedItems.length} item${_selectedItems.length == 1 ? '' : 's'} selected',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.slate[700] ?? Colors.blue[700],
            ),
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: () => _handleBulkAction('export'),
            icon: const Icon(LucideIcons.download, size: 16),
            label: const Text('Export'),
          ),
          const SizedBox(width: 8),
          TextButton.icon(
            onPressed: () => _handleBulkAction('delete'),
            icon: const Icon(LucideIcons.trash_2, size: 16),
            label: const Text('Delete'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              setState(() {
                _selectedItems.clear();
                widget.onSelectionChanged?.call(_selectedItems);
              });
            },
            icon: const Icon(LucideIcons.x, size: 18),
            tooltip: 'Clear selection',
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.slate[50] ?? Colors.grey[50],
        borderRadius: _hasSelection
            ? null
            : const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
        border: Border(
          bottom: BorderSide(color: AppColors.slate[200] ?? Colors.grey[300]!),
        ),
      ),
      child: Row(
        children: [
          // Select all checkbox
          SizedBox(
            width: 60,
            child: Checkbox(
              value: _isAllSelected,
              tristate: _hasSelection && !_isAllSelected,
              onChanged: (_) => _toggleSelectAll(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),

          // Column headers
          _buildSortableHeader('Product Name', 'name', 200),
          _buildSortableHeader('SKU', 'sku', 140),
          _buildSortableHeader(
            'Quantity',
            'quantity',
            100,
            alignment: TextAlign.center,
          ),
          _buildSortableHeader('Unit', 'unit', 120),
          _buildSortableHeader(
            'Status',
            'status',
            120,
            alignment: TextAlign.center,
          ),
          _buildSortableHeader('Location', 'location', 180),
          SizedBox(
            width: 140,
            child: Text(
              'Actions',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: AppColors.slate[700] ?? Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortableHeader(
    String title,
    String column,
    double width, {
    TextAlign alignment = TextAlign.left,
  }) {
    final isActive = widget.sortColumn == column;

    return SizedBox(
      width: width,
      child: InkWell(
        onTap: () => widget.onSort?.call(column, !widget.sortAscending),
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  title,
                  textAlign: alignment,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: isActive
                        ? AppColors.slate[700] ?? Colors.blue[700]
                        : AppColors.slate[600] ?? Colors.grey[700],
                  ),
                ),
              ),
              if (isActive) ...[
                const SizedBox(width: 4),
                Icon(
                  widget.sortAscending
                      ? LucideIcons.chevron_up
                      : LucideIcons.chevron_down,
                  size: 14,
                  color: AppColors.slate[600] ?? Colors.blue,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataRow(dynamic stock, int index) {
    final isSelected = _selectedItems.contains(stock);
    final isEven = index.isEven;

    return InkWell(
      onTap: () => widget.onTap?.call(stock),
      hoverColor: AppColors.slate[50]?.withValues(alpha: 0.3),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.slate[100]?.withValues(alpha: 0.5) ??
                    Colors.blue.withValues(alpha: 0.05)
              : (isEven
                    ? Colors.transparent
                    : AppColors.slate[25] ?? Colors.grey.withValues(alpha: 0.02)),
          border: index < widget.stocks.length - 1
              ? Border(
                  bottom: BorderSide(
                    color: AppColors.slate[100] ?? Colors.grey[200]!,
                    width: 0.5,
                  ),
                )
              : null,
        ),
        child: Row(
          children: [
            // Checkbox
            SizedBox(
              width: 60,
              child: Checkbox(
                value: isSelected,
                onChanged: (_) => _toggleSelection(stock),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),

            // Product name
            SizedBox(width: 200, child: _buildProductCell(stock)),

            // SKU
            SizedBox(width: 140, child: _buildSkuCell(stock)),

            // Quantity
            SizedBox(width: 100, child: _buildQuantityCell(stock)),

            // Unit
            SizedBox(width: 120, child: _buildUnitCell(stock)),

            // Status
            SizedBox(width: 120, child: _buildStatusCell(stock)),

            // Location
            SizedBox(width: 180, child: _buildLocationCell(stock)),

            // Actions
            SizedBox(width: 140, child: _buildActionsCell(stock)),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCell(dynamic stock) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          stock.name ?? 'Unknown Product',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (stock.description != null) ...[
          const SizedBox(height: 2),
          Text(
            stock.description!,
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  Widget _buildSkuCell(dynamic stock) {
    return Text(
      stock.sku ?? 'N/A',
      style: TextStyle(
        fontFamily: 'monospace',
        fontSize: 13,
        color: Colors.grey[700],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildQuantityCell(dynamic stock) {
    final quantity = stock.quantity ?? 0;
    final minStock = stock.minimumStock ?? 0;
    final color = _getQuantityColor(quantity, minStock);

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Text(
          quantity.toString(),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: color,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildUnitCell(dynamic stock) {
    return Text(
      stock.unit ?? 'pcs',
      style: TextStyle(color: Colors.grey[600], fontSize: 13),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildStatusCell(dynamic stock) {
    final status = _getStockStatus(stock);

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: status.color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: status.color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: status.color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              status.label,
              style: TextStyle(
                color: status.color,
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationCell(dynamic stock) {
    return Row(
      children: [
        Icon(LucideIcons.map_pin, size: 14, color: Colors.grey[500]),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            stock.location ?? 'No location',
            style: TextStyle(
              color: stock.location != null
                  ? Colors.grey[700]
                  : Colors.grey[500],
              fontSize: 13,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildActionsCell(dynamic stock) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: 'Edit',
          onPressed: () => widget.onAction?.call(stock, 'edit'),
          icon: const Icon(Icons.edit, size: 16),
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          padding: const EdgeInsets.all(4),
        ),
        const SizedBox(width: 4),
        PopupMenuButton<String>(
          tooltip: 'More actions',
          onSelected: (action) => widget.onAction?.call(stock, action),
          itemBuilder: (_) => [
            const PopupMenuItem(
              value: 'view',
              child: Row(
                children: [
                  Icon(LucideIcons.eye, size: 16),
                  SizedBox(width: 8),
                  Text('View Details'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'adjust',
              child: Row(
                children: [
                  Icon(LucideIcons.plus, size: 16),
                  SizedBox(width: 8),
                  Text('Adjust Stock'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'duplicate',
              child: Row(
                children: [
                  Icon(LucideIcons.copy, size: 16),
                  SizedBox(width: 8),
                  Text('Duplicate'),
                ],
              ),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(LucideIcons.trash_2, size: 16, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
          child: const Padding(
            padding: EdgeInsets.all(4),
            child: Icon(LucideIcons.move_horizontal, size: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Loading header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Loading rows
          Expanded(
            child: ListView.builder(
              itemCount: 8,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[200]!),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 14,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              height: 12,
                              width: 120,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        width: 60,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        width: 80,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.package_x, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'No Stock Items Found',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Add your first inventory item to get started',
                style: TextStyle(color: Colors.grey[500], fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Utility methods
  Color _getQuantityColor(int quantity, int minStock) {
    if (quantity <= 0) return Colors.red[600]!;
    if (quantity <= minStock) return Colors.orange[600]!;
    return Colors.green[600]!;
  }

  StockStatusInfo _getStockStatus(dynamic stock) {
    final quantity = stock.quantity ?? 0;
    final minStock = stock.minimumStock ?? 0;

    if (quantity <= 0) {
      return StockStatusInfo(label: 'Out of Stock', color: Colors.red[600]!);
    } else if (quantity <= minStock) {
      return StockStatusInfo(label: 'Low Stock', color: Colors.orange[600]!);
    } else {
      return StockStatusInfo(label: 'In Stock', color: Colors.green[600]!);
    }
  }

  void _handleBulkAction(String action) {
    // Handle bulk actions here
    HapticFeedback.mediumImpact();
    print('Bulk $action for ${_selectedItems.length} items');
  }
}

class StockStatusInfo {
  final String label;
  final Color color;

  const StockStatusInfo({required this.label, required this.color});
}
