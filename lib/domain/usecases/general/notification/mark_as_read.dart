// domain/usecases/notification/mark_as_read.dart
import 'package:stocktrack_pro/core/error/failures.dart';
import 'package:stocktrack_pro/domain/repositories/notification_repository.dart';
import 'package:dartz/dartz.dart';

class MarkAsRead {
  final NotificationRepository repository;
  MarkAsRead(this.repository);

  Future<Either<Failure, Unit>> call(String id) {
    return repository.markAsRead(id);
  }
}
