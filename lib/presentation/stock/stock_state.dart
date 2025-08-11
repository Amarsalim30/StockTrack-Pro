// stock_state.dart
import 'package:clean_arch_app/domain/entities/auth/user.dart';
import 'package:clean_arch_app/domain/entities/stock/stock.dart';
import 'package:clean_arch_app/core/enums/stock_status.dart';

enum SortBy { name, sku, quantity, lastUpdated }

extension SortByLabel on SortBy {
  String get label {
    switch (this) {
      case SortBy.name:
        return 'Name';
      case SortBy.sku:
        return 'SKU';
      case SortBy.quantity:
        return 'Quantity';
      case SortBy.lastUpdated:
        return 'Last Updated';
    }
  }

  static SortBy fromString(String value) {
    final v = value.toLowerCase();
    switch (v) {
      case 'name':
        return SortBy.name;
      case 'sku':
        return SortBy.sku;
      case 'quantity':
        return SortBy.quantity;
      case 'last updated':
      case 'lastupdated':
        return SortBy.lastUpdated;
      default:
        throw ArgumentError('Invalid sort field: $value');
    }
  }
}

enum SortOrder { ascending, descending }

enum StockStateStatus { initial, loading, success, error }

class StockState {
  final List<Stock> stocks; // canonical full list from repo
  final User? currentUser;

  final bool isLoading;
  final bool isBulkSelectionMode;
  final StockStateStatus status;
  final Set<String> selectedStockIds;
  final String searchQuery;
  final StockStatus? filterStatus;
  final SortBy sortBy;
  final SortOrder sortOrder;

  final List<SortBy> sortOptions; // Available fields to sort by
  final String? errorMessage;

  const StockState({
    this.stocks = const [],
    this.currentUser,
    this.status = StockStateStatus.initial,
    this.selectedStockIds = const {},
    this.searchQuery = '',
    this.filterStatus,
    this.sortBy = SortBy.name,
    this.sortOrder = SortOrder.ascending,
    this.sortOptions = const [SortBy.name, SortBy.sku, SortBy.quantity, SortBy.lastUpdated],
    this.errorMessage,
    this.isLoading = false,
    this.isBulkSelectionMode = false,
  });

  /// Default initial state
  factory StockState.initial() => const StockState();

  StockState copyWith({
    List<Stock>? stocks,
    User?  currentUser,
    StockStateStatus? status,
    Set<String>? selectedStockIds,
    String? searchQuery,
    StockStatus? filterStatus,
    SortBy? sortBy,
    SortOrder? sortOrder,
    List<SortBy>? sortOptions,
    String? errorMessage,
    bool? isLoading,
    bool? isBulkSelectionMode,
  }) {
    return StockState(
      stocks: stocks ?? this.stocks,
      currentUser: currentUser == null ? this.currentUser : currentUser,
      status: status ?? this.status,
      selectedStockIds: selectedStockIds ?? this.selectedStockIds,
      searchQuery: searchQuery ?? this.searchQuery,
      filterStatus: filterStatus ?? this.filterStatus,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
      sortOptions: sortOptions ?? this.sortOptions,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
      isBulkSelectionMode: isBulkSelectionMode ?? this.isBulkSelectionMode,
    );
  }

  // ---------- Convenience helpers ----------
  bool get hasSelection => selectedStockIds.isNotEmpty;
  int get selectedCount => selectedStockIds.length;
  bool get allSelected => stocks.isNotEmpty && selectedStockIds.length == stocks.length;

  // ---------- Computed / Derived data ----------
  /// Returns the list filtered by searchQuery and filterStatus and sorted.
  List<Stock> get filteredStocks {
    var list = List<Stock>.from(stocks);

    final q = searchQuery.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list.where((s) {
        final name = (s.name ?? '').toLowerCase();
        final sku = (s.sku ?? '').toLowerCase();
        final cat = (s.categoryId?.toString() ?? '').toLowerCase();
        return name.contains(q) || sku.contains(q) || cat.contains(q);
      }).toList();
    }

    if (filterStatus != null) {
      list = list.where((s) => s.status == filterStatus).toList();
    }

    // Sorting
    list.sort((a, b) {
      int cmp = 0;
      switch (sortBy) {
        case SortBy.name:
          cmp = (a.name ?? '').toLowerCase().compareTo((b.name ?? '').toLowerCase());
          break;
        case SortBy.sku:
          cmp = (a.sku ?? '').toLowerCase().compareTo((b.sku ?? '').toLowerCase());
          break;
        case SortBy.quantity:
          cmp = (a.quantity ?? 0).compareTo(b.quantity ?? 0);
          break;
        case SortBy.lastUpdated:
        // assumes Stock has a DateTime? lastUpdated field; fallback to 0
          final ad = a.updatedAt?.millisecondsSinceEpoch ?? 0;
          final bd = b.updatedAt?.millisecondsSinceEpoch ?? 0;
          cmp = ad.compareTo(bd);
          break;
      }
      return sortOrder == SortOrder.ascending ? cmp : -cmp;
    });

    return list;
  }
}
