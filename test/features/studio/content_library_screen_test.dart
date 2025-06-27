import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appoint/features/studio/ui/content_library_screen.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('ContentLibraryScreen', () {
    testWidgets('shows placeholder text', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ContentLibraryScreen(),
        ),
      );

      expect(find.text('No content available yet'), findsOneWidget);
    });
  });
}
