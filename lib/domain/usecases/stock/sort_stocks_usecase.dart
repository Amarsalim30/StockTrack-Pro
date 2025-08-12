// sort_stocks_usecase.dart
import 'package:clean_arch_app/domain/entities/stock/stock.dart';
import 'package:clean_arch_app/presentation/stock/stock_state.dart';

class SortStocksUseCase {
  List<Stock> call(
      List<Stock> stocks, {
        required SortBy sortBy,
        required SortOrder sortOrder, // used when sortBy doesn't include direction (we respect it for lastUpdated)
      }) {
    final sorted = List<Stock>.from(stocks);

    int compareNullableString(String? a, String? b) {
      return (a ?? '').toLowerCase().compareTo((b ?? '').toLowerCase());
    }

    int compareDateTime(DateTime? a, DateTime? b) {
      final at = a?.millisecondsSinceEpoch ?? 0;
      final bt = b?.millisecondsSinceEpoch ?? 0;
      return at.compareTo(bt);
    }

    sorted.sort((a, b) {
      int result = 0;

      switch (sortBy) {
        case SortBy.nameAsc:
          result = compareNullableString(a.name, b.name);
          // ascending already encoded
          break;
        case SortBy.nameDesc:
          result = compareNullableString(a.name, b.name);
          result = -result; // invert for desc
          break;
        case SortBy.quantityAsc:
          result = (a.quantity).compareTo(b.quantity);
          break;
        case SortBy.quantityDesc:
          result = (a.quantity).compareTo(b.quantity);
          result = -result;
          break;
        case SortBy.lastUpdated:
        // lastUpdated does not encode direction in the enum; use provided sortOrder
          result = compareDateTime(a.updatedAt, b.updatedAt);
          if (sortOrder == SortOrder.descending) result = -result;
          break;
      }

      return result;
    });

    return sorted;
  }
}
