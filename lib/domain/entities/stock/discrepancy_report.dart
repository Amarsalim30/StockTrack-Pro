import 'package:equatable/equatable.dart';

class DiscrepancyReport extends Equatable {
  final String reportId;
  final String stockTakeId;
  final DateTime generatedAt;
  final int totalItems;
  final int discrepancyCount;
  final double totalDiscrepancyValue;
  final List<DiscrepancyItem> discrepancies;

  const DiscrepancyReport({
    required this.reportId,
    required this.stockTakeId,
    required this.generatedAt,
    required this.totalItems,
    required this.discrepancyCount,
    required this.totalDiscrepancyValue,
    required this.discrepancies,
  });

  @override
  List<Object?> get props => [
        reportId,
        stockTakeId,
        generatedAt,
        totalItems,
        discrepancyCount,
        totalDiscrepancyValue,
        discrepancies,
      ];
}

class DiscrepancyItem extends Equatable {
  final String itemId;
  final String productName;
  final String sku;
  final int expectedQuantity;
  final int actualQuantity;
  final int discrepancy;
  final double unitPrice;
  final double discrepancyValue;

  const DiscrepancyItem({
    required this.itemId,
    required this.productName,
    required this.sku,
    required this.expectedQuantity,
    required this.actualQuantity,
    required this.discrepancy,
    required this.unitPrice,
    required this.discrepancyValue,
  });

  @override
  List<Object?> get props => [
        itemId,
        productName,
        sku,
        expectedQuantity,
        actualQuantity,
        discrepancy,
        unitPrice,
        discrepancyValue,
      ];
}