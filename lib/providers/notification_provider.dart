import 'package:appoint/models/notification_payload.dart';
import 'package:appoint/services/notification_service.dart';
import 'package:appoint/services/ui_notification_service.dart';
import 'package:appoint/providers/fcm_token_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

/// Provider for the notification service
final notificationServiceProvider = Provider<NotificationService>(
  (ref) => NotificationService(),
);

/// Provider for notification permissions state
final notificationPermissionsProvider = StateProvider<bool>((ref) => false);

/// Provider for pending notifications
final pendingNotificationsProvider = StateProvider<List<PendingNotificationRequest>>((ref) => []);

/// Provider for notifications list
final notificationsProvider =
    StateProvider<List<NotificationPayload>>((ref) => []);

/// Provider for the UI notification service
/// This should be overridden in the app's main function with a real implementation
final uiNotificationServiceProvider = Provider<UINotificationService>((ref) {
  // Return a stub implementation instead of throwing UnimplementedError
  return MockNotificationService();
});

/// Provider for notification helper methods
final notificationHelperProvider = Provider<NotificationHelper>((ref) {
  final notificationService = ref.watch(notificationServiceProvider);
  return NotificationHelper(notificationService, ref);
});

/// Helper class for common notification operations
class NotificationHelper {
  NotificationHelper(this._notificationService, this._ref);
  
  final NotificationService _notificationService;
  final Ref _ref;

  /// Request notification permissions and update state
  Future<bool> requestPermissions() async {
    final hasPermission = await _notificationService.requestPermissions();
    _ref.read(notificationPermissionsProvider.notifier).state = hasPermission;
    return hasPermission;
  }

  /// Send a local notification
  Future<void> sendLocalNotification({
    required String title,
    required String body,
    String? payload,
    int? id,
  }) async {
    await _notificationService.sendLocalNotification(
      title: title,
      body: body,
      payload: payload,
      id: id,
    );
  }

  /// Schedule a notification
  Future<void> scheduleNotification({
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
    int? id,
  }) async {
    await _notificationService.scheduleNotification(
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      payload: payload,
      id: id,
    );
  }

  /// Send a push notification (stub)
  Future<void> sendPushNotification({
    required String fcmToken,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    await _notificationService.sendPushNotification(
      fcmToken: fcmToken,
      title: title,
      body: body,
      data: data,
    );
  }

  /// Send notification to user by UID
  Future<void> sendNotificationToUser({
    required String uid,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    await _notificationService.sendNotificationToUser(
      uid: uid,
      title: title,
      body: body,
      data: data,
    );
  }

  /// Refresh pending notifications
  Future<void> refreshPendingNotifications() async {
    final pending = await _notificationService.getPendingNotifications();
    _ref.read(pendingNotificationsProvider.notifier).state = pending;
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notificationService.cancelAllNotifications();
    await refreshPendingNotifications();
  }

  /// Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    await _notificationService.cancelNotification(id);
    await refreshPendingNotifications();
  }
}

/// Provider for showing sync-related notifications
final syncNotificationProvider = Provider<SyncNotificationHelper>((ref) {
  final notificationService = ref.watch(uiNotificationServiceProvider);
  return SyncNotificationHelper(notificationService);
});

/// Helper class for showing sync-related notifications
class SyncNotificationHelper {
  SyncNotificationHelper(this._notificationService);
  final UINotificationService _notificationService;

  /// Show notification when sync starts
  void showSyncStarted() {
    _notificationService.showInfo('Syncing bookings...');
  }

  /// Show notification when sync completes successfully
  void showSyncCompleted(int syncedCount) {
    if (syncedCount == 0) {
      _notificationService.showInfo('No changes to sync');
    } else {
      _notificationService.showSuccess(
          'Successfully synced $syncedCount booking${syncedCount == 1 ? '' : 's'}');
    }
  }

  /// Show notification when sync fails
  void showSyncFailed(String error) {
    _notificationService.showError('Sync failed: $error');
  }

  /// Show notification when there are conflicts
  void showConflictDetected(String bookingId) {
    _notificationService
        .showWarning('Conflict detected for booking $bookingId');
  }

  /// Show notification when there are pending operations
  void showPendingOperations(int count) {
    _notificationService
        .showInfo('$count booking${count == 1 ? '' : 's'} pending sync');
  }

  /// Show notification when circuit breaker opens
  void showCircuitBreakerOpen() {
    _notificationService
        .showWarning('Sync temporarily disabled due to repeated failures');
  }

  /// Show notification when circuit breaker closes
  void showCircuitBreakerClosed() {
    _notificationService.showInfo('Sync resumed');
  }

  /// Show notification for permanent failures
  void showPermanentFailure(String bookingId) {
    _notificationService
        .showError('Booking $bookingId failed to sync permanently');
  }
}
