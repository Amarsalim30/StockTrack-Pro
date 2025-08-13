// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goods_receipt_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoodsReceiptItemModel _$GoodsReceiptItemModelFromJson(
  Map<String, dynamic> json,
) => GoodsReceiptItemModel(
  stockId: json['stockId'] as String,
  quantityReceived: (json['quantityReceived'] as num).toInt(),
  unitPrice: (json['unitPrice'] as num).toDouble(),
  totalPrice: (json['totalPrice'] as num).toDouble(),
  expiryDate: json['expiryDate'] == null
      ? null
      : DateTime.parse(json['expiryDate'] as String),
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$GoodsReceiptItemModelToJson(
  GoodsReceiptItemModel instance,
) => <String, dynamic>{
  'stockId': instance.stockId,
  'quantityReceived': instance.quantityReceived,
  'unitPrice': instance.unitPrice,
  'totalPrice': instance.totalPrice,
  'expiryDate': instance.expiryDate?.toIso8601String(),
  'notes': instance.notes,
};
