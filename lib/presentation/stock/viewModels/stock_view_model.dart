import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/usecases/stock/add_stock_usecase.dart';
import '../../../domain/usecases/stock/adjust_stock_usecase.dart';
import '../../../domain/usecases/stock/delete_multiple_stocks_usecase.dart';
import '../../../domain/usecases/stock/delete_stock_usecase.dart';
import '../../../domain/usecases/stock/filter_stocks_usecase.dart';
import '../../../domain/usecases/stock/get_all_stocks_usecase.dart';
import '../../../domain/usecases/stock/get_stock_by_id_usecase.dart';
import '../../../domain/usecases/stock/search_stocks_usecase.dart';
import '../../../domain/usecases/stock/sort_stocks_usecase.dart';
import '../../../domain/usecases/stock/toggle_stock_selection_usecase.dart';
import '../../../domain/usecases/stock/update_multiple_stock_status.dart';
import '../../../domain/usecases/stock/update_stock_status_usecase.dart';
import '../../../domain/usecases/stock/update_stock_usecase.dart';
import '../../../domain/usecases/user/get_current_user_usecase.dart';
import '../../../domain/entities/stock/stock.dart';
import '../../../core/enums/stock_status.dart';
import 'stock_state.dart';

class StockViewModel extends StateNotifier<StockState> {
  final GetAllStocksUseCase _getAllStocks;
  final FilterStocksUseCase _filterStocks;
  final SearchStocksUseCase _searchStocks;
  final SortStocksUseCase _sortStocks;
  final ToggleStockSelectionUseCase _toggleStockSelection;
  final DeleteStockUseCase _deleteStock;
  final DeleteMultipleStocksUseCase _deleteMultipleStocks;
  final UpdateStockUseCase _updateStock;
  final AddStockUseCase _addStock;
  final UpdateStockStatusUseCase _updateStockStatus;
  final UpdateMultipleStockStatusUseCase _updateMultipleStockStatus;
  final AdjustStockUseCase _adjustStock;
  final GetStockByIdUseCase _getStockById;
  final GetCurrentUserUseCase _getCurrentUser;

  StockViewModel({
    required GetAllStocksUseCase getAllStocks,
    required FilterStocksUseCase filterStocks,
    required SearchStocksUseCase searchStocks,
    required SortStocksUseCase sortStocks,
    required ToggleStockSelectionUseCase toggleStockSelection,
    required DeleteStockUseCase deleteStock,
    required DeleteMultipleStocksUseCase deleteMultipleStocks,
    required UpdateStockUseCase updateStock,
    required AddStockUseCase addStock,
    required UpdateStockStatusUseCase updateStockStatus,
    required UpdateMultipleStockStatusUseCase updateMultipleStockStatus,
    required AdjustStockUseCase adjustStock,
    required GetStockByIdUseCase getStockById,
    required GetCurrentUserUseCase getCurrentUser,
  })  : _getAllStocks = getAllStocks,
        _filterStocks = filterStocks,
        _searchStocks = searchStocks,
        _sortStocks = sortStocks,
        _toggleStockSelection = toggleStockSelection,
        _deleteStock = deleteStock,
        _deleteMultipleStocks = deleteMultipleStocks,
        _updateStock = updateStock,
        _addStock = addStock,
        _updateStockStatus = updateStockStatus,
        _updateMultipleStockStatus = updateMultipleStockStatus,
        _adjustStock = adjustStock,
        _getStockById = getStockById,
        _getCurrentUser = getCurrentUser,
        super(StockState());

  Future<void> loadStocks() async {
    state = state.copyWith(
      status: StockStateStatus.loading,
      errorMessage: null,
    );

    final userResult = await _getCurrentUser();
    userResult.fold(
          (failure) => state = state.copyWith(errorMessage: failure.toString()),
          (user) => state = state.copyWith(currentUser: user),
    );

    final result = await _getAllStocks();
    result.fold(
          (failure) => state = state.copyWith(
        status: StockStateStatus.error,
        errorMessage: failure.message,
      ),
          (stocks) => state = state.copyWith(
        stocks: stocks,
        filteredStocks: [],
        status: StockStateStatus.success,
      ),
    );
  }

  void searchStocks(String query) {
    final filtered = _searchStocks(state.stocks, query);
    state = state.copyWith(searchQuery: query, filteredStocks: filtered);
  }

  void filterByStatus(StockStatus? status) {
    if (status == null) {
      state = state.copyWithNullables(resetFilterStatus: true, filteredStocks: []);
    } else {
      final filtered = _filterStocks(state.stocks, status);
      state = state.copyWith(filterStatus: status, filteredStocks: filtered);
    }
  }

  void sortStocks(SortBy sortBy, SortOrder sortOrder) {
    final sorted = _sortStocks(
      state.effectiveFilteredStocks,
      sortBy: sortBy,
      sortOrder: sortOrder,
    );
    state = state.copyWith(
      sortBy: sortBy,
      sortOrder: sortOrder,
      filteredStocks: sorted,
    );
  }

  void toggleSelection(String stockId) {
    final updatedSet = _toggleStockSelection(state.selectedStockIds, stockId);
    state = state.copyWith(selectedStockIds: updatedSet);
  }

  void clearSelection() {
    state = state.copyWith(selectedStockIds: {}, isBulkSelectionMode: false);
  }

  void setBulkSelectionMode(bool enabled) {
    state = state.copyWith(isBulkSelectionMode: enabled);
  }

  Future<void> addStock(Stock stock) async {
    _setAction(ActionType.adding);
    final result = await _addStock(stock);
    result.fold(
          (failure) => _setError(failure.message),
          (newStock) {
        state = state.copyWith(
          stocks: [...state.stocks, newStock],
          filteredStocks: [],
        );
      },
    );
    _clearAction();
  }

  Future<void> updateStock(Stock stock) async {
    _setAction(ActionType.updating, stock.id);
    final result = await _updateStock(stock);
    result.fold(
          (failure) => _setError(failure.message),
          (updated) {
        final updatedStocks = state.stocks
            .map((s) => s.id == updated.id ? updated : s)
            .toList();
        state = state.copyWith(stocks: updatedStocks, filteredStocks: []);
      },
    );
    _clearAction();
  }

  Future<void> adjustStock(String stockId, int adjustment, String reason) async {
    _setAction(ActionType.adjusting, stockId);
    final result = await _adjustStock(stockId, adjustment, reason);
    result.fold(
          (failure) => _setError(failure.message),
          (_) => _replaceStock(stockId),
    );
    _clearAction();
  }

  Future<void> deleteStock(String id) async {
    _setAction(ActionType.deleting, id);
    final result = await _deleteStock(id);
    result.fold(
          (failure) => _setError(failure.message),
          (_) {
        final updatedStocks = state.stocks.where((s) => s.id != id).toList();
        state = state.copyWith(stocks: updatedStocks, filteredStocks: []);
      },
    );
    _clearAction();
  }

  Future<void> deleteSelectedStocks() async {
    if (state.selectedStockIds.isEmpty) return;
    _setAction(ActionType.deletingMultiple);
    final ids = state.selectedStockIds.toList();
    final result = await _deleteMultipleStocks(ids);
    result.fold(
          (failure) => _setError(failure.message),
          (_) {
        final updatedStocks =
        state.stocks.where((s) => !ids.contains(s.id)).toList();
        state = state.copyWith(
          stocks: updatedStocks,
          selectedStockIds: {},
          filteredStocks: [],
        );
      },
    );
    _clearAction();
  }

  Future<void> updateStatus(String id, StockStatus status) async {
    _setAction(ActionType.updatingStatus, id);
    final result = await _updateStockStatus(id, status);
    result.fold(
          (failure) => _setError(failure.message),
          (_) => _replaceStock(id),
    );
    _clearAction();
  }

  Future<void> updateMultipleStatuses(List<String> ids, StockStatus status) async {
    _setAction(ActionType.updatingMultipleStatus);
    final result = await _updateMultipleStockStatus(ids, status);
    result.fold(
          (failure) => _setError(failure.message),
          (_) => loadStocks(),
    );
    _clearAction();
  }

  Future<Stock?> getStockById(String id) async {
    _setAction(ActionType.loadingSingle, id);
    final result = await _getStockById(id);
    _clearAction();
    return result.fold(
          (failure) {
        _setError(failure.message);
        return null;
      },
          (stock) => stock,
    );
  }

  // -------------------- Private helpers --------------------
  void _setAction(ActionType action, [String? stockId]) {
    state = state.copyWith(currentAction: action, activeStockId: stockId);
  }

  void _clearAction() {
    state = state.copyWith(currentAction: null, activeStockId: null);
  }

  void _setError(String message) {
    state = state.copyWith(errorMessage: message);
  }

  Future<void> _replaceStock(String id) async {
    final stock = await getStockById(id);
    if (stock != null) {
      final updatedStocks =
      state.stocks.map((s) => s.id == id ? stock : s).toList();
      state = state.copyWith(stocks: updatedStocks, filteredStocks: []);
    }
  }
}
