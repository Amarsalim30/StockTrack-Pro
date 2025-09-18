import 'package:stocktrack_pro/core/error/failures.dart';
import 'package:stocktrack_pro/domain/entities/stock/stock.dart';
import 'package:stocktrack_pro/domain/repositories/stock_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../core/enums/stock_status.dart';
class FilterStocksUseCase {
  List<Stock> call(List<Stock> stocks, StockStatus? status) {
    if (status == null) return stocks;
    return stocks.where((stock) => stock.status == status).toList();
  }
}
