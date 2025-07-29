import 'package:appoint/providers/fcm_token_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Debug widget to display FCM token status
/// Only use this in development builds
class FCMTokenDebugWidget extends ConsumerWidget {
  const FCMTokenDebugWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fcmState = ref.watch(fcmTokenProvider);

    return Card(
      margin: const EdgeInsets.all(8),
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
                  'FCM Token Status',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildStatusRow('Token Available', fcmState.hasToken),
            _buildStatusRow('Loading', fcmState.isLoading),
            _buildStatusRow('Has Error', fcmState.hasError),
            if (fcmState.token != null) ...[
              const SizedBox(height: 8),
              const Text(
                'Token:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: SelectableText(
                  fcmState.token!,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
            if (fcmState.error != null) ...[
              const SizedBox(height: 8),
              const Text(
                'Error:',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  fcmState.error!,
                  style: const TextStyle(fontSize: 12, color: Colors.red),
                ),
              ),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: fcmState.isLoading
                        ? null
                        : () {
                            ref.read(fcmTokenProvider.notifier).refreshToken();
                          },
                    child: const Text('Refresh Token'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _copyTokenToClipboard(context, fcmState.token);
                    },
                    child: const Text('Copy Token'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, bool value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            Icon(
              value ? Icons.check_circle : Icons.cancel,
              color: value ? Colors.green : Colors.red,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(label),
            const Spacer(),
            Text(
              value ? 'Yes' : 'No',
              style: TextStyle(
                color: value ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );

  void _copyTokenToClipboard(BuildContext context, String? token) {
    if (token != null) {
      // In a real app, you would use Clipboard.setData
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Token copied to clipboard'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No token available'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
