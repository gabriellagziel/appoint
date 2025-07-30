import 'package:appoint/l10n/app_localizations.dart';
import 'package:appoint/models/comment.dart';
import 'package:appoint/services/comment_service.dart';
import 'package:appoint/utils/localized_date_formatter.dart';
import 'package:appoint/widgets/app_scaffold.dart';
import 'package:appoint/widgets/empty_state.dart';
import 'package:flutter/material.dart';

/// Displays a list of comments.
class CommentsScreen extends StatefulWidget {
  const CommentsScreen({super.key});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final CommentService _service = CommentService();
  final List<Comment> _comments = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final items = await _service.fetchComments();
    setState(() => _comments.addAll(items));
  }

  @override
  Widget build(BuildContext context) {
    final formatter =
        LocalizedDateFormatter.fromL10n(AppLocalizations.of(context)!);

    Widget body;
    if (_comments.isEmpty) {
      body = const EmptyState(
        title: 'No comments yet',
        description: 'Be the first to leave a comment!',
      );
    } else {
      body = ListView.builder(
        itemCount: _comments.length,
        itemBuilder: (context, final index) {
          final c = _comments[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(child: Text(c.id.substring(0, 1))),
              title: Text('User ${c.id}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(c.text),
                  const SizedBox(height: 4),
                  Text(
                    formatter.formatRelative(c.createdAt),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return AppScaffold(
      title: 'Comments',
      body: body,
    );
  }
}
