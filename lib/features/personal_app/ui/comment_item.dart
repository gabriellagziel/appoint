import 'package:flutter/material.dart';

import '../../../models/comment.dart';
import '../../../utils/localized_date_formatter.dart';
import '../../../l10n/app_localizations.dart';

/// Displays a single comment card with relative timestamp.
class CommentItem extends StatelessWidget {
  final Comment comment;

  const CommentItem({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final formatter = LocalizedDateFormatter(l10n);

    return Card(
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person)),
        title: Text(comment.username),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(comment.text),
            const SizedBox(height: 4),
            Text(
              formatter.formatRelative(comment.createdAt),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
