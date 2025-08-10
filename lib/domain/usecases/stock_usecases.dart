import 'stock/add_stock_usecase.dart';
import 'stock/adjust_stock_usecase.dart';
import 'stock/delete_multiple_stocks_usecase.dart';
import 'stock/delete_stock_usecase.dart';
import 'stock/filter_stocks_usecase.dart';
import 'stock/get_all_stocks_usecase.dart';
import 'stock/get_stock_by_id_usecase.dart';
import 'stock/search_stocks_usecase.dart';
import 'stock/sort_stocks_usecase.dart';
import 'stock/toggle_stock_selection_usecase.dart';
import 'stock/update_multiple_stock_status.dart';
import 'stock/update_stock_status_usecase.dart';
import 'stock/update_stock_usecase.dart';

class StockUseCases {
  final AddStockUseCase addStockUseCase;
  final AdjustStockUseCase adjustStockUseCase;
  final DeleteMultipleStocksUseCase deleteMultipleStocksUseCase;
  final DeleteStockUseCase deleteStockUseCase;
  final FilterStocksUseCase filterStocksUseCase;
  final GetAllStocksUseCase getAllStocksUseCase;
  final GetStockByIdUseCase getStockByIdUseCase;
  final SearchStocksUseCase searchStocksUseCase;
  final SortStocksUseCase sortStocksUseCase;
  final ToggleStockSelectionUseCase toggleStockSelectionUseCase;
  final UpdateMultipleStockStatusUseCase updateMultipleStockStatusUseCase;
  final UpdateStockStatusUseCase updateStockStatusUseCase;
  final UpdateStockUseCase updateStockUseCase;

  StockUseCases({
    required this.addStockUseCase,
    required this.adjustStockUseCase,
    required this.deleteMultipleStocksUseCase,
    required this.deleteStockUseCase,
    required this.filterStocksUseCase,
    required this.getAllStocksUseCase,
    required this.getStockByIdUseCase,
    required this.searchStocksUseCase,
    required this.sortStocksUseCase,
    required this.toggleStockSelectionUseCase,
    required this.updateMultipleStockStatusUseCase,
    required this.updateStockStatusUseCase,
    required this.updateStockUseCase,
  });
}
