import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/order/return_order.dart';
import 'return_order_item_model.dart';
import 'return_type_model.dart';

part 'return_order_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ReturnOrderModel extends Equatable {
  final String id;
  final String originalOrderId; // PO or SO
  final String requestedByUserId;
  final DateTime requestedAt;
  final ReturnTypeModel type;
  final String? approvedByUserId;
  final DateTime? processedAt;
  final String status; // pending, approved, processed, cancelled
  final List<ReturnOrderItemModel> items;
  final String? notes;

  const ReturnOrderModel({
    required this.id,
    required this.originalOrderId,
    required this.requestedByUserId,
    required this.requestedAt,
    required this.type,
    this.approvedByUserId,
    this.processedAt,
    required this.status,
    required this.items,
    this.notes,
  });

  factory ReturnOrderModel.fromJson(Map<String, dynamic> json) =>
      _$ReturnOrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReturnOrderModelToJson(this);

  ReturnOrder toDomain() => ReturnOrder(
    id: id,
    originalOrderId: originalOrderId,
    requestedByUserId: requestedByUserId,
    requestedAt: requestedAt,
    type: type.toDomain(),
    approvedByUserId: approvedByUserId,
    processedAt: processedAt,
    status: status,
    items: items.map((m) => m.toDomain()).toList(),
    notes: notes,
  );

  static ReturnOrderModel fromDomain(ReturnOrder ent) => ReturnOrderModel(
    id: ent.id,
    originalOrderId: ent.originalOrderId,
    requestedByUserId: ent.requestedByUserId,
    requestedAt: ent.requestedAt,
    type: ReturnTypeModel.fromDomain(ent.type),
    approvedByUserId: ent.approvedByUserId,
    processedAt: ent.processedAt,
    status: ent.status,
    items: ent.items.map(ReturnOrderItemModel.fromDomain).toList(),
    notes: ent.notes,
  );

  ReturnOrderModel copyWith({
    String? id,
    String? originalOrderId,
    String? requestedByUserId,
    DateTime? requestedAt,
    ReturnTypeModel? type,
    String? approvedByUserId,
    DateTime? processedAt,
    String? status,
    List<ReturnOrderItemModel>? items,
    String? notes,
  }) {
    return ReturnOrderModel(
      id: id ?? this.id,
      originalOrderId: originalOrderId ?? this.originalOrderId,
      requestedByUserId: requestedByUserId ?? this.requestedByUserId,
      requestedAt: requestedAt ?? this.requestedAt,
      type: type ?? this.type,
      approvedByUserId: approvedByUserId ?? this.approvedByUserId,
      processedAt: processedAt ?? this.processedAt,
      status: status ?? this.status,
      items: items ?? this.items,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
    id,
    originalOrderId,
    requestedByUserId,
    requestedAt,
    type,
    approvedByUserId,
    processedAt,
    status,
    items,
    notes,
  ];
}
