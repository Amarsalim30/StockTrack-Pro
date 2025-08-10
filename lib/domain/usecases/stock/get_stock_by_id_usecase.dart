import 'package:clean_arch_app/core/error/failures.dart';
import 'package:clean_arch_app/domain/entities/stock/stock.dart';
import 'package:dartz/dartz.dart';

import '../../repositories/stock_repository.dart';

/// 2. Get stock by ID
class GetStockByIdUseCase {
  final StockRepository repository;
  GetStockByIdUseCase(this.repository);

  Future<Either<Failure, Stock>> call(String id) {
    return repository.getStockById(id);
  }
}
