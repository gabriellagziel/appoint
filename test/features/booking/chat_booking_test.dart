import 'package:appoint/features/booking/screens/chat_booking_screen.dart';
import 'package:appoint/features/booking/services/booking_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../firebase_test_helper.dart';
import '../../mocks/firebase_mocks.dart';

late BookingService bookingService;
late MockFirebaseFirestore mockFirestore;

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
    setupFirebaseMocks();
    mockFirestore = MockFirebaseFirestore();
    bookingService = BookingService(firestore: mockFirestore);
  });

  group('ChatBookingScreen', () {
    testWidgets('should display chat interface',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ChatBookingScreen(),
          ),
        ),
      );

      // Verify the screen loads
      expect(find.text('Chat Booking'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.send), findsOneWidget);
    });

    testWidgets('should add user message when send button is pressed',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ChatBookingScreen(),
          ),
        ),
      );

      // Enter a message
      await tester.enterText(find.byType(TextField), 'Haircut');

      // Tap send button
      await tester.tap(find.byIcon(Icons.send));
      await tester.pump();

      // Verify message appears
      expect(find.text('Haircut'), findsOneWidget);
    });

    testWidgets('should show welcome message on initialization',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ChatBookingScreen(),
          ),
        ),
      );

      // Verify welcome message appears
      expect(
        find.text('Welcome! What type of appointment would you like?'),
        findsOneWidget,
      );
    });
  });
}
