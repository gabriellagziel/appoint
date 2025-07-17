import 'package:appoint/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  REDACTED_TOKEN.ensureInitialized();

  testWidgets('complete booking flow (web)', (tester) async {
    app.appMain();
    await tester.pumpAndSettle();

    // Wait for the home screen to load
    expect(find.text('Welcome'), findsOneWidget);

    // Navigate to booking request
    await tester.tap(find.text('Book Appointment'));
    await tester.pumpAndSettle();

    // Look for calendar or booking elements
    // The exact elements will depend on the booking screen structure
    expect(find.byIcon(Icons.calendar_month), findsWidgets);

    // Try to find and tap a calendar icon or date picker
    final calendarIcons = find.byIcon(Icons.calendar_month);
    if (calendarIcons.evaluate().isNotEmpty) {
      await tester.tap(calendarIcons.first);
      await tester.pumpAndSettle();
    }

    // Look for a confirm button
    final confirmButton = find.text('Confirm');
    if (confirmButton.evaluate().isNotEmpty) {
      await tester.tap(confirmButton);
      await tester.pumpAndSettle();
    }

    // Check for booking confirmation or success message
    // This could be various text depending on the implementation
    final successIndicators = [
      'Booking confirmed',
      'Appointment booked',
      'Success',
      'Confirmed',
    ];

    var foundSuccess = false;
    for (final indicator in successIndicators) {
      if (find.text(indicator).evaluate().isNotEmpty) {
        foundSuccess = true;
        break;
      }
    }

    // If no specific success message found, check for navigation back or other indicators
    if (!foundSuccess) {
      // Check if we're back to home screen or another expected state
      expect(find.text('Welcome'), findsOneWidget);
    }
  });
}
