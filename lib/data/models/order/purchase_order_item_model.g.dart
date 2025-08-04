// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_order_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchaseOrderItemModel _$PurchaseOrderItemModelFromJson(
  Map<String, dynamic> json,
) => PurchaseOrderItemModel(
  stockId: json['stockId'] as String,
  quantityOrdered: (json['quantityOrdered'] as num).toInt(),
  quantityReceived: (json['quantityReceived'] as num?)?.toInt(),
  unitCost: (json['unitCost'] as num?)?.toDouble(),
);

Map<String, dynamic> _$PurchaseOrderItemModelToJson(
  PurchaseOrderItemModel instance,
) => <String, dynamic>{
  'stockId': instance.stockId,
  'quantityOrdered': instance.quantityOrdered,
  'quantityReceived': instance.quantityReceived,
  'unitCost': instance.unitCost,
};
