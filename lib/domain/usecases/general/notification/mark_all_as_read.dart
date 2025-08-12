// domain/usecases/notification/mark_all_as_read.dart
import 'package:clean_arch_app/core/error/failures.dart';
import 'package:clean_arch_app/domain/repositories/notification_repository.dart';
import 'package:dartz/dartz.dart';

class MarkAllAsRead {
  final NotificationRepository repository;

  MarkAllAsRead(this.repository);

  /// Call repository to mark all notifications as read.
  /// Returns Either<Failure, Unit>.
  Future<Either<Failure, Unit>> call() {
    return repository.markAllAsRead();
  }
}
