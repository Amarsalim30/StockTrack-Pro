import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/sales/sales_order_item.dart';

part 'sales_order_item_model.g.dart';

@JsonSerializable()
class SalesOrderItemModel extends Equatable {
  final String stockId;
  final int quantity;
  final double unitPrice;

  const SalesOrderItemModel({
    required this.stockId,
    required this.quantity,
    required this.unitPrice,
  });

  factory SalesOrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$SalesOrderItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$SalesOrderItemModelToJson(this);

  SalesOrderItem toDomain() => SalesOrderItem(
    stockId: stockId,
    quantity: quantity,
    unitPrice: unitPrice,
  );

  static SalesOrderItemModel fromDomain(SalesOrderItem ent) =>
      SalesOrderItemModel(
        stockId: ent.stockId,
        quantity: ent.quantity,
        unitPrice: ent.unitPrice,
      );

  SalesOrderItemModel copyWith({
    String? stockId,
    int? quantity,
    double? unitPrice,
  }) {
    return SalesOrderItemModel(
      stockId: stockId ?? this.stockId,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
    );
  }

  @override
  List<Object?> get props => [stockId, quantity, unitPrice];
}
