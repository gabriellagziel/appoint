import 'package:appoint/l10n/app_localizations.dart';
import 'package:appoint/models/comment.dart';
import 'package:appoint/utils/localized_date_formatter.dart';
import 'package:flutter/material.dart';

/// Displays a single comment with a relative timestamp.
class CommentItem extends StatelessWidget {
  const CommentItem({required this.comment, super.key});
  final Comment comment;

  @override
  Widget build(BuildContext context) {
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
