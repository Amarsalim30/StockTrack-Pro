import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'report_model.g.dart';

/// A generic wrapper for different report payloads.
@JsonSerializable(genericArgumentFactories: true)
class ReportModel<T> extends Equatable {
  final String reportId;
  final String type; // e.g. 'expiry', 'reorder', 'movement', 'out'
  final DateTime generatedAt;
  final List<T> items;

  const ReportModel({
    required this.reportId,
    required this.type,
    required this.generatedAt,
    required this.items,
  });

  factory ReportModel.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$ReportModelFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$ReportModelToJson(this, toJsonT);

  @override
  List<Object?> get props => [reportId, type, generatedAt, items];
}
