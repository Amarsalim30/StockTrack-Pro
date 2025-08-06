// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportModel<T> _$ReportModelFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => ReportModel<T>(
  reportId: json['reportId'] as String,
  type: json['type'] as String,
  generatedAt: DateTime.parse(json['generatedAt'] as String),
  items: (json['items'] as List<dynamic>).map(fromJsonT).toList(),
);

Map<String, dynamic> _$ReportModelToJson<T>(
  ReportModel<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'reportId': instance.reportId,
  'type': instance.type,
  'generatedAt': instance.generatedAt.toIso8601String(),
  'items': instance.items.map(toJsonT).toList(),
};
