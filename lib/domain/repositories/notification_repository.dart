// domain/repositories/notification_repository.dart
import 'package:clean_arch_app/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import '../entities/general/notification.dart'; // adapt path if needed

abstract class NotificationRepository {
  /// Fetch all notifications (or initial page). Implement pagination if needed.
  Future<Either<Failure, List<Notification>>> getNotifications();

  /// Mark a single notification read on server
  Future<Either<Failure, Unit>> markAsRead(String id);

  /// Mark all notifications as read
  Future<Either<Failure, Unit>> markAllAsRead();

  /// Delete notification by id
  Future<Either<Failure, Unit>> deleteNotification(String id);

//   /// Optional: delete multiple notifications
//   Future<Either<Failure, Unit>> deleteMultipleNotifications(List<String> ids) async =>
//       Future.value(left(Failure(message: 'Not implemented')));
//
//   /// Optional: create/store a notification (e.g., local)
//   Future<Either<Failure, Notification>> createNotification(Notification notification) async =>
//       Future.value(left(Failure(message: 'Not implemented')));
}
