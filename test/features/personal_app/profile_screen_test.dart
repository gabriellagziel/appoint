import 'package:appoint/features/personal_app/ui/profile_screen.dart';
import 'package:appoint/models/user_profile.dart';
import 'package:appoint/providers/user_profile_provider.dart';
import 'package:appoint/providers/user_subscription_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'firebase_test_helper.dart';

void main() {
  setUpAll(() async {});

  group('ProfileScreen', () {
    testWidgets('renders profile data and edit button', (tester) async {
      const profile = UserProfile(id: '1', name: 'Tester', email: 't@e.com');

      final container = ProviderContainer(
        overrides: [
          currentUserProfileProvider
              .overrideWith((ref) => Stream.value(profile)),
          userSubscriptionProvider.overrideWith((ref) async => true),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: ProfileScreen()),
        ),
      );

      await tester.pump();

      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.text('Tester'), findsOneWidget);
      expect(find.text('t@e.com'), findsOneWidget);
      expect(find.text('Premium Subscriber'), findsOneWidget);
      expect(find.text('Edit Profile'), findsOneWidget);

      container.dispose();
    });
  });
}
