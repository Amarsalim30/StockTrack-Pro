// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'approval_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApprovalRequestModel _$ApprovalRequestModelFromJson(
  Map<String, dynamic> json,
) => ApprovalRequestModel(
  id: json['id'] as String,
  entityType: json['entityType'] as String,
  entityId: json['entityId'] as String,
  requestedBy: json['requestedBy'] as String,
  approvedBy: json['approvedBy'] as String?,
  requestedAt: DateTime.parse(json['requestedAt'] as String),
  approvedAt: json['approvedAt'] == null
      ? null
      : DateTime.parse(json['approvedAt'] as String),
  status: json['status'] as String,
  reason: json['reason'] as String?,
);

Map<String, dynamic> _$ApprovalRequestModelToJson(
  ApprovalRequestModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'entityType': instance.entityType,
  'entityId': instance.entityId,
  'requestedBy': instance.requestedBy,
  'approvedBy': instance.approvedBy,
  'requestedAt': instance.requestedAt.toIso8601String(),
  'approvedAt': instance.approvedAt?.toIso8601String(),
  'status': instance.status,
  'reason': instance.reason,
};
