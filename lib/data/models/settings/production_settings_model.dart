// lib/data/models/settings/production_settings_model.dart
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/settings/production_settings.dart';

part 'production_settings_model.g.dart';

@JsonSerializable()
class ProductionSettingsModel extends Equatable {
  final bool allowReservation;
  final bool autoConsumeOnComplete;
  final int defaultYieldPerRun;

  const ProductionSettingsModel({
    this.allowReservation = true,
    this.autoConsumeOnComplete = false,
    this.defaultYieldPerRun = 1,
  });

  factory ProductionSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$ProductionSettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductionSettingsModelToJson(this);

  ProductionSettings toDomain() => ProductionSettings(
    allowReservation: allowReservation,
    autoConsumeOnComplete: autoConsumeOnComplete,
    defaultYieldPerRun: defaultYieldPerRun,
  );

  static ProductionSettingsModel fromDomain(ProductionSettings e) =>
      ProductionSettingsModel(
        allowReservation: e.allowReservation,
        autoConsumeOnComplete: e.autoConsumeOnComplete,
        defaultYieldPerRun: e.defaultYieldPerRun,
      );

  ProductionSettingsModel copyWith({
    bool? allowReservation,
    bool? autoConsumeOnComplete,
    int? defaultYieldPerRun,
  }) {
    return ProductionSettingsModel(
      allowReservation: allowReservation ?? this.allowReservation,
      autoConsumeOnComplete:
          autoConsumeOnComplete ?? this.autoConsumeOnComplete,
      defaultYieldPerRun: defaultYieldPerRun ?? this.defaultYieldPerRun,
    );
  }

  @override
  List<Object?> get props => [
    allowReservation,
    autoConsumeOnComplete,
    defaultYieldPerRun,
  ];
}
