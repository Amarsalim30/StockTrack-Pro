// lib/data/models/settings/app_settings_model.dart
import 'package:clean_arch_app/data/models/settings/production_settings_model.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/settings/app_settings.dart';
import 'feature_toggle_model.dart';

@JsonSerializable(explicitToJson: true)
class AppSettingsModel extends Equatable {
  final List<FeatureToggleModel> featureToggles;
  final ProductionSettingsModel productionSettings; // <-- new
  // … other settings

  const AppSettingsModel(
    this.expiryDuration, {
    required this.featureToggles,
    required this.productionSettings,
    // …
  });

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$AppSettingsModelToJson(this);

  AppSettings toDomain() => AppSettings(
    featureToggles: featureToggles.map((m) => m.toDomain()).toList(),
    productionSettings: productionSettings.toDomain(),
    // … map the rest
  );

  static AppSettingsModel fromDomain(AppSettings d) => AppSettingsModel(
    featureToggles: d.featureToggles
        .map(FeatureToggleModel.fromDomain)
        .toList(),
    productionSettings: ProductionSettingsModel.fromDomain(
      d.productionSettings,
    ),
    // … map the rest
  );

  AppSettingsModel copyWith({
    List<FeatureToggleModel>? featureToggles,
    ProductionSettingsModel? productionSettings,
    // … other settings
  }) => AppSettingsModel(
    featureToggles: featureToggles ?? this.featureToggles,
    productionSettings: productionSettings ?? this.productionSettings,
    // … the rest
  );

  @override
  List<Object?> get props => [
    featureToggles,
    productionSettings,
    reorderSettings,
    stockTakeSettings,
    exportImportSettings,
    passwordPolicy,
    supplierSupport,
  ];

  int _durToJson(Duration? d) => d?.inDays;

  Duration? _durFromJson(int? days) =>
      days == null ? null : Duration(days: days);

  @JsonKey(fromJson: _durFromJson, toJson: _durToJson)
  final Duration? expiryDuration;
}
