// @dart=3.4
import 'dart:developer' as developer;

import 'package:appoint/features/studio_business/screens/business_calendar_screen.dart';
import 'package:appoint/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:vm_service/vm_service_io.dart';

Future<int> _heapUsage() async {
  info = await developer.Service.getInfo();
  if (info.serverUri == null) return -1;
  final service = await vmServiceConnectUri(
    'ws://localhost:${info.serverUri!.port}${info.serverUri!.path}ws',
  );
  vmData = await service.getVM();
  final iso = vmData.isolates?.first;
  if (iso == null) return -1;
  usage = await service.getMemoryUsage(iso.id!);
  return usage.heapUsage ?? -1;
}

void main() {
  binding = REDACTED_TOKEN.ensureInitialized();

  group('Calendar Performance Tests', () {
    testWidgets('CalendarWidget build performance test', (tester) async {
      before = await _heapUsage();
      sw = Stopwatch()..start();

      await binding.watchPerformance(
        () async {
          await app.appMain();
          await tester.pumpAndSettle();

          // Navigate to calendar screen
          navigator = tester.state<NavigatorState>(find.byType(Navigator));
          navigator.pushNamed('/business-calendar');
          await tester.pumpAndSettle();

          // Verify calendar widget is present
          expect(find.byType(BusinessCalendarScreen), findsOneWidget);
          expect(find.text('Business Calendar'), findsOneWidget);

          // Test tab switching performance
          await tester.tap(find.text('Week'));
          await tester.pumpAndSettle();

          await tester.tap(find.text('Month'));
          await tester.pumpAndSettle();

          await tester.tap(find.text('Day'));
          await tester.pumpAndSettle();
        },
        reportKey: 'calendar_widget',
      );

      sw.stop();
      after = await _heapUsage();

      // Assert performance requirements
      expect(
        sw.elapsedMilliseconds <= 1000,
        isTrue,
        reason:
            'Calendar widget build should complete within 1000ms, but took ${sw.elapsedMilliseconds}ms',
      );

      binding.reportData ??= <String, dynamic>{};
      binding.reportData!['calendar_widget_response_ms'] =
          sw.elapsedMilliseconds;
      binding.reportData!['calendar_widget_memory_bytes'] = after - before;

      final report =
          binding.reportData!['calendar_widget'] as Map<String, dynamic>;
      expect(report['REDACTED_TOKEN'] < 16.0, isTrue);
    });

    testWidgets('Calendar with many events performance test', (tester) async {
      before = await _heapUsage();
      sw = Stopwatch()..start();

      await binding.watchPerformance(
        () async {
          await app.appMain();
          await tester.pumpAndSettle();

          // Navigate to calendar screen
          navigator = tester.state<NavigatorState>(find.byType(Navigator));
          navigator.pushNamed('/business-calendar');
          await tester.pumpAndSettle();

          // Simulate loading many events (50+ bookings scenario)
          // This would typically be done by mocking the service
          // For now, we test the UI responsiveness with empty state

          // Test responsive layout changes
          await tester.binding.setSurfaceSize(const Size(1200, 800)); // Desktop
          await tester.pumpAndSettle();

          await tester.binding.setSurfaceSize(const Size(800, 600)); // Tablet
          await tester.pumpAndSettle();

          await tester.binding.setSurfaceSize(const Size(400, 800)); // Mobile
          await tester.pumpAndSettle();

          // Reset to default size
          await tester.binding.setSurfaceSize(null);
          await tester.pumpAndSettle();
        },
        reportKey: 'calendar_with_events',
      );

      sw.stop();
      after = await _heapUsage();

      // Assert performance requirements
      expect(
        sw.elapsedMilliseconds <= 1000,
        isTrue,
        reason:
            'Calendar with events should complete within 1000ms, but took ${sw.elapsedMilliseconds}ms',
      );

      binding.reportData ??= <String, dynamic>{};
      binding.reportData!['REDACTED_TOKEN'] =
          sw.elapsedMilliseconds;
      binding.reportData!['REDACTED_TOKEN'] = after - before;

      final report =
          binding.reportData!['calendar_with_events'] as Map<String, dynamic>;
      expect(report['average_frame_build_time_millis'] < 16.0, isTrue);
    });

    testWidgets('Calendar navigation performance test', (tester) async {
      before = await _heapUsage();
      sw = Stopwatch()..start();

      await binding.watchPerformance(
        () async {
          await app.appMain();
          await tester.pumpAndSettle();

          // Navigate to calendar screen
          navigator = tester.state<NavigatorState>(find.byType(Navigator));
          navigator.pushNamed('/business-calendar');
          await tester.pumpAndSettle();

          // Test rapid tab switching
          for (var i = 0; i < 10; i++) {
            await tester.tap(find.text('Day'));
            await tester.pumpAndSettle();

            await tester.tap(find.text('Week'));
            await tester.pumpAndSettle();

            await tester.tap(find.text('Month'));
            await tester.pumpAndSettle();
          }
        },
        reportKey: 'calendar_navigation',
      );

      sw.stop();
      after = await _heapUsage();

      // Assert performance requirements
      expect(
        sw.elapsedMilliseconds <= 1000,
        isTrue,
        reason:
            'Calendar navigation should complete within 1000ms, but took ${sw.elapsedMilliseconds}ms',
      );

      binding.reportData ??= <String, dynamic>{};
      binding.reportData!['calendar_navigation_response_ms'] =
          sw.elapsedMilliseconds;
      binding.reportData!['REDACTED_TOKEN'] = after - before;

      final report =
          binding.reportData!['calendar_navigation'] as Map<String, dynamic>;
      expect(report['REDACTED_TOKEN'] < 16.0, isTrue);
    });
  });
}
