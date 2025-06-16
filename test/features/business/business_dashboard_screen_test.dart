import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:appoint/features/business/screens/business_dashboard_screen.dart';

void main() {
  testWidgets('renders dashboard screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: BusinessDashboardScreen(),
        ),
      ),
    );

    expect(find.text('Welcome to Business Dashboard'), findsOneWidget);
  });
}
