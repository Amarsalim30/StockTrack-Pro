// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_order_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SalesOrderItemModel _$SalesOrderItemModelFromJson(Map<String, dynamic> json) =>
    SalesOrderItemModel(
      stockId: json['stockId'] as String,
      quantity: (json['quantity'] as num).toInt(),
      unitPrice: (json['unitPrice'] as num).toDouble(),
    );

Map<String, dynamic> _$SalesOrderItemModelToJson(
  SalesOrderItemModel instance,
) => <String, dynamic>{
  'stockId': instance.stockId,
  'quantity': instance.quantity,
  'unitPrice': instance.unitPrice,
};
