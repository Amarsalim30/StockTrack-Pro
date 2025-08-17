import 'package:clean_arch_app/data/models/order/goods_receipt_item_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'goods_receipt_model.g.dart';

@JsonSerializable(explicitToJson: true)
class GoodsReceiptModel {
  final String id;
  final String purchaseOrderId;
  final String receivedByUserId;
  final DateTime createdAt;
  final DateTime? receivedAtDate;
  final List<GoodsReceiptItemModel> items;
  final String status; // pending, received, cancelled
  final List<String> attachments;
  final String? notes;

  const GoodsReceiptModel({
    required this.id,
    required this.purchaseOrderId,
    required this.receivedByUserId,
    required this.createdAt,
    this.receivedAtDate,
    required this.items, // ✅ added here
    required this.status,
    required this.attachments,
    this.notes,
  });

  factory GoodsReceiptModel.fromJson(Map<String, dynamic> json) =>
      _$GoodsReceiptModelFromJson(json);

  Map<String, dynamic> toJson() => _$GoodsReceiptModelToJson(this);
}
