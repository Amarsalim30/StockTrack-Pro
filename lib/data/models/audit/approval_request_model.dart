// lib/data/models/audit/approval_request_model.dart

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/audit/approval_request.dart';

part 'approval_request_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ApprovalRequestModel extends Equatable {
  final String id;
  final String entityType; // e.g. 'Stock', 'Order'
  final String entityId;
  final String requestedBy;
  final String? approvedBy;
  final DateTime requestedAt;
  final DateTime? approvedAt;
  final String status; // 'pending', 'approved', 'rejected'
  final String? reason;

  const ApprovalRequestModel({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.requestedBy,
    this.approvedBy,
    required this.requestedAt,
    this.approvedAt,
    required this.status,
    this.reason,
  });

  factory ApprovalRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ApprovalRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApprovalRequestModelToJson(this);

  ApprovalRequest toEntity() => ApprovalRequest(
    id: id,
    entityType: entityType,
    entityId: entityId,
    requestedBy: requestedBy,
    approvedBy: approvedBy,
    requestedAt: requestedAt,
    approvedAt: approvedAt,
    status: status,
    reason: reason,
  );

  factory ApprovalRequestModel.fromEntity(ApprovalRequest ent) =>
      ApprovalRequestModel(
        id: ent.id,
        entityType: ent.entityType,
        entityId: ent.entityId,
        requestedBy: ent.requestedBy,
        approvedBy: ent.approvedBy,
        requestedAt: ent.requestedAt,
        approvedAt: ent.approvedAt,
        status: ent.status,
        reason: ent.reason,
      );

  @override
  List<Object?> get props => [
    id,
    entityType,
    entityId,
    requestedBy,
    approvedBy,
    requestedAt,
    approvedAt,
    status,
    reason,
  ];

  ApprovalRequestModel copyWith({
    String? id,
    String? entityType,
    String? entityId,
    String? requestedBy,
    String? approvedBy,
    DateTime? requestedAt,
    DateTime? approvedAt,
    String? status,
    String? reason,
  }) {
    return ApprovalRequestModel(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      requestedBy: requestedBy ?? this.requestedBy,
      approvedBy: approvedBy ?? this.approvedBy,
      requestedAt: requestedAt ?? this.requestedAt,
      approvedAt: approvedAt ?? this.approvedAt,
      status: status ?? this.status,
      reason: reason ?? this.reason,
    );
  }
}
