import 'package:appoint/features/business/screens/business_dashboard_screen.dart';
import 'package:appoint/models/user_type.dart';
import 'package:appoint/providers/user_provider.dart';
import 'package:appoint/widgets/app_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class MockUser extends User {
  const MockUser({
    required super.id,
    required super.name,
    required super.userType,
    super.email,
    super.phone,
    super.photoUrl,
    super.isAdminFreeAccess = false,
    super.businessMode = false,
    super.businessProfileId,
  });
}

void main() {
  group('Unified BusinessDashboardScreen', () {
    testWidgets('renders business dashboard for business user type', (WidgetTester tester) async {
      const mockBusinessUser = MockUser(
        id: 'business-user-1',
        name: 'Business User',
        userType: UserType.business,
        businessMode: true,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userProvider.overrideWith((ref) => mockBusinessUser),
          ],
          child: const MaterialApp(
            home: BusinessDashboardScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify business-specific content
      expect(find.text('Business Dashboard'), findsOneWidget);
      expect(find.text('Welcome to Your Business Dashboard'), findsOneWidget);
      expect(find.text('Total Appointments'), findsOneWidget);
      expect(find.text('Active Clients'), findsOneWidget);
      expect(find.text('Pending Requests'), findsOneWidget);
      expect(find.text('New Appointment'), findsOneWidget);
      expect(find.text('Add Client'), findsOneWidget);
      expect(find.text('View Calendar'), findsOneWidget);
      expect(find.text('Analytics'), findsOneWidget);

      // Verify business recent activity
      expect(find.text('New appointment booked'), findsOneWidget);
      expect(find.text('John Doe - Haircut'), findsOneWidget);

      // Verify studio-specific content is NOT present
      expect(find.text('Studio Dashboard'), findsNothing);
      expect(find.text('Upcoming Bookings'), findsNothing);
      expect(find.text('Studio Sessions'), findsNothing);
    });

    testWidgets('renders studio dashboard for studio user type', (WidgetTester tester) async {
      const mockStudioUser = MockUser(
        id: 'studio-user-1',
        name: 'Studio User',
        userType: UserType.studio,
        businessMode: true,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userProvider.overrideWith((ref) => mockStudioUser),
          ],
          child: const MaterialApp(
            home: BusinessDashboardScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify studio-specific content
      expect(find.text('Studio Dashboard'), findsOneWidget);
      expect(find.text('Welcome to Your Studio Dashboard'), findsOneWidget);
      expect(find.text('Upcoming Bookings'), findsOneWidget);
      expect(find.text('Studio Sessions'), findsOneWidget);
      expect(find.text('Active Members'), findsOneWidget);
      expect(find.text('Pending Bookings'), findsOneWidget);
      expect(find.text('Calendar'), findsOneWidget);
      expect(find.text('Availability'), findsOneWidget);
      expect(find.text('Studio Booking'), findsOneWidget);

      // Verify studio recent activity
      expect(find.text('Studio session booked'), findsOneWidget);
      expect(find.text('Alice Cooper - Recording'), findsOneWidget);

      // Verify business-specific content is NOT present
      expect(find.text('Business Dashboard'), findsNothing);
      expect(find.text('Total Appointments'), findsNothing);
      expect(find.text('New Appointment'), findsNothing);
      expect(find.text('Add Client'), findsNothing);
    });

    testWidgets('handles null user gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userProvider.overrideWith((ref) => null),
          ],
          child: const MaterialApp(
            home: BusinessDashboardScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should default to business dashboard when user is null
      expect(find.text('Business Dashboard'), findsOneWidget);
      expect(find.text('Welcome to Your Business Dashboard'), findsOneWidget);
    });

    testWidgets('shows app logo only for studio users', (WidgetTester tester) async {
      const mockStudioUser = MockUser(
        id: 'studio-user-1',
        name: 'Studio User',
        userType: UserType.studio,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userProvider.overrideWith((ref) => mockStudioUser),
          ],
          child: const MaterialApp(
            home: BusinessDashboardScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // App logo should be present for studio users
      expect(find.byType(AppLogo), findsOneWidget);
    });

    testWidgets('does not show app logo for business users', (WidgetTester tester) async {
      const mockBusinessUser = MockUser(
        id: 'business-user-1',
        name: 'Business User',
        userType: UserType.business,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userProvider.overrideWith((ref) => mockBusinessUser),
          ],
          child: const MaterialApp(
            home: BusinessDashboardScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // App logo should NOT be present for business users
      expect(find.byType(AppLogo), findsNothing);
    });

    testWidgets('studio bookings section shows empty state correctly', (WidgetTester tester) async {
      const mockStudioUser = MockUser(
        id: 'studio-user-1',
        name: 'Studio User',
        userType: UserType.studio,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userProvider.overrideWith((ref) => mockStudioUser),
          ],
          child: const MaterialApp(
            home: BusinessDashboardScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify empty bookings state
      expect(find.text('No upcoming bookings'), findsOneWidget);
      expect(find.byIcon(Icons.event_busy), findsOneWidget);
    });

    group('Quick Actions Navigation', () {
      testWidgets('studio user can access studio-specific routes', (WidgetTester tester) async {
        const mockStudioUser = MockUser(
          id: 'studio-user-1',
          name: 'Studio User',
          userType: UserType.studio,
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              userProvider.overrideWith((ref) => mockStudioUser),
            ],
            child: MaterialApp(
              home: const BusinessDashboardScreen(),
              routes: {
                '/business/calendar': (context) => const Scaffold(body: Text('Calendar')),
                '/business/availability': (context) => const Scaffold(body: Text('Availability')),
                '/business/profile': (context) => const Scaffold(body: Text('Profile')),
                '/studio/booking': (context) => const Scaffold(body: Text('Studio Booking')),
              },
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Test Calendar navigation
        await tester.tap(find.text('Calendar'));
        await tester.pumpAndSettle();
        expect(find.text('Calendar'), findsOneWidget);
      });
    });
  });
}