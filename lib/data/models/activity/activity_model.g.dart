// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityModel _$ActivityModelFromJson(Map<String, dynamic> json) =>
    ActivityModel(
      id: json['id'] as String,
      action: json['action'] as String,
      entityType: json['entityType'] as String,
      entityId: json['entityId'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String?,
      type: $enumDecodeNullable(_$ActivityTypeEnumMap, json['type']),
      description: json['description'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      metadata: json['metadata'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$ActivityModelToJson(ActivityModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'action': instance.action,
      'entityType': instance.entityType,
      'entityId': instance.entityId,
      'userId': instance.userId,
      'userName': instance.userName,
      'type': _$ActivityTypeEnumMap[instance.type],
      'description': instance.description,
      'timestamp': instance.timestamp.toIso8601String(),
      'metadata': instance.metadata,
    };

const _$ActivityTypeEnumMap = {
  ActivityType.stockIn: 'stockIn',
  ActivityType.stockOut: 'stockOut',
  ActivityType.adjustment: 'adjustment',
  ActivityType.transfer: 'transfer',
  ActivityType.return_: 'return_',
  ActivityType.created: 'created',
  ActivityType.updated: 'updated',
  ActivityType.deleted: 'deleted',
  ActivityType.approved: 'approved',
  ActivityType.rejected: 'rejected',
};
