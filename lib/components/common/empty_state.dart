import 'package:flutter/material.dart';
import 'package:appoint/config/theme.dart';

class EmptyState extends StatelessWidget {
  final String title;
  final IconData icon;
  final String? description;

  const EmptyState({
    final Key? key,
    required this.title,
    this.icon = Icons.inbox,
    this.description,
  }) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: AppTheme.secondaryColor),
          const SizedBox(height: 8),
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
          if (description != null) ...[
            const SizedBox(height: 4),
            Text(
              description!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }
}
