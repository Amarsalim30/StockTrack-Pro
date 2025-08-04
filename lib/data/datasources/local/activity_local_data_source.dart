import 'package:hive_flutter/hive_flutter.dart';
import '../../models/activity/activity_model.dart';
import '../../../core/error/exceptions.dart';

abstract class ActivityLocalDataSource {
  Future<List<ActivityModel>> getCachedActivities();

  Future<ActivityModel?> getCachedActivityById(String activityId);

  Future<void> cacheActivities(List<ActivityModel> activities);

  Future<void> cacheActivity(ActivityModel activity);

  Future<void> removeActivity(String activityId);

  Future<void> clearActivities();

  Future<List<ActivityModel>> getCachedActivitiesByUser(String userId);

  Future<List<ActivityModel>> getCachedActivitiesByDateRange(
    DateTime startDate,
    DateTime endDate,
  );
}

class ActivityLocalDataSourceImpl implements ActivityLocalDataSource {
  static const String _activitiesBoxName = 'activities';
  static const int _maxCachedActivities = 1000; // Limit cached activities

  final Box<Map<dynamic, dynamic>> _activitiesBox;

  ActivityLocalDataSourceImpl({
    required Box<Map<dynamic, dynamic>> activitiesBox,
  }) : _activitiesBox = activitiesBox;

  @override
  Future<List<ActivityModel>> getCachedActivities() async {
    try {
      final activities = <ActivityModel>[];
      for (var i = 0; i < _activitiesBox.length; i++) {
        final activityMap = _activitiesBox.getAt(i);
        if (activityMap != null) {
          activities.add(
            ActivityModel.fromJson(Map<String, dynamic>.from(activityMap)),
          );
        }
      }
      // Sort by timestamp descending
      activities.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return activities;
    } catch (e) {
      throw CacheException('Failed to get cached activities');
    }
  }

  @override
  Future<ActivityModel?> getCachedActivityById(String activityId) async {
    try {
      final activityMap = _activitiesBox.get(activityId);
      if (activityMap != null) {
        return ActivityModel.fromJson(Map<String, dynamic>.from(activityMap));
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get cached activity');
    }
  }

  @override
  Future<void> cacheActivities(List<ActivityModel> activities) async {
    try {
      await _activitiesBox.clear();
      // Limit the number of cached activities
      final activitiesToCache = activities.take(_maxCachedActivities).toList();
      for (final activity in activitiesToCache) {
        await _activitiesBox.put(activity.id, activity.toJson());
      }
    } catch (e) {
      throw CacheException('Failed to cache activities');
    }
  }

  @override
  Future<void> cacheActivity(ActivityModel activity) async {
    try {
      await _activitiesBox.put(activity.id, activity.toJson());

      // Remove oldest activities if we exceed the limit
      if (_activitiesBox.length > _maxCachedActivities) {
        await _removeOldestActivities();
      }
    } catch (e) {
      throw CacheException('Failed to cache activity');
    }
  }

  @override
  Future<void> removeActivity(String activityId) async {
    try {
      await _activitiesBox.delete(activityId);
    } catch (e) {
      throw CacheException('Failed to remove activity from cache');
    }
  }

  @override
  Future<void> clearActivities() async {
    try {
      await _activitiesBox.clear();
    } catch (e) {
      throw CacheException('Failed to clear activities cache');
    }
  }

  @override
  Future<List<ActivityModel>> getCachedActivitiesByUser(String userId) async {
    try {
      final allActivities = await getCachedActivities();
      return allActivities
          .where((activity) => activity.userId == userId)
          .toList();
    } catch (e) {
      throw CacheException('Failed to get cached activities by user');
    }
  }

  @override
  Future<List<ActivityModel>> getCachedActivitiesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final allActivities = await getCachedActivities();
      return allActivities.where((activity) {
        return activity.timestamp.isAfter(startDate) &&
            activity.timestamp.isBefore(endDate);
      }).toList();
    } catch (e) {
      throw CacheException('Failed to get cached activities by date range');
    }
  }

  Future<void> _removeOldestActivities() async {
    final activities = await getCachedActivities();
    if (activities.length > _maxCachedActivities) {
      // Sort by timestamp ascending (oldest first)
      activities.sort((a, b) => a.timestamp.compareTo(b.timestamp));

      // Remove the oldest activities
      final activitiesToRemove = activities.length - _maxCachedActivities;
      for (var i = 0; i < activitiesToRemove; i++) {
        await _activitiesBox.delete(activities[i].id);
      }
    }
  }

  static Future<void> initHive() async {
    await Hive.initFlutter();
    if (!Hive.isBoxOpen(_activitiesBoxName)) {
      await Hive.openBox<Map<dynamic, dynamic>>(_activitiesBoxName);
    }
  }
}
