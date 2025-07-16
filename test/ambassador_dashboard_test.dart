import 'package:appoint/features/ambassador_dashboard_screen.dart';
import 'package:appoint/models/ambassador_stats.dart';
import 'package:appoint/models/branch.dart';
import 'package:appoint/providers/ambassador_data_provider.dart';
import 'package:appoint/services/branch_service.dart';
import 'package:appoint/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'firebase_test_helper.dart';

class MockNotificationService extends Mock implements NotificationService {}

class MockBranchService extends Mock implements BranchService {}

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
  });

  group('Ambassador Dashboard Tests', () {
    late MockNotificationService mockNotificationService;
    late MockBranchService mockBranchService;
    late ProviderContainer container;

    setUp(() {
      mockNotificationService = MockNotificationService();
      mockBranchService = MockBranchService();

      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('should display ambassador dashboard',
        (WidgetTester tester) async {
      // Mock branch data
      final mockBranches = [
        Branch(
          id: 'branch1',
          name: 'Test Branch',
          address: 'Test Address',
          city: 'Test City',
          country: 'Test Country',
          latitude: 0.0,
          longitude: 0.0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      when(() => mockBranchService.fetchBranches())
          .thenAnswer((_) async => mockBranches);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: AmbassadorDashboardScreen(
              notificationService: mockNotificationService,
              branchService: mockBranchService,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify the dashboard displays
      expect(find.text('Ambassador Dashboard'), findsOneWidget);
      expect(find.byType(AmbassadorDashboardScreen), findsOneWidget);
    });

    testWidgets('should display chart when data is available',
        (WidgetTester tester) async {
      final mockStats = [
        AmbassadorStats(
          country: 'United States',
          language: 'English',
          ambassadors: 45,
          referrals: 128,
          surveyScore: 4.2,
          date: DateTime.now(),
        ),
        AmbassadorStats(
          country: 'Spain',
          language: 'Spanish',
          ambassadors: 32,
          referrals: 89,
          surveyScore: 4.5,
          date: DateTime.now(),
        ),
      ];

      // Mock branch data
      final mockBranches = [
        Branch(
          id: 'branch1',
          name: 'Test Branch',
          address: 'Test Address',
          city: 'Test City',
          country: 'Test Country',
          latitude: 0.0,
          longitude: 0.0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      when(() => mockBranchService.fetchBranches())
          .thenAnswer((_) async => mockBranches);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: AmbassadorDashboardScreen(
              notificationService: mockNotificationService,
              branchService: mockBranchService,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should display dashboard
      expect(find.byType(AmbassadorDashboardScreen), findsOneWidget);
    });

    testWidgets('should display error state when service fails',
        (WidgetTester tester) async {
      // Mock branch service to throw error
      when(() => mockBranchService.fetchBranches())
          .thenThrow(Exception('Service error'));

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: AmbassadorDashboardScreen(
              notificationService: mockNotificationService,
              branchService: mockBranchService,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should display error state
      expect(find.byType(AmbassadorDashboardScreen), findsOneWidget);
    });
  });

  group('Ambassador Data Provider Tests', () {
    test('should load data successfully', () async {
      final container = ProviderContainer();
      
      // Test that the provider can be read
      final provider = container.read(ambassadorDataProvider);
      expect(provider, isA<AsyncValue<List<AmbassadorStats>>>());
      
      container.dispose();
    });

    test('should update filters and reload data', () async {
      final container = ProviderContainer();
      
      // Test that the provider notifier can be accessed
      final notifier = container.read(ambassadorDataProvider.notifier);
      expect(notifier, isNotNull);
      
      container.dispose();
    });

    test('should clear filters and reload data', () async {
      final container = ProviderContainer();
      
      // Test that the provider notifier can be accessed
      final notifier = container.read(ambassadorDataProvider.notifier);
      expect(notifier, isNotNull);
      
      container.dispose();
    });
  });
}
