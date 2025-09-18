// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_upload_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhotoUploadResponseModel _$PhotoUploadResponseModelFromJson(
  Map<String, dynamic> json,
) => PhotoUploadResponseModel(
  photoId: json['photoId'] as String,
  url: json['url'] as String,
  message: json['message'] as String,
  success: json['success'] as bool,
);

Map<String, dynamic> _$PhotoUploadResponseModelToJson(
  PhotoUploadResponseModel instance,
) => <String, dynamic>{
  'photoId': instance.photoId,
  'url': instance.url,
  'message': instance.message,
  'success': instance.success,
};
