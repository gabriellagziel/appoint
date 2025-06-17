// Replace with the real file & widget name for your app's entrypoint
import 'package:appoint/main.dart';

// Flutter widgets & material controls
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('OTP flow: send and verify code', (tester) async {
    // Replace `MyApp` with your actual root widget class:
    await tester.pumpWidget(const MyApp());

    // Navigate to OTP screen
    await tester.tap(find.text('Select Minor'));
    await tester.pumpAndSettle();

    // Enter phone and send OTP
    await tester.enterText(find.byType(TextField).first, '1234567890');
    await tester.tap(find.text('Send OTP'));
    await tester.pumpAndSettle();

    // Enter code and verify
    await tester.enterText(find.byType(TextField).at(1), '000000');
    await tester.tap(find.text('Verify'));
    await tester.pumpAndSettle();

    expect(find.text('Booking Request'), findsOneWidget);
  });
}
