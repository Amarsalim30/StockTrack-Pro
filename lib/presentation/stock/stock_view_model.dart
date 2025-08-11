import 'dart:async';

import 'package:clean_arch_app/presentation/stock/mock_stock_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/enums/stock_status.dart';
import '../../domain/entities/stock/stock.dart';
import '../../domain/entities/auth/permission_type.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/stock/stock_usecases.dart';
import 'stock_state.dart';

/// Production-grade StockViewModel which uses grouped usecases.
/// - All domain/data access goes through `stockUseCases` (one injected object).
/// - ViewModel only updates immutable StockState.
/// - Filtering + sorting are applied in one place `_applyFiltersAndSort`.
class StockViewModel extends StateNotifier<StockState> {
  final StockUseCases stockUseCases;
  final AuthRepository authRepository;

  // Optional debounce for search (tweak timeout as needed)
  Timer? _searchDebounce;

  StockViewModel({
    required this.stockUseCases,
    required this.authRepository,
  }) : super(StockState.initial()) {
    _init();
  }

  // -----------------------
  // Initialization
  // -----------------------
  void _init() {
    _loadCurrentUser();
    loadStocks();
  }

  Future<void> _loadCurrentUser() async {
    try {
      final res = await authRepository.getCurrentUser();
      res.fold(
            (failure) => state = state.copyWith(
          status: StockStateStatus.error,
          errorMessage: _failureMessage(failure, fallback: 'Failed to load user'),
        ),
            (user) => state = state.copyWith(currentUser: user),
      );
    } catch (e) {
      state = state.copyWith(
        status: StockStateStatus.error,
        errorMessage: 'Failed to load user: $e',
      );
    }
  }

  String _failureMessage(dynamic failure, {String? fallback}) {
    try {
      if (failure == null) return fallback ?? 'Unknown error';
      if (failure is Exception) return failure.toString();
      // Common shape: failure.message
      final msg = (failure as dynamic).message;
      return msg ?? failure.toString();
    } catch (_) {
      return fallback ?? failure.toString();
    }
  }

  // -----------------------
  // Permission helpers
  // -----------------------
  bool hasPermission(PermissionType permission) =>
      state.currentUser?.hasPermission(permission) ?? false;

  bool get canCreateStock => hasPermission(PermissionType.createProduct);
  bool get canEditStock => hasPermission(PermissionType.editProduct);
  bool get canDeleteStock => hasPermission(PermissionType.deleteProduct);
  bool get canAdjustStock => hasPermission(PermissionType.adjustStock);
  bool get canViewStockReports => hasPermission(PermissionType.viewReports);

  // -----------------------
  // Load / Refresh
  // -----------------------
  Future<void> loadStocks() async {
    state = state.copyWith(status: StockStateStatus.loading, errorMessage: null);

    try {
      final result = await stockUseCases.getAllStocks();
      result.fold(
            (failure) {
          // fallback: if you want mock data only in dev, move this to DEV-only code
          final mock = getMockStocks();
          state = state.copyWith(
            stocks: mock,
            status: StockStateStatus.success,
            errorMessage: _failureMessage(failure, fallback: 'Using mock data'),
          );
          _applyFiltersAndSort();
        },
            (stocks) {
          final used = stocks.isEmpty ? getMockStocks() : stocks;
          state = state.copyWith(stocks: used, status: StockStateStatus.success);
          _applyFiltersAndSort();
        },
      );
    } catch (e) {
      final mock = getMockStocks();
      state = state.copyWith(
        stocks: mock,
        status: StockStateStatus.success,
        errorMessage: 'Using mock data due to error: $e',
      );
      _applyFiltersAndSort();
    }
  }

  Future<void> refresh() async => loadStocks();

  // -----------------------
  // Search / Filters
  // -----------------------
  /// Debounced search to avoid repeated work on every keystroke
  void setSearchQuery(String q) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      state = state.copyWith(searchQuery: q);
      _applyFiltersAndSort();
    });
  }void setFilterStatus(StockStatus? status) {
    state = state.copyWith(filterStatus: status);
    _applyFiltersAndSort();
  }

  // -----------------------
  // Sorting
  // -----------------------
  void setSortBy(SortBy sortBy) {
    // if same field, flip order; if different, set ascending
    if (state.sortBy == sortBy) {
      final newOrder = state.sortOrder == SortOrder.ascending
          ? SortOrder.descending
          : SortOrder.ascending;
      state = state.copyWith(sortOrder: newOrder);
    } else {
      state = state.copyWith(sortBy: sortBy, sortOrder: SortOrder.ascending);
    }
    _applyFiltersAndSort();
  }

  void toggleSortOrder(SortBy sortBy) {
    setSortBy(sortBy); // setSortBy already toggles
  }

  // -----------------------
  // Core: apply filters & sort in one place
  // -----------------------
  void _applyFiltersAndSort() {
    final base = List<Stock>.from(state.stocks);

    var filtered = base;

    final query = (state.searchQuery ?? '').trim();
    if (query.isNotEmpty) {
      final q = query.toLowerCase();
      filtered = filtered.where((s) {
        return (s.name ?? '').toLowerCase().contains(q) ||
            (s.sku ?? '').toLowerCase().contains(q) ||
            ((s.description ?? '').toLowerCase().contains(q));
      }).toList();
    }

    if (state.filterStatus != null) {
      filtered = filtered.where((s) => s.status == state.filterStatus).toList();
    }

    // Sort: use state.sortBy & state.sortOrder
    filtered.sort((a, b) {
      int cmp = 0;
      switch (state.sortBy) {
        case SortBy.name:
          cmp = (a.name ?? '').compareTo(b.name ?? '');
          break;
        case SortBy.sku:
          cmp = (a.sku ?? '').compareTo(b.sku ?? '');
          break;
        case SortBy.quantity:
          cmp = a.quantity.compareTo(b.quantity);
          break;
        case SortBy.lastUpdated:
          cmp = (a.updatedAt ?? DateTime(0)).compareTo(b.updatedAt ?? DateTime(0));
          break;
        default:
          cmp = (a.name ?? '').compareTo(b.name ?? '');
      }
      return state.sortOrder == SortOrder.ascending ? cmp : -cmp;
    });

    state = state.copyWith(filteredStocks: filtered);
  }

  // -----------------------
  // Selection / Bulk
  // -----------------------
  void toggleBulkSelectionMode() {
    final newMode = !state.isBulkSelectionMode;
    state = state.copyWith(
      isBulkSelectionMode: newMode,
      selectedStockIds: newMode ? state.selectedStockIds : <String>{},
    );
  }

  void toggleStockSelection(String stockId) {
    final set = Set<String>.from(state.selectedStockIds);
    if (!set.add(stockId)) set.remove(stockId);
    state = state.copyWith(selectedStockIds: set);
  }

  void selectAll() {
    final all = state.filteredStocks.map((s) => s.id).toSet();
    state = state.copyWith(selectedStockIds: all);
  }

  void clearSelection() => state = state.copyWith(selectedStockIds: <String>{});

  // -----------------------
  // CRUD via usecases
  // -----------------------
  Future<void> addStock(Stock stock) async {
    if (!canCreateStock) {
      state = state.copyWith(
          status: StockStateStatus.error,
          errorMessage: 'You do not have permission to create stock items');
      return;
    }

    state = state.copyWith(status: StockStateStatus.loading, errorMessage: null);

    try {
      final res = await stockUseCases.addStock(stock);
      res.fold(
            (failure) => state = state.copyWith(
            status: StockStateStatus.error,
            errorMessage: _failureMessage(failure, fallback: 'Failed to add')),
            (_) => loadStocks(),
      );
    } catch (e) {
      state = state.copyWith(
          status: StockStateStatus.error, errorMessage: 'Failed to add: $e');
    }
  }

  Future<void> updateStock(Stock stock) async {
    if (!canEditStock) {
      state = state.copyWith(
          status: StockStateStatus.error,
          errorMessage: 'You do not have permission to edit stock items');
      return;
    }

    state = state.copyWith(status: StockStateStatus.loading, errorMessage: null);

    try {
      final res = await stockUseCases.updateStock(stock);
      res.fold(
            (failure) => state = state.copyWith(
            status: StockStateStatus.error,
            errorMessage: _failureMessage(failure, fallback: 'Failed to update')),
            (_) => loadStocks(),
      );
    } catch (e) {
      state = state.copyWith(
          status: StockStateStatus.error, errorMessage: 'Failed to update: $e');
    }
  }

  Future<void> deleteStock(String id) async {
    if (!canDeleteStock) {
      state = state.copyWith(
          status: StockStateStatus.error,
          errorMessage: 'You do not have permission to delete stock items');
      return;
    }

    state = state.copyWith(status: StockStateStatus.loading, errorMessage: null);

    try {
      final res = await stockUseCases.deleteStock(id);
      res.fold(
            (failure) => state.copyWith(
            status: StockStateStatus.error,
            errorMessage: _failureMessage(failure, fallback: 'Failed to delete')),
            (_) {
          final remaining = state.stocks.where((s) => s.id != id).toList();
          state = state.copyWith(
            stocks: remaining,
            selectedStockIds: Set<String>.from(state.selectedStockIds)..remove(id),
            status: StockStateStatus.success,
          );
          _applyFiltersAndSort();
        },
      );
    } catch (e) {
      state = state.copyWith(
          status: StockStateStatus.error, errorMessage: 'Failed to delete: $e');
    }
  }

  Future<void> bulkDelete() async {
    if (!canDeleteStock) {
      state = state.copyWith(
          status: StockStateStatus.error,
          errorMessage: 'You do not have permission to delete stock items');
      return;
    }

    final ids = state.selectedStockIds.toList();
    if (ids.isEmpty) return;

    state = state.copyWith(status: StockStateStatus.loading, errorMessage: null);

    try {
      // Prefer a batched usecase if available:
      if (stockUseCases.deleteMultipleStocks != null) {
        final res = await stockUseCases.deleteMultipleStocks!(ids);
        res.fold(
              (failure) => state.copyWith(
              status: StockStateStatus.error,
              errorMessage: _failureMessage(failure, fallback: 'Failed batch delete')),
              (_) {
            state = state.copyWith(
              stocks: state.stocks.where((s) => !ids.contains(s.id)).toList(),
              selectedStockIds: <String>{},
              isBulkSelectionMode: false,
              status: StockStateStatus.success,
            );
            _applyFiltersAndSort();
          },
        );
      } else {
        // fallback to parallel deletes and collect failures
        final results = await Future.wait(ids.map((id) => stockUseCases.deleteStock(id)));
        final failures = results.where((r) => r.isLeft()).toList();
        if (failures.isNotEmpty) {
          state = state.copyWith(
              status: StockStateStatus.error,
              errorMessage: 'Some items could not be deleted');
        } else {
          state = state.copyWith(
            stocks: state.stocks.where((s) => !ids.contains(s.id)).toList(),
            selectedStockIds: <String>{},
            isBulkSelectionMode: false,
            status: StockStateStatus.success,
          );
          _applyFiltersAndSort();
        }
      }
    } catch (e) {
      state = state.copyWith(
          status: StockStateStatus.error, errorMessage: 'Bulk delete failed: $e');
    }
  }

  Future<void> adjustStock(String stockId, int delta, String reason) async {
    if (!canAdjustStock) {
      state = state.copyWith(
        status: StockStateStatus.error,
        errorMessage: 'You do not have permission to adjust stock quantities',
      );
      return;
    }

    state = state.copyWith(status: StockStateStatus.loading, errorMessage: null);

    try {
      final res = await stockUseCases.adjustStock(stockId, delta, reason);
      res.fold(
            (failure) => state.copyWith(
            status: StockStateStatus.error,
            errorMessage: _failureMessage(failure, fallback: 'Failed to adjust')),
            (_) => loadStocks(),
      );
    } catch (e) {
      state = state.copyWith(
          status: StockStateStatus.error, errorMessage: 'Failed to adjust: $e');
    }
  }

  Future<void> bulkUpdateStatus(StockStatus status) async {
    if (!canEditStock) {
      state = state.copyWith(
          status: StockStateStatus.error,
          errorMessage: 'You do not have permission to update stock status');
      return;
    }

    final ids = state.selectedStockIds.toList();
    if (ids.isEmpty) return;

    state = state.copyWith(status: StockStateStatus.loading, errorMessage: null);

    try {
      if (stockUseCases.updateMultipleStockStatus != null) {
        final res = await stockUseCases.updateMultipleStockStatus!(ids, status);
        res.fold(
              (failure) => state.copyWith(
              status: StockStateStatus.error,
              errorMessage: _failureMessage(failure, fallback: 'Failed batch update')),
              (_) async {
            await loadStocks();
            state = state.copyWith(selectedStockIds: <String>{}, isBulkSelectionMode: false);
          },
        );
      } else {
        // fallback: update one-by-one
        final results = await Future.wait(ids.map((id) {
          final s = state.stocks.firstWhere((it) => it.id == id);
          final updated = s.copyWith(status: status);
          return stockUseCases.updateStock(updated);
        }));
        final failures = results.where((r) => r.isLeft()).toList();
        if (failures.isNotEmpty) {
          state = state.copyWith(status: StockStateStatus.error, errorMessage: 'Some updates failed');
        } else {
          await loadStocks();
          state = state.copyWith(selectedStockIds: <String>{}, isBulkSelectionMode: false);
        }
      }
    } catch (e) {
      state = state.copyWith(status: StockStateStatus.error, errorMessage: 'Failed to bulk update: $e');
    }
  }

  // -----------------------
  // Helpers / UI actions (placeholders)
  // -----------------------
  Stock? getStockById(String id) => state.stocks.firstWhere((s) => s.id == id);

  // Placeholder – wire these to real UI navigations / dialogs
  void showAddStock(/* BuildContext ctx */) {
    // TODO: open create modal / route
  }

  void refreshItem(String id) {
  }void handleItemAction(String stockId, String action) {
    switch (action.toLowerCase()) {
      case 'delete':
        deleteStock(stockId);
        break;
      case 'edit':
        // TODO: Navigate to edit screen
        break;
      case 'adjust':
        // TODO: Show adjustment dialog
        break;
      default:
        // Unknown action
        break;
    }
  }

  void openAdvancedFilters() {
    // TODO: trigger advanced filters UI
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }
}
