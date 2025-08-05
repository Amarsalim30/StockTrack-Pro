import 'package:clean_arch_app/data/models/convert_helpers/production_order_status_converter.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/production/production_order.dart';
import '../../../data/models/production/production_order_status_model.dart';
import '../../../data/mappers/production/production_order_status_mapper.dart';

part 'production_order_model.g.dart';

@JsonSerializable()
class ProductionOrderModel extends Equatable {
  final String id;
  final String productId;
  final int quantityToProduce;

  @ProductionOrderStatusModelConverter()
  final ProductionOrderStatusModel status;

  final DateTime createdAt;
  final DateTime? startedAt;
  final DateTime? completedAt;

  const ProductionOrderModel({
    required this.id,
    required this.productId,
    required this.quantityToProduce,
    required this.status,
    required this.createdAt,
    this.startedAt,
    this.completedAt,
  });

  factory ProductionOrderModel.fromJson(Map<String, dynamic> json) =>
      _$ProductionOrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductionOrderModelToJson(this);

  /// Converts this model to a domain entity
  ProductionOrder toDomain() => ProductionOrder(
    id: id,
    productId: productId,
    quantityToProduce: quantityToProduce,
    status: ProductionOrderStatusMapper.toEntity(status.name),
    createdAt: createdAt,
    startedAt: startedAt,
    completedAt: completedAt,
  );

  /// Builds this model from a domain entity
  static ProductionOrderModel fromDomain(ProductionOrder e) =>
      ProductionOrderModel(
        id: e.id,
        productId: e.productId,
        quantityToProduce: e.quantityToProduce,
        status: ProductionOrderStatusMapper.toModel(e.status),
        createdAt: e.createdAt,
        startedAt: e.startedAt,
        completedAt: e.completedAt,
      );

  @override
  List<Object?> get props => [
    id,
    productId,
    quantityToProduce,
    status,
    createdAt,
    startedAt,
    completedAt,
  ];
}
