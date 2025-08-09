// lib/presentation/stock/stock_page.dart
import 'package:clean_arch_app/presentation/stock/stock_state.dart';
import 'package:clean_arch_app/presentation/stock/stock_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/colors.dart';
import '../../di/injection.dart' as di;
import '../dashboard/dashboard_view_model.dart';
import '../dashboard/widgets/stock_list.dart';
import 'widgets/spread_sheet_table.dart';
/// Production-ready responsive StockPage:
/// - Uses spreadsheet table on wide widths (pixel-aligned headers)
/// - Mobile fallback uses existing StockList
/// - Controls wrap gracefully; no RenderFlex overflow
class StockPage extends ConsumerWidget {
  const StockPage({super.key});

  // Breakpoints you can tweak
  static const double _controlWrapBreakpoint = 640;
  static const double _desktopTableBreakpoint = 900;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardVm = ref.watch(di.dashboardViewModelProvider.notifier);
    final stockVm = ref.watch(di.stockViewModelProvider.notifier);
    final stockState = ref.watch(di.stockViewModelProvider);

    final stocks = stockState?.stocks ?? [];
    final isLoading = stockState?.isLoading ?? false;
    final total = stocks.length;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.slate[900],
        onPressed: () => stockVm.showAddStock?.call(context),
        tooltip: 'Add stock item',
        child: const Icon(LucideIcons.plus),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title + count
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Stock Inventory',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 80, maxWidth: 200),
                    child: Text(
                      '$total items',
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Controls row (search, filter, sort) — responsive/wrap
              LayoutBuilder(builder: (context, constraints) {
                final narrow = constraints.maxWidth < _controlWrapBreakpoint;
                return _ControlsBar(
                  narrow: narrow,
                  onSearch: stockVm.setSearchQuery ?? (_) {},
                  onClearSearch: () => stockVm.setSearchQuery?.call(''),
                  onFilterSelected: (value) => dashboardVm.setFilter?.call(value),
                  onSortSelected: (sortBy) {
                    // call VM methods if present
                    stockVm.setSortBy?.call(sortBy);
                    final isSame = stockState?.sortBy == sortBy;
                    if (isSame) stockVm.toggleSortOrder?.call(sortBy);
                  },
                  stockState: stockState,
                );
              }),

              const SizedBox(height: 12),

              // Content area
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: isLoading
                      ? const Center(child: CupertinoActivityIndicator())
                      : stocks.isEmpty
                      ? _emptyState(context)
                      : LayoutBuilder(builder: (context, c) {
                    final wide = c.maxWidth >= _desktopTableBreakpoint;
                    // Spreadsheet-style table on wide screens; mobile list on narrower screens
                    return wide
                        ? SpreadsheetTable(
                      stocks: stocks,
                      onAction: (id, action) => stockVm.handleItemAction?.call(context, id, action),
                      onRefreshItem: (id) => stockVm.refreshItem?.call(id),
                    )
                        : RefreshIndicator.adaptive(
                      onRefresh: () async => stockVm.refresh?.call(),
                      child: StockList(stocks: stocks),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.slate[900],
      elevation: 0,
      titleSpacing: 16.0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'StockTrackPro',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 2),
          Text(
            'Professional Inventory Management',
            style: TextStyle(fontSize: 12, color: Colors.white70),
          ),
        ],
      ),
      centerTitle: false,
      actions: [
        IconButton(
          tooltip: 'Notifications',
          onPressed: () {},
          icon: const Icon(Icons.notifications_none, color: Colors.white),
        ),
        IconButton(
          tooltip: 'Account',
          onPressed: () {},
          icon: const Icon(Icons.account_circle_rounded, color: Colors.white),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _emptyState(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.18),
        const Icon(LucideIcons.package, size: 64, color: Colors.black12),
        const SizedBox(height: 12),
        const Center(
          child: Text(
            'No items found',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black54),
          ),
        ),
        const SizedBox(height: 8),
        Center(child: Text('Tap "Add Stock" to create your first inventory item.', style: TextStyle(color: Colors.grey[700]))),
      ],
    );
  }
}

/// Controls bar — wraps on small widths and constrains children to avoid RenderFlex errors.
class _ControlsBar extends StatelessWidget {
  final bool narrow;
  final void Function(String) onSearch;
  final VoidCallback onClearSearch;
  final void Function(String) onFilterSelected;
  final void Function(dynamic) onSortSelected;
  final dynamic stockState;

  const _ControlsBar({
    required this.narrow,
    required this.onSearch,
    required this.onClearSearch,
    required this.onFilterSelected,
    required this.onSortSelected,
    required this.stockState,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 8,
      spacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // Search input - constrained so it doesn't force overflow
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: narrow ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width * 0.62,
            minWidth: 200,
          ),
          child: SizedBox(
            height: 44,
            child: TextField(
              onChanged: onSearch,
              textAlignVertical: TextAlignVertical.center,
              style: const TextStyle(fontSize: 15, color: Colors.black),
              decoration: InputDecoration(
                hintText: 'Search inventory...',
                hintStyle: TextStyle(color: Colors.grey[700]),
                prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: onClearSearch,
                  tooltip: 'Clear search',
                ),
                filled: true,
                fillColor: Colors.white,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.black, width: 1.0),
                ),
              ),
            ),
          ),
        ),

        // Slight spacer when enough width
        if (!narrow) const SizedBox(width: 6),

        // Filter + Sort in intrinsic width to avoid unwanted expansion
        IntrinsicWidth(
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            SizedBox(
              height: 44,
              child: PopupMenuButton<String>(
                tooltip: 'Filter items',
                onSelected: onFilterSelected,
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'All', child: Text('All')),
                  PopupMenuItem(value: 'Available', child: Text('Available')),
                  PopupMenuItem(value: 'Out of Stock', child: Text('Out of Stock')),
                ],
                offset: const Offset(0, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(children: const [
                    Icon(LucideIcons.filter, size: 18, color: Colors.black87),
                    SizedBox(width: 6),
                    Icon(LucideIcons.chevron_down, size: 18, color: Colors.black54),
                  ]),
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              height: 44,
              child: PopupMenuButton<dynamic>(
                tooltip: 'Sort items',
                onSelected: onSortSelected,
                itemBuilder: (_) {
                  final options = (stockState?.sortOptions ?? <dynamic>[]);
                  return options
                      .map<PopupMenuItem<dynamic>>((s) => PopupMenuItem(
                    value: s,
                    child: Row(children: [
                      Text(s?.name ?? s.toString()),
                      const Spacer(),
                      if (stockState?.sortBy == s)
                        Icon(
                          stockState?.sortOrder == SortOrder.ascending ? LucideIcons.arrow_up : LucideIcons.arrow_down,
                          size: 16,
                        ),
                    ]),
                  ))
                      .toList();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(children: [
                    Icon(
                      stockState?.sortOrder == SortOrder.ascending ? LucideIcons.arrow_up : LucideIcons.arrow_down,
                      size: 18,
                      color: Colors.black87,
                    ),
                    const SizedBox(width: 6),
                    Text(stockState?.sortBy?.toString() ?? 'Sort'),
                    const SizedBox(width: 6),
                    const Icon(LucideIcons.chevron_down, size: 18, color: Colors.black54),
                  ]),
                ),
              ),
            )
          ]),
        ),
      ],
    );
  }
}

/// Small SortOrder placeholder — remove if you provide it in your model.
enum SortOrder { ascending, descending }
