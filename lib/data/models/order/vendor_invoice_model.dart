import 'package:json_annotation/json_annotation.dart';

part 'vendor_invoice_model.g.dart';

@JsonSerializable(explicitToJson: true)
class VendorInvoiceModel {
  final String id;
  final String purchaseOrderId;
  final String invoiceNumber;
  final String supplierId;
  final DateTime invoiceDate;
  final DateTime? dueDate;
  final double totalAmount;
  final String status; // pending, paid, cancelled
  final List<String>? attachments;
  final String? notes;

  const VendorInvoiceModel({
    required this.id,
    required this.purchaseOrderId,
    required this.supplierId,
    required this.invoiceNumber,
    required this.invoiceDate,
    this.dueDate,
    required this.totalAmount,
    required this.status,
    this.attachments,
    this.notes,
  });

  factory VendorInvoiceModel.fromJson(Map<String, dynamic> json) =>
      _$VendorInvoiceModelFromJson(json);

  Map<String, dynamic> toJson() => _$VendorInvoiceModelToJson(this);
}