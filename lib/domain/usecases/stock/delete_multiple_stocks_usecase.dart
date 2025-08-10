import 'package:clean_arch_app/core/error/failures.dart';
import 'package:clean_arch_app/domain/entities/stock/stock.dart';
import 'package:clean_arch_app/domain/repositories/stock_repository.dart';
import 'package:dartz/dartz.dart';

/// 6. Delete multiple stocks
class DeleteMultipleStocksUseCase {
  final StockRepository repository;
  DeleteMultipleStocksUseCase(this.repository);

  Future<Either<Failure, void>> call(List<String> ids) {
    return repository.deleteStocks(ids);
  }
}
