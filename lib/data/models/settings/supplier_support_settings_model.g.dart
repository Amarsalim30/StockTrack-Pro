// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier_support_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupplierSupportSettingsModel _$SupplierSupportSettingsModelFromJson(
  Map<String, dynamic> json,
) => SupplierSupportSettingsModel(
  enabled: json['enabled'] as bool,
  supplierRoles: (json['supplierRoles'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  config: json['config'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$SupplierSupportSettingsModelToJson(
  SupplierSupportSettingsModel instance,
) => <String, dynamic>{
  'enabled': instance.enabled,
  'supplierRoles': instance.supplierRoles,
  'config': instance.config,
};
