// lib/data/models/settings/app_settings_model.dart
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/settings/app_settings.dart';
import 'feature_toggle_model.dart';
import 'production_settings_model.dart';
import 'reorder_workflow_settings_model.dart';
import 'stock_take_settings_model.dart';
import 'export_import_settings_model.dart';
import 'password_policy_model.dart';
import 'supplier_support_settings_model.dart';

part 'app_settings_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AppSettingsModel extends Equatable {
  final List<FeatureToggleModel> featureToggles;
  final ProductionSettingsModel productionSettings;
  final ReorderWorkflowSettingsModel reorderSettings;
  final StockTakeSettingsModel stockTakeSettings;
  final ExportImportSettingsModel exportImportSettings;
  final PasswordPolicyModel passwordPolicy;
  final SupplierSupportSettingsModel supplierSupport;
  @JsonKey(fromJson: _durFromJson, toJson: _durToJson)
  final Duration? expiryDuration;

  const AppSettingsModel({
    required this.featureToggles,
    required this.productionSettings,
    required this.reorderSettings,
    required this.stockTakeSettings,
    required this.exportImportSettings,
    required this.passwordPolicy,
    required this.supplierSupport,
    this.expiryDuration,
  });

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$AppSettingsModelToJson(this);

  AppSettings toDomain() => AppSettings(
    featureToggles: featureToggles.map((m) => m.toDomain()).toList(),
    productionSettings: productionSettings.toDomain(),
    reorderSettings: reorderSettings.toDomain(),
    stockTakeSettings: stockTakeSettings.toDomain(),
    exportImportSettings: exportImportSettings.toDomain(),
    passwordPolicy: passwordPolicy.toDomain(),
    supplierSupport: supplierSupport.toDomain(),
    expiryDuration: expiryDuration,
  );

  static AppSettingsModel fromDomain(AppSettings d) => AppSettingsModel(
      featureToggles: d.featureToggles
          .map(FeatureToggleModel.fromDomain)
          .toList(),
      productionSettings: ProductionSettingsModel.fromDomain(
          d.productionSettings),
      reorderSettings: ReorderWorkflowSettingsModel.fromDomain(
          d.reorderSettings),
      stockTakeSettings: StockTakeSettingsModel.fromDomain(d.stockTakeSettings),
      exportImportSettings: ExportImportSettingsModel.fromDomain(
          d.exportImportSettings),
      passwordPolicy: PasswordPolicyModel.fromDomain(d.passwordPolicy),
      supplierSupport: SupplierSupportSettingsModel.fromDomain(
          d.supplierSupport),
      expiryDuration: d.expiryDuration
  );

  AppSettingsModel copyWith({
    List<FeatureToggleModel>? featureToggles,
    ProductionSettingsModel? productionSettings,
    ReorderWorkflowSettingsModel? reorderSettings,
    StockTakeSettingsModel? stockTakeSettings,
    ExportImportSettingsModel? exportImportSettings,
    PasswordPolicyModel? passwordPolicy,
    SupplierSupportSettingsModel? supplierSupport,
    Duration? expiryDuration,
  }) => AppSettingsModel(
    featureToggles: featureToggles ?? this.featureToggles,
    productionSettings: productionSettings ?? this.productionSettings,
    reorderSettings: reorderSettings ?? this.reorderSettings,
    stockTakeSettings: stockTakeSettings ?? this.stockTakeSettings,
    exportImportSettings: exportImportSettings ?? this.exportImportSettings,
    passwordPolicy: passwordPolicy ?? this.passwordPolicy,
    supplierSupport: supplierSupport ?? this.supplierSupport,
    expiryDuration: expiryDuration ?? this.expiryDuration,
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
    expiryDuration,
  ];

  static int? _durToJson(Duration? d) => d?.inDays;

  static Duration? _durFromJson(int? days) =>
      days == null ? null : Duration(days: days);
}
