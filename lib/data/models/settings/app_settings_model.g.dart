// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppSettingsModel _$AppSettingsModelFromJson(Map<String, dynamic> json) =>
    AppSettingsModel(
      featureToggles: (json['featureToggles'] as List<dynamic>)
          .map((e) => FeatureToggleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      productionSettings: ProductionSettingsModel.fromJson(
        json['productionSettings'] as Map<String, dynamic>,
      ),
      reorderSettings: ReorderWorkflowSettingsModel.fromJson(
        json['reorderSettings'] as Map<String, dynamic>,
      ),
      stockTakeSettings: StockTakeSettingsModel.fromJson(
        json['stockTakeSettings'] as Map<String, dynamic>,
      ),
      exportImportSettings: ExportImportSettingsModel.fromJson(
        json['exportImportSettings'] as Map<String, dynamic>,
      ),
      passwordPolicy: PasswordPolicyModel.fromJson(
        json['passwordPolicy'] as Map<String, dynamic>,
      ),
      supplierSupport: SupplierSupportSettingsModel.fromJson(
        json['supplierSupport'] as Map<String, dynamic>,
      ),
      expiryDuration: AppSettingsModel._durFromJson(
        (json['expiryDuration'] as num?)?.toInt(),
      ),
    );

Map<String, dynamic> _$AppSettingsModelToJson(AppSettingsModel instance) =>
    <String, dynamic>{
      'featureToggles': instance.featureToggles.map((e) => e.toJson()).toList(),
      'productionSettings': instance.productionSettings.toJson(),
      'reorderSettings': instance.reorderSettings.toJson(),
      'stockTakeSettings': instance.stockTakeSettings.toJson(),
      'exportImportSettings': instance.exportImportSettings.toJson(),
      'passwordPolicy': instance.passwordPolicy.toJson(),
      'supplierSupport': instance.supplierSupport.toJson(),
      'expiryDuration': AppSettingsModel._durToJson(instance.expiryDuration),
    };
