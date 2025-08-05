// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppSettingsModel _$AppSettingsModelFromJson(Map<String, dynamic> json) =>
    AppSettingsModel(
      json['expiryDuration'] == null
          ? null
          : Duration(microseconds: (json['expiryDuration'] as num).toInt()),
      featureToggles: (json['featureToggles'] as List<dynamic>)
          .map((e) => FeatureToggleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      productionSettings: ProductionSettingsModel.fromJson(
        json['productionSettings'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$AppSettingsModelToJson(AppSettingsModel instance) =>
    <String, dynamic>{
      'featureToggles': instance.featureToggles.map((e) => e.toJson()).toList(),
      'productionSettings': instance.productionSettings.toJson(),
      'expiryDuration': instance.expiryDuration?.inMicroseconds,
    };
