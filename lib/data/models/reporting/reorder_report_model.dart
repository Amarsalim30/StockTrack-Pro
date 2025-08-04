import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/reporting/reorder_report.dart';

part 'reorder_report_model.g.dart';

@JsonSerializable()
class ReorderReportModel extends Equatable {
  final String stockId;
  final String name;
  final int quantity;
  final int minimumStock;
  final bool needsReorder;

  const ReorderReportModel({
    required this.stockId,
    required this.name,
    required this.quantity,
    required this.minimumStock,
    required this.needsReorder,
  });

  factory ReorderReportModel.fromJson(Map<String, dynamic> json) =>
      _$ReorderReportModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReorderReportModelToJson(this);

  ReorderReport toDomain() => ReorderReport(
    stockId: stockId,
    name: name,
    quantity: quantity,
    minimumStock: minimumStock,
    needsReorder: needsReorder,
  );

  static ReorderReportModel fromDomain(ReorderReport e) => ReorderReportModel(
    stockId: e.stockId,
    name: e.name,
    quantity: e.quantity,
    minimumStock: e.minimumStock,
    needsReorder: e.needsReorder,
  );

  ReorderReportModel copyWith({
    String? stockId,
    String? name,
    int? quantity,
    int? minimumStock,
    bool? needsReorder,
  }) {
    return ReorderReportModel(
      stockId: stockId ?? this.stockId,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      minimumStock: minimumStock ?? this.minimumStock,
      needsReorder: needsReorder ?? this.needsReorder,
    );
  }

  @override
  List<Object?> get props => [
    stockId,
    name,
    quantity,
    minimumStock,
    needsReorder,
  ];
}
