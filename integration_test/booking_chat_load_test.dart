// @dart=3.4
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:appoint/main.dart' as app;

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Booking Chat Load', () {
    testWidgets('repeated chat booking flow', (final tester) async {
      await binding.watchPerformance(() async {
        await app.appMain();
        await tester.pumpAndSettle();

        final navigator = tester.state<NavigatorState>(find.byType(Navigator));
        navigator.pushNamed('/chat-booking');
        await tester.pumpAndSettle();

        Future<void> runFlow() async {
          await tester.enterText(find.byType(TextField), 'Haircut');
          await tester.testTextInput.receiveAction(TextInputAction.done);
          await tester.pumpAndSettle();

          await tester.enterText(find.byType(TextField), '2025-01-01');
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

        for (var i = 0; i < 20; i++) {
          await runFlow();
        }
      }, reportKey: 'booking_chat_load');

      final report =
          binding.reportData!['booking_chat_load'] as Map<String, dynamic>;
      expect(report['90th_percentile_frame_build_time_millis'] < 16.0, isTrue);
    });
  });
}
