import 'package:clean_arch_app/core/error/failures.dart';
import 'package:clean_arch_app/domain/entities/stock/stock.dart';
import 'package:clean_arch_app/domain/repositories/stock_repository.dart';
import 'package:dartz/dartz.dart';

/// 4. Update an existing stock
class UpdateStockUseCase {
  final StockRepository repository;
  UpdateStockUseCase(this.repository);

  Future<Either<Failure, Stock>> call(Stock stock) {
    return repository.updateStock(stock);
  }
}
