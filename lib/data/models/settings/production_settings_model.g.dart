// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'production_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductionSettingsModel _$ProductionSettingsModelFromJson(
  Map<String, dynamic> json,
) => ProductionSettingsModel(
  allowReservation: json['allowReservation'] as bool? ?? true,
  autoConsumeOnComplete: json['autoConsumeOnComplete'] as bool? ?? false,
  defaultYieldPerRun: (json['defaultYieldPerRun'] as num?)?.toInt() ?? 1,
);

Map<String, dynamic> _$ProductionSettingsModelToJson(
  ProductionSettingsModel instance,
) => <String, dynamic>{
  'allowReservation': instance.allowReservation,
  'autoConsumeOnComplete': instance.autoConsumeOnComplete,
  'defaultYieldPerRun': instance.defaultYieldPerRun,
};
