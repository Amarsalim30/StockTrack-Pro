// lib/presentation/stock/widgets/stock_list.dart
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:clean_arch_app/core/enums/stock_status.dart';
import '../../../domain/entities/stock/stock.dart';

/// Production-grade responsive StockList
/// - Desktop/tablet: spreadsheet-like table (explicit column widths)
/// - Mobile: stacked, touch-friendly cards
/// - Features: selection, swipe-to-delete, pull-to-refresh skeletons, stable keys
class StockList extends StatefulWidget {
  final List<Stock> stocks;
  final bool isLoading;
  final Future<void> Function()? onRefresh;
  final void Function(Stock stock, String action)? onAction;
  final void Function(Stock stock)? onTap;
  final void Function(Set<Stock> selected)? onSelectionChanged;

  const StockList({
    super.key,
    required this.stocks,
    this.isLoading = false,
    this.onRefresh,
    this.onAction,
    this.onTap,
    this.onSelectionChanged,
  });

  @override
  State<StockList> createState() => _StockListState();
}

class _StockListState extends State<StockList> with TickerProviderStateMixin {
  // Local selection state (could be lifted)
  final Set<Stock> _selected = <Stock>{};

  // Breakpoints & fixed column widths — tweak to match your brand
  static const double _desktopBreakpoint = 880;
  static const double _actionsColumnWidth = 88;
  static const double _checkboxColumnWidth = 56;

  bool get _isAllSelected => _selected.length == widget.stocks.length && widget.stocks.isNotEmpty;

  void _toggleSelectAll(bool? v) {
    setState(() {
      if (v == true) {
        _selected.addAll(widget.stocks);
      } else {
        _selected.clear();
      }
      widget.onSelectionChanged?.call(_selected);
    });
  }

  void _toggleItemSelection(Stock item, bool? v) {
    setState(() {
      if (v == true) _selected.add(item);
      else _selected.remove(item);
      widget.onSelectionChanged?.call(_selected);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return _buildLoading();
    }

    if (widget.stocks.isEmpty) {
      return Center(child: Text('No stock items found.', style: TextStyle(color: Colors.grey[700])));
    }

    return LayoutBuilder(builder: (context, constraints) {
      final isDesktop = constraints.maxWidth >= _desktopBreakpoint;
      return isDesktop ? _buildDesktopTable(constraints) : _buildMobileList();
    });
  }

  // ---------------- Desktop / Table ----------------
  Widget _buildDesktopTable(BoxConstraints constraints) {
    // horizontal scroll if table width > viewport
    final minWidth = constraints.maxWidth;
    return Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: minWidth),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            margin: EdgeInsets.zero,
            child: Column(
              children: [
                // Header
                Container(
                  color: Colors.grey.shade100,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Row(
                    children: [
                      SizedBox(width: _checkboxColumnWidth, child: _headerCheckbox()),
                      Expanded(flex: 4, child: _headerText('ITEM DETAILS')),
                      Expanded(flex: 2, child: _headerText('STOCK', alignRight: true)),
                      Expanded(flex: 2, child: _headerText('STATUS', alignCenter: true)),
                      SizedBox(width: _actionsColumnWidth, child: _headerText('Actions', alignCenter: true)),
                    ],
                  ),
                ),

                // Divider
                const Divider(height: 1),

                // Rows
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(), // outer scroll handles it
                  shrinkWrap: true,
                  itemCount: widget.stocks.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, idx) {
                    final item = widget.stocks[idx];
                    return _desktopRow(item);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _headerCheckbox() {
    return Checkbox(
      value: _isAllSelected,
      onChanged: (v) => _toggleSelectAll(v),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    );
  }

  Widget _headerText(String text, {bool alignRight = false, bool alignCenter = false}) {
    final alignment = alignCenter ? Alignment.center : (alignRight ? Alignment.centerRight : Alignment.centerLeft);
    return Align(
      alignment: alignment,
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
    );
  }

  Widget _desktopRow(Stock item) {
    final status = _statusMapping(item.status);
    final isSelected = _selected.contains(item);

    return InkWell(
      onTap: () => widget.onTap?.call(item),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        color: isSelected ? Colors.blue.withOpacity(0.04) : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Row(
          children: [
            SizedBox(
              width: _checkboxColumnWidth,
              child: Checkbox(
                value: isSelected,
                onChanged: (v) => _toggleItemSelection(item, v),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
            ),
            Expanded(
              flex: 4,
              child: _itemDetailsColumn(item, compact: true),
            ),
            Expanded(
              flex: 2,
              child: _stockColumn(item, alignRight: true),
            ),
            Expanded(
              flex: 2,
              child: Align(alignment: Alignment.center, child: _statusBadge(status)),
            ),
            SizedBox(
              width: _actionsColumnWidth,
              child: Align(
                alignment: Alignment.center,
                child: _rowActions(item),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- Mobile / Card List ----------------
  Widget _buildMobileList() {
    return RefreshIndicator.adaptive(
      onRefresh: widget.onRefresh ?? () async {},
      child: ListView.builder(
        key: const PageStorageKey('stock_mobile_list'),
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: widget.stocks.length,
        itemBuilder: (_, idx) {
          final item = widget.stocks[idx];
          return Dismissible(
            key: ValueKey(item.id ?? idx),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(color: Colors.red.shade700, borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            confirmDismiss: (_) => _confirmDelete(item),
            onDismissed: (_) => widget.onAction?.call(item, 'delete'),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 1,
                child: InkWell(
                  onTap: () => widget.onTap?.call(item),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        // Checkbox (bigger touch area on mobile)
                        InkResponse(
                          onTap: () => _toggleItemSelection(item, !_selected.contains(item)),
                          radius: 26,
                          child: Checkbox(
                            value: _selected.contains(item),
                            onChanged: (v) => _toggleItemSelection(item, v),
                          ),
                        ),

                        // Content
                        Expanded(
                          child: _itemDetailsColumn(item),
                        ),

                        // Qty + actions
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _quantityBadge(item),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  tooltip: 'Refresh',
                                  onPressed: () => widget.onAction?.call(item, 'refresh'),
                                  icon: const Icon(LucideIcons.refresh_cw, size: 20),
                                ),
                                PopupMenuButton<String>(
                                  tooltip: 'More actions',
                                  onSelected: (v) => widget.onAction?.call(item, v),
                                  itemBuilder: (_) => const [
                                    PopupMenuItem(value: 'view', child: Text('View')),
                                    PopupMenuItem(value: 'adjust', child: Text('Adjust')),
                                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ---------------- Row pieces ----------------
  Widget _itemDetailsColumn(Stock stock, {bool compact = false}) {
    // compact true for desktop where vertical space is limited
    final nameStyle = const TextStyle(fontWeight: FontWeight.w600, fontSize: 14);
    final metaStyle = TextStyle(color: Colors.grey[700], fontSize: compact ? 12 : 13);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(stock.name ?? '-', style: nameStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 6),
        Row(
          children: [
            Flexible(child: Text('SKU: ${stock.sku ?? "-"}', style: metaStyle, maxLines: 1, overflow: TextOverflow.ellipsis)),
            const SizedBox(width: 12),
            if (stock.location != null)
              Row(
                children: [
                  const Icon(Icons.location_pin, size: 12, color: Colors.grey),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(stock.location!, style: metaStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }

  Widget _stockColumn(Stock stock, {bool alignRight = false}) {
    final qtyText = Text('${stock.quantity}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15));
    final minText = Text('Min: ${stock.minimumStock ?? 0}', style: TextStyle(color: Colors.grey[600], fontSize: 12));

    return Column(
      crossAxisAlignment: alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        qtyText,
        const SizedBox(height: 6),
        minText,
        const SizedBox(height: 6),
        SizedBox(
          width: 100,
          child: LinearProgressIndicator(
            value: _progressValue(stock),
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(_progressColor(stock)),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _statusBadge(Map<String, dynamic> status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: (status['color'] as Color).withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(status['text'], style: TextStyle(color: status['color'], fontWeight: FontWeight.w700)),
    );
  }

  Widget _quantityBadge(Stock item) {
    final color = _progressColor(item);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Icon(LucideIcons.box, size: 16, color: color),
          const SizedBox(width: 6),
          Text('${item.quantity}', style: TextStyle(fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _rowActions(Stock item) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: 'Refresh',
          onPressed: () => widget.onAction?.call(item, 'refresh'),
          icon: const Icon(LucideIcons.refresh_cw, size: 18),
        ),
        // Compact popup so column stays fixed width
        PopupMenuButton<String>(
          tooltip: 'More',
          onSelected: (v) => widget.onAction?.call(item, v),
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'view', child: Text('View')),
            PopupMenuItem(value: 'adjust', child: Text('Adjust')),
            PopupMenuItem(value: 'edit', child: Text('Edit')),
            PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
      ],
    );
  }

  // ---------------- Helpers ----------------
  double _progressValue(Stock stock) {
    final min = (stock.minimumStock ?? 0);
    final cap = (min > 0) ? (min * 2) : 100;
    if (cap <= 0) return 0.0;
    return (stock.quantity / cap).clamp(0.0, 1.0);
  }

  Color _progressColor(Stock stock) {
    final min = (stock.minimumStock ?? 0);
    if (stock.quantity <= 0) return Colors.red.shade700;
    if (min > 0 && stock.quantity <= min) return Colors.orange.shade700;
    return Colors.green.shade700;
  }

  Future<bool> _confirmDelete(Stock item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete item'),
        content: Text('Delete "${item.name}"? This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Delete')),
        ],
      ),
    );
    return confirmed ?? false;
  }

  Map<String, dynamic> _statusMapping(StockStatus? s) {
    switch (s) {
      case StockStatus.available:
        return {'color': Colors.green.shade700, 'text': 'GOOD'};
      case StockStatus.lowStock:
        return {'color': Colors.orange.shade700, 'text': 'LOW'};
      case StockStatus.outOfStock:
        return {'color': Colors.red.shade700, 'text': 'CRITICAL'};
      default:
        return {'color': Colors.grey.shade600, 'text': 'UNKNOWN'};
    }
  }

  // Simple loading skeleton (used when isLoading true)
  Widget _buildLoading() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            height: 88,
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(width: 44, height: 44, decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(6))),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 14, color: Colors.grey.shade200),
                      const SizedBox(height: 8),
                      Container(height: 12, width: 160, color: Colors.grey.shade200),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(width: 72, height: 32, color: Colors.grey.shade200),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
