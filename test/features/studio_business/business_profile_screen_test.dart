import 'package:appoint/features/studio_business/screens/business_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../firebase_test_helper.dart';

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
  });

  group('BusinessProfileScreen', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: BusinessProfileScreen(),
          ),
        ),
      );

      // Verify the app bar title
      expect(find.text('Business Profile'), findsOneWidget);

      // Verify form fields are present
      expect(find.text('Business Name'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
      expect(find.text('Phone Number'), findsOneWidget);

      // Verify save button is present
      expect(find.text('Save Changes'), findsOneWidget);
    });

    testWidgets('shows loading indicator when profile is null',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: BusinessProfileScreen(),
          ),
        ),
      );

      // Initially shows loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
