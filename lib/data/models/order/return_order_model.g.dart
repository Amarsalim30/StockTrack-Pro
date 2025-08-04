// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'return_order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReturnOrderModel _$ReturnOrderModelFromJson(Map<String, dynamic> json) =>
    ReturnOrderModel(
      id: json['id'] as String,
      originalOrderId: json['originalOrderId'] as String,
      requestedByUserId: json['requestedByUserId'] as String,
      requestedAt: DateTime.parse(json['requestedAt'] as String),
      type: $enumDecode(_$ReturnTypeModelEnumMap, json['type']),
      approvedByUserId: json['approvedByUserId'] as String?,
      processedAt: json['processedAt'] == null
          ? null
          : DateTime.parse(json['processedAt'] as String),
      status: json['status'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => ReturnOrderItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$ReturnOrderModelToJson(ReturnOrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'originalOrderId': instance.originalOrderId,
      'requestedByUserId': instance.requestedByUserId,
      'requestedAt': instance.requestedAt.toIso8601String(),
      'type': _$ReturnTypeModelEnumMap[instance.type]!,
      'approvedByUserId': instance.approvedByUserId,
      'processedAt': instance.processedAt?.toIso8601String(),
      'status': instance.status,
      'items': instance.items.map((e) => e.toJson()).toList(),
      'notes': instance.notes,
    };

const _$ReturnTypeModelEnumMap = {
  ReturnTypeModel.supplier: 'supplier',
  ReturnTypeModel.customer: 'customer',
  ReturnTypeModel.warranty: 'warranty',
};
