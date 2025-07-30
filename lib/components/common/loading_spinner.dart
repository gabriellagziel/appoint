import 'package:flutter/material.dart';

/// Simple centered loading spinner with optional text.
class LoadingSpinner extends StatelessWidget {
  const LoadingSpinner({super.key, this.text = 'Loading...'});

  /// Message shown below the spinner.
  final String text;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(text),
          ],
        ),
      );
}
