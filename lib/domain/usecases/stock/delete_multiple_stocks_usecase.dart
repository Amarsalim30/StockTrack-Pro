import 'package:stocktrack_pro/core/error/failures.dart';
import 'package:stocktrack_pro/domain/repositories/stock_repository.dart';
import 'package:dartz/dartz.dart';

/// 6. Delete multiple stocks
class DeleteMultipleStocksUseCase {
  final StockRepository repository;
  DeleteMultipleStocksUseCase(this.repository);

  Future<Either<Failure, void>> call(List<String> ids) {
    return repository.deleteStocks(ids);
  }
}
