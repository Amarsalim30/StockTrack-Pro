// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchaseOrderModel _$PurchaseOrderModelFromJson(Map<String, dynamic> json) =>
    PurchaseOrderModel(
      id: json['id'] as String,
      supplierId: json['supplierId'] as String,
      createdByUserId: json['createdByUserId'] as String,
      approvedByUserId: json['approvedByUserId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      expectedDeliveryDate: json['expectedDeliveryDate'] == null
          ? null
          : DateTime.parse(json['expectedDeliveryDate'] as String),
      receivedDate: json['receivedDate'] == null
          ? null
          : DateTime.parse(json['receivedDate'] as String),
      status: json['status'] as String,
      items: (json['items'] as List<dynamic>)
          .map(
            (e) => PurchaseOrderItemModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$PurchaseOrderModelToJson(PurchaseOrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'supplierId': instance.supplierId,
      'createdByUserId': instance.createdByUserId,
      'approvedByUserId': instance.approvedByUserId,
      'createdAt': instance.createdAt.toIso8601String(),
      'expectedDeliveryDate': instance.expectedDeliveryDate?.toIso8601String(),
      'receivedDate': instance.receivedDate?.toIso8601String(),
      'status': instance.status,
      'items': instance.items.map((e) => e.toJson()).toList(),
      'notes': instance.notes,
    };
