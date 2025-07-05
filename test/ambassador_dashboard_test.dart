import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:appoint/features/ambassador_dashboard_screen.dart';
import 'package:appoint/providers/ambassador_data_provider.dart';
import 'package:appoint/services/ambassador_service.dart';
import 'package:appoint/models/ambassador_stats.dart';
import 'fake_firebase_setup.dart';

class MockAmbassadorService extends Mock implements AmbassadorService {}

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await initializeTestFirebase();

  late MockAmbassadorService mockService;
  late ProviderContainer container;

  setUp(() {
    mockService = MockAmbassadorService();
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
    testWidgets('should display loading state initially', (final tester) async {
      when(() => mockService.fetchAmbassadorStats()).thenAnswer(
        (final _) async => Future.delayed(const Duration(seconds: 1)),
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: AmbassadorDashboardScreen(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsAtLeastNWidgets(1));
    });

    testWidgets('should display data table with ambassador stats',
        (final tester) async {
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
          .thenAnswer((final _) async => mockStats);
      when(() => mockService.generateChartData(any())).thenReturn([
        const ChartDataPoint(
            label: 'United States', value: 45.0, category: 'ambassadors'),
        const ChartDataPoint(
            label: 'Spain', value: 32.0, category: 'ambassadors'),
      ]);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: AmbassadorDashboardScreen(),
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

    testWidgets('should filter data by country', (final tester) async {
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

      final filteredStats = [
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
          .thenAnswer((final _) async => allStats);
      when(() => mockService.fetchAmbassadorStats(country: 'United States'))
          .thenAnswer((final _) async => filteredStats);
      when(() => mockService.generateChartData(any())).thenReturn([
        const ChartDataPoint(
            label: 'United States', value: 45.0, category: 'ambassadors'),
        const ChartDataPoint(
            label: 'Spain', value: 32.0, category: 'ambassadors'),
      ]);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: AmbassadorDashboardScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Initially shows all data
      expect(find.text('United States').first, findsOneWidget);
      expect(find.text('Spain').first, findsOneWidget);

      // Select country filter
      await tester.tap(find.byType(DropdownButtonFormField<String>).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('United States').last);
      await tester.pumpAndSettle();

      // Should only show filtered data
      expect(find.text('United States').first, findsOneWidget);
      expect(find.text('Spain'), findsNothing);
    });

    testWidgets('should filter data by language', (final tester) async {
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

      final filteredStats = [
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
          .thenAnswer((final _) async => allStats);
      when(() => mockService.fetchAmbassadorStats(language: 'Spanish'))
          .thenAnswer((final _) async => filteredStats);
      when(() => mockService.generateChartData(any())).thenReturn([
        const ChartDataPoint(
            label: 'United States', value: 45.0, category: 'ambassadors'),
        const ChartDataPoint(
            label: 'Spain', value: 32.0, category: 'ambassadors'),
      ]);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: AmbassadorDashboardScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Initially shows all data
      expect(find.text('United States').first, findsOneWidget);
      expect(find.text('Spain').first, findsOneWidget);

      // Select language filter
      await tester.tap(find.byType(DropdownButtonFormField<String>).at(1));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Spanish').last);
      await tester.pumpAndSettle();

      // Should only show filtered data
      expect(find.text('United States'), findsNothing);
      expect(find.text('Spain').first, findsOneWidget);
    });

    testWidgets('should clear filters when clear button is pressed',
        (final tester) async {
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
          .thenAnswer((final _) async => allStats);
      when(() => mockService.generateChartData(any())).thenReturn([
        const ChartDataPoint(
            label: 'United States', value: 45.0, category: 'ambassadors'),
        const ChartDataPoint(
            label: 'Spain', value: 32.0, category: 'ambassadors'),
      ]);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: AmbassadorDashboardScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Press clear filters button
      await tester.tap(find.text('Clear Filters'));
      await tester.pumpAndSettle();

      // Should show all data again
      expect(find.text('United States'), findsWidgets);
      expect(find.text('Spain'), findsWidgets);
    });

    testWidgets('should display chart when data is available',
        (final tester) async {
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
          .thenAnswer((final _) async => mockStats);
      when(() => mockService.generateChartData(any())).thenReturn([
        const ChartDataPoint(
            label: 'United States', value: 45.0, category: 'ambassadors'),
        const ChartDataPoint(
            label: 'Spain', value: 32.0, category: 'ambassadors'),
      ]);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: AmbassadorDashboardScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should display chart
      expect(find.byType(BarChart), findsOneWidget);
    }, skip: true);

    testWidgets('should display error state when service fails',
        (final tester) async {
      when(() => mockService.fetchAmbassadorStats())
          .thenThrow(Exception('Service error'));

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: AmbassadorDashboardScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.error), findsAtLeastNWidgets(1));
      expect(find.textContaining('Error:'), findsAtLeastNWidgets(1));
    }, skip: true);
  }, skip: true);

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
          .thenAnswer((final _) async => mockStats);
      when(() => mockService.generateChartData(any())).thenReturn([
        const ChartDataPoint(
            label: 'United States', value: 45.0, category: 'ambassadors'),
      ]);

      // Poll until the provider emits AsyncData, then verify
      await Future.doWhile(() async {
        final state = container.read(ambassadorDataProvider);
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
          .thenAnswer((final _) async => mockStats);
      when(() => mockService.fetchAmbassadorStats(country: 'United States'))
          .thenAnswer((final _) async => mockStats);
      when(() => mockService.generateChartData(any())).thenReturn([
        const ChartDataPoint(
            label: 'United States', value: 45.0, category: 'ambassadors'),
      ]);

      final notifier = container.read(ambassadorDataProvider.notifier);

      // Update filters
      notifier.updateFilters(country: 'United States');
      await Future.delayed(
          const Duration(milliseconds: 100)); // Wait for async operation

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
          .thenAnswer((final _) async => mockStats);
      when(() => mockService.generateChartData(any())).thenReturn([
        const ChartDataPoint(
            label: 'United States', value: 45.0, category: 'ambassadors'),
      ]);

      final notifier = container.read(ambassadorDataProvider.notifier);

      // Clear filters
      notifier.clearFilters();
      await Future.delayed(
          const Duration(milliseconds: 100)); // Wait for async operation

      verify(() => mockService.fetchAmbassadorStats()).called(2);
    });
  });
}
