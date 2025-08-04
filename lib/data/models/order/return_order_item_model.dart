import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/order/return_order_item.dart';

part 'return_order_item_model.g.dart';

@JsonSerializable()
class ReturnOrderItemModel extends Equatable {
  final String stockId;
  final int quantity;
  final String? reason;

  const ReturnOrderItemModel({
    required this.stockId,
    required this.quantity,
    this.reason,
  });

  factory ReturnOrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$ReturnOrderItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReturnOrderItemModelToJson(this);

  ReturnOrderItem toDomain() =>
      ReturnOrderItem(stockId: stockId, quantity: quantity, reason: reason);

  static ReturnOrderItemModel fromDomain(ReturnOrderItem ent) =>
      ReturnOrderItemModel(
        stockId: ent.stockId,
        quantity: ent.quantity,
        reason: ent.reason,
      );

  ReturnOrderItemModel copyWith({
    String? stockId,
    int? quantity,
    String? reason,
  }) {
    return ReturnOrderItemModel(
      stockId: stockId ?? this.stockId,
      quantity: quantity ?? this.quantity,
      reason: reason ?? this.reason,
    );
  }

  @override
  List<Object?> get props => [stockId, quantity, reason];
}
