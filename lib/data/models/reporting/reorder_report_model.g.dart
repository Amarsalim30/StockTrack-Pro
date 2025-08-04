// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reorder_report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReorderReportModel _$ReorderReportModelFromJson(Map<String, dynamic> json) =>
    ReorderReportModel(
      stockId: json['stockId'] as String,
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toInt(),
      minimumStock: (json['minimumStock'] as num).toInt(),
      needsReorder: json['needsReorder'] as bool,
    );

Map<String, dynamic> _$ReorderReportModelToJson(ReorderReportModel instance) =>
    <String, dynamic>{
      'stockId': instance.stockId,
      'name': instance.name,
      'quantity': instance.quantity,
      'minimumStock': instance.minimumStock,
      'needsReorder': instance.needsReorder,
    };
