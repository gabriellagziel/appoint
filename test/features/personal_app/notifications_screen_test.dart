import 'package:appoint/features/personal_app/ui/notifications_screen.dart';
import 'package:appoint/models/notification_payload.dart';
import 'package:appoint/providers/user_notifications_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'firebase_test_helper.dart';

void main() {
  setUpAll(() async {});
  group('NotificationsScreen', () {
    testWidgets('shows notifications from provider', (tester) async {
      final notifications = [
        NotificationPayload(id: '1', title: 'A', body: 'a'),
        NotificationPayload(id: '2', title: 'B', body: 'b'),
      ];

      final container = ProviderContainer(
        overrides: [
          userNotificationsProvider.overrideWith((ref) async => notifications),
        ],
      );

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
