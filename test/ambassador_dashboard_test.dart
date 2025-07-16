import 'package:appoint/features/ambassador_dashboard_screen.dart';
import 'package:appoint/models/ambassador_stats.dart';
import 'package:appoint/providers/ambassador_data_provider.dart';
import 'package:appoint/services/ambassador_service.dart';
import 'package:appoint/services/branch_service.dart';
import 'package:appoint/services/notification_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'firebase_test_helper.dart';

class MockAmbassadorService extends Mock implements AmbassadorService {}

class MockNotificationService extends Mock implements NotificationService {}

class MockBranchService extends Mock implements BranchService {}

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
  });

  late MockAmbassadorService mockService;
  late MockNotificationService mockNotificationService;
  late MockBranchService mockBranchService;
  late ProviderContainer container;

  setUp(() {
    mockService = MockAmbassadorService();
    mockNotificationService = MockNotificationService();
    mockBranchService = MockBranchService();

    // Stub the notification service to prevent Firebase calls
    when(() => mockNotificationService.initialize(onMessage: any(named: 'onMessage')))
        .thenAnswer((_) async {});

    // Stub the branch service to return empty list
    when(() => mockBranchService.fetchBranches()).thenAnswer((_) async => []);

    container = ProviderContainer(
      overrides: [
        ambassadorServiceProvider.overrideWithValue(mockService),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('Ambassador Dashboard Tests', () {
    testWidgets('should display loading state initially', (tester) async {
      when(() => mockService.fetchAmbassadorStats()).thenAnswer(
        (_) async => Future.delayed(const Duration(seconds: 1)),
      );

      await tester.pumpWidget(
        createTestAppWithFirebaseHandling(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              home: AmbassadorDashboardScreen(
                notificationService: mockNotificationService,
                branchService: mockBranchService,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsAtLeastNWidgets(1));
    });

    testWidgets('should display data table with ambassador stats',
        (tester) async {
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

      when(() => mockService.fetchAmbassadorStats())
          .thenAnswer((_) async => mockStats);
      when(() => mockService.generateChartData(any())).thenReturn([
        const ChartDataPoint(
          label: 'United States',
          value: 45,
          category: 'ambassadors',
        ),
        const ChartDataPoint(
          label: 'Spain',
          value: 32,
          category: 'ambassadors',
        ),
      ]);

      await tester.pumpWidget(
        createTestAppWithFirebaseHandling(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              home: AmbassadorDashboardScreen(
                notificationService: mockNotificationService,
                branchService: mockBranchService,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(DataTable), findsOneWidget);
      expect(find.text('United States').first, findsOneWidget);
      expect(find.text('Spain').first, findsOneWidget);
      expect(find.text('45').first, findsOneWidget);
      expect(find.text('32').first, findsOneWidget);
    });

    testWidgets('should filter data by country', (tester) async {
      final allStats = [
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

      // Mock service to return all data (filtering happens locally in widget)
      when(() => mockService.fetchAmbassadorStats())
          .thenAnswer((_) async => allStats);
      when(() => mockService.generateChartData(any())).thenReturn([
        const ChartDataPoint(
          label: 'United States',
          value: 45,
          category: 'ambassadors',
        ),
        const ChartDataPoint(
          label: 'Spain',
          value: 32,
          category: 'ambassadors',
        ),
      ]);

      await tester.pumpWidget(
        createTestAppWithFirebaseHandling(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              home: AmbassadorDashboardScreen(
                notificationService: mockNotificationService,
                branchService: mockBranchService,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Initially shows all data
      expect(find.text('United States'), findsWidgets);
      expect(find.text('Spain'), findsWidgets);

      // Find and tap the country dropdown
      countryDropdowns = find.byType(DropdownButtonFormField<String>);
      expect(countryDropdowns, findsWidgets);
      
      // Tap the first dropdown (country filter)
      await tester.tap(countryDropdowns.first);
      await tester.pumpAndSettle();

      // Select "United States" from the dropdown
      usaOption = find.text('United States').last;
      await tester.tap(usaOption);
      await tester.pumpAndSettle();

      // Should only show United States data (local filtering)
      expect(find.text('United States'), findsWidgets);
      expect(find.text('Spain'), findsNothing);
    });

    testWidgets('should filter data by language', (tester) async {
      final allStats = [
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

      // Mock service to return all data (filtering happens locally in widget)
      when(() => mockService.fetchAmbassadorStats())
          .thenAnswer((_) async => allStats);
      when(() => mockService.generateChartData(any())).thenReturn([
        const ChartDataPoint(
          label: 'United States',
          value: 45,
          category: 'ambassadors',
        ),
        const ChartDataPoint(
          label: 'Spain',
          value: 32,
          category: 'ambassadors',
        ),
      ]);

      await tester.pumpWidget(
        createTestAppWithFirebaseHandling(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              home: AmbassadorDashboardScreen(
                notificationService: mockNotificationService,
                branchService: mockBranchService,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Initially shows all data
      expect(find.text('United States'), findsWidgets);
      expect(find.text('Spain'), findsWidgets);

      // Find and tap the language dropdown (second dropdown)
      languageDropdowns = find.byType(DropdownButtonFormField<String>);
      expect(languageDropdowns, findsWidgets);
      
      // Tap the second dropdown (language filter)
      await tester.tap(languageDropdowns.at(1));
      await tester.pumpAndSettle();

      // Select "Spanish" from the dropdown
      spanishOption = find.text('Spanish').last;
      await tester.tap(spanishOption);
      await tester.pumpAndSettle();

      // Should only show Spanish data (local filtering)
      expect(find.text('United States'), findsNothing);
      expect(find.text('Spain'), findsWidgets);
    });

    testWidgets('should clear filters when clear button is pressed',
        (tester) async {
      final allStats = [
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

      when(() => mockService.fetchAmbassadorStats())
          .thenAnswer((_) async => allStats);
      when(() => mockService.generateChartData(any())).thenReturn([
        const ChartDataPoint(
          label: 'United States',
          value: 45,
          category: 'ambassadors',
        ),
        const ChartDataPoint(
          label: 'Spain',
          value: 32,
          category: 'ambassadors',
        ),
      ]);

      await tester.pumpWidget(
        createTestAppWithFirebaseHandling(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              home: AmbassadorDashboardScreen(
                notificationService: mockNotificationService,
                branchService: mockBranchService,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Ensure the clear filters button is visible before tapping
      clearFiltersButton = find.text('Clear Filters');
      expect(clearFiltersButton, findsWidgets);
      await tester.ensureVisible(clearFiltersButton.first);
      await tester.tap(clearFiltersButton.first);
      await tester.pumpAndSettle();

      // Should show all data again
      expect(find.text('United States'), findsWidgets);
      expect(find.text('Spain'), findsWidgets);
    });

    testWidgets(
      'should display chart when data is available',
      (tester) async {
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

        when(() => mockService.fetchAmbassadorStats())
            .thenAnswer((_) async => mockStats);
        when(() => mockService.generateChartData(any())).thenReturn([
          const ChartDataPoint(
            label: 'United States',
            value: 45,
            category: 'ambassadors',
          ),
          const ChartDataPoint(
            label: 'Spain',
            value: 32,
            category: 'ambassadors',
          ),
        ]);

        await tester.pumpWidget(
          createTestAppWithFirebaseHandling(
            UncontrolledProviderScope(
              container: container,
              child: MaterialApp(
                home: AmbassadorDashboardScreen(
                  notificationService: mockNotificationService,
                  branchService: mockBranchService,
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Should display chart
        expect(find.byType(BarChart), findsOneWidget);
      },
    );

    testWidgets(
      'should display error state when service fails',
      (tester) async {
        when(() => mockService.fetchAmbassadorStats())
            .thenThrow(Exception('Service error'));

        await tester.pumpWidget(
          createTestAppWithFirebaseHandling(
            UncontrolledProviderScope(
              container: container,
              child: MaterialApp(
                home: AmbassadorDashboardScreen(
                  notificationService: mockNotificationService,
                  branchService: mockBranchService,
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.error), findsAtLeastNWidgets(1));
        expect(find.textContaining('Error:'), findsAtLeastNWidgets(1));
      },
    );
  });

  group('Ambassador Data Provider Tests', () {
    test('should load data successfully', () async {
      final mockStats = [
        AmbassadorStats(
          country: 'United States',
          language: 'English',
          ambassadors: 45,
          referrals: 128,
          surveyScore: 4.2,
          date: DateTime.now(),
        ),
      ];

      when(() => mockService.fetchAmbassadorStats())
          .thenAnswer((_) async => mockStats);
      when(() => mockService.generateChartData(any())).thenReturn([
        const ChartDataPoint(
          label: 'United States',
          value: 45,
          category: 'ambassadors',
        ),
      ]);

      // Poll until the provider emits AsyncData, then verify
      await Future.doWhile(() async {
        state = container.read(ambassadorDataProvider);
        if (state is AsyncData<AmbassadorData>) {
          expect(state.value.stats, equals(mockStats));
          return false;
        }
        await Future.delayed(const Duration(milliseconds: 10));
        return true;
      });
    });

    test('should update filters and reload data', () async {
      final mockStats = [
        AmbassadorStats(
          country: 'United States',
          language: 'English',
          ambassadors: 45,
          referrals: 128,
          surveyScore: 4.2,
          date: DateTime.now(),
        ),
      ];

      when(() => mockService.fetchAmbassadorStats())
          .thenAnswer((_) async => mockStats);
      when(() => mockService.fetchAmbassadorStats(country: 'United States'))
          .thenAnswer((_) async => mockStats);
      when(() => mockService.generateChartData(any())).thenReturn([
        const ChartDataPoint(
          label: 'United States',
          value: 45,
          category: 'ambassadors',
        ),
      ]);

      notifier = container.read(ambassadorDataProvider.notifier);

      // Update filters
      notifier.updateFilters(country: 'United States');
      await Future.delayed(
        const Duration(milliseconds: 100),
      ); // Wait for async operation

      verify(() => mockService.fetchAmbassadorStats(country: 'United States'))
          .called(1);
    });

    test('should clear filters and reload data', () async {
      final mockStats = [
        AmbassadorStats(
          country: 'United States',
          language: 'English',
          ambassadors: 45,
          referrals: 128,
          surveyScore: 4.2,
          date: DateTime.now(),
        ),
      ];

      when(() => mockService.fetchAmbassadorStats())
          .thenAnswer((_) async => mockStats);
      when(() => mockService.generateChartData(any())).thenReturn([
        const ChartDataPoint(
          label: 'United States',
          value: 45,
          category: 'ambassadors',
        ),
      ]);

      notifier = container.read(ambassadorDataProvider.notifier);

      // Clear filters
      notifier.clearFilters();
      await Future.delayed(
        const Duration(milliseconds: 100),
      ); // Wait for async operation

      verify(() => mockService.fetchAmbassadorStats()).called(2);
    });
  });
}
