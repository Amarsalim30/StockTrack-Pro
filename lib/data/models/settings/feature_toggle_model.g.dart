// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feature_toggle_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeatureToggleModel _$FeatureToggleModelFromJson(Map<String, dynamic> json) =>
    FeatureToggleModel(
      featureKey: json['featureKey'] as String,
      enabled: json['enabled'] as bool,
      config: json['config'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$FeatureToggleModelToJson(FeatureToggleModel instance) =>
    <String, dynamic>{
      'featureKey': instance.featureKey,
      'enabled': instance.enabled,
      'config': instance.config,
    };
