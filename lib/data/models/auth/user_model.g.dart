// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: json['id'] as String,
  username: json['username'] as String,
  email: json['email'] as String,
  roles: (json['roles'] as List<dynamic>)
      .map((e) => RoleModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  isActive: json['isActive'] as bool? ?? true,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'email': instance.email,
  'roles': instance.roles.map((e) => e.toJson()).toList(),
  'isActive': instance.isActive,
};
