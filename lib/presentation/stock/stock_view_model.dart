import 'package:clean_arch_app/domain/usecases/stock_usecases.dart';
import 'package:clean_arch_app/presentation/stock/mock_stock_data.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import '../../core/enums/stock_status.dart';
import '../../domain/entities/stock/stock.dart';
import '../../domain/entities/auth/permission_type.dart';
import '../../domain/repositories/stock_repository.dart';
import '../../domain/repositories/auth_repository.dart';
import 'stock_state.dart';

class StockViewModel extends StateNotifier<StockState> {
  final StockUseCases stockUseCases;
  final AuthRepository authRepository;

  StockViewModel({
    required  this.stockUseCases,
    required this.authRepository,
  }) :super(const StockState()) {
    _loadCurrentUser();
    loadStocks();
  }

  // Permission checks
  bool hasPermission(PermissionType permission) {
    return state.currentUser?.hasPermission(permission) ?? false;
  }

  bool get canCreateStock => hasPermission(PermissionType.createProduct);

  bool get canEditStock => hasPermission(PermissionType.editProduct);

  bool get canDeleteStock => hasPermission(PermissionType.deleteProduct);

  bool get canAdjustStock => hasPermission(PermissionType.adjustStock);

  bool get canViewStockReports =>
      hasPermission(PermissionType.viewReports); // Load current user
  Future<void> _loadCurrentUser() async {
    try {
      final result = await authRepository.getCurrentUser();
      result.fold(
        (failure) => state = state.copyWith(
          status: StockStateStatus.error,
          errorMessage: 'Failed to load user: $failure',
        ),
        (user) => state = state.copyWith(currentUser: user),
      );
    } catch (e) {
      state = state.copyWith(
        status: StockStateStatus.error,
        errorMessage: 'Failed to load user: $e',
      );
    }
  } // Load stocks

  Future<void> loadStocks() async {
    state = state.copyWith(
      status: StockStateStatus.loading,
      errorMessage: null,
    );

    try {
      final result = await stockUseCases.getAllStocksUseCase();
      result.fold(
        (failure) {
          // Use mock data as fallback for development
          final mockData = getMockStocks();
          state = state.copyWith(
            stocks: mockData,
            status: StockStateStatus.success,
            errorMessage: 'Using mock data: ${failure.message}',
          );
          _applyFiltersAndSort();
        },
        (stocks) {
          final stocksToUse = stocks.isEmpty ? getMockStocks() : stocks;
          state = state.copyWith(
            stocks: stocksToUse,
            status: StockStateStatus.success,
          );
          _applyFiltersAndSort();
        },
      );
    } catch (e) {
      // Use mock data as fallback for development
      final mockData = getMockStocks();
      state = state.copyWith(
        stocks: mockData,
        status: StockStateStatus.success,
        errorMessage: 'Using mock data: $e',
      );
      _applyFiltersAndSort();
    }
  }

  // Search functionality
  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    _applyFiltersAndSort();
  }

  // Filter functionality
  void setFilterStatus(StockStatus? status) {
    state = state.copyWith(filterStatus: status);
    _applyFiltersAndSort();
  }

  // Sort functionality
  void setSortBy(SortBy sortBy) {
    if (state.sortBy == sortBy) {
      state = state.copyWith(
        sortOrder: state.sortOrder == SortOrder.ascending
            ? SortOrder.descending
            : SortOrder.ascending,
      );
    } else {
      state = state.copyWith(sortBy: sortBy, sortOrder: SortOrder.ascending);
    }
    _applyFiltersAndSort();
  }
  void edit(Stock filteredStock){
    
  }

  // Apply filters and sort
  void _applyFiltersAndSort() {
    var filtered = [...state.stocks];

    if (state.searchQuery.isNotEmpty) {
      final q = state.searchQuery.toLowerCase();
      filtered = filtered.where((stock) {
        return stock.name.toLowerCase().contains(q) ||
            stock.sku.toLowerCase().contains(q) ||
            (stock.description?.toLowerCase().contains(q) ?? false);
      }).toList();
    }

    if (state.filterStatus != null) {
      filtered = filtered
          .where((stock) => stock.status == state.filterStatus)
          .toList();
    }

    filtered.sort((a, b) {
      int cmp;
      switch (state.sortBy) {
        case SortBy.name:
          cmp = a.name.compareTo(b.name);
          break;
        case SortBy.sku:
          cmp = a.sku.compareTo(b.sku);
          break;
        case SortBy.quantity:
          cmp = a.quantity.compareTo(b.quantity);
          break;
        case SortBy.lastUpdated:
          cmp = a.updatedAt.compareTo(b.updatedAt);
          break;
      }
      return state.sortOrder == SortOrder.ascending ? cmp : -cmp;
    });

    state = state.copyWith(filteredStocks: filtered);
  }

  // Bulk selection
  void toggleBulkSelectionMode() {
    final newMode = !state.isBulkSelectionMode;
    if (!newMode) {
      state = state.copyWith(
        isBulkSelectionMode: newMode,
        selectedStockIds: {},
      );
    } else {
      state = state.copyWith(isBulkSelectionMode: newMode);
    }
  }

  void toggleSortOrder(SortBy selectedSortBy) {
    final isSameSort = state.sortBy == selectedSortBy;

    final newOrder = isSameSort
        ? (state.sortOrder == SortOrder.ascending
        ? SortOrder.descending
        : SortOrder.ascending)
        : SortOrder.ascending;

    final newSortBy = selectedSortBy;

    final sortedStocks = [...state.stocks]
      ..sort((a, b) {
        int result = 0;
        switch (newSortBy) {
          case SortBy.name:
            result = a.name.compareTo(b.name);
            break;
          case SortBy.sku:
            result = a.sku.compareTo(b.sku);
            break;
          case SortBy.quantity:
            result = a.quantity.compareTo(b.quantity);
            break;
          case SortBy.lastUpdated:
            result = a.updatedAt.compareTo(b.updatedAt);
            break;
        }

        return newOrder == SortOrder.ascending ? result : -result;
      });

    state = state.copyWith(
      stocks: sortedStocks,
      sortBy: newSortBy,
      sortOrder: newOrder,
    );
  }

  void toggleStockSelection(String stockId) {
    final newSet = Set<String>.from(state.selectedStockIds);
    if (newSet.contains(stockId)) {
      newSet.remove(stockId);
    } else {
      newSet.add(stockId);
    }
    state = state.copyWith(selectedStockIds: newSet);
  }

  void selectAll() {
    final allIds = state.filteredStocks.map((stock) => stock.id).toSet();
    state = state.copyWith(selectedStockIds: allIds);
  }

  void clearSelection() {
    state = state.copyWith(selectedStockIds: {});
  } // CRUD Operations

  Future<void> addStock(Stock stock) async {
    if (!canCreateStock) {
      state = state.copyWith(
        status: StockStateStatus.error,
        errorMessage: 'You do not have permission to create stock items',
      );
      return;
    }

    state = state.copyWith(
      status: StockStateStatus.loading,
      errorMessage: null,
    );

    try {
      final result = await stockUseCases.addStockUseCase(stock);
      result.fold(
        (failure) => state = state.copyWith(
          status: StockStateStatus.error,
          errorMessage: failure.message,
        ),
        (_) => loadStocks(),
      );
    } catch (e) {
      state = state.copyWith(
        status: StockStateStatus.error,
        errorMessage: 'Failed to create stock: $e',
      );
    }
  }

  Future<void> updateStock(Stock stock) async {
    if (!canEditStock) {
      state = state.copyWith(
        status: StockStateStatus.error,
        errorMessage: 'You do not have permission to edit stock items',
      );
      return;
    }

    state = state.copyWith(
      status: StockStateStatus.loading,
      errorMessage: null,
    );

    try {
      final result = await stockUseCases.updateStockUseCase(stock);
      result.fold(
        (failure) => state = state.copyWith(
          status: StockStateStatus.error,
          errorMessage: failure.message,
        ),
        (_) => loadStocks(),
      );
    } catch (e) {
      state = state.copyWith(
        status: StockStateStatus.error,
        errorMessage: 'Failed to update stock: $e',
      );
    }
  }

  Future<void> deleteStock(String stockId) async {
    if (!canDeleteStock) {
      state = state.copyWith(
        status: StockStateStatus.error,
        errorMessage: 'You do not have permission to delete stock items',
      );
      return;
    }

    state = state.copyWith(
      status: StockStateStatus.loading,
      errorMessage: null,
    );

    try {
      final result = await stockUseCases.deleteStockUseCase(stockId);
      result.fold(
        (failure) => state = state.copyWith(
          status: StockStateStatus.error,
          errorMessage: failure.message,
        ),
        (_) {
          final updatedStocks = state.stocks
              .where((stock) => stock.id != stockId)
              .toList();
          final updatedSelectedIds = Set<String>.from(state.selectedStockIds)
            ..remove(stockId);
          state = state.copyWith(
            stocks: updatedStocks,
            selectedStockIds: updatedSelectedIds,
            status: StockStateStatus.success,
          );
          _applyFiltersAndSort();
        },
      );
    } catch (e) {
      state = state.copyWith(
        status: StockStateStatus.error,
        errorMessage: 'Failed to delete stock: $e',
      );
    }
  }

  Future<void> bulkDelete() async {
    if (!canDeleteStock) {
      state = state.copyWith(
        status: StockStateStatus.error,
        errorMessage: 'You do not have permission to delete stock items',
      );
      return;
    }

    if (state.selectedStockIds.isEmpty) return;

    state = state.copyWith(
      status: StockStateStatus.loading,
      errorMessage: null,
    );

    try {
      final results = await Future.wait(
        state.selectedStockIds.map((id) => stockUseCases.deleteStockUseCase(id)),
      );

      // Check if any operations failed
      final failures = results.where((result) => result.isLeft()).toList();

      if (failures.isNotEmpty) {
        state = state.copyWith(
          status: StockStateStatus.error,
          errorMessage: 'Some items could not be deleted',
        );
      } else {
        final updatedStocks = state.stocks
            .where((stock) => !state.selectedStockIds.contains(stock.id))
            .toList();
        state = state.copyWith(
          stocks: updatedStocks,
          selectedStockIds: {},
          isBulkSelectionMode: false,
          status: StockStateStatus.success,
        );
        _applyFiltersAndSort();
      }
    } catch (e) {
      state = state.copyWith(
        status: StockStateStatus.error,
        errorMessage: 'Failed to delete stocks: $e',
      );
    }
  }

  Future<void> adjustStock(
    String stockId,
    int adjustment,
    String reason,
  ) async {
    if (!canAdjustStock) {
      state = state.copyWith(
        status: StockStateStatus.error,
        errorMessage: 'You do not have permission to adjust stock quantities',
      );
      return;
    }

    state = state.copyWith(
      status: StockStateStatus.loading,
      errorMessage: null,
    );

    try {
      final result = await stockUseCases.adjustStockUseCase(
        stockId,
        adjustment,
        reason,
      );
      result.fold(
        (failure) => state = state.copyWith(
          status: StockStateStatus.error,
          errorMessage: failure.message,
        ),
        (_) => loadStocks(),
      );
    } catch (e) {
      state = state.copyWith(
        status: StockStateStatus.error,
        errorMessage: 'Failed to adjust stock: $e',
      );
    }
  }

  Future<void> bulkUpdateStatus(StockStatus status) async {
    if (!canEditStock) {
      state = state.copyWith(
        status: StockStateStatus.error,
        errorMessage: 'You do not have permission to edit stock items',
      );
      return;
    }

    if (state.selectedStockIds.isEmpty) return;

    state = state.copyWith(
      status: StockStateStatus.loading,
      errorMessage: null,
    );

    try {
      final selectedStocks = state.stocks
          .where((stock) => state.selectedStockIds.contains(stock.id))
          .toList();

      final results = await Future.wait(
        selectedStocks.map(
          (stock) => stockUseCases.updateMultipleStockStatusUseCase(state.selectedStockIds.toList(),
            stock.copyWith(status: status) as StockStatus,
          ),
        ),
      );

      // Check if any operations failed
      final failures = results.where((result) => result.isLeft()).toList();

      if (failures.isNotEmpty) {
        state = state.copyWith(
          status: StockStateStatus.error,
          errorMessage: 'Some items could not be updated',
        );
      } else {
        await loadStocks();
        state = state.copyWith(
          selectedStockIds: {},
          isBulkSelectionMode: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: StockStateStatus.error,
        errorMessage: 'Failed to update stocks: $e',
      );
    }
  } // Get stock by ID
  Stock? getStockById(String id) {
    return state.stocks.firstWhereOrNull((stock) => stock.id == id);
  }

  // Refresh
  Future<void> refresh() async {
    await loadStocks();
  } // Clear error
  void clearError() {
    state = state.copyWith(
      errorMessage: null,
      status: StockStateStatus.success,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setStatusFilter(String value) {
  }

  void addNewStock() {
  }

  void showAddStock(BuildContext context) {}

  void refreshItem(String id) {}

  void handleItemAction(BuildContext context, Stock item, String action) {}

  void openAdvancedFilters() {
  }
}


