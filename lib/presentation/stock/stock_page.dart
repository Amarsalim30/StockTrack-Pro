import 'package:clean_arch_app/core/constants/breakpoints.dart';
import 'package:clean_arch_app/domain/entities/stock/stock.dart';
import 'package:clean_arch_app/presentation/stock/stock_state.dart';
import 'package:clean_arch_app/presentation/stock/stock_view_model.dart';
import 'package:clean_arch_app/presentation/stock/widgets/app_bar.dart';
import 'package:clean_arch_app/presentation/stock/widgets/empty_state.dart';
import 'package:clean_arch_app/presentation/stock/widgets/stock_controls_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/colors.dart';
import '../../di/injection.dart' as di;
import '../dashboard/widgets/stock_list.dart';
import 'widgets/spread_sheet_table.dart';

/// Production-ready responsive StockPage:
/// - Uses spreadsheet table on wide widths (pixel-aligned headers)
/// - Mobile fallback uses existing StockList
/// - Controls wrap gracefully; no RenderFlex overflow
class StockPage extends ConsumerWidget {
  const StockPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // NOTE: Use `read` for the notifier (to call methods) and `watch/select` for state slices
    final stockVM = ref.read(di.stockViewModelProvider.notifier);

    // Select only what we need to avoid unnecessary rebuilds
    final stocks = ref.watch(di.stockViewModelProvider.select((s) => s.stocks));
    final isLoading = ref.watch(
      di.stockViewModelProvider.select((s) => s.isLoading),
    );
    final sortBy = ref.watch(di.stockViewModelProvider.select((s) => s.sortBy));
    final searchQuery = ref.watch(
      di.stockViewModelProvider.select((s) => s.searchQuery),
    );
    final filterStatus = ref.watch(
      di.stockViewModelProvider.select((s) => s.filterStatus),
    );
    final isBulkMode = ref.watch(
      di.stockViewModelProvider.select((s) => s.isBulkSelectionMode),
    );
    final total = stocks.length;
    final sortOrder = ref.watch(
      di.stockViewModelProvider.select((s) => s.sortOrder),
    );
    final sortOptions = ref.watch(
      di.stockViewModelProvider.select((s) => s.sortOptions),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(total),
              const SizedBox(height: 12),
              _buildControls(
                context,
                narrowBreakpoint: Breakpoints.controlWrapBreakpoint,
                sortOptions: sortOptions,
                sortOrder: sortOrder,
                searchQuery: searchQuery,
                filterStatus: filterStatus.toString(),
                sortBy: sortBy,
                isBulkMode: isBulkMode,
                stockVM: stockVM,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: _buildContent(context, isLoading, stocks, stockVM),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(int total) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Stock Inventory',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
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
    );
  }

  Widget _buildControls(
    BuildContext context, {
    required StockViewModel stockVM,
    required double narrowBreakpoint,
    required String searchQuery,
    required String? filterStatus,
    required dynamic sortBy,
    required bool isBulkMode,
    required List<SortBy> sortOptions,
    required SortOrder sortOrder,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow = constraints.maxWidth < narrowBreakpoint;

        return ControlsBar(
          narrow: narrow,
          searchQuery: searchQuery,
          isBulkMode: isBulkMode,
          currentFilter: filterStatus,
          currentSortBy: sortBy,
          currentSortOrder: sortOrder,
          sortOptions: sortOptions,
          onSearch: stockVM.setSearchQuery,
          onClearSearch: () => stockVM.setSearchQuery(''),
          onFilterSelected: stockVM.setStatusFilter,

          onSortSelected: (selectedSortBy) {
            if (sortBy == selectedSortBy) {
              stockVM.toggleSortOrder(selectedSortBy);
            } else {
              stockVM.setSortBy(selectedSortBy);
            }
          },
          onOpenAdvancedFilter: stockVM.openAdvancedFilters,
        );
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    bool isLoading,
    List<Stock> stocks,
    dynamic stockVM,
  ) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: isLoading
          ? const Center(child: CupertinoActivityIndicator())
          : stocks.isEmpty
          ? emptyState(context)
          : LayoutBuilder(
              builder: (context, c) {
                final wide = c.maxWidth >= Breakpoints.desktopTableBreakpoint;
                return wide
                    ? SpreadsheetTable(
                        key: const ValueKey('spreadsheet_table'),
                        stocks: stocks,
                        onAction: (id, action) =>
                            stockVM.handleItemAction(context, id, action),
                        onRefreshItem: (id) => stockVM.refreshItem(id),
                      )
                    : RefreshIndicator.adaptive(
                        onRefresh: () async => stockVM.refresh(),
                        child: StockList(
                          key: const ValueKey('stock_list'),
                          stocks: stocks,
                        ),
                      );
              },
            ),
    );
  }
}
