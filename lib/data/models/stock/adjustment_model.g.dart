// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adjustment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdjustmentModel _$AdjustmentModelFromJson(Map<String, dynamic> json) =>
    AdjustmentModel(
      id: json['id'] as String,
      stockId: json['stockId'] as String,
      quantityChange: (json['quantityChange'] as num).toInt(),
      reason: json['reason'] as String,
      performedByUserId: json['performedByUserId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$AdjustmentModelToJson(AdjustmentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'stockId': instance.stockId,
      'quantityChange': instance.quantityChange,
      'reason': instance.reason,
      'performedByUserId': instance.performedByUserId,
      'timestamp': instance.timestamp.toIso8601String(),
    };
