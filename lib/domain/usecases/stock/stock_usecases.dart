import 'add_stock_usecase.dart';
import 'adjust_stock_usecase.dart';
import 'delete_multiple_stocks_usecase.dart';
import 'delete_stock_usecase.dart';
import 'filter_stocks_usecase.dart';
import 'get_all_stocks_usecase.dart';
import 'get_stock_by_id_usecase.dart';
import 'search_stocks_usecase.dart';
import 'sort_stocks_usecase.dart';
import 'toggle_stock_selection_usecase.dart';
import 'update_multiple_stock_status.dart';
import 'update_stock_status_usecase.dart';
import 'update_stock_usecase.dart';

class StockUseCases {
  final AddStockUseCase addStock;
  final AdjustStockUseCase adjustStock;
  final DeleteMultipleStocksUseCase deleteMultipleStocks;
  final DeleteStockUseCase deleteStock;
  final FilterStocksUseCase filterStocks;
  final GetAllStocksUseCase getAllStocks;
  final GetStockByIdUseCase getStockById;
  final SearchStocksUseCase searchStocks;
  final SortStocksUseCase sortStocks;
  final ToggleStockSelectionUseCase toggleStockSelection;
  final UpdateMultipleStockStatusUseCase updateMultipleStockStatus;
  final UpdateStockStatusUseCase updateStockStatus;
  final UpdateStockUseCase updateStock;

  StockUseCases({
    required this.addStock,
    required this.adjustStock,
    required this.deleteMultipleStocks,
    required this.deleteStock,
    required this.filterStocks,
    required this.getAllStocks,
    required this.getStockById,
    required this.searchStocks,
    required this.sortStocks,
    required this.toggleStockSelection,
    required this.updateMultipleStockStatus,
    required this.updateStockStatus,
    required this.updateStock,
  });
}
