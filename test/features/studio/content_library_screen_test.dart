import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appoint/features/studio/ui/content_library_screen.dart';
import '../../fake_firebase_setup.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await initializeTestFirebase();
  group('ContentLibraryScreen', () {
    testWidgets('shows placeholder text', (final WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ContentLibraryScreen(),
        ),
      );

      expect(find.text('No content available yet'), findsOneWidget);
    });
  });
}
