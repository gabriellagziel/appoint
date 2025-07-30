import 'package:flutter/material.dart';

/// Generic screen to display an empty state with an action button.
class EmptyScreen extends StatelessWidget {
  const EmptyScreen({
    required this.subtitle,
    required this.actionLabel,
    required this.onAction,
    super.key,
  });
  final String subtitle;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) => Center(
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
