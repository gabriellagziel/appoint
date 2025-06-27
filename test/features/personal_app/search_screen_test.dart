import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appoint/features/personal_app/ui/search_screen.dart';
import '../../fake_firebase_setup.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await initializeTestFirebase();

  group('SearchScreen', () {
    testWidgets('shows search field', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SearchScreen(),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
    });
  });
}
