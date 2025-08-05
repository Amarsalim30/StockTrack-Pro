// lib/data/models/activity/activity_model.dart

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/activity/activity.dart';

part 'activity_model.g.dart';

/// Data-layer model for Activity, maps to domain Activity entity
@JsonSerializable(explicitToJson: true)
class ActivityModel extends Equatable {
  final String id;
  final String action;
  final String entityType; // e.g., 'Stock', 'Order', 'User'
  final String entityId;
  final String userId;
  final String? userName;
  final ActivityType? type;
  final String? description;
  final DateTime timestamp;
  final Map<String, dynamic> metadata;

  const ActivityModel({
    required this.id,
    required this.action,
    required this.entityType,
    required this.entityId,
    required this.userId,
    this.userName,
    this.type,
    this.description,
    required this.timestamp,
    required this.metadata,
  });

  /// Convert JSON to ActivityModel
  factory ActivityModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityModelFromJson(json);

  /// Convert ActivityModel to JSON
  Map<String, dynamic> toJson() => _$ActivityModelToJson(this);

  /// Map to domain entity
  Activity toEntity() {
    return Activity(
      id: id,
      action: action,
      entityType: entityType,
      entityId: entityId,
      userId: userId,
      userName: userName,
      type: type,
      description: description,
      timestamp: timestamp,
      metadata: metadata,
    );
  }

  /// Create from domain entity
  factory ActivityModel.fromEntity(Activity entity) {
    return ActivityModel(
      id: entity.id,
      action: entity.action,
      entityType: entity.entityType,
      entityId: entity.entityId,
      userId: entity.userId,
      userName: entity.userName,
      type: entity.type,
      description: entity.description,
      timestamp: entity.timestamp,
      metadata: entity.metadata,
    );
  }

  @override
  List<Object?> get props => [
    id,
    action,
    entityType,
    entityId,
    userId,
    timestamp,
    metadata,
  ];

  /// CopyWith for immutable updates
  ActivityModel copyWith({
    String? id,
    String? action,
    String? entityType,
    String? entityId,
    String? userId,
    DateTime? timestamp,
    Map<String, dynamic>? metadata,
  }) {
    return ActivityModel(
      id: id ?? this.id,
      action: action ?? this.action,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      userId: userId ?? this.userId,
      timestamp: timestamp ?? this.timestamp,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Convert ActivityType to string
  static String activityTypeToString(ActivityType type) {
    switch (type) {
      case ActivityType.stockIn:
        return 'stock_in';
      case ActivityType.stockOut:
        return 'stock_out';
      case ActivityType.adjustment:
        return 'adjustment';
      case ActivityType.transfer:
        return 'transfer';
      case ActivityType.return_:
        return 'return';
      case ActivityType.created:
        return 'created';
      case ActivityType.updated:
        return 'updated';
      case ActivityType.deleted:
        return 'deleted';
      case ActivityType.approved:
        return 'approved';
      case ActivityType.rejected:
        return 'rejected';
    }
  }

  /// Convert string to ActivityType
  static ActivityType activityTypeFromString(String type) {
    switch (type) {
      case 'stock_in':
        return ActivityType.stockIn;
      case 'stock_out':
        return ActivityType.stockOut;
      case 'adjustment':
        return ActivityType.adjustment;
      case 'transfer':
        return ActivityType.transfer;
      case 'return':
        return ActivityType.return_;
      case 'created':
        return ActivityType.created;
      case 'updated':
        return ActivityType.updated;
      case 'deleted':
        return ActivityType.deleted;
      case 'approved':
        return ActivityType.approved;
      case 'rejected':
        return ActivityType.rejected;
      default:
        return ActivityType.created;
    }
  }
}
