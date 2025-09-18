import 'dart:async';

/// Firebase Cloud Messaging test data source for testing purposes
class FirebaseMessagingTestDataSource {
  final List<Map<String, dynamic>> _sentMessages = [];
  final List<Map<String, dynamic>> _receivedMessages = [];
  final Map<String, StreamController<Map<String, dynamic>>> _messageControllers = {};
  
  String? _fcmToken;
  bool _permissionGranted = true;

  /// Initialize messaging
  Future<void> initialize() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _fcmToken = 'mock_fcm_token_${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Get FCM token
  Future<String?> getToken() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _fcmToken;
  }

  /// Request notification permission
  Future<bool> requestPermission() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _permissionGranted;
  }

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    await Future.delayed(const Duration(milliseconds: 100));
    // Mock subscription - in real implementation, this would register with FCM
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await Future.delayed(const Duration(milliseconds: 100));
    // Mock unsubscription
  }

  /// Send notification (for testing purposes)
  Future<void> sendNotification({
    required String title,
    required String body,
    String? token,
    String? topic,
    Map<String, String>? data,
    String? imageUrl,
  }) async {
    await Future.delayed(const Duration(milliseconds: 150));

    final notification = {
      'messageId': 'msg_${DateTime.now().millisecondsSinceEpoch}',
      'title': title,
      'body': body,
      'token': token,
      'topic': topic,
      'data': data ?? {},
      'imageUrl': imageUrl,
      'sentAt': DateTime.now().toIso8601String(),
    };

    _sentMessages.add(notification);

    // Simulate receiving the notification if it's sent to current token or subscribed topic
    if (token == _fcmToken || (topic != null && _isSubscribedToTopic(topic))) {
      _simulateMessageReceived(notification);
    }
  }

  /// Send data message
  Future<void> sendDataMessage({
    required Map<String, String> data,
    String? token,
    String? topic,
  }) async {
    await Future.delayed(const Duration(milliseconds: 120));

    final message = {
      'messageId': 'data_msg_${DateTime.now().millisecondsSinceEpoch}',
      'data': data,
      'token': token,
      'topic': topic,
      'sentAt': DateTime.now().toIso8601String(),
      'type': 'data',
    };

    _sentMessages.add(message);

    if (token == _fcmToken || (topic != null && _isSubscribedToTopic(topic))) {
      _simulateMessageReceived(message);
    }
  }

  /// Listen to foreground messages
  Stream<Map<String, dynamic>> onMessage() {
    const streamKey = 'foreground';
    _messageControllers[streamKey] ??= StreamController<Map<String, dynamic>>.broadcast();
    return _messageControllers[streamKey]!.stream;
  }

  /// Listen to background message interactions
  Stream<Map<String, dynamic>> onMessageOpenedApp() {
    const streamKey = 'background';
    _messageControllers[streamKey] ??= StreamController<Map<String, dynamic>>.broadcast();
    return _messageControllers[streamKey]!.stream;
  }

  /// Listen to token refresh
  Stream<String> onTokenRefresh() {
    final controller = StreamController<String>.broadcast();
    
    // Simulate token refresh every 30 seconds in real app
    Timer.periodic(const Duration(seconds: 30), (timer) {
      if (!controller.isClosed) {
        _fcmToken = 'mock_fcm_token_${DateTime.now().millisecondsSinceEpoch}';
        controller.add(_fcmToken!);
      } else {
        timer.cancel();
      }
    });
    
    return controller.stream;
  }

  /// Handle background messages (for testing)
  void handleBackgroundMessage(Map<String, dynamic> message) {
    _receivedMessages.add({
      ...message,
      'receivedAt': DateTime.now().toIso8601String(),
      'state': 'background',
    });
  }

  /// Simulate receiving a message
  void _simulateMessageReceived(Map<String, dynamic> message) {
    final receivedMessage = {
      ...message,
      'receivedAt': DateTime.now().toIso8601String(),
      'state': 'foreground',
    };

    _receivedMessages.add(receivedMessage);

    // Notify foreground listeners
    if (_messageControllers['foreground'] != null) {
      _messageControllers['foreground']!.add(receivedMessage);
    }
  }

  /// Simulate app being opened from notification
  void simulateNotificationTap(Map<String, dynamic> message) {
    final tappedMessage = {
      ...message,
      'receivedAt': DateTime.now().toIso8601String(),
      'state': 'notification_tap',
    };

    _receivedMessages.add(tappedMessage);

    if (_messageControllers['background'] != null) {
      _messageControllers['background']!.add(tappedMessage);
    }
  }

  bool _isSubscribedToTopic(String topic) {
    // Mock subscription check - in real implementation, this would check actual subscriptions
    return true;
  }

  // Test helper methods
  void simulateTokenRefresh() {
    _fcmToken = 'mock_fcm_token_${DateTime.now().millisecondsSinceEpoch}';
    
    if (_messageControllers['token_refresh'] != null) {
      _messageControllers['token_refresh']!.add({'token': _fcmToken});
    }
  }

  void simulatePermissionDenied() {
    _permissionGranted = false;
  }

  void simulatePermissionGranted() {
    _permissionGranted = true;
  }

  void simulateNetworkError() {
    throw Exception('Network error - FCM test simulation');
  }

  void clearMessageHistory() {
    _sentMessages.clear();
    _receivedMessages.clear();
  }

  void dispose() {
    for (final controller in _messageControllers.values) {
      controller.close();
    }
    _messageControllers.clear();
  }

  // Getters for testing
  List<Map<String, dynamic>> get sentMessages => List.unmodifiable(_sentMessages);
  List<Map<String, dynamic>> get receivedMessages => List.unmodifiable(_receivedMessages);
  String? get currentToken => _fcmToken;
  bool get hasPermission => _permissionGranted;
  int get totalSentMessages => _sentMessages.length;
  int get totalReceivedMessages => _receivedMessages.length;

  List<Map<String, dynamic>> getMessagesByTopic(String topic) {
    return _sentMessages.where((msg) => msg['topic'] == topic).toList();
  }

  List<Map<String, dynamic>> getNotificationMessages() {
    return _sentMessages.where((msg) => msg['title'] != null).toList();
  }

  List<Map<String, dynamic>> getDataMessages() {
    return _sentMessages.where((msg) => msg['type'] == 'data').toList();
  }
}