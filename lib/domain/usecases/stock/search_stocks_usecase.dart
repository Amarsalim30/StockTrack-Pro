import 'package:stocktrack_pro/domain/entities/stock/stock.dart';
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
