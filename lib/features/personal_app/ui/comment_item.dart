import 'package:flutter/material.dart';

import '../../../models/comment.dart';
import '../../../utils/localized_date_formatter.dart';

/// Displays a single comment with a relative timestamp.
class CommentItem extends StatelessWidget {
  final Comment comment;

  const CommentItem({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    final timestamp =
        LocalizedDateFormatter.relativeTimeFromNow(comment.createdAt);

    return Card(
      child: ListTile(
        title: Text(comment.text),
        subtitle: Text(timestamp),
      ),
    );
  }
}
