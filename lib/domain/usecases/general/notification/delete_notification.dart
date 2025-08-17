// domain/usecases/notification/delete_notification.dart
import 'package:clean_arch_app/core/error/failures.dart';
import 'package:clean_arch_app/domain/repositories/notification_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteNotification {
  final NotificationRepository repository;
  DeleteNotification(this.repository);

  Future<Either<Failure, Unit>> call(String id) {
    return repository.deleteNotification(id);
  }
}
