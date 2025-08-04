// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reorder_workflow_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReorderWorkflowSettingsModel _$ReorderWorkflowSettingsModelFromJson(
  Map<String, dynamic> json,
) => ReorderWorkflowSettingsModel(
  autoReorderEnabled: json['autoReorderEnabled'] as bool,
  reorderPointMultiplier: (json['reorderPointMultiplier'] as num).toInt(),
  maxPendingOrders: (json['maxPendingOrders'] as num).toInt(),
);

Map<String, dynamic> _$ReorderWorkflowSettingsModelToJson(
  ReorderWorkflowSettingsModel instance,
) => <String, dynamic>{
  'autoReorderEnabled': instance.autoReorderEnabled,
  'reorderPointMultiplier': instance.reorderPointMultiplier,
  'maxPendingOrders': instance.maxPendingOrders,
};
