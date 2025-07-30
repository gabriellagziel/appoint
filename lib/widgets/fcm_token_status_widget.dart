import 'package:appoint/providers/fcm_token_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Simple widget to display FCM token status
class FCMTokenStatusWidget extends ConsumerWidget {
  const FCMTokenStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fcmState = ref.watch(fcmTokenProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
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
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildStatusRow('Enabled', fcmState.hasToken && !fcmState.hasError),
            _buildStatusRow('Loading', fcmState.isLoading),
            if (fcmState.hasError)
              _buildStatusRow('Error', true, errorColor: true),
            const SizedBox(height: 8),
            if (fcmState.hasToken)
              ElevatedButton(
                onPressed: () {
                  ref.read(fcmTokenProvider.notifier).refreshToken();
                },
                child: const Text('Refresh Token'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, bool value, {bool errorColor = false}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            Icon(
              value ? Icons.check_circle : Icons.cancel,
              color: errorColor
                  ? Colors.red
                  : value
                      ? Colors.green
                      : Colors.grey,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(label),
            const Spacer(),
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
}
