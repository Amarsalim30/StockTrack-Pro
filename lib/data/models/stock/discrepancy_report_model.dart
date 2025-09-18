import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'discrepancy_report_model.g.dart';

@JsonSerializable()
class DiscrepancyReportModel extends Equatable {
  final String reportId;
  final String stockTakeId;
  final DateTime generatedAt;
  final int totalItems;
  final int discrepancyCount;
  final double totalDiscrepancyValue;
  final List<DiscrepancyItemModel> discrepancies;

  const DiscrepancyReportModel({
    required this.reportId,
    required this.stockTakeId,
    required this.generatedAt,
    required this.totalItems,
    required this.discrepancyCount,
    required this.totalDiscrepancyValue,
    required this.discrepancies,
  });

  factory DiscrepancyReportModel.fromJson(Map<String, dynamic> json) =>
      _$DiscrepancyReportModelFromJson(json);

  Map<String, dynamic> toJson() => _$DiscrepancyReportModelToJson(this);

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

@JsonSerializable()
class DiscrepancyItemModel extends Equatable {
  final String itemId;
  final String productName;
  final String sku;
  final int expectedQuantity;
  final int actualQuantity;
  final int discrepancy;
  final double unitPrice;
  final double discrepancyValue;

  const DiscrepancyItemModel({
    required this.itemId,
    required this.productName,
    required this.sku,
    required this.expectedQuantity,
    required this.actualQuantity,
    required this.discrepancy,
    required this.unitPrice,
    required this.discrepancyValue,
  });

  factory DiscrepancyItemModel.fromJson(Map<String, dynamic> json) =>
      _$DiscrepancyItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$DiscrepancyItemModelToJson(this);

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