// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_movement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockMovementModel _$StockMovementModelFromJson(Map<String, dynamic> json) =>
    StockMovementModel(
      id: json['id'] as String,
      stockId: json['stockId'] as String,
      type: $enumDecode(_$MovementTypeModelEnumMap, json['type']),
      quantity: (json['quantity'] as num).toInt(),
      reason: json['reason'] as String?,
      referenceId: json['referenceId'] as String?,
      performedByUserId: json['performedByUserId'] as String?,
      fromLocation: json['fromLocation'] as String?,
      toLocation: json['toLocation'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$StockMovementModelToJson(StockMovementModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'stockId': instance.stockId,
      'type': _$MovementTypeModelEnumMap[instance.type]!,
      'quantity': instance.quantity,
      'reason': instance.reason,
      'referenceId': instance.referenceId,
      'performedByUserId': instance.performedByUserId,
      'fromLocation': instance.fromLocation,
      'toLocation': instance.toLocation,
      'timestamp': instance.timestamp.toIso8601String(),
    };

const _$MovementTypeModelEnumMap = {
  MovementTypeModel.inbound: 'inbound',
  MovementTypeModel.outbound: 'outbound',
  MovementTypeModel.adjustment: 'adjustment',
};
