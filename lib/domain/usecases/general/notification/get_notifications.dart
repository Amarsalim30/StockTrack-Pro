// domain/usecases/notification/get_notifications.dart
import 'package:stocktrack_pro/core/error/failures.dart';
import 'package:stocktrack_pro/domain/entities/general/notification.dart';
import 'package:stocktrack_pro/domain/repositories/notification_repository.dart';
import 'package:dartz/dartz.dart';


class GetNotifications {
  final NotificationRepository repository;
  GetNotifications(this.repository);

  Future<Either<Failure, List<Notification>>> call() {
    return repository.getNotifications();
  }
}
