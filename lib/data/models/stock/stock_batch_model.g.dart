// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_batch_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockBatchModel _$StockBatchModelFromJson(Map<String, dynamic> json) =>
    StockBatchModel(
      batchId: json['batchId'] as String,
      stockId: json['stockId'] as String,
      quantity: (json['quantity'] as num).toInt(),
      manufactureDate: DateTime.parse(json['manufactureDate'] as String),
      expiryDate: json['expiryDate'] == null
          ? null
          : DateTime.parse(json['expiryDate'] as String),
    );

Map<String, dynamic> _$StockBatchModelToJson(StockBatchModel instance) =>
    <String, dynamic>{
      'batchId': instance.batchId,
      'stockId': instance.stockId,
      'quantity': instance.quantity,
      'manufactureDate': instance.manufactureDate.toIso8601String(),
      'expiryDate': instance.expiryDate?.toIso8601String(),
    };
