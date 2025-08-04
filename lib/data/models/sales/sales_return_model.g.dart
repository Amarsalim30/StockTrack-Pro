// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_return_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SalesReturnModel _$SalesReturnModelFromJson(Map<String, dynamic> json) =>
    SalesReturnModel(
      id: json['id'] as String,
      salesOrderId: json['salesOrderId'] as String,
      returnedByUserId: json['returnedByUserId'] as String,
      returnedAt: DateTime.parse(json['returnedAt'] as String),
      items: (json['items'] as List<dynamic>)
          .map((e) => SalesOrderItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      refundAmount: (json['refundAmount'] as num).toDouble(),
      reason: json['reason'] as String?,
      status: json['status'] as String,
    );

Map<String, dynamic> _$SalesReturnModelToJson(SalesReturnModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'salesOrderId': instance.salesOrderId,
      'returnedByUserId': instance.returnedByUserId,
      'returnedAt': instance.returnedAt.toIso8601String(),
      'items': instance.items.map((e) => e.toJson()).toList(),
      'refundAmount': instance.refundAmount,
      'reason': instance.reason,
      'status': instance.status,
    };
