import 'package:hive_flutter/hive_flutter.dart';
import '../../models/user/user_model.dart';
import '../../../core/error/exceptions.dart';

abstract class UserLocalDataSource {
  Future<List<UserModel>> getCachedUsers();

  Future<UserModel?> getCachedUserById(String userId);

  Future<void> cacheUsers(List<UserModel> users);

  Future<void> cacheUser(UserModel user);

  Future<void> removeUser(String userId);

  Future<void> clearUsers();

  Future<UserModel?> getCurrentUser();

  Future<void> cacheCurrentUser(UserModel user);

  Future<void> clearCurrentUser();
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  static const String _usersBoxName = 'users';
  static const String _currentUserBoxName = 'current_user';
  static const String _currentUserKey = 'current';

  final Box<Map<dynamic, dynamic>> _usersBox;
  final Box<Map<dynamic, dynamic>> _currentUserBox;

  UserLocalDataSourceImpl({
    required Box<Map<dynamic, dynamic>> usersBox,
    required Box<Map<dynamic, dynamic>> currentUserBox,
  }) : _usersBox = usersBox,
       _currentUserBox = currentUserBox;

  @override
  Future<List<UserModel>> getCachedUsers() async {
    try {
      final users = <UserModel>[];
      for (var i = 0; i < _usersBox.length; i++) {
        final userMap = _usersBox.getAt(i);
        if (userMap != null) {
          users.add(UserModel.fromJson(Map<String, dynamic>.from(userMap)));
        }
      }
      return users;
    } catch (e) {
      throw CacheException('Failed to get cached users');
    }
  }

  @override
  Future<UserModel?> getCachedUserById(String userId) async {
    try {
      final userMap = _usersBox.get(userId);
      if (userMap != null) {
        return UserModel.fromJson(Map<String, dynamic>.from(userMap));
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get cached user');
    }
  }

  @override
  Future<void> cacheUsers(List<UserModel> users) async {
    try {
      await _usersBox.clear();
      for (final user in users) {
        await _usersBox.put(user.id, user.toJson());
      }
    } catch (e) {
      throw CacheException('Failed to cache users');
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      await _usersBox.put(user.id, user.toJson());
    } catch (e) {
      throw CacheException('Failed to cache user');
    }
  }

  @override
  Future<void> removeUser(String userId) async {
    try {
      await _usersBox.delete(userId);
    } catch (e) {
      throw CacheException('Failed to remove user from cache');
    }
  }

  @override
  Future<void> clearUsers() async {
    try {
      await _usersBox.clear();
    } catch (e) {
      throw CacheException('Failed to clear users cache');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final userMap = _currentUserBox.get(_currentUserKey);
      if (userMap != null) {
        return UserModel.fromJson(Map<String, dynamic>.from(userMap));
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get current user from cache');
    }
  }

  @override
  Future<void> cacheCurrentUser(UserModel user) async {
    try {
      await _currentUserBox.put(_currentUserKey, user.toJson());
    } catch (e) {
      throw CacheException('Failed to cache current user');
    }
  }

  @override
  Future<void> clearCurrentUser() async {
    try {
      await _currentUserBox.delete(_currentUserKey);
    } catch (e) {
      throw CacheException('Failed to clear current user cache');
    }
  }

  static Future<void> initHive() async {
    await Hive.initFlutter();
    if (!Hive.isBoxOpen(_usersBoxName)) {
      await Hive.openBox<Map<dynamic, dynamic>>(_usersBoxName);
    }
    if (!Hive.isBoxOpen(_currentUserBoxName)) {
      await Hive.openBox<Map<dynamic, dynamic>>(_currentUserBoxName);
    }
  }
}
