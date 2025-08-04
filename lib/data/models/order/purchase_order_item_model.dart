import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/order/purchase_order_item.dart';

part 'purchase_order_item_model.g.dart';

@JsonSerializable()
class PurchaseOrderItemModel extends Equatable {
  final String stockId;
  final int quantityOrdered;
  final int? quantityReceived;
  final double? unitCost;

  const PurchaseOrderItemModel({
    required this.stockId,
    required this.quantityOrdered,
    this.quantityReceived,
    this.unitCost,
  });

  factory PurchaseOrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$PurchaseOrderItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$PurchaseOrderItemModelToJson(this);

  PurchaseOrderItem toDomain() => PurchaseOrderItem(
    stockId: stockId,
    quantityOrdered: quantityOrdered,
    quantityReceived: quantityReceived,
    unitCost: unitCost,
  );

  static PurchaseOrderItemModel fromDomain(PurchaseOrderItem ent) =>
      PurchaseOrderItemModel(
        stockId: ent.stockId,
        quantityOrdered: ent.quantityOrdered,
        quantityReceived: ent.quantityReceived,
        unitCost: ent.unitCost,
      );

  PurchaseOrderItemModel copyWith({
    String? stockId,
    int? quantityOrdered,
    int? quantityReceived,
    double? unitCost,
  }) {
    return PurchaseOrderItemModel(
      stockId: stockId ?? this.stockId,
      quantityOrdered: quantityOrdered ?? this.quantityOrdered,
      quantityReceived: quantityReceived ?? this.quantityReceived,
      unitCost: unitCost ?? this.unitCost,
    );
  }

  @override
  List<Object?> get props => [
    stockId,
    quantityOrdered,
    quantityReceived,
    unitCost,
  ];
}
