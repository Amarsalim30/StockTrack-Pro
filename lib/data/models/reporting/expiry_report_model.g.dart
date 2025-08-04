// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expiry_report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExpiryReportModel _$ExpiryReportModelFromJson(Map<String, dynamic> json) =>
    ExpiryReportModel(
      stockId: json['stockId'] as String,
      name: json['name'] as String,
      expiryDate: DateTime.parse(json['expiryDate'] as String),
      daysToExpiry: (json['daysToExpiry'] as num).toInt(),
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$ExpiryReportModelToJson(ExpiryReportModel instance) =>
    <String, dynamic>{
      'stockId': instance.stockId,
      'name': instance.name,
      'expiryDate': instance.expiryDate.toIso8601String(),
      'daysToExpiry': instance.daysToExpiry,
      'quantity': instance.quantity,
    };
