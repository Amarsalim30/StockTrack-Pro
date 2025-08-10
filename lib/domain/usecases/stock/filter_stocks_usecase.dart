import 'package:clean_arch_app/core/error/failures.dart';
import 'package:clean_arch_app/domain/entities/stock/stock.dart';
import 'package:clean_arch_app/domain/repositories/stock_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../core/enums/stock_status.dart';
class FilterStocksUseCase {
  List<Stock> call(List<Stock> stocks, StockStatus? status) {
    if (status == null) return stocks;
    return stocks.where((stock) => stock.status == status).toList();
  }
}
