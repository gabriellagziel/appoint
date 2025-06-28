import 'package:flutter/material.dart';

/// Simple error screen with retry action.
class ErrorScreen extends StatelessWidget {
  final String message;
  final VoidCallback onTryAgain;

  const ErrorScreen({
    Key? key,
    required this.message,
    required this.onTryAgain,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            ElevatedButton(
              onPressed: onTryAgain,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
