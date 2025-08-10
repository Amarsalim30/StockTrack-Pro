// lib/presentation/stock/pages/stock_page_mobile.dart

import 'package:clean_arch_app/presentation/stock/viewModels/stock_view_model.dart';
import 'package:clean_arch_app/presentation/stock/widgets/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/stock_table_mobile.dart';

class StockPageMobile extends StatelessWidget {
  const StockPageMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<StockViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: vm.showFilterSheet,
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: vm.showSortSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(vm),
          Expanded(
            child: vm.state.filteredStocks.isEmpty
                ? _buildEmptyState()
                : StockTableMobile(
              stocks: vm.state.filteredStocks,
              selectedStockIds: vm.state.selectedIds,
              isAllSelected: vm.state.isAllSelected,
              onSelectAll: vm.toggleSelectAll,
              onSelectRow: vm.toggleSelectRow,
              onBulkDelete: vm.bulkDelete,
              onBulkEdit: vm.bulkEdit,
              onEditStock: vm.editStock,
              onDeleteStock: vm.deleteStock,
              onViewDetails: vm.viewDetails,
              enableSwipeActions: true,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: vm.addStock,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSearchBar(StockViewModel vm) {
    return Padding(
      padding: const EdgeInsets.all(StockStyles.spaceMD),
      child: TextField(
        onChanged: vm.updateSearchQuery,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: 'Search stock items...',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(StockStyles.radiusMD),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: StockStyles.spaceSM,
            horizontal: StockStyles.spaceMD,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined,
              size: 64, color: StockStyles.textSecondary),
          const SizedBox(height: StockStyles.spaceMD),
          Text(
            'No stock items found',
            style: StockStyles.subtitle,
          ),
        ],
      ),
    );
  }
}
