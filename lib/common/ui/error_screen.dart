import 'package:appoint/components/common/retry_button.dart';
import 'package:flutter/material.dart';

/// Generic screen to display an error with a retry option.
class ErrorScreen extends StatelessWidget {
  const ErrorScreen({
    required this.message,
    required this.onRetry,
    super.key,
  });
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            RetryButton(onPressed: onRetry),
          ],
        ),
      );
}
