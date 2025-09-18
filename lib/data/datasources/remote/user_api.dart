import 'package:dio/dio.dart';
import '../../models/auth/user_model.dart';

class UserApi {
  final Dio _dio;

  UserApi(this._dio);

  Future<List<UserModel>> getAllUsers() async {
    final response = await _dio.get('/users');
    final data = response.data['data'] as List;
    return data.map((json) => UserModel.fromJson(json)).toList();
  }

  Future<UserModel> getUserById(String id) async {
    final response = await _dio.get('/users/$id');
    return UserModel.fromJson(response.data);
  }

  Future<void> createUser(UserModel user) async {
    await _dio.post('/users', data: user.toJson());
  }

  Future<void> updateUser(UserModel user) async {
    await _dio.put('/users/${user.id}', data: user.toJson());
  }

  Future<void> deleteUser(String id) async {
    await _dio.delete('/users/$id');
  }

  Future<void> updateUserPermissions(String id,
      List<String> permissions) async {
    await _dio.put(
        '/users/$id/permissions', data: {'permissions': permissions});
  }


  Future<Map<String, dynamic>> getUserStats() async {
    final response = await _dio.get('/users/stats');
    return response.data;
  }

  Future<void> resetUserPassword(String id) async {
    await _dio.post('/users/$id/reset-password');
  }

  Future<List<UserModel>> searchUsers(String query) async {
    final response = await _dio.get('/users/search', queryParameters: {'q': query});
    final data = response.data['data'] as List;
    return data.map((json) => UserModel.fromJson(json)).toList();
  }

  Future<UserModel> toggleUserStatus(String id) async {
    final response = await _dio.put('/users/$id/toggle-status');
    return UserModel.fromJson(response.data);
  }
}
