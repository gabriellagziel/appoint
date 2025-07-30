import 'package:appoint/exceptions/booking_conflict_exception.dart';
import 'package:appoint/providers/notification_provider.dart';
import 'package:appoint/services/ui_notification_service.dart';
import 'package:appoint/widgets/booking_conflict_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Example showing how to integrate the notification system
class NotificationIntegrationExample extends ConsumerStatefulWidget {
  const NotificationIntegrationExample({super.key});

  @override
  ConsumerState<NotificationIntegrationExample> createState() =>
      REDACTED_TOKEN();
}

class REDACTED_TOKEN
    extends ConsumerState<NotificationIntegrationExample> {
  late SyncNotificationHelper syncHelper;

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Notification Integration Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _showInfoNotification,
              child: const Text('Show Info Notification'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _showWarningNotification,
              child: const Text('Show Warning Notification'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _showErrorNotification,
              child: const Text('Show Error Notification'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _showSuccessNotification,
              child: const Text('Show Success Notification'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _showConflictDialog,
              child: const Text('Show Conflict Dialog'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _showSyncNotifications,
              child: const Text('Show Sync Notifications'),
            ),
          ],
        ),
      ),
    );

  void _showInfoNotification() {
    ref
        .read(uiNotificationServiceProvider)
        .showInfo('This is an informational message');
  }

  void _showWarningNotification() {
    ref
        .read(uiNotificationServiceProvider)
        .showWarning('This is a warning message');
  }

  void _showErrorNotification() {
    ref
        .read(uiNotificationServiceProvider)
        .showError('This is an error message');
  }

  void _showSuccessNotification() {
    ref
        .read(uiNotificationServiceProvider)
        .showSuccess('This is a success message');
  }

  Future<void> _showConflictDialog() async {
    final conflict = BookingConflictException(
      bookingId: 'example-booking-123',
      localUpdatedAt: DateTime.now().subtract(const Duration(hours: 1)),
      remoteUpdatedAt: DateTime.now(),
      message: 'This is an example conflict',
    );

    final resolution = await showBookingConflictDialog(
      context,
      conflict,
      onKeepLocal: () => debugPrint('User chose to keep local version'),
      onKeepRemote: () => debugPrint('User chose to keep remote version'),
      onMerge: () => debugPrint('User chose to merge changes'),
    );

    switch (resolution) {
      case ConflictResolution.keepLocal:
        debugPrint('Keeping local version');
      case ConflictResolution.keepRemote:
        debugPrint('Keeping remote version');
      case ConflictResolution.merge:
        debugPrint('Merging changes');
      case null:
        debugPrint('Dialog was dismissed');
    }
  }

  void _showSyncNotifications() {
    syncHelper = ref.read(syncNotificationProvider);

    // Simulate sync process
    syncHelper.showSyncStarted();

    // Simulate sync completion
    Future.delayed(const Duration(seconds: 2), () {
      syncHelper.showSyncCompleted(3);
    });

    // Simulate conflict
    Future.delayed(const Duration(seconds: 4), () {
      syncHelper.showConflictDetected('booking-123');
    });

    // Simulate circuit breaker
    Future.delayed(const Duration(seconds: 6), syncHelper.showCircuitBreakerOpen);
  }
}

/// Example of how to set up the notification service in main.dart
class MainAppSetupExample {
  static late GlobalKey<ScaffoldMessengerState> messengerKey;

  static Widget buildApp() {
    messengerKey = GlobalKey<ScaffoldMessengerState>();

    return ProviderScope(
      overrides: [
        uiNotificationServiceProvider.overrideWithValue(
          ScaffoldNotificationService(messengerKey),
        ),
      ],
      child: MaterialApp(
        title: 'Appoint App',
        scaffoldMessengerKey: messengerKey,
        home: const NotificationIntegrationExample(),
      ),
    );
  }
}

/// Example of how to handle conflicts in a booking screen
class BookingScreenExample extends ConsumerWidget {
  const BookingScreenExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
      appBar: AppBar(title: const Text('Bookings')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _handleBookingSync(context, ref),
          child: const Text('Sync Bookings'),
        ),
      ),
    );

  Future<void> _handleBookingSync(BuildContext context, WidgetRef ref) async {
    try {
      // Simulate booking sync that might throw a conflict
      await _simulateBookingSync();
    } on BookingConflictException catch (e) {
      // Show conflict dialog
      final resolution = await showBookingConflictDialog(
        context,
        e,
        onKeepLocal: () => _handleKeepLocal(e.bookingId),
        onKeepRemote: () => _handleKeepRemote(e.bookingId),
      );

      // Handle the resolution
      switch (resolution) {
        case ConflictResolution.keepLocal:
          await _forceLocalVersion(e.bookingId);
        case ConflictResolution.keepRemote:
          await _discardLocalVersion(e.bookingId);
        case ConflictResolution.merge:
          await _mergeVersions(e.bookingId);
        case null:
          // User dismissed dialog, do nothing
          break;
      }
    } catch (e) {
      // Show error notification
      ref.read(uiNotificationServiceProvider).showError('Sync failed: $e');
    }
  }

  // Mock methods for demonstration
  Future<void> _simulateBookingSync() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Simulate conflict
    throw BookingConflictException(
      bookingId: 'demo-booking-123',
      localUpdatedAt: DateTime.now().subtract(const Duration(minutes: 30)),
      remoteUpdatedAt: DateTime.now(),
      message: 'Demo conflict for testing',
    );
  }

  Future<void> _handleKeepLocal(String bookingId) async {
    debugPrint('Handling keep local for booking: $bookingId');
  }

  Future<void> _handleKeepRemote(String bookingId) async {
    debugPrint('Handling keep remote for booking: $bookingId');
  }

  Future<void> _forceLocalVersion(String bookingId) async {
    debugPrint('Forcing local version for booking: $bookingId');
  }

  Future<void> _discardLocalVersion(String bookingId) async {
    debugPrint('Discarding local version for booking: $bookingId');
  }

  Future<void> _mergeVersions(String bookingId) async {
    debugPrint('Merging versions for booking: $bookingId');
  }
}
