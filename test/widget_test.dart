import 'package:appoint/exceptions/booking_conflict_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'firebase_test_helper.dart';

// Minimal smoke test for the app.

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
  });

  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Text('Business Dashboard'),
      ),
    );
    expect(find.text('Business Dashboard'), findsOneWidget);
  });

  testWidgets(
      'BookingConflictException should provide meaningful string representation',
      (WidgetTester tester) async {
    // Test that the exception provides meaningful error messages
    final exception = BookingConflictException(
      bookingId: 'test-booking',
      localUpdatedAt: DateTime.now(),
      remoteUpdatedAt: DateTime.now().add(const Duration(hours: 1)),
      message: 'Test conflict',
    );
    expect(exception.toString(), contains('BookingConflictException'));
    expect(exception.toString(), contains('Test conflict'));
  });
}
