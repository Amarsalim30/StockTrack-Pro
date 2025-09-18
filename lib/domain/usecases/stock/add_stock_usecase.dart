import 'package:stocktrack_pro/core/error/failures.dart';
import 'package:stocktrack_pro/domain/entities/stock/stock.dart';
import 'package:stocktrack_pro/domain/repositories/stock_repository.dart';
import 'package:dartz/dartz.dart';

/// 3. Add a new stock
class AddStockUseCase {
  final StockRepository repository;
  AddStockUseCase(this.repository);

  Future<Either<Failure, void>> call(Stock stock) {
    return repository.addStock(stock);
  }
}
