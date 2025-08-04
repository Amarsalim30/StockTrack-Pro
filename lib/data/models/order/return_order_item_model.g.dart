// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'return_order_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReturnOrderItemModel _$ReturnOrderItemModelFromJson(
  Map<String, dynamic> json,
) => ReturnOrderItemModel(
  stockId: json['stockId'] as String,
  quantity: (json['quantity'] as num).toInt(),
  reason: json['reason'] as String?,
);

Map<String, dynamic> _$ReturnOrderItemModelToJson(
  ReturnOrderItemModel instance,
) => <String, dynamic>{
  'stockId': instance.stockId,
  'quantity': instance.quantity,
  'reason': instance.reason,
};
