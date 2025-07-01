import 'package:flutter/material.dart';

import 'package:appoint/models/comment.dart';
import 'package:appoint/utils/localized_date_formatter.dart';
import 'package:appoint/l10n/app_localizations.dart';

/// Displays a single comment with a relative timestamp.
class CommentItem extends StatelessWidget {
  final Comment comment;

  const CommentItem({super.key, required this.comment});

  @override
  Widget build(final BuildContext context) {
    final formatter =
        LocalizedDateFormatter.fromL10n(AppLocalizations.of(context)!);
    final timestamp = formatter.formatRelative(comment.createdAt);

    return Card(
      child: ListTile(
        title: Text(comment.text),
        subtitle: Text(timestamp),
      ),
    );
  }
}
