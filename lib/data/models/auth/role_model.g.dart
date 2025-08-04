// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoleModel _$RoleModelFromJson(Map<String, dynamic> json) => RoleModel(
  id: json['id'] as String,
  name: json['name'] as String,
  permissions: (json['permissions'] as List<dynamic>)
      .map((e) => $enumDecode(_$PermissionTypeModelEnumMap, e))
      .toList(),
);

Map<String, dynamic> _$RoleModelToJson(RoleModel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'permissions': instance.permissions
      .map((e) => _$PermissionTypeModelEnumMap[e]!)
      .toList(),
};

const _$PermissionTypeModelEnumMap = {
  PermissionTypeModel.createOrder: 'createOrder',
  PermissionTypeModel.approveOrder: 'approveOrder',
  PermissionTypeModel.receiveStock: 'receiveStock',
  PermissionTypeModel.adjustStock: 'adjustStock',
  PermissionTypeModel.viewReports: 'viewReports',
  PermissionTypeModel.processReturns: 'processReturns',
};
