import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/error/exceptions.dart';
import '../../models/activity/activity_model.dart';
import 'package:meta/meta.dart';

abstract class RemoteActivityDataSource {
  Future<List<ActivityModel>> getActivities({
    DateTime? startDate,
    DateTime? endDate,
    String? type,
    String? userId,
    int? limit,
    int? offset,
  });

  Future<ActivityModel> getActivityById(String id);

  Future<void> logActivity(ActivityModel activity);

  Future<Map<String, int>> getActivityStatistics({
    DateTime? startDate,
    DateTime? endDate,
  });
}

class RemoteActivityDataSourceImpl implements RemoteActivityDataSource {
  final http.Client client;

  RemoteActivityDataSourceImpl({required this.client});

  @override
  Future<List<ActivityModel>> getActivities({
    DateTime? startDate,
    DateTime? endDate,
    String? type,
    String? userId,
    int? limit,
    int? offset,
  }) async {
    try {
      final response = await client.get(
        Uri.parse('https://example.com/api/activities'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> activitiesJson = json.decode(response.body);
        return activitiesJson
            .map((activity) => ActivityModel.fromJson(activity))
            .toList();
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<ActivityModel> getActivityById(String id) async {
    try {
      final response = await client.get(
        Uri.parse('https://example.com/api/activities/$id'),
      );

      if (response.statusCode == 200) {
        return ActivityModel.fromJson(json.decode(response.body));
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> logActivity(ActivityModel activity) async {
    try {
      final response = await client.post(
        Uri.parse('https://example.com/api/activities'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(activity.toJson()),
      );

      if (response.statusCode != 201) {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<Map<String, int>> getActivityStatistics({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final response = await client.get(
        Uri.parse('https://example.com/api/activities/statistics'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> statsJson = json.decode(response.body);
        return statsJson.map((key, value) => MapEntry(key, value as int));
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}
