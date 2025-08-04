// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SalesOrderModel _$SalesOrderModelFromJson(Map<String, dynamic> json) =>
    SalesOrderModel(
      id: json['id'] as String,
      customerId: json['customerId'] as String,
      createdByUserId: json['createdByUserId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      status: json['status'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => SalesOrderItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$SalesOrderModelToJson(SalesOrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customerId': instance.customerId,
      'createdByUserId': instance.createdByUserId,
      'createdAt': instance.createdAt.toIso8601String(),
      'status': instance.status,
      'items': instance.items.map((e) => e.toJson()).toList(),
      'totalAmount': instance.totalAmount,
      'notes': instance.notes,
    };
