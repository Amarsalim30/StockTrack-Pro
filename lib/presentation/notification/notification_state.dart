// notification_state.dart
import 'package:meta/meta.dart';
import '../../domain/entities/general/notification.dart'; // adapt path

enum NotificationStateStatus { initial, loading, success, error }

@immutable
class NotificationState {
  final List<Notification> notifications;
  final NotificationStateStatus status;
  final String? errorMessage;

  const NotificationState({
    this.notifications = const [],
    this.status = NotificationStateStatus.initial,
    this.errorMessage,
  });

  factory NotificationState.initial() => const NotificationState();

  // sentinel so callers can explicitly set nullable fields to `null`
  static const _noChange = Object();

  NotificationState copyWith({
    List<Notification>? notifications,
    NotificationStateStatus? status,
    Object? errorMessage = _noChange, // Object? so null is a valid override
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      status: status ?? this.status,
      errorMessage: errorMessage == _noChange ? this.errorMessage : errorMessage as String?,
    );
  }

  // computed helpers
  int get unreadCount => notifications.where((n) => n.read == false).length;
  bool get hasUnread => unreadCount > 0;
}
