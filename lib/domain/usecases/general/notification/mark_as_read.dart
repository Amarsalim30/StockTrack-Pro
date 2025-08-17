// domain/usecases/notification/mark_as_read.dart
import 'package:clean_arch_app/core/error/failures.dart';
import 'package:clean_arch_app/domain/repositories/notification_repository.dart';
import 'package:dartz/dartz.dart';

class MarkAsRead {
  final NotificationRepository repository;
  MarkAsRead(this.repository);

  Future<Either<Failure, Unit>> call(String id) {
    return repository.markAsRead(id);
  }
}
