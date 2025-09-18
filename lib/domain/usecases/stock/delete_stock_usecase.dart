import 'package:stocktrack_pro/core/error/failures.dart';
import 'package:stocktrack_pro/domain/entities/stock/stock.dart';
import 'package:stocktrack_pro/domain/repositories/stock_repository.dart';
import 'package:dartz/dartz.dart';
/// 5. Delete a stock by ID
class DeleteStockUseCase {
  final StockRepository repository;
  DeleteStockUseCase(this.repository);

  Future<Either<Failure, void>> call(String id) {
    return repository.deleteStock(id);
  }
}
