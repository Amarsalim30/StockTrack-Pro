import 'package:clean_arch_app/domain/entities/stock/stock.dart';
import 'package:flutter/material.dart';

class StockList extends StatefulWidget {
  final bool isLoading;
  final List<Stock> stocks;
  final Function(Stock)? onTap;
  final Function(Stock)? onEdit;
  final Function(Stock)? onDelete;
  final Function(Stock)? onSelect;
  final bool selectable;

  const StockList({
    super.key,
    required this.isLoading,
    required this.stocks,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onSelect,
    this.selectable = true,
  });

  @override
  State<StockList> createState() => _StockListState();
}

class _StockListState extends State<StockList> {
  final ScrollController _horizontalController = ScrollController();
  final Set<Stock> _selected = {};

  // Column widths
  final double _checkboxWidth = 50;
  final double _nameWidth = 200;
  final double _skuWidth = 120;
  final double _categoryWidth = 140;
  final double _locationWidth = 140;
  final double _stockWidth = 120;
  final double _minStockWidth = 110;
  final double _statusWidth = 110;
  final double _actionsWidth = 90;

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) return _buildLoadingSkeleton();
    if (widget.stocks.isEmpty) return _buildEmptyState();

    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _buildHeaderRow(),
          Expanded(
            child: ListView.builder(
              itemCount: widget.stocks.length,
              itemBuilder: (context, index) {
                final stock = widget.stocks[index];
                return _buildTableRow(stock, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: SingleChildScrollView(
        controller: _horizontalController,
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: _getTotalTableWidth(),
          child: Row(
            children: [
              _buildHeaderCell('', _checkboxWidth),
              _buildHeaderCell('NAME', _nameWidth),
              _buildHeaderCell('SKU', _skuWidth),
              _buildHeaderCell('CATEGORY', _categoryWidth),
              _buildHeaderCell('LOCATION', _locationWidth),
              _buildHeaderCell('STOCK', _stockWidth),
              _buildHeaderCell('MIN STOCK', _minStockWidth),
              _buildHeaderCell('STATUS', _statusWidth),
              _buildHeaderCell('ACTIONS', _actionsWidth),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCell(String text, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 13,
          color: Colors.grey.shade700,
          letterSpacing: 0.6,
        ),
      ),
    );
  }

  Widget _buildTableRow(Stock stock, int index) {
    final isSelected = _selected.contains(stock);

    return InkWell(
      onTap: () => widget.onTap?.call(stock),
      hoverColor: Colors.blue.withOpacity(0.05),
      child: Container(
        height: 64,
        color: index.isEven ? Colors.grey.shade50 : Colors.white,
        child: SingleChildScrollView(
          controller: _horizontalController,
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: _getTotalTableWidth(),
            child: Row(
              children: [
                _buildRowCheckbox(stock),
                _buildCell(stock.name ?? 'Unnamed', _nameWidth, FontWeight.w600),
                _buildCell(stock.sku ?? '-', _skuWidth, null, 'monospace'),
                _buildCell(stock.categoryId ?? 'N/A', _categoryWidth),
                _buildCell(stock.location ?? 'N/A', _locationWidth),
                _buildStockCell(stock),
                _buildCell('${stock.minimumStock ?? 0}', _minStockWidth,
                    FontWeight.w500, 'monospace'),
                _buildStatusCell(stock),
                _buildActionsCell(stock),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCell(String text, double width,
      [FontWeight? weight, String? fontFamily]) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontWeight: weight ?? FontWeight.normal,
          fontSize: 14,
          fontFamily: fontFamily,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildStockCell(Stock stock) {
    final progress = _getProgressValue(stock);
    final color = _getProgressColor(stock);

    return Container(
      width: _stockWidth,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${stock.quantity}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCell(Stock stock) {
    final statusName = stock.status.toString().split('.').last;
    final statusColor = _getStatusColor(statusName);
    return Container(
      width: _statusWidth,
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: statusColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          _formatStatusName(statusName),
          style: TextStyle(
            color: statusColor,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildActionsCell(Stock stock) {
    return SizedBox(
      width: _actionsWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.edit, size: 18, color: Colors.blue),
            onPressed: () => widget.onEdit?.call(stock),
            splashRadius: 20,
          ),
          IconButton(
            icon: const Icon(Icons.delete, size: 18, color: Colors.red),
            onPressed: () => widget.onDelete?.call(stock),
            splashRadius: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildRowCheckbox(Stock stock) {
    return SizedBox(
      width: _checkboxWidth,
      child: widget.selectable
          ? Checkbox(
        value: _selected.contains(stock),
        onChanged: (selected) {
          setState(() {
            if (selected == true) {
              _selected.add(stock);
            } else {
              _selected.remove(stock);
            }
            widget.onSelect?.call(stock);
          });
        },
      )
          : const SizedBox.shrink(),
    );
  }

  double _getTotalTableWidth() {
    return _checkboxWidth +
        _nameWidth +
        _skuWidth +
        _categoryWidth +
        _locationWidth +
        _stockWidth +
        _minStockWidth +
        _statusWidth +
        _actionsWidth;
  }

  double _getProgressValue(Stock stock) {
    final minStock = stock.minimumStock ?? 0;
    if (minStock == 0) return 1.0;
    return (stock.quantity / minStock).clamp(0.0, 1.0);
  }

  Color _getProgressColor(Stock stock) {
    final minStock = stock.minimumStock ?? 0;
    final ratio = minStock == 0 ? 1 : stock.quantity / minStock;
    if (ratio < 0.5) return Colors.red;
    if (ratio < 1) return Colors.orange;
    return Colors.green;
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'instock':
        return Colors.green;
      case 'outofstock':
        return Colors.red;
      case 'lowstock':
        return Colors.orange;
      case 'reserved':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _formatStatusName(String status) {
    switch (status.toLowerCase()) {
      case 'instock':
        return 'In Stock';
      case 'outofstock':
        return 'Out of Stock';
      case 'lowstock':
        return 'Low Stock';
      case 'reserved':
        return 'Reserved';
      default:
        return status;
    }
  }

  Widget _buildLoadingSkeleton() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        'No stocks available',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }
}
