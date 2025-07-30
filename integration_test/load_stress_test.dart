// @dart=3.4
import 'package:appoint/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Load & Stress Tests', () {
    testWidgets('booking chat load test', (tester) async {
      await binding.watchPerformance(
        () async {
          await app.appMain();
          await tester.pumpAndSettle();

          navigator = tester.state<NavigatorState>(find.byType(Navigator));
          navigator.pushNamed('/chat-booking');
          await tester.pumpAndSettle();

          Future<void> runFlow() async {
            await tester.enterText(find.byType(TextField), 'Haircut');
            await tester.testTextInput.receiveAction(TextInputAction.done);
            await tester.pumpAndSettle();

            await tester.enterText(find.byType(TextField), '2024-01-01');
            await tester.testTextInput.receiveAction(TextInputAction.done);
            await tester.pumpAndSettle();

            await tester.enterText(find.byType(TextField), '10:00');
            await tester.testTextInput.receiveAction(TextInputAction.done);
            await tester.pumpAndSettle();

            await tester.enterText(find.byType(TextField), 'None');
            await tester.testTextInput.receiveAction(TextInputAction.done);
            await tester.pumpAndSettle();

            await tester.enterText(find.byType(TextField), 'yes');
            await tester.testTextInput.receiveAction(TextInputAction.done);
            await tester.pumpAndSettle();
          }

          for (var i = 0; i < 10; i++) {
            await runFlow();
          }
        },
        reportKey: 'booking_load',
      );

      final report =
          binding.reportData!['booking_load'] as Map<String, dynamic>;
      expect(report['90th_percentile_frame_build_time_millis'] < 16.0, isTrue);
    });

    testWidgets('dashboard stress navigation', (tester) async {
      await binding.watchPerformance(
        () async {
          await app.appMain();
          await tester.pumpAndSettle();

          navigator = tester.state<NavigatorState>(find.byType(Navigator));
          for (var i = 0; i < 20; i++) {
            navigator.pushNamed('/dashboard');
            await tester.pumpAndSettle();
            expect(find.text('Dashboard'), findsOneWidget);
            await tester.pageBack();
            await tester.pumpAndSettle();
          }
        },
        reportKey: 'dashboard_stress',
      );

      final report =
          binding.reportData!['dashboard_stress'] as Map<String, dynamic>;
      expect(report['average_frame_build_time_millis'] < 16.0, isTrue);
    });
  });
}
