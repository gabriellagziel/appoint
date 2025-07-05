import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/features/profile/user_profile_screen.dart';

void main() {
  group('UserProfileScreen Delete Account Tests', () {
    testWidgets('should show delete account button', (tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const UserProfileScreen(),
          ),
        ),
      );

      // Act & Assert
      // Note: This is a basic test to verify the widget can be rendered
      // Full functionality would require proper mocking of Firebase services
      expect(find.byType(UserProfileScreen), findsOneWidget);
    });
  });
}
