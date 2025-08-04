// lib/data/models/audit/audit_log_model.dart

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/audit/audit_log.dart';

part 'audit_log_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AuditLogModel extends Equatable {
  final String id;
  final String action; // description of change
  final String performedBy;
  final DateTime performedAt;
  final Map<String, dynamic>? details;

  const AuditLogModel({
    required this.id,
    required this.action,
    required this.performedBy,
    required this.performedAt,
    this.details,
  });

  factory AuditLogModel.fromJson(Map<String, dynamic> json) =>
      _$AuditLogModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuditLogModelToJson(this);

  AuditLog toEntity() => AuditLog(
    id: id,
    action: action,
    performedBy: performedBy,
    performedAt: performedAt,
    details: details,
  );

  factory AuditLogModel.fromEntity(AuditLog ent) => AuditLogModel(
    id: ent.id,
    action: ent.action,
    performedBy: ent.performedBy,
    performedAt: ent.performedAt,
    details: ent.details,
  );

  @override
  List<Object?> get props => [id, action, performedBy, performedAt, details];

  AuditLogModel copyWith({
    String? id,
    String? action,
    String? performedBy,
    DateTime? performedAt,
    Map<String, dynamic>? details,
  }) {
    return AuditLogModel(
      id: id ?? this.id,
      action: action ?? this.action,
      performedBy: performedBy ?? this.performedBy,
      performedAt: performedAt ?? this.performedAt,
      details: details ?? this.details,
    );
  }
}
