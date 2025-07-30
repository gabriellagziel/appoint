import 'dart:async';

import 'package:appoint/models/comment.dart';

/// Simple comment service used for the comments UI widget tests.
class CommentService {
  Future<List<Comment>> fetchComments() async => [
        Comment(id: '1', text: 'First!', createdAt: DateTime.now()),
        Comment(id: '2', text: 'Nice post', createdAt: DateTime.now()),
      ];

  Future<void> postComment(String text) async {
    // Stubbed network call
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }
}
