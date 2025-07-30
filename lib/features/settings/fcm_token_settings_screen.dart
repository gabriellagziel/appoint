import 'package:appoint/providers/fcm_token_provider.dart';
import 'package:appoint/widgets/debug/fcm_token_debug_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Settings screen for FCM token management
/// This screen allows users to view and manage their notification settings
class FCMTokenSettingsScreen extends ConsumerWidget {
  const FCMTokenSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fcmState = ref.watch(fcmTokenProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(fcmTokenProvider.notifier).refreshToken();
            },
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Token',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.notifications,
                          color: fcmState.hasError ? Colors.red : Colors.green,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Push Notifications',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildStatusTile(
                      'Notifications Enabled',
                      fcmState.hasToken && !fcmState.hasError,
                      Icons.check_circle,
                      Icons.cancel,
                    ),
                    _buildStatusTile(
                      'Token Available',
                      fcmState.hasToken,
                      Icons.check_circle,
                      Icons.cancel,
                    ),
                    _buildStatusTile(
                      'Loading',
                      fcmState.isLoading,
                      Icons.hourglass_empty,
                      Icons.hourglass_empty,
                    ),
                    if (fcmState.hasError)
                      _buildStatusTile(
                        'Error',
                        true,
                        Icons.error,
                        Icons.error,
                        errorColor: true,
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Actions Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Actions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: fcmState.isLoading
                                ? null
                                : () {
                                    ref
                                        .read(fcmTokenProvider.notifier)
                                        .refreshToken();
                                  },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Refresh Token'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: fcmState.hasToken
                                ? () {
                                    _showTokenDialog(context, fcmState.token!);
                                  }
                                : null,
                            icon: const Icon(Icons.copy),
                            label: const Text('View Token'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Debug Widget (only in debug mode)
            if (const bool.fromEnvironment('DEBUG_MODE'))
              const FCMTokenDebugWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusTile(
    String title,
    bool value,
    IconData trueIcon,
    IconData falseIcon, {
    bool errorColor = false,
  }) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Icon(
              value ? trueIcon : falseIcon,
              color: errorColor
                  ? Colors.red
                  : value
                      ? Colors.green
                      : Colors.grey,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Text(
              value ? 'Yes' : 'No',
              style: TextStyle(
                color: errorColor
                    ? Colors.red
                    : value
                        ? Colors.green
                        : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );

  void _showTokenDialog(BuildContext context, String token) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('FCM Token'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your device token for push notifications:',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
              child: SelectableText(
                token,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
