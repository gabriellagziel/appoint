import 'package:flutter/material.dart';
import 'package:appoint/components/common/retry_button.dart';

/// Simple error screen with retry action.
class ErrorScreen extends StatelessWidget {
  final String message;
  final VoidCallback onTryAgain;

  const ErrorScreen({
    final Key? key,
    required this.message,
    required this.onTryAgain,
  }) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 96,
              color: Colors.red,
            ),
            const SizedBox(height: 24),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            RetryButton(onPressed: onTryAgain),
          ],
        ),
      ),
    );
  }
}
