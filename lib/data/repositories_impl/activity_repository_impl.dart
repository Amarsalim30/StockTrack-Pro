import 'package:dartz/dartz.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/activity/activity.dart';
import '../../domain/repositories/activity_repository.dart';
import '../datasources/remote/activity_source.dart';
import '../models/activity/activity_model.dart';

class ActivityRepositoryImpl implements ActivityRepository {
  final RemoteActivityDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ActivityRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Activity>>> getActivities({
    DateTime? startDate,
    DateTime? endDate,
    ActivityType? type,
    String? userId,
    int? limit,
    int? offset,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final activities = await remoteDataSource.getActivities(
          startDate: startDate,
          endDate: endDate,
          type: type != null ? ActivityModel.activityTypeToString(type) : null,
          userId: userId,
          limit: limit,
          offset: offset,
        );
        return Right(activities.cast<Activity>());
      } on ServerException {
        return const Left(ServerFailure(message: 'Server error occurred'));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Activity>> getActivityById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final activity = await remoteDataSource.getActivityById(id);
        return Right(activity as Activity);
      } on ServerException {
        return const Left(ServerFailure(message: 'Server error occurred'));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
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
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final activity = ActivityModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          userId: userId,
          userName: userName,
          type: type,
          action: action,
          description: description,
          metadata: metadata ?? {},
          timestamp: DateTime.now(),
          entityType: entityType ?? '',
          entityId: entityId ?? '',
        );
        await remoteDataSource.logActivity(activity);
        return const Right(null);
      } on ServerException {
        return const Left(ServerFailure(message: 'Failed to log activity'));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Map<String, int>>> getActivityStatistics({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final stats = await remoteDataSource.getActivityStatistics(
          startDate: startDate,
          endDate: endDate,
        );
        return Right(stats);
      } on ServerException {
        return const Left(ServerFailure(message: 'Failed to get statistics'));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<Activity>>> getUserActivities(
    String userId, {
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final activities = await remoteDataSource.getActivities(
          userId: userId,
          startDate: startDate,
          endDate: endDate,
          limit: limit,
        );
        return Right(activities.cast<Activity>());
      } on ServerException {
        return const Left(
          ServerFailure(message: 'Failed to get user activities'),
        );
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}
