// domain/usecases/notification/delete_notification.dart
import 'package:stocktrack_pro/core/error/failures.dart';
import 'package:stocktrack_pro/domain/repositories/notification_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteNotification {
  final NotificationRepository repository;
  DeleteNotification(this.repository);

  Future<Either<Failure, Unit>> call(String id) {
    return repository.deleteNotification(id);
  }
}
