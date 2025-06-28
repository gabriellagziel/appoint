import 'package:flutter/material.dart';

/// Generic screen to display an empty state with an action button.
class EmptyScreen extends StatelessWidget {
  final String subtitle;
  final String actionLabel;
  final VoidCallback onAction;

  const EmptyScreen({
    super.key,
    required this.subtitle,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(subtitle, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onAction,
            child: Text(actionLabel),
          ),
        ],
      ),
    );
  }
}
