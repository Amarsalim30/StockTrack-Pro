// data/remote/notifications_api.dart
import 'package:clean_arch_app/data/models/general/notification_model.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'notification_api.g.dart';

@RestApi()
abstract class NotificationApi {
  factory NotificationApi(Dio dio, {String baseUrl}) = _NotificationApi;

  @GET('/notifications')
  Future<List<NotificationModel>> getNotifications();

  // If your API wraps items in { items: [...], meta: {...} } adapt the return type accordingly.

  @POST('/notifications/{id}/mark-read')
  Future<void> markAsRead(@Path('id') String id);

  @POST('/notifications/mark-all-read')
  Future<void> markAllAsRead();

  @DELETE('/notifications/{id}')
  Future<void> deleteNotification(@Path('id') String id);

  @POST('/notifications/delete-batch')
  Future<void> deleteMultipleNotifications(@Body() Map<String, dynamic> body);
  // body example: { "ids": ["id1","id2"] }

  @POST('/notifications')
  Future<NotificationModel> createNotification(@Body() NotificationModel model);
}
