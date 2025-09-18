import 'package:stocktrack_pro/core/enums/stock_status.dart';
import 'package:stocktrack_pro/core/error/failures.dart';
import 'package:stocktrack_pro/domain/repositories/stock_repository.dart';
import 'package:dartz/dartz.dart';

/// 7. Update stock status for one item
class UpdateStockStatusUseCase {
  final StockRepository repository;
  UpdateStockStatusUseCase(this.repository);

  Future<Either<Failure, void>> call(String id, StockStatus status) {
    return repository.updateStockStatus(id, status);
  }
}
