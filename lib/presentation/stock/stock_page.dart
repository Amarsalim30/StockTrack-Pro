import 'package:clean_arch_app/core/enums/stock_status.dart';
import 'package:clean_arch_app/di/injection.dart'; // should export stockViewModelProvider
import 'package:clean_arch_app/domain/entities/stock/stock.dart';
import 'package:clean_arch_app/presentation/stock/stock_view_model.dart';
import 'package:clean_arch_app/presentation/stock/widgets/app_bar.dart';
import 'package:clean_arch_app/presentation/stock/widgets/build_action_bar.dart';
import 'package:clean_arch_app/presentation/stock/widgets/search_control_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StockPage extends ConsumerWidget {
  const StockPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(stockViewModelProvider.notifier);
    final state = ref.watch(stockViewModelProvider);

    final List<Stock> stocks = state.filteredStocks;
    final isLoading = state.isLoading;
    final selectable = state.isBulkSelectionMode; // show checkboxes by default (change to state flag if you add one)
    final selectedIds = state.selectedStockIds;
    final allSelected = state.allSelected;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
  appBar: ProductionTopAppBar(),

      body: RefreshIndicator(
        onRefresh: ()=>vm.refresh(),
        child: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: buildActionBar(context, ref),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 6), // tightened
                child: _buildTitleAndCount(stocks.length),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: SearchControlBar(),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: isLoading
                      ? _buildLoading()
                      : stocks.isEmpty
                      ? _buildEmpty()
                      : _buildListView(stocks, selectable, selectedIds, allSelected, vm, ref),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget buildTopAppBar(BuildContext context, StockViewModel stockVm) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(72.0),
      child: AppBar(
        backgroundColor: const Color(0xFF0E2330),
        elevation: 0,
        toolbarHeight: 72,
        titleSpacing: 18,
        automaticallyImplyLeading: false, // keep no back button if not needed
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'StockTrack-Pro',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.1,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Professional Inventory Management',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => stockVm.refresh(),
            icon: const Icon(Icons.refresh),
            color: Colors.white70,
            tooltip: 'Refresh',
            visualDensity: VisualDensity.compact,
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
            color: Colors.white70,
            tooltip: 'Notifications',
            visualDensity: VisualDensity.compact,
          ),
          const SizedBox(width: 6),
          Padding(
            padding: const EdgeInsets.only(right: 14.0),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: const Icon(Icons.person, color: Color(0xFF0E2330)),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildTitleAndCount(int total) {
    return Row(
      children: [
        const Text('Stock Inventory',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF0B2130))),
        const Spacer(),
        Text('$total items', style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildSearchFilterRow(StockViewModel vm, dynamic state) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 40, // slightly smaller
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFE6E9EE)),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                const Icon(Icons.search, color: Color(0xFF9AA6B2), size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    onChanged: vm.updateSearch,
                    decoration: const InputDecoration.collapsed(
                      hintText: 'Search inventory...',
                      hintStyle: TextStyle(color: Color(0xFF9AA6B2)),
                    ),
                    style: const TextStyle(fontSize: 14),
                    textInputAction: TextInputAction.search,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        _smallActionButton(icon: Icons.filter_list, tooltip: 'Filter', onTap: () {
          final current = state.filterStatus;
          vm.setFilterStatus(current == StockStatus.inStock ? null : StockStatus.inStock);
        }),
        const SizedBox(width: 8),
        _smallActionButton(icon: Icons.swap_vert, tooltip: 'Sort', onTap: vm.toggleSort),
      ],
    );
  }

  Widget _smallActionButton({required IconData icon, String? tooltip, VoidCallback? onTap}) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(side: BorderSide(color: const Color(0xFFE6E9EE)), borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(width: 40, height: 40, child: Center(child: Icon(icon, color: const Color(0xFF374151), size: 18))),
      ),
    );
  }

  Widget _buildListView(List<Stock> stocks, bool selectable, Set<String> selectedIds, bool allSelected, StockViewModel vm, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE7EDF3)),
      ),
      child: Column(
        children: [
          // Header row inside the white card
          Container(
            height: 48, // tightened from 56
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
              color: Colors.white,
            ),
            child: Row(
              children: [
                if (selectable)
                  SizedBox(
                    width: 44,
                    child: Checkbox(
                      value: allSelected ? true : (selectedIds.isEmpty ? false : null),
                      tristate: true,
                      onChanged: (v) {
                        if (v == true) vm.selectAllAll();
                        else vm.clearSelection();
                      },
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                Expanded(flex: 4, child: Padding(
                  padding: const EdgeInsets.only(left: 6.0),
                  child: Text('ITEM DETAILS', style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w700)),
                )),
                Expanded(flex: 2, child: Text('STOCK', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w700))),
                Expanded(flex: 2, child: Text('STATUS', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w700))),
                Expanded(flex:2,child: SizedBox(width: 96, child: Center(child: Text('ACTIONS', style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w700))))),
              ],
            ),
          ),

          // List rows
          Expanded(
            child: ListView.separated(
              itemCount: stocks.length,
              separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey.shade100),
              itemBuilder: (context, index) {
                final s = stocks[index];
                final isSelected = selectedIds.contains(s.id);
                return _stockRow(s, index, isSelected, selectable, vm, ref);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _stockRow(Stock stock, int index, bool isSelected, bool selectable, StockViewModel vm, WidgetRef ref) {
    final isEven = index % 2 == 0;
    final bg = isSelected ? const Color(0xFFF1F9FF) : (isEven ? Colors.white : const Color(0xFFF9FBFD));

    return AnimatedContainer(
      duration: const Duration(milliseconds: 140),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10), // tightened
      color: bg,
      child: Row(
        children: [
          if (selectable)
            SizedBox(
              width: 44,
              child: Checkbox(
                value: isSelected,
                onChanged: (_) => vm.toggleStockSelection(stock.id),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
            ),
          Expanded(flex: 4, child: _itemDetailsCol(stock)),
          Expanded(flex: 2, child: _stockCol(stock)),
          Expanded(flex: 2, child: Center(child: _statusPill(stock.status))),
          Expanded(
            flex: 2,
            child: SizedBox(
              width: 96, // narrower
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Single overflow dropdown with View & Delete
                  PopupMenuButton<_Action>(
                    tooltip: 'Actions',
                    onSelected: (action) async {
                      switch (action) {
                        case _Action.view:
                        // adapt to your VM API
                            showViewStock(ref.context, stock);
                          break;
                        case _Action.delete:
                          final confirmed = await _confirmDelete(ref.context, stock);
                          if (confirmed) vm.deleteStock(stock.id);
                          break;
                      }
                    },
                    itemBuilder: (_) => [
                      const PopupMenuItem(value: _Action.view, child: ListTile(leading: Icon(Icons.remove_red_eye_outlined), title: Text('View'))),
                      const PopupMenuItem(value: _Action.delete, child: ListTile(leading: Icon(Icons.delete_outline), title: Text('Delete'))),
                    ],
                    icon: const Icon(Icons.more_vert, size: 20, color: Color(0xFF374151)),
                    padding: EdgeInsets.zero,
                    offset: const Offset(0, 36),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
  Future<void> showViewStock(BuildContext context, Stock stock) async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(stock.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Quantity: ${stock.quantity}'),
            Text('Status: ${stock.status.name}'),
            if (stock.description != null) ...[
              const SizedBox(height: 8),
              Text(stock.description!),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.edit),
            label: const Text('Edit'),
            onPressed: () {
              Navigator.of(ctx).pop(); // close view dialog first
              _showEditStock(context, stock); // open edit screen/dialog
            },
          ),
        ],
      ),
    );
  }
  /// Example edit function — replace with your real navigation/edit form
  void _showEditStock(BuildContext context, Stock stock) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Stock'),
        content: Text('Here you would show your edit form for "${stock.name}".'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: save changes via ViewModel.updateStock(...)
              Navigator.of(ctx).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context, Stock stock) async {
    final res = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete item'),
        content: Text('Are you sure you want to delete "${stock.name}"? This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Delete')),
        ],
      ),
    );
    return res == true;
  }

  Widget _itemDetailsCol(Stock s) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Text(
        s.name ?? '-',
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF0B2130)),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      const SizedBox(height: 4), // tightened
      Row(
        children: [
          Text('SKU :', style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(width: 6),
          Text(s.sku ?? '-', style: TextStyle(color: Colors.grey.shade700, fontSize: 12 ,overflow: TextOverflow.ellipsis)),
        ],
      ),
      const SizedBox(height: 6),
      Row(children: [
        Text(s.categoryId?.toString() ?? '-', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
        const SizedBox(width: 12),
        const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
        const SizedBox(width: 4),
        Flexible(child: Text(s.location?.toString() ?? '-', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey.shade600, fontSize: 12))),
      ]),
    ]);
  }

  Widget _stockCol(Stock s) {
    final qty = s.quantity ?? 0;
    final min = s.minimumStock ?? 0;
    final progress = _calcProgress(qty, min);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('$qty', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF0B2130))),
        const SizedBox(height: 4),
        Text('Min: $min', style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
        const SizedBox(height: 6),
        Container(
          width: 72,
          height: 6,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: const Color(0xFFF0F4F8)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation(_stockColor(qty, min)),
            ),
          ),
        ),
      ],
    );
  }

  double _calcProgress(int qty, int min) {
    if (min <= 0) return 1.0;
    final v = (qty / (min * 2));
    return v.clamp(0.0, 1.0);
  }

  Color _stockColor(int qty, int min) {
    if (min <= 0) return const Color(0xFF10B981);
    final ratio = qty / min;
    if (ratio <= 0.5) return const Color(0xFFEF4444);
    if (ratio <= 1.0) return const Color(0xFFF59E0B);
    return const Color(0xFF10B981);
  }

  Widget _statusPill(dynamic status) {
    StockStatus s;
    if (status is StockStatus) s = status;
    else if (status is String) s = _parseStatus(status);
    else s = StockStatus.inStock;

    final style = _statusStyle(s);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), // slightly narrower
      decoration: BoxDecoration(color: style['bg'] as Color, borderRadius: BorderRadius.circular(18)),
      child: Text(style['label'] as String, style: TextStyle(color: style['fg'] as Color, fontWeight: FontWeight.w800, fontSize: 11)),
    );
  }

  StockStatus _parseStatus(String raw) {
    final r = raw.toLowerCase();
    if (r.contains('good')) return StockStatus.inStock;
    if (r.contains('low')) return StockStatus.lowStock;
    if (r.contains('out')) return StockStatus.outOfStock;
    return StockStatus.inStock;
  }

  Map<String, Object> _statusStyle(StockStatus s) {
    switch (s) {
      case StockStatus.lowStock:
        return {'label': 'LOW', 'bg': const Color(0xFFFEF3C7), 'fg': const Color(0xFF92400E)};
      case StockStatus.outOfStock:
        return {'label': 'OUT', 'bg': const Color(0xFFF3F4F6), 'fg': const Color(0xFF374151)};
      case StockStatus.inStock:
      default:
        return {'label': 'AVAILABLE', 'bg': const Color(0xFFEFFAF6), 'fg': const Color(0xFF065F46)};
    }
  }

  Widget _buildLoading() => const Center(child: CircularProgressIndicator());
  Widget _buildEmpty() => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    Icon(Icons.inventory_2_outlined, size: 48, color: Colors.grey.shade400),
    const SizedBox(height: 12),
    Text('No inventory items found', style: TextStyle(fontSize: 16, color: Colors.grey.shade700, fontWeight: FontWeight.w700)),
    const SizedBox(height: 6),
    Text('Add items to your inventory to get started', style: TextStyle(color: Colors.grey.shade500)),
  ]));
}
// small enum for local action mapping
enum _Action { view, delete }
