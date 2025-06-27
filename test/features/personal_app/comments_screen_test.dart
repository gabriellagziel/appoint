import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appoint/features/personal_app/ui/comments_screen.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('CommentsScreen', () {
    testWidgets('shows input field and send button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CommentsScreen(),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.send), findsOneWidget);
    });
  });
}
