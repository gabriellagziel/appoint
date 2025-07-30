import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appoint/features/personal_app/login_screen.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Personal LoginScreen', () {
    testWidgets('shows login screen text', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      expect(find.text('Login Screen'), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
