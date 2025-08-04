// Stock State
import '../../core/enums/stock_status.dart';
import '../../data/models/stock/stock_model.dart';
import '../../data/models/user/user_model.dart';

enum SortBy { name, sku, quantity, lastUpdated }

enum SortOrder { ascending, descending }

class StockState {
  final List<StockModel> stocks;
  final List<StockModel> filteredStocks;
  final Set<String> selectedStockIds;
  final bool isLoading;
  final bool isBulkSelectionMode;
  final String searchQuery;
  final StockStatus? filterStatus;
  final SortBy sortBy;
  final SortOrder sortOrder;
  final String? error;
  final UserModel? currentUser;

  StockState({
    this.stocks = const [],
    this.filteredStocks = const [],
    this.selectedStockIds = const {},
    this.isLoading = false,
    this.isBulkSelectionMode = false,
    this.searchQuery = '',
    this.filterStatus,
    this.sortBy = SortBy.name,
    this.sortOrder = SortOrder.ascending,
    this.error,
    this.currentUser,
  });

  StockState copyWith({
    List<StockModel>? stocks,
    List<StockModel>? filteredStocks,
    Set<String>? selectedStockIds,
    bool? isLoading,
    bool? isBulkSelectionMode,
    String? searchQuery,
    StockStatus? filterStatus,
    SortBy? sortBy,
    SortOrder? sortOrder,
    String? error,
    UserModel? currentUser,
  }) {
    return StockState(
      stocks: stocks ?? this.stocks,
      filteredStocks: filteredStocks ?? this.filteredStocks,
      selectedStockIds: selectedStockIds ?? this.selectedStockIds,
      isLoading: isLoading ?? this.isLoading,
      isBulkSelectionMode: isBulkSelectionMode ?? this.isBulkSelectionMode,
      searchQuery: searchQuery ?? this.searchQuery,
      filterStatus: filterStatus ?? this.filterStatus,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
      error: error,
      currentUser: currentUser ?? this.currentUser,
    );
  }
}
