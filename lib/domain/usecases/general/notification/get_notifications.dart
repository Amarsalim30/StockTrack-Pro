// domain/usecases/notification/get_notifications.dart
import 'package:clean_arch_app/core/error/failures.dart';
import 'package:clean_arch_app/domain/entities/general/notification.dart';
import 'package:clean_arch_app/domain/repositories/notification_repository.dart';
import 'package:dartz/dartz.dart';


class GetNotifications {
  final NotificationRepository repository;
  GetNotifications(this.repository);

  Future<Either<Failure, List<Notification>>> call() {
    return repository.getNotifications();
  }
}
