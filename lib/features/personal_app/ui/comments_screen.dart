import 'package:flutter/material.dart';
import '../../../models/comment.dart';
import '../../../services/comment_service.dart';
import '../../../utils/localized_date_formatter.dart';
import '../../../widgets/app_scaffold.dart';
import '../../../widgets/empty_state.dart';
import '../../../l10n/app_localizations.dart';

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
      body = const EmptyState(message: 'No comments yet');
    } else {
      body = ListView.builder(
        itemCount: _comments.length,
        itemBuilder: (context, index) {
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
      appBar: AppBar(title: const Text('Comments')),
      body: body,
    );
  }
}
