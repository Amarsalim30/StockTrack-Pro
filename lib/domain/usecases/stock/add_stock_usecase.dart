import 'package:clean_arch_app/core/error/failures.dart';
import 'package:clean_arch_app/domain/entities/stock/stock.dart';
import 'package:clean_arch_app/domain/repositories/stock_repository.dart';
import 'package:dartz/dartz.dart';

/// 3. Add a new stock
class AddStockUseCase {
  final StockRepository repository;
  AddStockUseCase(this.repository);

    return repository.addStock(stock);
  }
}
