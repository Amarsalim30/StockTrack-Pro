import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState {
  final String userName;
  final String userEmail;
  final String userRole;
  final String avatarUrl;
  final bool autoSync;
  final bool lowStockAlerts;
  final bool activityNotifications;
  final bool isLoading;

  SettingsState({
    this.userName = '',
    this.userEmail = '',
    this.userRole = '',
    this.avatarUrl = '',
    this.autoSync = true,
    this.lowStockAlerts = true,
    this.activityNotifications = true,
    this.isLoading = false,
  });

  bool get isAdmin => userRole.toLowerCase() == 'admin';

  SettingsState copyWith({
    String? userName,
    String? userEmail,
    String? userRole,
    String? avatarUrl,
    bool? autoSync,
    bool? lowStockAlerts,
    bool? activityNotifications,
    bool? isLoading,
  }) {
    return SettingsState(
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      userRole: userRole ?? this.userRole,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      autoSync: autoSync ?? this.autoSync,
      lowStockAlerts: lowStockAlerts ?? this.lowStockAlerts,
      activityNotifications:
          activityNotifications ?? this.activityNotifications,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class SettingsViewModel extends StateNotifier<SettingsState> {
  SettingsViewModel() : super(SettingsState());

  late SharedPreferences _prefs;

  // Initialize preferences
  Future<void> init() async {
    state = state.copyWith(isLoading: true);
    try {
      _prefs = await SharedPreferences.getInstance();
      await _loadSettings();
      await _loadUserProfile();
    } catch (e) {
      debugPrint('Error initializing settings: $e');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  // Load settings from SharedPreferences
  Future<void> _loadSettings() async {
    final autoSync = _prefs.getBool('auto_sync') ?? true;
    final lowStockAlerts = _prefs.getBool('low_stock_alerts') ?? true;
    final activityNotifications =
        _prefs.getBool('activity_notifications') ?? true;

    state = state.copyWith(
      autoSync: autoSync,
      lowStockAlerts: lowStockAlerts,
      activityNotifications: activityNotifications,
    );
  }

  // Load user profile (in real app, this would come from auth service)
  Future<void> _loadUserProfile() async {
    // Simulated user data - replace with actual auth service calls
    final userName = _prefs.getString('user_name') ?? 'John Doe';
    final userEmail = _prefs.getString('user_email') ?? 'john.doe@example.com';
    final userRole = _prefs.getString('user_role') ?? 'Admin';
    final avatarUrl = _prefs.getString('avatar_url') ?? '';

    state = state.copyWith(
      userName: userName,
      userEmail: userEmail,
      userRole: userRole,
      avatarUrl: avatarUrl,
    );
  }

  // Update general settings
  Future<void> setAutoSync(bool value) async {
    state = state.copyWith(autoSync: value);
    await _prefs.setBool('auto_sync', value);
  }

  Future<void> setLowStockAlerts(bool value) async {
    state = state.copyWith(lowStockAlerts: value);
    await _prefs.setBool('low_stock_alerts', value);
  }

  Future<void> setActivityNotifications(bool value) async {
    state = state.copyWith(activityNotifications: value);
    await _prefs.setBool('activity_notifications', value);
  }

  // Security actions
  Future<void> changePassword() async {
    // Navigate to password change screen or show dialog
    debugPrint('Change password requested');
  }

  Future<void> setupTwoFactorAuth() async {
    // Navigate to 2FA setup screen
    debugPrint('2FA setup requested');
  }

  Future<void> viewLoginHistory() async {
    // Navigate to login history screen
    debugPrint('View login history requested');
  }

  // Data management actions (admin only)
  Future<void> exportData() async {
    if (!state.isAdmin) {
      debugPrint('Export data requires admin privileges');
      return;
    }
    state = state.copyWith(isLoading: true);
    try {
      // Implement data export logic
      await Future.delayed(const Duration(seconds: 2)); // Simulated delay
      debugPrint('Data exported successfully');
    } catch (e) {
      debugPrint('Error exporting data: $e');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> syncData() async {
    if (!state.isAdmin) {
      debugPrint('Sync data requires admin privileges');
      return;
    }
    state = state.copyWith(isLoading: true);
    try {
      // Implement data sync logic
      await Future.delayed(const Duration(seconds: 2)); // Simulated delay
      debugPrint('Data synced successfully');
    } catch (e) {
      debugPrint('Error syncing data: $e');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> clearLocalData() async {
    if (!state.isAdmin) {
      debugPrint('Clear local data requires admin privileges');
      return false;
    }
    state = state.copyWith(isLoading: true);
    try {
      // Clear all preferences except user data
      final userRole = _prefs.getString('user_role');
      final userName = _prefs.getString('user_name');
      final userEmail = _prefs.getString('user_email');

      await _prefs.clear();

      // Restore user data
      if (userRole != null) await _prefs.setString('user_role', userRole);
      if (userName != null) await _prefs.setString('user_name', userName);
      if (userEmail != null) await _prefs.setString('user_email', userEmail);

      // Reset to defaults
      await _loadSettings();
      debugPrint('Local data cleared successfully');
      return true;
    } catch (e) {
      debugPrint('Error clearing local data: $e');
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

// Provider
final settingsViewModelProvider =
    StateNotifierProvider<SettingsViewModel, SettingsState>((ref) {
      return SettingsViewModel();
    });
