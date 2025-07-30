import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appoint/features/personal_app/ui/content_detail_screen.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ContentDetailScreen', () {
    testWidgets('displays given content id', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ContentDetailScreen(contentId: '123'),
        ),
      );

      expect(find.text('Content ID: 123'), findsOneWidget);
    });
  });
}
