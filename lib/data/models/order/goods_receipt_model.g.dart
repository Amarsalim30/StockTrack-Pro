// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goods_receipt_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoodsReceiptModel _$GoodsReceiptModelFromJson(Map<String, dynamic> json) =>
    GoodsReceiptModel(
      id: json['id'] as String,
      purchaseOrderId: json['purchaseOrderId'] as String,
      receivedByUserId: json['receivedByUserId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      receivedAtDate: json['receivedAtDate'] == null
          ? null
          : DateTime.parse(json['receivedAtDate'] as String),
      items: (json['items'] as List<dynamic>)
          .map((e) => GoodsReceiptItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as String,
      attachments: (json['attachments'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$GoodsReceiptModelToJson(GoodsReceiptModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'purchaseOrderId': instance.purchaseOrderId,
      'receivedByUserId': instance.receivedByUserId,
      'createdAt': instance.createdAt.toIso8601String(),
      'receivedAtDate': instance.receivedAtDate?.toIso8601String(),
      'items': instance.items.map((e) => e.toJson()).toList(),
      'status': instance.status,
      'attachments': instance.attachments,
      'notes': instance.notes,
    };
