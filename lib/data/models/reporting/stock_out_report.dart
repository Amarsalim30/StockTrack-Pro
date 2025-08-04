import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/reporting/stock_out_report.dart';

part 'stock_out_report_model.g.dart';

@JsonSerializable()
class StockOutReportModel extends Equatable {
  final String stockId;
  final String name;
  final int quantityOut;
  final DateTime dateOut;
  final String performedBy;
  final String? reason;

  const StockOutReportModel({
    required this.stockId,
    required this.name,
    required this.quantityOut,
    required this.dateOut,
    required this.performedBy,
    this.reason,
  });

  factory StockOutReportModel.fromJson(Map<String, dynamic> json) =>
      _$StockOutReportModelFromJson(json);

  Map<String, dynamic> toJson() => _$StockOutReportModelToJson(this);

  StockOutReport toDomain() => StockOutReport(
    stockId: stockId,
    name: name,
    quantityOut: quantityOut,
    dateOut: dateOut,
    performedBy: performedBy,
    reason: reason,
  );

  static StockOutReportModel fromDomain(StockOutReport e) =>
      StockOutReportModel(
        stockId: e.stockId,
        name: e.name,
        quantityOut: e.quantityOut,
        dateOut: e.dateOut,
        performedBy: e.performedBy,
        reason: e.reason,
      );

  StockOutReportModel copyWith({
    String? stockId,
    String? name,
    int? quantityOut,
    DateTime? dateOut,
    String? performedBy,
    String? reason,
  }) {
    return StockOutReportModel(
      stockId: stockId ?? this.stockId,
      name: name ?? this.name,
      quantityOut: quantityOut ?? this.quantityOut,
      dateOut: dateOut ?? this.dateOut,
      performedBy: performedBy ?? this.performedBy,
      reason: reason ?? this.reason,
    );
  }

  @override
  List<Object?> get props => [
    stockId,
    name,
    quantityOut,
    dateOut,
    performedBy,
    reason,
  ];
}
