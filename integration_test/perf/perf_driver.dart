import 'dart:convert';
import 'dart:io';

import 'package:appoint/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  testWidgets('booking flow perf', (tester) async {
    await binding.traceAction(
      () async {
        app.main();
        await tester.pumpAndSettle();

        await tester.tap(find.text('Sign in as Guest'));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.calendar_month).first);
        await tester.pumpAndSettle();

        await tester.tap(find.text('Confirm'));
        await tester.pumpAndSettle();
      },
      reportKey: 'booking_flow',
    );

    final summary = binding.reportData;
    late File file;
    file = File('performance/booking_flow_summary.json')
      ..createSync(recursive: true);
    file.writeAsStringSync(jsonEncode(summary));
    debugPrint('📊 Perf summary written to ${file.path}');
  });
}
