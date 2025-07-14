import 'package:appoint/models/notification_payload.dart';
import 'package:appoint/services/notification_service.dart';
import 'package:appoint/services/ui_notification_service.dart';
// import 'package:appoint/providers/fcm_token_provider.dart'; // Unused
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationServiceProvider = Provider<NotificationService>(
  (ref) => NotificationService(),
);

/// Provider for notifications list
final notificationsProvider =
    StateProvider<List<NotificationPayload>>((ref) => []);

/// Provider for the UI notification service
/// This should be overridden in the app's main function with a real implementation
final uiNotificationServiceProvider = Provider<UINotificationService>((ref) {
  throw UnimplementedError(
    'UINotificationService not provided. '
    'Please override this provider in your main function.',
  );
});

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
          'Successfully synced $syncedCount booking${syncedCount == 1 ? '' : 's'}',);
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
