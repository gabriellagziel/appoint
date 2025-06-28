import 'package:flutter/material.dart';
import '../../../components/common/app_scaffold.dart';
import '../../../components/common/empty_state.dart';
import '../../../services/comment_service.dart';
import '../../../models/comment.dart';
import '../../../utils/localized_date_formatter.dart';
import 'comment_item.dart';

/// Screen showing a list of comments.
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
    return AppScaffold(
      title: 'Comments',
      child: _comments.isEmpty
          ? const EmptyState(title: 'No comments yet')
          : ListView.builder(
              itemCount: _comments.length,
              itemBuilder: (context, i) {
                return CommentItem(comment: _comments[i]);
              },
            ),
    );
  }
}
