// stock_state.dart
import 'package:clean_arch_app/domain/entities/auth/user.dart';
import 'package:clean_arch_app/domain/entities/stock/stock.dart';
import 'package:clean_arch_app/core/enums/stock_status.dart';

enum SortBy { nameAsc, nameDesc, quantityAsc, quantityDesc, lastUpdated }

extension SortByLabel on SortBy {
  String get label {
    switch (this) {
      case SortBy.nameAsc:
        return 'Name (A–Z)';
      case SortBy.nameDesc:
        return 'Name (Z–A)';
      case SortBy.quantityAsc:
        return 'Quantity (Low → High)';
      case SortBy.quantityDesc:
        return 'Quantity (High → Low)';
      case SortBy.lastUpdated:
        return 'Last updated';
    }
  }

  /// Flexible parser: accepts "name", "quantity", "lastUpdated" or explicit enum strings.
  static SortBy fromString(String value) {
    final v = value.trim().toLowerCase();
    switch (v) {
      case 'name':
      case 'name_asc':
      case 'name (a–z)':
      case 'name (a-z)':
        return SortBy.nameAsc;
      case 'name_desc':
      case 'name (z–a)':
      case 'name (z-a)':
        return SortBy.nameDesc;
      case 'quantity':
      case 'quantity_asc':
        return SortBy.quantityAsc;
      case 'quantity_desc':
        return SortBy.quantityDesc;
      case 'last_updated':
      case 'last updated':
        return SortBy.lastUpdated;
      default:
      // default fallback
        return SortBy.nameAsc;
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
    this.sortBy = SortBy.nameAsc,
    this.sortOrder = SortOrder.ascending,
    this.sortOptions = const [
      SortBy.nameAsc,
      SortBy.nameDesc,
      SortBy.quantityAsc,
      SortBy.quantityDesc
    ],
    this.errorMessage,
    this.isLoading = false,
    this.isBulkSelectionMode = false,
  });

  /// Default initial state
  factory StockState.initial() => const StockState();
  static const _noChange = Object();

  StockState copyWith({
    List<Stock>? stocks,
    User? currentUser,
    StockStateStatus? status,
    Set<String>? selectedStockIds,
    String? searchQuery,
    Object? filterStatus = _noChange,
    SortBy? sortBy,
    SortOrder? sortOrder,
    List<SortBy>? sortOptions,
    String? errorMessage,
    bool? isLoading,
    bool? isBulkSelectionMode,
  }) {
    return StockState(
      stocks: stocks ?? this.stocks,
      // allow setting currentUser to null by explicitly passing non-null ? (keeps existing if parameter omitted)
      currentUser: currentUser ?? this.currentUser,
      status: status ?? this.status,
      selectedStockIds: selectedStockIds ?? this.selectedStockIds,
      searchQuery: searchQuery ?? this.searchQuery,
      filterStatus: filterStatus == _noChange
          ? this.filterStatus
          : filterStatus as StockStatus?,
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

    final q = (searchQuery).trim().toLowerCase();
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
        case SortBy.nameAsc:
        case SortBy.nameDesc:
          cmp = (a.name ?? '').toLowerCase().compareTo((b.name ?? '').toLowerCase());
          if (sortBy == SortBy.nameDesc) cmp = -cmp;
          break;

        case SortBy.quantityAsc:
        case SortBy.quantityDesc:
        // Stock.quantity in your domain model is non-nullable int; but guard anyway
          final aq = a.quantity;
          final bq = b.quantity;
          cmp = aq.compareTo(bq);
          if (sortBy == SortBy.quantityDesc) cmp = -cmp;
          break;

        case SortBy.lastUpdated:
        // sort by updatedAt (newest first); respect sortOrder for direction
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
