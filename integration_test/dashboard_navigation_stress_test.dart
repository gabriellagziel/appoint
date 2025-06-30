// @dart=3.4
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:appoint/main.dart' as app;

void main() {
  final binding = REDACTED_TOKEN.ensureInitialized()
      as REDACTED_TOKEN;

  group('Dashboard Navigation Stress', () {
    testWidgets('navigate to dashboard repeatedly', (tester) async {
      await binding.watchPerformance(() async {
        await app.appMain();
        await tester.pumpAndSettle();

        final navigator = tester.state<NavigatorState>(find.byType(Navigator));
        for (var i = 0; i < 50; i++) {
          navigator.pushNamed('/dashboard');
          await tester.pumpAndSettle();
          expect(find.text('Dashboard'), findsOneWidget);
          await tester.pageBack();
          await tester.pumpAndSettle();
        }
      }, reportKey: 'dashboard_navigation_stress');

      final report = binding.reportData!['dashboard_navigation_stress']
          as Map<String, dynamic>;
      expect(report['average_frame_build_time_millis'] < 16.0, isTrue);
    });
  });
}
