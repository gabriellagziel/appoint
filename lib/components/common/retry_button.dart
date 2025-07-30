import 'package:flutter/material.dart';

/// Reusable icon button for retry actions.
class RetryButton extends StatelessWidget {
  const RetryButton({required this.onPressed, super.key});

  /// Callback when the user taps the button.
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: onPressed,
            icon: const Icon(Icons.refresh),
          ),
          const SizedBox(height: 4),
          const Text('Try Again'),
        ],
      );
}
