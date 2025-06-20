import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appoint/features/studio_business/screens/business_dashboard_screen.dart';

void main() {
  group('BusinessDashboardScreen', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: BusinessDashboardScreen(),
        ),
      );

      // Verify the app bar title
      expect(find.text('Business Dashboard'), findsOneWidget);

      // Verify section headers
      expect(find.text('Upcoming Bookings'), findsOneWidget);
      expect(find.text('Quick Actions'), findsOneWidget);

      // Verify quick action buttons
      expect(find.text('Calendar'), findsOneWidget);
      expect(find.text('Availability'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);

      // Verify mock bookings are displayed
      expect(find.text('Yoga Class'), findsOneWidget);
      expect(find.text('Personal Coaching'), findsOneWidget);
    });
  });
}
