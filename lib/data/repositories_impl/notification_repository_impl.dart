// data/repositories/notification_repository_impl.dart
import 'package:clean_arch_app/core/error/failures.dart';
import 'package:clean_arch_app/data/datasources/remote/notification_api.dart';
import 'package:clean_arch_app/data/mappers/general/notification_mapper.dart';
import 'package:clean_arch_app/domain/entities/general/notification.dart' as entity;
import 'package:clean_arch_app/domain/repositories/notification_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationApi api;

  NotificationRepositoryImpl(this.api);
  Failure _mapError(Object error) {
    if (error is DioException) {
      return ServerFailure(message: error.message ?? 'Server error');
    } else {
      return ServerFailure(message: 'Unexpected error: $error');
    }
  }

  @override
  Future<Either<Failure, List<entity.Notification>>> getNotifications() async {
    try {
      final list = await api.getNotifications();
      final entities = list.map((m) => NotificationMapper.toEntity(m)).toList();
      return right(entities);
    } catch (e) {
      return left(_mapError(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> markAsRead(String id) async {
    try {
      await api.markAsRead(id);
      return right(unit);
    } catch (e) {
      return left(_mapError(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> markAllAsRead() async {
    try {
      await api.markAllAsRead();
      return right(unit);
    } catch (e) {
      return left(_mapError(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteNotification(String id) async {
    try {
      await api.deleteNotification(id);
      return right(unit);
    } catch (e) {
      return left(_mapError(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteMultipleNotifications(List<String> ids) async {
    try {
      await api.deleteMultipleNotifications({'ids': ids});
      return right(unit);
    } catch (e) {
      return left(_mapError(e));
    }
  }

  @override
  Future<Either<Failure, entity.Notification>> createNotification(entity.Notification notification) async {
    try {
      final model = NotificationMapper.fromEntity(notification);
      final created = await api.createNotification(model);
      return right(NotificationMapper.toEntity(created));
    } catch (e) {
      return left(_mapError(e));
    }
  }
}
