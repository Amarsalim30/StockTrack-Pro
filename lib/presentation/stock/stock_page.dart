import 'package:clean_arch_app/core/constants/breakpoints.dart';
import 'package:clean_arch_app/core/enums/stock_status.dart';
import 'package:clean_arch_app/domain/entities/stock/stock.dart';
import 'package:clean_arch_app/presentation/stock/stock_state.dart';
import 'package:clean_arch_app/presentation/stock/stock_view_model.dart';
import 'package:clean_arch_app/presentation/stock/widgets/app_bar.dart';
import 'package:clean_arch_app/presentation/stock/widgets/empty_state.dart';
import 'package:clean_arch_app/presentation/stock/widgets/search_controls_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/colors.dart';
import '../../di/injection.dart' as di;
import 'widgets/stock_list.dart';
import 'widgets/spread_sheet_table.dart';

class StockPage extends ConsumerWidget {
  const StockPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // notifier for calling methods
    final StockViewModel stockVM = ref.read(di.stockViewModelProvider.notifier);
    final StockState stockState = ref.watch(di.stockViewModelProvider);
    // reactive state slices (select only what's needed)
    final List<Stock> stocks =
    ref.watch(di.stockViewModelProvider.select((s) => s.filteredStocks));
    final bool isLoading =
    ref.watch(di.stockViewModelProvider.select((s) => s.status == StockStateStatus.loading));
    final SortBy? sortBy =
    ref.watch(di.stockViewModelProvider.select((s) => s.sortBy));
  final String searchQuery =
    ref.watch(di.stockViewModelProvider.select((s) => s.searchQuery ?? ''));
  final StockStatus? filterStatus =
    ref.watch(di.stockViewModelProvider.select((s) => s.filterStatus));
    final bool isBulkMode =
    ref.watch(di.stockViewModelProvider.select((s) => s.isBulkSelectionMode));
    final SortOrder sortOrder =
    ref.watch(di.stockViewModelProvider.select((s) => s.sortOrder));
    final List<SortBy> sortOptions =
    ref.watch(di.stockViewModelProvider.select((s) => s.sortOptions));
    final int total = stocks.length;

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
               const SearchControlBar(),
              const SizedBox(height: 12),
              Expanded(child: _buildContent(context, isLoading, stockState.stocks, stockVM)),
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

  Widget _buildContent(
      BuildContext context,
      bool isLoading,
      List<Stock> stocks,
      StockViewModel stockVM,
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
          final wide =
              c.maxWidth >= Breakpoints.desktopTableBreakpoint;return wide? SpreadsheetTable(
            key: const ValueKey('spreadsheet_table'),
            stocks: stocks,
            onAction: (id, action) =>
                stockVM.handleItemAction(id, action),
            onRefreshItem: (id) => stockVM.refreshItem(id),
          ) : RefreshIndicator.adaptive(
            onRefresh: () async => stockVM.refresh(),
            child: StockList(
              key: const ValueKey('stock_list'),
              stocks: stocks,
              isLoading: isLoading,
              onTap: (stock) {
                // Handle stock item tap - navigate to details or edit
              },
              onEdit: (stock) => stockVM.handleItemAction(stock.id, 'edit'),
              onDelete: (stock) => stockVM.handleItemAction(stock.id, 'delete'),
            ),
          );
        },
      ),
    );
  }
}
