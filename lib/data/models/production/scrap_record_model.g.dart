// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scrap_record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScrapRecordModel _$ScrapRecordModelFromJson(Map<String, dynamic> json) =>
    ScrapRecordModel(
      productionOrderId: json['productionOrderId'] as String,
      rawMaterialId: json['rawMaterialId'] as String,
      wastedQuantity: (json['wastedQuantity'] as num).toInt(),
      reason: json['reason'] as String,
    );

Map<String, dynamic> _$ScrapRecordModelToJson(ScrapRecordModel instance) =>
    <String, dynamic>{
      'productionOrderId': instance.productionOrderId,
      'rawMaterialId': instance.rawMaterialId,
      'wastedQuantity': instance.wastedQuantity,
      'reason': instance.reason,
    };
