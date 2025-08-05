// lib/data/models/settings/app_settings_model.dart
import 'package:clean_arch_app/data/models/settings/production_settings_model.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/settings/app_settings.dart';
import 'feature_toggle_model.dart';
import 'reorder_workflow_settings_model.dart';
import 'stock_take_settings_model.dart';
import 'export_import_settings_model.dart';
import 'password_policy_model.dart';
import 'supplier_support_settings_model.dart';

part 'app_settings_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AppSettingsModel extends Equatable {
  final List<FeatureToggleModel> featureToggles;
  final ProductionSettingsModel productionSettings; // <-- new
  // … other settings

  const AppSettingsModel(
    this.expiryDuration, {
    required this.featureToggles,
    required this.productionSettings,
    // TODO: Add the other settings here.
        reorderSettings = ReorderWorkflowSettingsModel.fromDomain(
            d.reorderSettings),
        stockTakeSettings = StockTakeSettingsModel.fromDomain(
            d.stockTakeSettings),
        exportImportSettings = ExportImportSettingsModel.fromDomain(
            d.exportImportSettings),
        passwordPolicy = PasswordPolicyModel.fromDomain(d.passwordPolicy),
        supplierSupport = SupplierSupportSettingsModel.fromDomain(
            d.supplierSupport),
  });

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$AppSettingsModelToJson(this);

  AppSettings toDomain() => AppSettings(
    featureToggles: featureToggles.map((m) => m.toDomain()).toList(),
    productionSettings: productionSettings.toDomain(),
    reorderSettings =
        ReorderWorkflowSettingsModel.fromDomain(e.reorderSettings),
    stockTakeSettings = StockTakeSettingsModel.fromDomain(e.stockTakeSettings),
    exportImportSettings =
        ExportImportSettingsModel.fromDomain(e.exportImportSettings),
    passwordPolicy = PasswordPolicyModel.fromDomain(e.passwordPolicy),
    supplierSupport =
        SupplierSupportSettingsModel.fromDomain(e.supplierSupport),
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
    reorderSettings: reorderSettings ?? this.reorderSettings,
    stockTakeSettings: stockTakeSettings ?? this.stockTakeSettings,
    exportImportSettings: exportImportSettings ?? this.exportImportSettings,
    passwordPolicy: passwordPolicy ?? this.passwordPolicy,
    supplierSupport: supplierSupport ?? this.supplierSupport,
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

  final Duration? expiryDuration;

  static int? _durToJson(Duration? d) => d?.inDays;

  static Duration? _durFromJson(int? days) =>
      days == null ? null : Duration(days: days);
}
