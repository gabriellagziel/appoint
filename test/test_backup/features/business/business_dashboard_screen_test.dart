import 'package:appoint/features/business/screens/business_dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/firebase_mocks.dart';
import '../../firebase_test_helper.dart';

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
    setupFirebaseMocks();
  });

  testWidgets('Business Dashboard shows welcome text',
      (WidgetTester tester) async {
    final firestore = MockFirebaseFirestore();

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: BusinessDashboardScreen()),
      ),
    );

    expect(find.text('Welcome to Your Business Dashboard'), findsOneWidget);

    verifyZeroInteractions(firestore);
  });
}
