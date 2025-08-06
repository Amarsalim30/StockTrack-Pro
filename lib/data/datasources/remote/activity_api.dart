import '../../../core/network/api_client.dart';
import '../../models/activity/activity_model.dart';

abstract class ActivityApi {
  Future<List<ActivityModel>> getActivities({
    int? page,
    int? limit,
    String? userId,
    String? type,
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<ActivityModel> getActivityById(String activityId);

  Future<ActivityModel> logActivity(Map<String, dynamic> activityData);

  Future<Map<String, dynamic>> getActivityStats({
    String? userId,
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<List<Map<String, dynamic>>> getActivityTypes();

  Future<void> deleteActivity(String activityId);

  Future<void> deleteActivities({String? userId, DateTime? beforeDate});
}

class ActivityApiImpl implements ActivityApi {
  final ApiClient _apiClient;

  ActivityApiImpl(this._apiClient);

  @override
  Future<List<ActivityModel>> getActivities({
    int? page,
    int? limit,
    String? userId,
    String? type,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final queryParams = <String, dynamic>{};
    if (page != null) queryParams['page'] = page;
    if (limit != null) queryParams['limit'] = limit;
    if (userId != null && userId.isNotEmpty) queryParams['userId'] = userId;
    if (type != null && type.isNotEmpty) queryParams['type'] = type;
    if (startDate != null) {
      queryParams['startDate'] = startDate.toIso8601String();
    }
    if (endDate != null) {
      queryParams['endDate'] = endDate.toIso8601String();
    }

    final response = await _apiClient.get<Map<String, dynamic>>(
      '/activities',
      queryParameters: queryParams,
    );

    final activities = response['data'] as List;
    return activities.map((json) => ActivityModel.fromJson(json)).toList();
  }

  @override
  Future<ActivityModel> getActivityById(String activityId) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/activities/$activityId',
    );
    return ActivityModel.fromJson(response);
  }

  @override
  Future<ActivityModel> logActivity(Map<String, dynamic> activityData) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/activities',
      data: activityData,
    );
    return ActivityModel.fromJson(response);
  }

  @override
  Future<Map<String, dynamic>> getActivityStats({
    String? userId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final queryParams = <String, dynamic>{};
    if (userId != null && userId.isNotEmpty) queryParams['userId'] = userId;
    if (startDate != null) {
      queryParams['startDate'] = startDate.toIso8601String();
    }
    if (endDate != null) {
      queryParams['endDate'] = endDate.toIso8601String();
    }

    final response = await _apiClient.get<Map<String, dynamic>>(
      '/activities/stats',
      queryParameters: queryParams,
    );
    return response;
  }

  @override
  Future<List<Map<String, dynamic>>> getActivityTypes() async {
    final response = await _apiClient.get<List<dynamic>>('/activities/types');
    return response.map((item) => item as Map<String, dynamic>).toList();
  }

  @override
  Future<void> deleteActivity(String activityId) async {
    await _apiClient.delete('/activities/$activityId');
  }

  @override
  Future<void> deleteActivities({String? userId, DateTime? beforeDate}) async {
    final queryParams = <String, dynamic>{};
    if (userId != null && userId.isNotEmpty) queryParams['userId'] = userId;
    if (beforeDate != null) {
      queryParams['beforeDate'] = beforeDate.toIso8601String();
    }

    await _apiClient.delete('/activities', queryParameters: queryParams);
  }
}
