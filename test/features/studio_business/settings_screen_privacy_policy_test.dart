import 'package:appoint/features/studio_business/screens/settings_screen.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../firebase_test_helper.dart';

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
  });

  group('SettingsScreen Privacy Policy Tests', () {
    late FakeFirebaseFirestore fakeFirestore;
    late MockFirebaseAuth mockAuth;
    late MockUser mockUser;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      mockUser = MockUser(
        uid: 'test-user-id',
        email: 'test@example.com',
      );
      mockAuth = MockFirebaseAuth(mockUser: mockUser);
    });

    testWidgets('should show privacy policy tile', (tester) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SettingsScreen(),
          ),
        ),
      );

      // Act & Assert
      expect(find.text('Privacy Policy'), findsOneWidget);
      expect(find.text('Read our privacy policy'), findsOneWidget);
    });

    testWidgets('should tap privacy policy tile', (tester) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SettingsScreen(),
          ),
        ),
      );

      // Act
      privacyPolicyTile = find.text('Privacy Policy');
      await tester.tap(privacyPolicyTile);
      await tester.pumpAndSettle();

      // Assert - The tile should be tappable
      // Note: We can't test the actual URL opening in widget tests
      // That would be tested in integration tests or with mocked url_launcher
      expect(find.text('Privacy Policy'), findsOneWidget);
    });

    testWidgets('should show privacy policy in account settings section',
        (tester) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SettingsScreen(),
          ),
        ),
      );

      // Act & Assert
      expect(find.text('Account Settings'), findsOneWidget);

      // Find the privacy policy tile within the account settings section
      final accountSettingsSection = find.ancestor(
        of: find.text('Privacy Policy'),
        matching: find.byType(Column),
      );
      expect(accountSettingsSection, findsOneWidget);
    });

    testWidgets('should have correct icon for privacy policy', (tester) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SettingsScreen(),
          ),
        ),
      );

      // Act & Assert
      final privacyPolicyTile = find.ancestor(
        of: find.text('Privacy Policy'),
        matching: find.byType(ListTile),
      );

      listTile = tester.widget<ListTile>(privacyPolicyTile);
      expect(listTile.leading, isA<Icon>());

      final icon = listTile.leading! as Icon;
      expect(icon.icon, Icons.security);
    });
  });
}
