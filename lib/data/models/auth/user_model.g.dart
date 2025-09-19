// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: json['id'] as String,
  username: json['username'] as String,
  email: json['email'] as String,
  roles: (json['roles'] as List<dynamic>?)
      ?.map((e) => RoleModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  isActive: json['isActive'] as bool? ?? true,
  isEmailVerified: json['isEmailVerified'] as bool?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  lastLoginAt: json['lastLoginAt'] == null
      ? null
      : DateTime.parse(json['lastLoginAt'] as String),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'email': instance.email,
  'roles': instance.roles?.map((e) => e.toJson()).toList(),
  'isActive': instance.isActive,
  'isEmailVerified': instance.isEmailVerified,
  'createdAt': instance.createdAt?.toIso8601String(),
  'lastLoginAt': instance.lastLoginAt?.toIso8601String(),
};
