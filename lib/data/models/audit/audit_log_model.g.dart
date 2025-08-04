// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditLogModel _$AuditLogModelFromJson(Map<String, dynamic> json) =>
    AuditLogModel(
      id: json['id'] as String,
      action: json['action'] as String,
      performedBy: json['performedBy'] as String,
      performedAt: DateTime.parse(json['performedAt'] as String),
      details: json['details'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$AuditLogModelToJson(AuditLogModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'action': instance.action,
      'performedBy': instance.performedBy,
      'performedAt': instance.performedAt.toIso8601String(),
      'details': instance.details,
    };
