import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/features/business/screens/business_dashboard_screen.dart';
import '../../test_setup.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await registerFirebaseMock();
  });

  testWidgets('Business Dashboard shows welcome text',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(
      child: MaterialApp(home: BusinessDashboardScreen()),
    ));

    expect(find.text('Welcome to Business Dashboard'), findsOneWidget);
  });
}
