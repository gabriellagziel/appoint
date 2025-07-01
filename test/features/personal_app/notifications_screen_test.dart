import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/features/personal_app/ui/notifications_screen.dart';
import 'package:appoint/providers/user_notifications_provider.dart';
import 'package:appoint/models/notification_payload.dart';
import '../../fake_firebase_setup.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await initializeTestFirebase();
  group('NotificationsScreen', () {
    testWidgets('shows notifications from provider', (final tester) async {
      final notifications = [
        NotificationPayload(id: '1', title: 'A', body: 'a'),
        NotificationPayload(id: '2', title: 'B', body: 'b'),
      ];

      final container = ProviderContainer(overrides: [
        userNotificationsProvider.overrideWith((final ref) async => notifications),
      ]);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: NotificationsScreen(),
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(ListTile), findsNWidgets(2));

      container.dispose();
    });
  });
}
