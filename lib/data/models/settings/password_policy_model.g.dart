// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password_policy_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PasswordPolicyModel _$PasswordPolicyModelFromJson(Map<String, dynamic> json) =>
    PasswordPolicyModel(
      minLength: (json['minLength'] as num).toInt(),
      requireUppercase: json['requireUppercase'] as bool,
      requireNumbers: json['requireNumbers'] as bool,
      requireSpecialChars: json['requireSpecialChars'] as bool,
      expiryDuration: json['expiryDuration'] == null
          ? null
          : Duration(microseconds: (json['expiryDuration'] as num).toInt()),
    );

Map<String, dynamic> _$PasswordPolicyModelToJson(
  PasswordPolicyModel instance,
) => <String, dynamic>{
  'minLength': instance.minLength,
  'requireUppercase': instance.requireUppercase,
  'requireNumbers': instance.requireNumbers,
  'requireSpecialChars': instance.requireSpecialChars,
  'expiryDuration': instance.expiryDuration?.inMicroseconds,
};
