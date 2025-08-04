// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_movement_report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockMovementReportModel _$StockMovementReportModelFromJson(
  Map<String, dynamic> json,
) => StockMovementReportModel(
  movementId: json['movementId'] as String,
  stockId: json['stockId'] as String,
  type: json['type'] as String,
  quantity: (json['quantity'] as num).toInt(),
  performedBy: json['performedBy'] as String,
  timestamp: DateTime.parse(json['timestamp'] as String),
  reason: json['reason'] as String?,
);

Map<String, dynamic> _$StockMovementReportModelToJson(
  StockMovementReportModel instance,
) => <String, dynamic>{
  'movementId': instance.movementId,
  'stockId': instance.stockId,
  'type': instance.type,
  'quantity': instance.quantity,
  'performedBy': instance.performedBy,
  'timestamp': instance.timestamp.toIso8601String(),
  'reason': instance.reason,
};
