import 'package:flutter_test/flutter_test.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/features/business/screens/business_dashboard_screen.dart';
import '../../fake_firebase_setup.dart';
import 'package:mockito/mockito.dart';
import '../../mocks/firebase_mocks.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await initializeTestFirebase();

  testWidgets('Business Dashboard shows welcome text',
      (final WidgetTester tester) async {
    final firestore = MockFirebaseFirestore();

    await tester.pumpWidget(const ProviderScope(
      child: MaterialApp(home: BusinessDashboardScreen()),
    ));

    expect(find.text('Welcome to Business Dashboard'), findsOneWidget);

    verifyZeroInteractions(firestore);
  });
}
