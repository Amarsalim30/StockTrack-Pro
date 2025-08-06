// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'production_order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductionOrderModel _$ProductionOrderModelFromJson(
  Map<String, dynamic> json,
) => ProductionOrderModel(
  id: json['id'] as String,
  productId: json['productId'] as String,
  quantityToProduce: (json['quantityToProduce'] as num).toInt(),
  status: const ProductionOrderStatusModelConverter().fromJson(
    json['status'] as String,
  ),
  createdAt: DateTime.parse(json['createdAt'] as String),
  startedAt: json['startedAt'] == null
      ? null
      : DateTime.parse(json['startedAt'] as String),
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
);

Map<String, dynamic> _$ProductionOrderModelToJson(
  ProductionOrderModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'productId': instance.productId,
  'quantityToProduce': instance.quantityToProduce,
  'status': const ProductionOrderStatusModelConverter().toJson(instance.status),
  'createdAt': instance.createdAt.toIso8601String(),
  'startedAt': instance.startedAt?.toIso8601String(),
  'completedAt': instance.completedAt?.toIso8601String(),
};
