import 'package:stocktrack_pro/core/error/failures.dart';
import 'package:stocktrack_pro/domain/entities/stock/stock.dart';
import 'package:stocktrack_pro/domain/repositories/stock_repository.dart';
import 'package:dartz/dartz.dart';

/// 4. Update an existing stock
class UpdateStockUseCase {
  final StockRepository repository;
  UpdateStockUseCase(this.repository);

  Future<Either<Failure, Stock>> call(Stock stock) {
    return repository.updateStock(stock);
  }
}
