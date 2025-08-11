// Stock State
import 'package:clean_arch_app/domain/entities/auth/user.dart';
import 'package:clean_arch_app/domain/entities/stock/stock.dart';

import '../../core/enums/stock_status.dart';

enum SortBy { name, sku, quantity, lastUpdated;
  String get label {
    switch (this) {
      case SortBy.name:
        return 'Name';
      case SortBy.quantity:
        return 'Quantity';
      case SortBy.lastUpdated:
        return 'Last Updated';
      case SortBy.sku:
        return 'SKU';
    }
  }
}

enum SortOrder { ascending, descending }

enum StockStateStatus { initial, loading, success, error }

class StockState {
  final List<Stock> stocks;
  final List<Stock> filteredStocks;
  final User? currentUser;

  final bool isLoading;
  final bool isBulkSelectionMode;
  final StockStateStatus status;
  final Set<String> selectedStockIds;
  final String? searchQuery;
  final StockStatus? filterStatus;
  final SortBy sortBy;
  final SortOrder sortOrder;

  final List<SortBy> sortOptions;   // Available fields to sort by
  final String? errorMessage;

  const StockState({
    this.stocks = const [],
    this.filteredStocks = const [],
    this.status = StockStateStatus.initial,
    this.selectedStockIds = const {},
    this.searchQuery,
    this.filterStatus,
    this.sortBy = SortBy.name,
    this.sortOptions = const [SortBy.name, SortBy.sku, SortBy.quantity, SortBy.lastUpdated],
    this.sortOrder = SortOrder.ascending,
    this.errorMessage,
    this.isLoading = false,
    this.isBulkSelectionMode = false,
    this.currentUser,
  });
  /// Default initial state
  factory StockState.initial() => const StockState(
    stocks: [],
    filteredStocks: [],
    selectedStockIds: {},
  );

  StockState copyWith({
    List<Stock>? stocks,
    List<Stock>? filteredStocks,
    StockStateStatus? status,
    Set<String>? selectedStockIds,
    String? searchQuery,
    StockStatus? filterStatus,
    SortBy? sortBy,
    SortOrder? sortOrder,
    String? errorMessage,
    bool? isLoading,
    bool? isBulkSelectionMode,
    User? currentUser,
  }) {
    return StockState(
      stocks: stocks ?? this.stocks,
      filteredStocks: filteredStocks ?? this.filteredStocks,
      status: status ?? this.status,
      selectedStockIds: selectedStockIds ?? this.selectedStockIds,
      searchQuery: searchQuery ?? this.searchQuery,
      filterStatus: filterStatus ?? this.filterStatus,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
      errorMessage: errorMessage,
      isLoading: isLoading ?? this.isLoading,
      isBulkSelectionMode: isBulkSelectionMode ?? this.isBulkSelectionMode,
      currentUser: currentUser ?? this.currentUser,
    );
  }
}
