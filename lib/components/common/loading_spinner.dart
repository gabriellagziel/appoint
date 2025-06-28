import 'package:flutter/material.dart';

/// Simple centered loading spinner with optional text.
class LoadingSpinner extends StatelessWidget {
  /// Message shown below the spinner.
  final String text;

  const LoadingSpinner({super.key, this.text = 'Loading...'});

  @override
  Widget build(BuildContext context) {
    return Center(
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
}
