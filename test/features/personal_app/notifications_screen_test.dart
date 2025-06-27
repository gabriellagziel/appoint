import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appoint/features/personal_app/ui/notifications_screen.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('NotificationsScreen', () {
    testWidgets('shows 3 placeholder notifications', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NotificationsScreen(),
        ),
      );

      expect(find.byType(ListTile), findsNWidgets(3));
    });
  });
}
