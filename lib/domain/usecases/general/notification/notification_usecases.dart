// domain/usecases/notification/notification_usecases.dart
import 'package:stocktrack_pro/domain/repositories/notification_repository.dart';
import 'package:stocktrack_pro/domain/usecases/general/notification/mark_all_as_read.dart';

import 'get_notifications.dart';
import 'mark_as_read.dart';
import 'delete_notification.dart';
// import other usecases as needed

class NotificationUseCases {
  final GetNotifications getNotifications;
  final MarkAsRead markAsRead;
  final DeleteNotification deleteNotification;
  final MarkAllAsRead markAllAsRead;

  NotificationUseCases({
    required this.getNotifications,
    required this.markAsRead,
    required this.markAllAsRead,
    required this.deleteNotification,
  });

  /// convenience factory to create usecases given a repo
  factory NotificationUseCases.fromRepository(NotificationRepository repo) {
    return NotificationUseCases(
      getNotifications: GetNotifications(repo),
      markAsRead: MarkAsRead(repo),
      markAllAsRead: MarkAllAsRead(repo),
      deleteNotification: DeleteNotification(repo),
    );
  }
}
