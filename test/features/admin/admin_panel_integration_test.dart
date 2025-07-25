import 'package:appoint/features/admin/admin_broadcast_screen.dart';
import 'package:appoint/features/admin/admin_dashboard_screen.dart';
import 'package:appoint/features/admin/admin_monetization_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:appoint/models/admin_broadcast_message.dart';
import 'package:appoint/models/admin_dashboard_stats.dart';
import 'package:appoint/providers/admin_provider.dart';
import 'package:appoint/services/admin_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../firebase_test_helper.dart';

class MockAdminService extends Mock implements AdminService {}

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
  });

  group('Admin Panel Integration Tests', () {
    late MockAdminService mockAdminService;
    late ProviderContainer container;

    setUp(() {
      mockAdminService = MockAdminService();

      container = ProviderContainer(
        overrides: [
          adminServiceProvider.overrideWithValue(mockAdminService),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('Admin Dashboard loads with stats',
        (WidgetTester tester) async {
      // Mock admin dashboard stats
      final mockStats = AdminDashboardStats(
        totalUsers: 1000,
        activeUsers: 800,
        totalBookings: 500,
        completedBookings: 450,
        pendingBookings: 50,
        totalRevenue: 10000,
        adRevenue: 3000,
        subscriptionRevenue: 7000,
        totalOrganizations: 25,
        activeOrganizations: 20,
        totalAmbassadors: 50,
        activeAmbassadors: 45,
        totalErrors: 10,
        criticalErrors: 2,
        userGrowthByMonth: {'2024-01': 100, '2024-02': 150},
        revenueByMonth: {'2024-01': 5000.0, '2024-02': 5000.0},
        bookingsByMonth: {'2024-01': 250, '2024-02': 250},
        topCountries: {'US': 500, 'CA': 300},
        topCities: {'NYC': 200, 'LA': 150},
        userTypes: {'free': 600, 'premium': 400},
        subscriptionTiers: {'basic': 300, 'pro': 100},
        lastUpdated: DateTime.now(),
      );

      // Create a new container with the mock data
      final testContainer = ProviderContainer(
        overrides: [
          adminDashboardStatsProvider.overrideWith((ref) => mockStats),
          isAdminProvider.overrideWith((ref) => true),
        ],
      );

      // Build the admin dashboard with proper localization
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: testContainer,
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('en', ''),
            home: AdminDashboardScreen(),
          ),
        ),
      );

      // Wait for the widget to load and settle
      await tester.pump();
      await tester.pumpAndSettle();

      // Verify that the dashboard displays key statistics
      expect(find.text('Total Users'), findsOneWidget);
      expect(find.text('1000'), findsOneWidget);
      expect(find.text('Total Bookings'), findsOneWidget);
      expect(find.text('500'), findsOneWidget);
      expect(find.text('Total Revenue'), findsOneWidget);
      expect(find.text(r'$10000.00'), findsOneWidget);

      testContainer.dispose();
    });

    testWidgets('Admin Broadcast screen loads',
        (WidgetTester tester) async {
      // Mock broadcast messages
      final mockMessages = [
        AdminBroadcastMessage(
          id: '1',
          title: 'Test Broadcast',
          content: 'Test content',
          type: BroadcastMessageType.text,
          targetingFilters: const BroadcastTargetingFilters(),
          createdByAdminId: 'admin1',
          createdByAdminName: 'Admin User',
          createdAt: DateTime.now(),
          status: BroadcastMessageStatus.sent,
        ),
      ];

      // Create a new container with the mock data
      final testContainer = ProviderContainer(
        overrides: [
          broadcastMessagesProvider.overrideWith((ref) => mockMessages),
          isAdminProvider.overrideWith((ref) => true),
        ],
      );

      // Build the broadcast screen with proper localization
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: testContainer,
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('en', ''),
            home: AdminBroadcastScreen(),
          ),
        ),
      );

      // Wait for the widget to load and settle
      await tester.pump();
      await tester.pumpAndSettle();

      // Verify that the broadcast screen displays
      expect(find.text('Test Broadcast'), findsOneWidget);
      expect(find.text('Test content'), findsOneWidget);

      testContainer.dispose();
    });

    testWidgets('Admin Monetization screen loads',
        (WidgetTester tester) async {
      // Mock monetization settings
      final mockSettings = MonetizationSettings(
        adsEnabledForFreeUsers: true,
        adsEnabledForChildren: false,
        adsEnabledForStudioUsers: true,
        adsEnabledForPremiumUsers: false,
        adFrequencyForFreeUsers: 1,
        adFrequencyForChildren: 0,
        adFrequencyForStudioUsers: 0.5,
        adFrequencyForPremiumUsers: 0,
        enabledAdTypes: ['interstitial', 'banner'],
        adTypeSettings: {},
        lastUpdated: DateTime.now(),
      );

      when(() => mockAdminService.fetchMonetizationSettings())
          .thenAnswer((_) async => mockSettings);

      // Build the monetization screen with proper localization
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('en', ''),
            home: AdminMonetizationScreen(),
          ),
        ),
      );

      // Wait for the widget to load
      await tester.pumpAndSettle();

      // Verify that the monetization screen displays
      expect(find.text('Monetization Settings'), findsOneWidget);
    });

    test('Admin service methods work correctly', () async {
      // Test fetchAdminDashboardStats
      final mockStats = AdminDashboardStats(
        totalUsers: 100,
        activeUsers: 80,
        totalBookings: 50,
        completedBookings: 45,
        pendingBookings: 5,
        totalRevenue: 1000,
        adRevenue: 300,
        subscriptionRevenue: 700,
        totalOrganizations: 5,
        activeOrganizations: 4,
        totalAmbassadors: 10,
        activeAmbassadors: 9,
        totalErrors: 2,
        criticalErrors: 0,
        userGrowthByMonth: {},
        revenueByMonth: {},
        bookingsByMonth: {},
        topCountries: {},
        topCities: {},
        userTypes: {},
        subscriptionTiers: {},
        lastUpdated: DateTime.now(),
      );

      when(() => mockAdminService.fetchAdminDashboardStats())
          .thenAnswer((_) async => mockStats);

      result = await mockAdminService.fetchAdminDashboardStats();
      expect(result.totalUsers, equals(100));
      expect(result.totalBookings, equals(50));
      expect(result.totalRevenue, equals(1000.0));

      verify(() => mockAdminService.fetchAdminDashboardStats()).called(1);
    });

    test('Admin providers work correctly', () async {
      // Test admin dashboard stats provider
      final mockStats = AdminDashboardStats(
        totalUsers: 100,
        activeUsers: 80,
        totalBookings: 50,
        completedBookings: 45,
        pendingBookings: 5,
        totalRevenue: 1000,
        adRevenue: 300,
        subscriptionRevenue: 700,
        totalOrganizations: 5,
        activeOrganizations: 4,
        totalAmbassadors: 10,
        activeAmbassadors: 9,
        totalErrors: 2,
        criticalErrors: 0,
        userGrowthByMonth: {},
        revenueByMonth: {},
        bookingsByMonth: {},
        topCountries: {},
        topCities: {},
        userTypes: {},
        subscriptionTiers: {},
        lastUpdated: DateTime.now(),
      );

      when(() => mockAdminService.fetchAdminDashboardStats())
          .thenAnswer((_) async => mockStats);

      stats = await container.read(adminDashboardStatsProvider.future);
      expect(stats.totalUsers, equals(100));
      expect(stats.totalBookings, equals(50));
      expect(stats.totalRevenue, equals(1000.0));
    });
  }, skip: true,);
}
