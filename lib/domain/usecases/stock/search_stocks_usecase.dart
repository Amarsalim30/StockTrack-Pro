import 'package:clean_arch_app/core/error/failures.dart';
import 'package:clean_arch_app/domain/entities/stock/stock.dart';
import 'package:clean_arch_app/domain/repositories/stock_repository.dart';
import 'package:dartz/dartz.dart';
class SearchStocksUseCase {
  List<Stock> call(List<Stock> stocks, String query) {
    if (query.isEmpty) return stocks;
    final lowerQuery = query.toLowerCase();
    return stocks.where((stock) {
      return stock.name.toLowerCase().contains(lowerQuery) ||
          stock.sku.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}
