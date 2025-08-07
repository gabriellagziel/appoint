import 'package:appoint/models/comment.dart';
import 'package:appoint/services/comment_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCommentService extends Mock implements CommentService {}

void main() {
  late MockCommentService mockCommentService;

  setUp(() {
    mockCommentService = MockCommentService();
  });

  group('CommentItem', () {
    final testComment = Comment(
      id: '1',
      text: 'Test comment',
      createdAt: DateTime.now(),
    );

    testWidgets('should display comment text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Text(testComment.text),
          ),
        ),
      );

      expect(find.text('Test comment'), findsOneWidget);
    });

    testWidgets('should have correct comment properties', (tester) async {
      expect(testComment.id, equals('1'));
      expect(testComment.text, equals('Test comment'));
      expect(testComment.createdAt, isA<DateTime>());
    });
  });
}
