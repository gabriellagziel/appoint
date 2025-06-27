import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appoint/features/personal_app/ui/profile_screen.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('ProfileScreen', () {
    testWidgets('renders avatar, text, and edit button', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));

      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.text('Username'), findsOneWidget);
      expect(find.text('Bio'), findsOneWidget);
      expect(find.text('Edit'), findsOneWidget);
    });
  });
}
