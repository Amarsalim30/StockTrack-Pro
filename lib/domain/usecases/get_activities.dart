import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/activity/activity.dart';
import '../repositories/activity_repository.dart';

class GetActivities implements UseCase<List<Activity>, GetActivitiesParams> {
  final ActivityRepository repository;

  GetActivities(this.repository);

  @override
  Future<Either<Failure, List<Activity>>> call(GetActivitiesParams params) {
    return repository.getActivities(
      startDate: params.startDate,
      endDate: params.endDate,
      type: params.type,
      userId: params.userId,
      limit: params.limit,
      offset: params.offset,
    );
  }
}

class GetActivitiesParams extends Equatable {
  final DateTime? startDate;
  final DateTime? endDate;
  final ActivityType? type;
  final String? userId;
  final int? limit;
  final int? offset;

  const GetActivitiesParams({
    this.startDate,
    this.endDate,
    this.type,
    this.userId,
    this.limit,
    this.offset,
  });

  @override
  List<Object?> get props => [startDate, endDate, type, userId, limit, offset];
}
