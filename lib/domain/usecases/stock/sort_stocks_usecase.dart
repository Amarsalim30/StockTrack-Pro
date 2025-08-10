import 'package:clean_arch_app/core/error/failures.dart';
import 'package:clean_arch_app/domain/entities/stock/stock.dart';
import 'package:clean_arch_app/domain/repositories/stock_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../presentation/stock/viewModels/stock_state.dart';
class SortStocksUseCase {
  List<Stock> call(List<Stock> stocks, {
    required SortBy sortBy,
    required SortOrder sortOrder,
  }) {
    final sorted = List<Stock>.from(stocks);
    sorted.sort((a, b) {
      int result;
      switch (sortBy) {
        case SortBy.name:
          result = a.name.compareTo(b.name);
          break;
        case SortBy.sku:
          result = a.sku.compareTo(b.sku);
          break;
        case SortBy.quantity:
          result = a.quantity.compareTo(b.quantity);
          break;
        case SortBy.lastUpdated:
          result = a.updatedAt.compareTo(b.updatedAt);
          break;
      }
      return sortOrder == SortOrder.ascending ? result : -result;
    });
    return sorted;
  }
}