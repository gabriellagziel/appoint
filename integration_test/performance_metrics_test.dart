// @dart=3.4
import 'dart:developer' as developer;

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
  binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Performance Metrics', () {
    testWidgets('booking chat metrics', (tester) async {
      before = await _heapUsage();
      sw = Stopwatch()..start();

      await binding.watchPerformance(
        () async {
          await app.appMain();
          await tester.pumpAndSettle();
          navigator = tester.state<NavigatorState>(find.byType(Navigator));
          navigator.pushNamed('/chat-booking');
          await tester.pumpAndSettle();

          await tester.enterText(find.byType(TextField).first, 'Haircut');
          await tester.testTextInput.receiveAction(TextInputAction.done);
          await tester.pumpAndSettle();
        },
        reportKey: 'booking_chat',
      );

      sw.stop();
      after = await _heapUsage();
      binding.reportData ??= <String, dynamic>{};
      binding.reportData!['booking_chat_response_ms'] = sw.elapsedMilliseconds;
      binding.reportData!['booking_chat_memory_bytes'] = after - before;

      final report =
          binding.reportData!['booking_chat'] as Map<String, dynamic>;
      expect(report['90th_percentile_frame_build_time_millis'] < 16.0, isTrue);
    });

    testWidgets('dashboard flow metrics', (tester) async {
      before = await _heapUsage();
      sw = Stopwatch()..start();

      await binding.watchPerformance(
        () async {
          await app.appMain();
          await tester.pumpAndSettle();
          navigator = tester.state<NavigatorState>(find.byType(Navigator));
          for (var i = 0; i < 5; i++) {
            navigator.pushNamed('/dashboard');
            await tester.pumpAndSettle();
            expect(find.text('Dashboard'), findsOneWidget);
            await tester.pageBack();
            await tester.pumpAndSettle();
          }
        },
        reportKey: 'dashboard_flow',
      );

      sw.stop();
      after = await _heapUsage();
      binding.reportData ??= <String, dynamic>{};
      binding.reportData!['dashboard_flow_response_ms'] =
          sw.elapsedMilliseconds;
      binding.reportData!['dashboard_flow_memory_bytes'] = after - before;

      final report =
          binding.reportData!['dashboard_flow'] as Map<String, dynamic>;
      expect(report['average_frame_build_time_millis'] < 16.0, isTrue);
    });
  });
}
