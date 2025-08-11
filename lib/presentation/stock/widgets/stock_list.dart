import 'package:clean_arch_app/core/enums/stock_status.dart';
import 'package:clean_arch_app/domain/entities/stock/stock.dart';
import 'package:flutter/material.dart';

class StockList extends StatefulWidget {
  final List<Stock> stocks;
  final bool isLoading;
  final Function(Stock)? onEdit;
  final Function(Stock)? onView;
  final Function(Stock)? onDuplicate;
  final Function(Stock?)? onSelect;
  final bool selectable;

  const StockList({
    super.key,
    required this.stocks,
    this.isLoading = false,
    this.onEdit,
    this.onView,
    this.onDuplicate,
    this.onSelect,
    this.selectable = true,
  });

  @override
  State<StockList> createState() => _StockListState();
}

class _StockListState extends State<StockList> {
  final Set<String> _selectedItems = {};

  bool get _allSelected =>
      widget.stocks.isNotEmpty && _selectedItems.length == widget.stocks.length;

  void _notifySelectionChange() {
    final selected = widget.stocks.where((s) => _selectedItems.contains(s.id)).toList();
    widget.onSelect?.call(selected.isNotEmpty ? selected.first : null);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) return _buildLoadingState();
    if (widget.stocks.isEmpty) return _buildEmptyState();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12)],
      ),
      child: Column(
        children: [
          _buildHeader(context),
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 100, maxHeight: 800),
            child: LayoutBuilder(builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 700;
              return Flexible(
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: widget.stocks.length,
                  separatorBuilder: (_, __) =>
                      Divider(height: 1, color: Colors.grey.shade100),
                  itemBuilder: (context, index) {
                    final s = widget.stocks[index];
                    return isWide ? _buildDesktopRow(s, index) : _buildMobileRow(s, index);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final textStyle = TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.grey.shade600);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          if (widget.selectable)
            SizedBox(
              width: 56,
              child: Center(
                child: Checkbox(
                  value: _allSelected ? true : (_selectedItems.isEmpty ? false : null),
                  onChanged: _toggleSelectAll,
                  tristate: true,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
          Expanded(flex: 4, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text('ITEM DETAILS', style: textStyle))),
          Expanded(flex: 2, child: Text('STOCK', style: textStyle)),
          Expanded(flex: 2, child: Text('STATUS', style: textStyle)),
          const SizedBox(width: 120, child: Center(child: Text('ACTIONS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF64748B))))),
        ],
      ),
    );
  }

  Widget _buildDesktopRow(Stock stock, int index) {
    final isSelected = _selectedItems.contains(stock.id);
    final isEven = index % 2 == 0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.shade50 : (isEven ? Colors.white : const Color(0xFFFAFAFA)),
        borderRadius: BorderRadius.circular(10),
        border: isSelected ? Border.all(color: Colors.blue.shade200, width: 1.5) : null,
      ),
      child: InkWell(
        onTap: () => widget.onView?.call(stock),
        borderRadius: BorderRadius.circular(10),
        child: Row(
          children: [
            if (widget.selectable)
              SizedBox(
                width: 56,
                child: Center(
                  child: Checkbox(
                    value: isSelected,
                    onChanged: (_) => _toggleSelection(stock.id),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),
            Expanded(flex: 4, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: _buildItemDetails(stock))),
            Expanded(flex: 2, child: Center(child: _buildStockBlock(stock))),
            Expanded(flex: 2, child: Center(child: _buildStatusBadge(stock.status))),
            SizedBox(
              width: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Tooltip(message: 'Edit', child: _roundIconButton(Icons.edit_outlined, const Color(0xFF3B82F6), () => widget.onEdit?.call(stock))),
                  const SizedBox(width: 8),
                  Tooltip(message: 'View', child: _roundIconButton(Icons.visibility_outlined, const Color(0xFF10B981), () => widget.onView?.call(stock))),
                  const SizedBox(width: 8),
                  Tooltip(message: 'Duplicate', child: _roundIconButton(Icons.content_copy_outlined, const Color(0xFF8B5CF6), () => widget.onDuplicate?.call(stock))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileRow(Stock stock, int index) {
    final isSelected = _selectedItems.contains(stock.id);

    return ListTile(
      key: ValueKey(stock.id),
      onTap: () => widget.onView?.call(stock),
      leading: widget.selectable
          ? Checkbox(value: isSelected, onChanged: (_) => _toggleSelection(stock.id), materialTapTargetSize: MaterialTapTargetSize.shrinkWrap)
          : CircleAvatar(radius: 18, child: Text(_initials(stock.name), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
      title: Text(stock.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 6),
        Wrap(spacing: 8, runSpacing: 4, children: [
          Text('SKU: ${stock.sku ?? "-"}', style: const TextStyle(fontFamily: 'monospace', fontSize: 12, color: Colors.black54)),
          Text(stock.categoryId?.toString() ?? '-', style: const TextStyle(fontSize: 12, color: Colors.black54)),
          Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.location_on_outlined, size: 12, color: Colors.black38),
            const SizedBox(width: 4),
            Text(stock.location?.toString() ?? '-', style: const TextStyle(fontSize: 12, color: Colors.black54)),
          ]),
        ])
      ]),
      trailing: Column(mainAxisSize: MainAxisSize.min, children: [
        // quantity box
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8)),
          child: Column(children: [FittedBox(child: Text('${stock.quantity ?? 0}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16))), const SizedBox(height: 2), Text('Min: ${stock.minimumStock ?? 0}', style: const TextStyle(fontSize: 10))]),
        ),
        const SizedBox(height: 8),
        _buildStatusBadge(stock.status),
        const SizedBox(height: 8),
        Row(mainAxisSize: MainAxisSize.min, children: [
          IconButton(icon: const Icon(Icons.edit_outlined, size: 18), onPressed: () => widget.onEdit?.call(stock), tooltip: 'Edit'),
          IconButton(icon: const Icon(Icons.content_copy_outlined, size: 18), onPressed: () => widget.onDuplicate?.call(stock), tooltip: 'Duplicate'),
        ])
      ]),
    );
  }

  Widget _buildItemDetails(Stock stock) {
    return Row(
      children: [
        CircleAvatar(radius: 18, backgroundColor: Colors.blue.shade50, child: Text(_initials(stock.name), style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.blue))),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(stock.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 6),
            Row(children: [
              Text('SKU: ${stock.sku ?? "-"}', style: const TextStyle(fontSize: 12, fontFamily: 'monospace', color: Colors.black54)),
              const SizedBox(width: 12),
              Text(stock.categoryId?.toString() ?? '-', style: const TextStyle(fontSize: 12, color: Colors.black54)),
              const SizedBox(width: 12),
              Row(children: [
                Icon(Icons.location_on_outlined, size: 12, color: Colors.black38),
                const SizedBox(width: 4),
                Text(stock.location?.toString() ?? '-', style: const TextStyle(fontSize: 12, color: Colors.black54)),
              ])
            ])
          ]),
        )
      ],
    );
  }

  Widget _buildStockBlock(Stock stock) {
    final qty = stock.quantity ?? 0;
    final min = stock.minimumStock ?? 0;
    final width = 64.0;
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Text('$qty', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
      const SizedBox(height: 4),
      Text('Min: $min', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
      const SizedBox(height: 6),
      Container(
        width: width,
        height: 8,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: Colors.grey.shade200),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(value: _getStockProgress(stock), backgroundColor: Colors.transparent, valueColor: AlwaysStoppedAnimation(_getStockColor(stock))),
        ),
      )
    ]);
  }

  Widget _buildStatusBadge(StockStatus? status) {
    final s = status ?? StockStatus.available;
    final map = _statusStyle(s);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: map['bg'] as Color, borderRadius: BorderRadius.circular(14)),
      child: Text(map['label'] as String, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: map['fg'] as Color)),
    );
  }

  Map<String, Object> _statusStyle(StockStatus s) {
    switch (s) {
      case StockStatus.good:
        return {'label': 'GOOD', 'bg': const Color(0xFFDCFCE7), 'fg': const Color(0xFF166534)};
      case StockStatus.critical:
        return {'label': 'CRITICAL', 'bg': const Color(0xFFFEE2E2), 'fg': const Color(0xFF991B1B)};
      case StockStatus.low:
        return {'label': 'LOW', 'bg': const Color(0xFFFEF3C7), 'fg': const Color(0xFF92400E)};
      case StockStatus.outOfStock:
        return {'label': 'OUT', 'bg': const Color(0xFFF3F4F6), 'fg': const Color(0xFF374151)};
      case StockStatus.available:
      default:
        return {'label': 'AVAILABLE', 'bg': const Color(0xFFEFFAF6), 'fg': const Color(0xFF065F46)};
    }
  }

  Widget _roundIconButton(IconData icon, Color color, VoidCallback onTap) {
    return Material(
      color: color.withOpacity(0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(8), child: Padding(padding: const EdgeInsets.all(6), child: Icon(icon, size: 18, color: color))),
    );
  }

  double _getStockProgress(Stock stock) {
    final min = (stock.minimumStock ?? 0).toDouble();
    if (min <= 0) return 1.0;
    final prog = (stock.quantity ?? 0) / (min * 2);
    return prog.clamp(0.0, 1.0);
  }

  Color _getStockColor(Stock stock) {
    final min = (stock.minimumStock ?? 0).toDouble();
    final qty = (stock.quantity ?? 0).toDouble();
    final ratio = min <= 0 ? 1.0 : qty / min;
    if (ratio <= 0.5) return const Color(0xFFEF4444);
    if (ratio <= 1.0) return const Color(0xFFF59E0B);
    return const Color(0xFF10B981);
  }

  void _toggleSelection(String stockId) {
    setState(() {
      if (_selectedItems.contains(stockId)) {
        _selectedItems.remove(stockId);
      } else {
        _selectedItems.add(stockId);
      }
      _notifySelectionChange();
    });
  }

  void _toggleSelectAll(bool? value) {
    setState(() {
      if (value == true) {
        _selectedItems.addAll(widget.stocks.map((s) => s.id));
      } else {
        _selectedItems.clear();
      }
      _notifySelectionChange();
    });
  }

  Widget _buildLoadingState() {
    return Container(
      height: 200,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))]),
      child: const Center(child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Color(0xFF3B82F6)))),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 220,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))]),
      child: const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.inventory_2_outlined, size: 48, color: Color(0xFF9CA3AF)), SizedBox(height: 16), Text('No inventory items found', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF6B7280))), SizedBox(height: 8), Text('Add items to your inventory to get started', style: TextStyle(fontSize: 14, color: Color(0xFF9CA3AF))),])),
    );
  }

  String _initials(String? name) {
    if (name == null || name.trim().isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }
}
