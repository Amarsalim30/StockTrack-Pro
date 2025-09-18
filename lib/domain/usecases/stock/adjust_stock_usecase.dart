import 'package:stocktrack_pro/core/error/failures.dart';
import 'package:stocktrack_pro/domain/entities/stock/stock.dart';
import 'package:stocktrack_pro/domain/repositories/stock_repository.dart';
import 'package:dartz/dartz.dart';

class AdjustStockUseCase {
  final StockRepository repository;
  AdjustStockUseCase(this.repository);

  Future<Either<Failure, void>> call(
    String stockId,
    int adjustment,
    String reason,
  ) {
    return repository.adjustStock(stockId, adjustment, reason);
  }
}
