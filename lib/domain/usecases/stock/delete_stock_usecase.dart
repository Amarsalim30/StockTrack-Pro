import 'package:clean_arch_app/core/error/failures.dart';
import 'package:clean_arch_app/domain/entities/stock/stock.dart';
import 'package:clean_arch_app/domain/repositories/stock_repository.dart';
import 'package:dartz/dartz.dart';
/// 5. Delete a stock by ID
class DeleteStockUseCase {
  final StockRepository repository;
  DeleteStockUseCase(this.repository);

  Future<Either<Failure, void>> call(String id) {
    return repository.deleteStock(id);
  }
}
