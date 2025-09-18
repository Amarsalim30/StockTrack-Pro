import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'photo_upload_response_model.g.dart';

@JsonSerializable()
class PhotoUploadResponseModel extends Equatable {
  final String photoId;
  final String url;
  final String message;
  final bool success;

  const PhotoUploadResponseModel({
    required this.photoId,
    required this.url,
    required this.message,
    required this.success,
  });

  factory PhotoUploadResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PhotoUploadResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$PhotoUploadResponseModelToJson(this);

  @override
  List<Object?> get props => [photoId, url, message, success];
}