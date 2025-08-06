import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/activity/activity.dart';

abstract class ActivityRepository {
  Future<Either<Failure, List<Activity>>> getActivities({
    DateTime? startDate,
    DateTime? endDate,
    ActivityType? type,
    String? userId,
    int? limit,
    int? offset,
  });

  Future<Either<Failure, Activity>> getActivityById(String id);

  Future<Either<Failure, void>> logActivity({
    required String userId,
    required String userName,
    required ActivityType type,
    required String action,
    String? description,
    String? entityType,
    String? entityId,
    String? entityName,
    String? entityLocation,
    Map<String, dynamic>? metadata,
  });

  Future<Either<Failure, Map<String, int>>> getActivityStatistics({
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<Either<Failure, List<Activity>>> getUserActivities(
    String userId, {
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  });
}
