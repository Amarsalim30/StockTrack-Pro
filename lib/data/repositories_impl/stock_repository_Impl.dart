import '../../core/enums/stock_status.dart';
import '../../domain/repositories/stock_repository.dart';
import '../datasources/remote/stock_api.dart';
import '../models/stock/stock_model.dart';

class StockRepositoryImpl implements StockRepository {
  final StockApi api;

  StockRepositoryImpl(this.api);

  @override
  Future<List<StockModel>> getStocks() => api.getStocks();

  @override
  Future<StockModel> getStockById(String id) => api.getStockById(id);

  @override
  Future<void> createStock(StockModel stock) => api.createStock(stock);

  @override
  Future<void> updateStock(StockModel stock) =>
      api.updateStock(stock.id, stock);

  @override
  Future<void> deleteStock(String id) => api.deleteStock(id);

  @override
  Future<void> deleteStocks(List<String> ids) => api.deleteStocks({'ids': ids});

  @override
  Future<void> updateStockStatus(List<String> ids, StockStatus status) =>
      api.updateStockStatus({'ids': ids, 'status': status.code});

  @override
  Future<void> adjustStock(String id, int adjustment, String reason) =>
      api.adjustStock(id, {'adjustment': adjustment, 'reason': reason});
}
