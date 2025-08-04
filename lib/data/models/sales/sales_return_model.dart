import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/sales/sales_return.dart';
import 'sales_order_item_model.dart';

part 'sales_return_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SalesReturnModel extends Equatable {
  final String id;
  final String salesOrderId;
  final String returnedByUserId;
  final DateTime returnedAt;
  final List<SalesOrderItemModel> items;
  final double refundAmount;
  final String? reason;
  final String status; // pending, approved, refunded, cancelled

  const SalesReturnModel({
    required this.id,
    required this.salesOrderId,
    required this.returnedByUserId,
    required this.returnedAt,
    required this.items,
    required this.refundAmount,
    this.reason,
    required this.status,
  });

  factory SalesReturnModel.fromJson(Map<String, dynamic> json) =>
      _$SalesReturnModelFromJson(json);

  Map<String, dynamic> toJson() => _$SalesReturnModelToJson(this);

  SalesReturn toDomain() => SalesReturn(
    id: id,
    salesOrderId: salesOrderId,
    returnedByUserId: returnedByUserId,
    returnedAt: returnedAt,
    items: items.map((m) => m.toDomain()).toList(),
    refundAmount: refundAmount,
    reason: reason,
    status: status,
  );

  static SalesReturnModel fromDomain(SalesReturn ent) => SalesReturnModel(
    id: ent.id,
    salesOrderId: ent.salesOrderId,
    returnedByUserId: ent.returnedByUserId,
    returnedAt: ent.returnedAt,
    items: ent.items.map(SalesOrderItemModel.fromDomain).toList(),
    refundAmount: ent.refundAmount,
    reason: ent.reason,
    status: ent.status,
  );

  SalesReturnModel copyWith({
    String? id,
    String? salesOrderId,
    String? returnedByUserId,
    DateTime? returnedAt,
    List<SalesOrderItemModel>? items,
    double? refundAmount,
    String? reason,
    String? status,
  }) {
    return SalesReturnModel(
      id: id ?? this.id,
      salesOrderId: salesOrderId ?? this.salesOrderId,
      returnedByUserId: returnedByUserId ?? this.returnedByUserId,
      returnedAt: returnedAt ?? this.returnedAt,
      items: items ?? this.items,
      refundAmount: refundAmount ?? this.refundAmount,
      reason: reason ?? this.reason,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
    id,
    salesOrderId,
    returnedByUserId,
    returnedAt,
    items,
    refundAmount,
    reason,
    status,
  ];
}
