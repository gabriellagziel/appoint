import 'package:appoint/features/studio_business/screens/business_dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../firebase_test_helper.dart';

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
  });

  group('BusinessDashboardScreen', () {
    testWidgets('renders dashboard with basic structure',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: BusinessDashboardScreen(),
        ),
      );

      expect(find.byType(BusinessDashboardScreen), findsOneWidget);
    });
  });
}
