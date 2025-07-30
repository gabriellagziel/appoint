import 'package:appoint/components/common/retry_button.dart';
import 'package:flutter/material.dart';

/// Simple error screen with retry action.
class ErrorScreen extends StatelessWidget {
  const ErrorScreen({
    required this.message,
    required this.onTryAgain,
    super.key,
  });
  final String message;
  final VoidCallback onTryAgain;

  @override
  Widget build(BuildContext context) => Scaffold(
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
