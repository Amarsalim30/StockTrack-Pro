import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/sales/sales_order.dart';
import 'sales_order_item_model.dart';

part 'sales_order_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SalesOrderModel extends Equatable {
  final String id;
  final String customerId;
  final String createdByUserId;
  final DateTime createdAt;
  final String status; // pending, paid, shipped, cancelled
  final List<SalesOrderItemModel> items;
  final double totalAmount;
  final String? notes;

  const SalesOrderModel({
    required this.id,
    required this.customerId,
    required this.createdByUserId,
    required this.createdAt,
    required this.status,
    required this.items,
    required this.totalAmount,
    this.notes,
  });

  factory SalesOrderModel.fromJson(Map<String, dynamic> json) =>
      _$SalesOrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$SalesOrderModelToJson(this);

  SalesOrder toDomain() => SalesOrder(
    id: id,
    customerId: customerId,
    createdByUserId: createdByUserId,
    createdAt: createdAt,
    status: status,
    items: items.map((m) => m.toDomain()).toList(),
    totalAmount: totalAmount,
    notes: notes,
  );

  static SalesOrderModel fromDomain(SalesOrder ent) => SalesOrderModel(
    id: ent.id,
    customerId: ent.customerId,
    createdByUserId: ent.createdByUserId,
    createdAt: ent.createdAt,
    status: ent.status,
    items: ent.items.map(SalesOrderItemModel.fromDomain).toList(),
    totalAmount: ent.totalAmount,
    notes: ent.notes,
  );

  SalesOrderModel copyWith({
    String? id,
    String? customerId,
    String? createdByUserId,
    DateTime? createdAt,
    String? status,
    List<SalesOrderItemModel>? items,
    double? totalAmount,
    String? notes,
  }) {
    return SalesOrderModel(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      createdByUserId: createdByUserId ?? this.createdByUserId,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
    id,
    customerId,
    createdByUserId,
    createdAt,
    status,
    items,
    totalAmount,
    notes,
  ];
}
