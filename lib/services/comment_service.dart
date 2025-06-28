import 'dart:async';

import '../models/comment.dart';

/// Simple comment service used for the comments UI widget tests.
class CommentService {
  Future<List<Comment>> fetchComments() async {
    return [
      Comment(
          id: '1',
          username: 'Alice',
          text: 'First!',
          createdAt: DateTime.now()),
      Comment(
          id: '2',
          username: 'Bob',
          text: 'Nice post',
          createdAt: DateTime.now()),
    ];
  }

  Future<void> postComment(String text) async {
    // Stubbed network call
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }
}
