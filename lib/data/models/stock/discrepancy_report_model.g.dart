// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discrepancy_report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiscrepancyReportModel _$DiscrepancyReportModelFromJson(
  Map<String, dynamic> json,
) => DiscrepancyReportModel(
  reportId: json['reportId'] as String,
  stockTakeId: json['stockTakeId'] as String,
  generatedAt: DateTime.parse(json['generatedAt'] as String),
  totalItems: (json['totalItems'] as num).toInt(),
  discrepancyCount: (json['discrepancyCount'] as num).toInt(),
  totalDiscrepancyValue: (json['totalDiscrepancyValue'] as num).toDouble(),
  discrepancies: (json['discrepancies'] as List<dynamic>)
      .map((e) => DiscrepancyItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$DiscrepancyReportModelToJson(
  DiscrepancyReportModel instance,
) => <String, dynamic>{
  'reportId': instance.reportId,
  'stockTakeId': instance.stockTakeId,
  'generatedAt': instance.generatedAt.toIso8601String(),
  'totalItems': instance.totalItems,
  'discrepancyCount': instance.discrepancyCount,
  'totalDiscrepancyValue': instance.totalDiscrepancyValue,
  'discrepancies': instance.discrepancies,
};

DiscrepancyItemModel _$DiscrepancyItemModelFromJson(
  Map<String, dynamic> json,
) => DiscrepancyItemModel(
  itemId: json['itemId'] as String,
  productName: json['productName'] as String,
  sku: json['sku'] as String,
  expectedQuantity: (json['expectedQuantity'] as num).toInt(),
  actualQuantity: (json['actualQuantity'] as num).toInt(),
  discrepancy: (json['discrepancy'] as num).toInt(),
  unitPrice: (json['unitPrice'] as num).toDouble(),
  discrepancyValue: (json['discrepancyValue'] as num).toDouble(),
);

Map<String, dynamic> _$DiscrepancyItemModelToJson(
  DiscrepancyItemModel instance,
) => <String, dynamic>{
  'itemId': instance.itemId,
  'productName': instance.productName,
  'sku': instance.sku,
  'expectedQuantity': instance.expectedQuantity,
  'actualQuantity': instance.actualQuantity,
  'discrepancy': instance.discrepancy,
  'unitPrice': instance.unitPrice,
  'discrepancyValue': instance.discrepancyValue,
};
