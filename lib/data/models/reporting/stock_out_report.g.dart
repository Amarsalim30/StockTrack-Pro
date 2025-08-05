// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_out_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockOutReportModel _$StockOutReportModelFromJson(Map<String, dynamic> json) =>
    StockOutReportModel(
      stockId: json['stockId'] as String,
      name: json['name'] as String,
      quantityOut: (json['quantityOut'] as num).toInt(),
      dateOut: DateTime.parse(json['dateOut'] as String),
      performedBy: json['performedBy'] as String,
      reason: json['reason'] as String?,
    );

Map<String, dynamic> _$StockOutReportModelToJson(
  StockOutReportModel instance,
) => <String, dynamic>{
  'stockId': instance.stockId,
  'name': instance.name,
  'quantityOut': instance.quantityOut,
  'dateOut': instance.dateOut.toIso8601String(),
  'performedBy': instance.performedBy,
  'reason': instance.reason,
};
