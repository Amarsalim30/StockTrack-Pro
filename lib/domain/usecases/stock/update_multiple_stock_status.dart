import 'package:clean_arch_app/core/enums/stock_status.dart';
import 'package:clean_arch_app/core/error/failures.dart';
import 'package:clean_arch_app/domain/repositories/stock_repository.dart';
import 'package:dartz/dartz.dart';

/// 8. Update stock status for multiple items
class UpdateMultipleStockStatusUseCase {
  final StockRepository repository;
  UpdateMultipleStockStatusUseCase(this.repository);

  Future<
      Either<Failure, void>> call(List<String> ids, StockStatus status) {
    return repository.updateMultipleStockStatus(ids, status);
  }
}
