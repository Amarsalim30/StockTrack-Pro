// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_take_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockTakeSettingsModel _$StockTakeSettingsModelFromJson(
  Map<String, dynamic> json,
) => StockTakeSettingsModel(
  gpsEnforced: json['gpsEnforced'] as bool,
  maxDistanceMeters: (json['maxDistanceMeters'] as num?)?.toDouble(),
  allowedLocations: (json['allowedLocations'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$StockTakeSettingsModelToJson(
  StockTakeSettingsModel instance,
) => <String, dynamic>{
  'gpsEnforced': instance.gpsEnforced,
  'maxDistanceMeters': instance.maxDistanceMeters,
  'allowedLocations': instance.allowedLocations,
};
