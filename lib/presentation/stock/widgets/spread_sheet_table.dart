
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

/// Spreadsheet table built with Table widget for exact header alignment.
/// Use this on wide screens where fixed-width columns make sense.
class SpreadsheetTable extends StatelessWidget {
  final List stocks;
  final void Function(dynamic id, String action) onAction;
  final void Function(dynamic id) onRefreshItem;

  const SpreadsheetTable({super.key, required this.stocks, required this.onAction, required this.onRefreshItem});


  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
          child: Card(
            elevation: 0,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(2),   // Name
                  1: FixedColumnWidth(140),// SKU
                  2: FixedColumnWidth(80), // Qty
                  3: FixedColumnWidth(100),// Unit
                  4: FixedColumnWidth(120),// Status
                  5: FixedColumnWidth(180),// Last updated
                  6: FixedColumnWidth(160),// Actions
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  // Header
                  TableRow(
                    decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(6)),
                    children: [
                      _headerCell('Name', alignment: Alignment.centerLeft),
                      _headerCell('SKU', alignment: Alignment.centerLeft),
                      _headerCell('Qty', alignment: Alignment.centerRight),
                      _headerCell('Unit', alignment: Alignment.centerLeft),
                      _headerCell('Status', alignment: Alignment.center),
                      _headerCell('Last updated', alignment: Alignment.centerLeft),
                      _headerCell('Actions', alignment: Alignment.center),
                    ],
                  ),

                  // Data rows
                  ...stocks.map<TableRow>((item) {
                    final int qty = (item.quantity as int?) ?? 0;
                    final int low = (item.lowStockThreshold as int?) ?? 5;
                    final status = qty <= 0 ? 'Out' : (qty <= low ? 'Low' : 'OK');
                    final lastUpdated = (item.lastUpdated is DateTime) ? _friendly((item.lastUpdated as DateTime)) : '-';

                    return TableRow(children: [
                      _dataCell(Text(item.name ?? '-', overflow: TextOverflow.ellipsis), alignment: Alignment.centerLeft),
                      _dataCell(Text(item.sku ?? '-', overflow: TextOverflow.ellipsis), alignment: Alignment.centerLeft),
                      _dataCell(Text(qty.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: _qtyColor(qty, low))), alignment: Alignment.centerRight),
                      _dataCell(Text(item.unit ?? '-', overflow: TextOverflow.ellipsis), alignment: Alignment.centerLeft),
                      _dataCell(Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(color: _qtyColor(qty, low).withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
                        child: Text(status, textAlign: TextAlign.center, style: TextStyle(color: _qtyColor(qty, low), fontWeight: FontWeight.w600)),
                      ), alignment: Alignment.center),
                      _dataCell(Text(lastUpdated), alignment: Alignment.centerLeft),
                      _dataCell(_rowActions(item), alignment: Alignment.center),
                    ]);
                  }).toList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _headerCell(String text, {Alignment alignment = Alignment.centerLeft}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      alignment: alignment,
      child: Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black87)),
    );
  }

  Widget _dataCell(Widget child, {Alignment alignment = Alignment.centerLeft}) {
    return Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12), alignment: alignment, child: child);
  }

  Widget _rowActions(dynamic item) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(tooltip: 'Refresh', onPressed: () => onRefreshItem(item.id), icon: const Icon(LucideIcons.refresh_cw, size: 18)),
        IconButton(tooltip: 'Edit', onPressed: () => onAction(item.id, 'edit'), icon: const Icon(Icons.edit, size: 18)),
        PopupMenuButton<String>(
          onSelected: (v) => onAction(item.id, v),
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'view', child: Text('View')),
            PopupMenuItem(value: 'adjust', child: Text('Adjust')),
            PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
      ],
    );
  }

  Color _qtyColor(int qty, int low) {
    if (qty <= 0) return Colors.red.shade700;
    if (qty <= low) return Colors.orange.shade700;
    return Colors.green.shade700;
  }

  static String _friendly(DateTime dt) {
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    return '$y-$m-$d $hh:$mm';
  }
}
