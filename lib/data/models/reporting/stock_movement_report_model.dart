import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/reporting/stock_movement_report.dart';

part 'stock_movement_report_model.g.dart';

@JsonSerializable()
class StockMovementReportModel extends Equatable {
  final String movementId;
  final String stockId;
  final String type; // 'in', 'out', 'transfer', 'adjustment'
  final int quantity;
  final String performedBy;
  final DateTime timestamp;
  final String? reason;

  const StockMovementReportModel({
    required this.movementId,
    required this.stockId,
    required this.type,
    required this.quantity,
    required this.performedBy,
    required this.timestamp,
    this.reason,
  });

  factory StockMovementReportModel.fromJson(Map<String, dynamic> json) =>
      _$StockMovementReportModelFromJson(json);

  Map<String, dynamic> toJson() => _$StockMovementReportModelToJson(this);

  StockMovementReport toDomain() => StockMovementReport(
    movementId: movementId,
    stockId: stockId,
    type: type,
    quantity: quantity,
    performedBy: performedBy,
    timestamp: timestamp,
    reason: reason,
  );

  static StockMovementReportModel fromDomain(StockMovementReport e) =>
      StockMovementReportModel(
        movementId: e.movementId,
        stockId: e.stockId,
        type: e.type,
        quantity: e.quantity,
        performedBy: e.performedBy,
        timestamp: e.timestamp,
        reason: e.reason,
      );

  StockMovementReportModel copyWith({
    String? movementId,
    String? stockId,
    String? type,
    int? quantity,
    String? performedBy,
    DateTime? timestamp,
    String? reason,
  }) {
    return StockMovementReportModel(
      movementId: movementId ?? this.movementId,
      stockId: stockId ?? this.stockId,
      type: type ?? this.type,
      quantity: quantity ?? this.quantity,
      performedBy: performedBy ?? this.performedBy,
      timestamp: timestamp ?? this.timestamp,
      reason: reason ?? this.reason,
    );
  }

  @override
  List<Object?> get props => [
    movementId,
    stockId,
    type,
    quantity,
    performedBy,
    timestamp,
    reason,
  ];
}
