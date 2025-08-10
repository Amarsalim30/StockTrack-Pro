import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../entities/stock/stock.dart';
import '../../repositories/stock_repository.dart';

/// 1. Get all stocks
class GetAllStocksUseCase {
  final StockRepository repository;
  GetAllStocksUseCase(this.repository);

  Future<Either<Failure, List<Stock>>> call() {
    return repository.getAllStocks();
  }
}
