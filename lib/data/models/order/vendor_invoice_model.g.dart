// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_invoice_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VendorInvoiceModel _$VendorInvoiceModelFromJson(Map<String, dynamic> json) =>
    VendorInvoiceModel(
      id: json['id'] as String,
      purchaseOrderId: json['purchaseOrderId'] as String,
      supplierId: json['supplierId'] as String,
      invoiceNumber: json['invoiceNumber'] as String,
      invoiceDate: DateTime.parse(json['invoiceDate'] as String),
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      status: json['status'] as String,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$VendorInvoiceModelToJson(VendorInvoiceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'purchaseOrderId': instance.purchaseOrderId,
      'invoiceNumber': instance.invoiceNumber,
      'supplierId': instance.supplierId,
      'invoiceDate': instance.invoiceDate.toIso8601String(),
      'dueDate': instance.dueDate?.toIso8601String(),
      'totalAmount': instance.totalAmount,
      'status': instance.status,
      'attachments': instance.attachments,
      'notes': instance.notes,
    };
