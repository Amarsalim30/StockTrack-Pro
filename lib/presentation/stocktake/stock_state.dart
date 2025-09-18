
import 'package:stocktrack_pro/domain/entities/stock/stock_take.dart';
import 'package:stocktrack_pro/domain/entities/stock/stock_take_item.dart';

class StockTakeState {
  final bool isLoading;
  final String? error;
  final List<StockTake> stockTakes;
  final StockTake? currentSession;
  final List<StockTakeItem> items;
  final List<StockTakeItem> filteredItems;
  final String searchQuery;
  final bool showCountedOnly;
  final bool showDiscrepanciesOnly;
  final CountMethod? filterByCountMethod;

  StockTakeState({
    this.isLoading = false,
    this.error,
    this.stockTakes = const [],
    this.currentSession,
    this.items = const [],
    this.filteredItems = const [],
    this.searchQuery = '',
    this.showCountedOnly = false,
    this.showDiscrepanciesOnly = false,
    this.filterByCountMethod,
  });

  StockTakeState copyWith({
    bool? isLoading,
    String? error,
    List<StockTake>? stockTakes,
    StockTake? currentSession,
    List<StockTakeItem>? items,
    List<StockTakeItem>? filteredItems,
    String? searchQuery,
    bool? showCountedOnly,
    bool? showDiscrepanciesOnly,
    CountMethod? filterByCountMethod,
  }) {
    return StockTakeState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      stockTakes: stockTakes ?? this.stockTakes,
      currentSession: currentSession ?? this.currentSession,
      items: items ?? this.items,
      filteredItems: filteredItems ?? this.filteredItems,
      searchQuery: searchQuery ?? this.searchQuery,
      showCountedOnly: showCountedOnly ?? this.showCountedOnly,
      showDiscrepanciesOnly:
      showDiscrepanciesOnly ?? this.showDiscrepanciesOnly,
      filterByCountMethod: filterByCountMethod ?? this.filterByCountMethod,
    );
  }
}
