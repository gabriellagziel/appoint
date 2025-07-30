import 'package:appoint/features/admin/ui/admin_dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'firebase_test_helper.dart';

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
  });

  testWidgets('Admin Dashboard shows overview text',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: AdminDashboardScreen()),
      ),
    );

    expect(find.text('Admin overview goes here'), findsOneWidget);
  });
}
