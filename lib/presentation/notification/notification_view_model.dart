// notification_view_model.dart
import 'dart:async';
import 'package:clean_arch_app/domain/usecases/general/notification/notification_usecases.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'notification_state.dart';
import '../../domain/entities/general/notification.dart'; // adapt

/// ViewModel responsible for loading and mutating notifications.
/// Follows the pattern of your StockViewModel (usecases injected).
class NotificationViewModel extends StateNotifier<NotificationState> {
  final NotificationUseCases notificationUseCases;

  NotificationViewModel({required this.notificationUseCases})
      : super(NotificationState.initial()) {
    _init();
  }

  void _init() {
    loadNotifications();
  }

  /// Loads notifications from the repository via usecase.
  Future<void> loadNotifications() async {
    state = state.copyWith(status: NotificationStateStatus.loading, errorMessage: null);
    try {
      final res = await notificationUseCases.getNotifications();
      res.fold(
            (failure) {
          // in case of failure we keep existing list but set errorMessage
          state = state.copyWith(
            status: NotificationStateStatus.error,
            errorMessage: _failureMessage(failure, fallback: 'Failed to load notifications'),
          );
        },
            (List<Notification> list) {
          state = state.copyWith(notifications: list, status: NotificationStateStatus.success, errorMessage: null);
        },
      );
    } catch (e) {
      state = state.copyWith(
        status: NotificationStateStatus.error,
        errorMessage: 'Failed to load notifications: $e',
      );
    }
  }

  Future<void> refresh() async => loadNotifications();

  // -----------------------
  // Mutations
  // -----------------------

  /// Mark a single notification as read. Optimistic update with rollback on failure.
  Future<void> markAsRead(String id) async {
    final index = state.notifications.indexWhere((n) => n.id == id);
    if (index < 0) return;

    // optimistic local update
    final prev = List<Notification>.from(state.notifications);
    final updated = prev.map((n) => n.id == id ? n.copyWith(read: true) : n).toList();
    state = state.copyWith(notifications: updated);

    try {
      final res = await notificationUseCases.markAsRead(id);
      res.fold(
            (failure) {
          // rollback on failure and set error
          state = state.copyWith(
            notifications: prev,
            errorMessage: _failureMessage(failure, fallback: 'Failed to mark as read'),
          );
        },
            (_) {
          // success: optionally refresh from server for canonical state
        },
      );
    } catch (e) {
      // rollback
      state = state.copyWith(notifications: prev, errorMessage: 'Failed to mark as read: $e');
    }
  }

  /// Mark all notifications as read.
  Future<void> markAllAsRead() async {
    final prev = List<Notification>.from(state.notifications);
    final optim = prev.map((n) => n.copyWith(read: true)).toList();
    state = state.copyWith(notifications: optim);

    try {
      final res = await notificationUseCases.markAllAsRead();
      res.fold(
            (failure) {
          // rollback on failure
          state = state.copyWith(notifications: prev, errorMessage: _failureMessage(failure, fallback: 'Failed to mark all as read'));
        },
            (_) {
          // success - leave optimistic state
        },
      );
    } catch (e) {
      state = state.copyWith(notifications: prev, errorMessage: 'Failed to mark all as read: $e');
    }
  }

  /// Delete a notification
  Future<void> deleteNotification(String id) async {
    final prev = List<Notification>.from(state.notifications);
    final newList = prev.where((n) => n.id != id).toList();
    state = state.copyWith(notifications: newList);

    try {
      final res = await notificationUseCases.deleteNotification(id);
      res.fold(
            (failure) {
          // rollback on failure
          state = state.copyWith(notifications: prev, errorMessage: _failureMessage(failure, fallback: 'Failed to delete notification'));
        },
            (_) {
          // success
        },
      );
    } catch (e) {
      state = state.copyWith(notifications: prev, errorMessage: 'Delete failed: $e');
    }
  }

  /// Clear local notifications list (UI-only; does not call server)
  void clearLocal() {
    state = state.copyWith(notifications: <Notification>[]);
  }

  // -----------------------
  // Helpers
  // -----------------------
  String _failureMessage(dynamic failure, {String? fallback}) {
    try {
      if (failure == null) return fallback ?? 'Unknown error';
      if (failure is Exception) return failure.toString();
      final msg = (failure as dynamic).message;
      return msg ?? failure.toString();
    } catch (_) {
      return fallback ?? failure.toString();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
