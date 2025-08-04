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
  final DateTime timestamp;
  final Map<String, dynamic> metadata;

  const ActivityModel({
    required this.id,
    required this.action,
    required this.entityType,
    required this.entityId,
    required this.userId,
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
}
