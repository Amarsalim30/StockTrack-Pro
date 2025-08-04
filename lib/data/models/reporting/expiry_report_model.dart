import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/reporting/expiry_report.dart';

part 'expiry_report_model.g.dart';

@JsonSerializable()
class ExpiryReportModel extends Equatable {
  final String stockId;
  final String name;
  final DateTime expiryDate;
  final int daysToExpiry;
  final int quantity;

  const ExpiryReportModel({
    required this.stockId,
    required this.name,
    required this.expiryDate,
    required this.daysToExpiry,
    required this.quantity,
  });

  factory ExpiryReportModel.fromJson(Map<String, dynamic> json) =>
      _$ExpiryReportModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExpiryReportModelToJson(this);

  ExpiryReport toDomain() => ExpiryReport(
    stockId: stockId,
    name: name,
    expiryDate: expiryDate,
    daysToExpiry: daysToExpiry,
    quantity: quantity,
  );

  static ExpiryReportModel fromDomain(ExpiryReport e) => ExpiryReportModel(
    stockId: e.stockId,
    name: e.name,
    expiryDate: e.expiryDate,
    daysToExpiry: e.daysToExpiry,
    quantity: e.quantity,
  );

  ExpiryReportModel copyWith({
    String? stockId,
    String? name,
    DateTime? expiryDate,
    int? daysToExpiry,
    int? quantity,
  }) {
    return ExpiryReportModel(
      stockId: stockId ?? this.stockId,
      name: name ?? this.name,
      expiryDate: expiryDate ?? this.expiryDate,
      daysToExpiry: daysToExpiry ?? this.daysToExpiry,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [
    stockId,
    name,
    expiryDate,
    daysToExpiry,
    quantity,
  ];
}
