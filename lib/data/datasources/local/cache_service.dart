import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

abstract class CacheService {
  Future<void> setString(String key, String value);

  Future<String?> getString(String key);

  Future<void> setInt(String key, int value);

  Future<int?> getInt(String key);

  Future<void> setBool(String key, bool value);

  Future<bool?> getBool(String key);

  Future<void> setJson(String key, Map<String, dynamic> json);

  Future<Map<String, dynamic>?> getJson(String key);

  Future<void> remove(String key);

  Future<void> clear();
}

class CacheServiceImpl implements CacheService {
  final SharedPreferences _prefs;

  CacheServiceImpl(this._prefs);

  @override
  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  @override
  Future<String?> getString(String key) async {
    return _prefs.getString(key);
  }

  @override
  Future<void> setInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  @override
  Future<int?> getInt(String key) async {
    return _prefs.getInt(key);
  }

  @override
  Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  @override
  Future<bool?> getBool(String key) async {
    return _prefs.getBool(key);
  }

  @override
  Future<void> setJson(String key, Map<String, dynamic> json) async {
    final jsonString = jsonEncode(json);
    await _prefs.setString(key, jsonString);
  }

  @override
  Future<Map<String, dynamic>?> getJson(String key) async {
    final jsonString = _prefs.getString(key);
    if (jsonString != null) {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    }
    return null;
  }

  @override
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  @override
  Future<void> clear() async {
    await _prefs.clear();
  }
}

class CacheKeys {
  static const String authToken = 'auth_token';
  static const String refreshToken = 'refresh_token';
  static const String currentUser = 'current_user';
  static const String rememberMe = 'remember_me';
  static const String savedEmail = 'saved_email';
  static const String theme = 'theme';
  static const String language = 'language';
}
