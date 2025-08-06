import 'package:clean_arch_app/data/mappers/settings/feature_toggle_mapper.dart';
import 'package:clean_arch_app/data/models/settings/app_settings_model.dart';
import 'package:clean_arch_app/domain/entities/settings/app_settings.dart';
import 'production_settings_mapper.dart';
import 'reorder_workflow_settings_mapper.dart';
import 'stock_take_settings_mapper.dart';
import 'export_import_settings_mapper.dart';
import 'password_policy_mapper.dart';
import 'supplier_support_settings_mapper.dart';

class AppSettingsMapper {
  static AppSettings toEntity(AppSettingsModel model) {
    return AppSettings(
      featureToggles: model.featureToggles
          .map(FeatureToggleMapper.toEntity)
          .toList(),
      productionSettings: ProductionSettingsMapper.toEntity(
          model.productionSettings),
      reorderSettings: ReorderWorkflowSettingsMapper.toEntity(
          model.reorderSettings),
      stockTakeSettings: StockTakeSettingsMapper.toEntity(
          model.stockTakeSettings),
      exportImportSettings: ExportImportSettingsMapper.toEntity(
          model.exportImportSettings),
      passwordPolicy: PasswordPolicyMapper.toEntity(model.passwordPolicy),
      supplierSupport: SupplierSupportSettingsMapper.toEntity(
          model.supplierSupport),
      expiryDuration: model.expiryDuration,
    );
  }

  static AppSettingsModel fromEntity(AppSettings entity) {
    return AppSettingsModel(
      featureToggles: entity.featureToggles
          .map(FeatureToggleMapper.fromEntity)
          .toList(),
      productionSettings: ProductionSettingsMapper.fromEntity(
          entity.productionSettings),
      reorderSettings: ReorderWorkflowSettingsMapper.fromEntity(
          entity.reorderSettings),
      stockTakeSettings: StockTakeSettingsMapper.fromEntity(
          entity.stockTakeSettings),
      exportImportSettings: ExportImportSettingsMapper.fromEntity(
          entity.exportImportSettings),
      passwordPolicy: PasswordPolicyMapper.fromEntity(entity.passwordPolicy),
      supplierSupport: SupplierSupportSettingsMapper.fromEntity(
          entity.supplierSupport),
      expiryDuration: entity.expiryDuration,
    );
  }
}
