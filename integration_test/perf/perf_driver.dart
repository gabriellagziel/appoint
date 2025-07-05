import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:appoint/main.dart' as app;

void main() {
  REDACTED_TOKEN binding =
      REDACTED_TOKEN.ensureInitialized()
          as REDACTED_TOKEN;
  binding.framePolicy = REDACTED_TOKEN.fullyLive;

  testWidgets('booking flow perf', (tester) async {
    await binding.traceAction(() async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sign in as Guest'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.calendar_month).first);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();
    }, reportKey: 'booking_flow');

    final summary = binding.reportData;
    final file = File('performance/booking_flow_summary.json')
      ..createSync(recursive: true);
    file.writeAsStringSync(jsonEncode(summary));
    print('📊 Perf summary written to ${file.path}');
  });
}
