// lib/data/models/production/production_order_model.dart

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/production/production_order.dart';

part 'production_order_model.g.dart';

enum ProductionOrderStatus {
  pending,
  inProgress,
  completed,
  cancelled,
}
@JsonSerializable()
class ProductionOrderModel extends Equatable {
  final String id;
  final String productId;
  final int quantityToProduce;
  final String status; // use enum.name
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

  ProductionOrder toDomain() => ProductionOrder(
    id: id,
    productId: productId,
    quantityToProduce: quantityToProduce,
    status: ProductionOrderStatus.values.byName(status),
    createdAt: createdAt,
    startedAt: startedAt,
    completedAt: completedAt,
  );

  static ProductionOrderModel fromDomain(ProductionOrder e) =>
      ProductionOrderModel(
        id: e.id,
        productId: e.productId,
        quantityToProduce: e.quantityToProduce,
        status: e.status.name,
        createdAt: e.createdAt,
        startedAt: e.startedAt,
        completedAt: e.completedAt,
      );

  ProductionOrderModel copyWith({
    String? id,
    String? productId,
    int? quantityToProduce,
    String? status,
    DateTime? createdAt,
    DateTime? startedAt,
    DateTime? completedAt,
  }) {
    return ProductionOrderModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      quantityToProduce: quantityToProduce ?? this.quantityToProduce,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

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
