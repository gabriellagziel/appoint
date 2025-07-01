import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/features/admin/ui/admin_dashboard_screen.dart';
import '../../fake_firebase_setup.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await initializeTestFirebase();

  testWidgets('Admin Dashboard shows overview text', (final WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(
      child: MaterialApp(home: AdminDashboardScreen()),
    ));

    expect(find.text('Admin overview goes here'), findsOneWidget);
  });
}
