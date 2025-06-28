import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appoint/features/personal_app/ui/comment_item.dart';
import 'package:appoint/models/comment.dart';
import '../../fake_firebase_setup.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await initializeTestFirebase();

  group('CommentItem', () {
    testWidgets('renders relative time', (tester) async {
      final timestamp = DateTime.now().subtract(const Duration(minutes: 2));
      await tester.pumpWidget(
        MaterialApp(
          home: CommentItem(
            comment: Comment(id: '1', text: 'Hello', createdAt: timestamp),
          ),
        ),
      );

      expect(find.text('Hello'), findsOneWidget);
      expect(find.textContaining('minute'), findsOneWidget);
    });
  });
}
