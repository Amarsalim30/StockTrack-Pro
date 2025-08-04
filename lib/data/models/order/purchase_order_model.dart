import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/order/purchase_order.dart';
import 'purchase_order_item_model.dart';

part 'purchase_order_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PurchaseOrderModel extends Equatable {
  final String id;
  final String supplierId;
  final String createdByUserId;
  final String? approvedByUserId;
  final DateTime createdAt;
  final DateTime? expectedDeliveryDate;
  final DateTime? receivedDate;
  final String status; // pending, sent, received, cancelled
  final List<PurchaseOrderItemModel> items;
  final String? notes;

  const PurchaseOrderModel({
    required this.id,
    required this.supplierId,
    required this.createdByUserId,
    this.approvedByUserId,
    required this.createdAt,
    this.expectedDeliveryDate,
    this.receivedDate,
    required this.status,
    required this.items,
    this.notes,
  });

  factory PurchaseOrderModel.fromJson(Map<String, dynamic> json) =>
      _$PurchaseOrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$PurchaseOrderModelToJson(this);

  PurchaseOrder toDomain() => PurchaseOrder(
    id: id,
    supplierId: supplierId,
    createdByUserId: createdByUserId,
    approvedByUserId: approvedByUserId,
    createdAt: createdAt,
    expectedDeliveryDate: expectedDeliveryDate,
    receivedDate: receivedDate,
    status: status,
    items: items.map((m) => m.toDomain()).toList(),
    notes: notes,
  );

  static PurchaseOrderModel fromDomain(PurchaseOrder ent) => PurchaseOrderModel(
    id: ent.id,
    supplierId: ent.supplierId,
    createdByUserId: ent.createdByUserId,
    approvedByUserId: ent.approvedByUserId,
    createdAt: ent.createdAt,
    expectedDeliveryDate: ent.expectedDeliveryDate,
    receivedDate: ent.receivedDate,
    status: ent.status,
    items: ent.items.map(PurchaseOrderItemModel.fromDomain).toList(),
    notes: ent.notes,
  );

  PurchaseOrderModel copyWith({
    String? id,
    String? supplierId,
    String? createdByUserId,
    String? approvedByUserId,
    DateTime? createdAt,
    DateTime? expectedDeliveryDate,
    DateTime? receivedDate,
    String? status,
    List<PurchaseOrderItemModel>? items,
    String? notes,
  }) {
    return PurchaseOrderModel(
      id: id ?? this.id,
      supplierId: supplierId ?? this.supplierId,
      createdByUserId: createdByUserId ?? this.createdByUserId,
      approvedByUserId: approvedByUserId ?? this.approvedByUserId,
      createdAt: createdAt ?? this.createdAt,
      expectedDeliveryDate: expectedDeliveryDate ?? this.expectedDeliveryDate,
      receivedDate: receivedDate ?? this.receivedDate,
      status: status ?? this.status,
      items: items ?? this.items,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
    id,
    supplierId,
    createdByUserId,
    approvedByUserId,
    createdAt,
    expectedDeliveryDate,
    receivedDate,
    status,
    items,
    notes,
  ];
}
