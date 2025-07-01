import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appoint/models/notification_item.dart';

/// Simple service that manages in-memory notifications.
class LocalNotificationService {
  LocalNotificationService(this._controller);

  final StateController<List<NotificationItem>> _controller;

  /// Returns the current list of notifications.
  List<NotificationItem> fetchNotifications() {
    return _controller.state;
  }

  /// Clears all stored notifications.
  void clearNotifications() {
    _controller.state = [];
  }
}
