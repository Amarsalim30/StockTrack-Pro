// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'export_import_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExportImportSettingsModel _$ExportImportSettingsModelFromJson(
  Map<String, dynamic> json,
) => ExportImportSettingsModel(
  exportEnabled: json['exportEnabled'] as bool,
  importEnabled: json['importEnabled'] as bool,
  importValidationRules: json['importValidationRules'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$ExportImportSettingsModelToJson(
  ExportImportSettingsModel instance,
) => <String, dynamic>{
  'exportEnabled': instance.exportEnabled,
  'importEnabled': instance.importEnabled,
  'importValidationRules': instance.importValidationRules,
};
