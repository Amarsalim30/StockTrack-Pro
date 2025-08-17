import 'package:json_annotation/json_annotation.dart';

part 'goods_receipt_item_model.g.dart';

@JsonSerializable(explicitToJson: true)
class GoodsReceiptItemModel {
  final String stockId;
  final int quantityReceived;
  final double unitPrice;
  final double totalPrice;
  final DateTime? expiryDate;
  final String? notes;

  const GoodsReceiptItemModel({
    required this.stockId,
    required this.quantityReceived,
    required this.unitPrice,
    required this.totalPrice,
    this.expiryDate,
    this.notes,
  });

  factory GoodsReceiptItemModel.fromJson(Map<String, dynamic> json) =>
      _$GoodsReceiptItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$GoodsReceiptItemModelToJson(this);
}