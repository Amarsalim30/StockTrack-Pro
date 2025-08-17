import 'package:dartz/dartz.dart';

import '../../core/enums/stock_status.dart';
import '../../core/error/failures.dart';
import '../entities/stock/stock.dart';

abstract class StockRepository {
  Future<Either<Failure, List<Stock>>> getAllStocks();

  Future<Either<Failure, Stock>> getStockById(String id);

  Future<Either<Failure, Stock>> updateStock(Stock stock);

  Future<Either<Failure, void>> deleteStock(String id);

  Future<Either<Failure, void>> deleteStocks(List<String> ids);

  Future<Either<Failure, void>> updateStockStatus(String id,
      StockStatus status);
  Future<Either<Failure, void>> updateMultipleStockStatus(List<String> ids,
      StockStatus status);

  Future<Either<Failure, void>> adjustStock(String stockId, int adjustment,
      String reason);
  Future<Either<Failure, void >> addStock(Stock stock);
}
