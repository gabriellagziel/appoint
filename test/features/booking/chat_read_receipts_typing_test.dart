import 'package:appoint/features/booking/widgets/chat_flow_widget.dart';
import 'package:appoint/providers/auth_provider.dart';
import 'package:appoint/providers/booking_draft_provider.dart';
import 'package:appoint/providers/firebase_providers.dart';
import 'package:appoint/services/auth_service.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthService extends Mock implements AuthService {}

class _MockUser extends Mock implements User {}

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late _MockAuthService mockAuthService;
  late _MockUser mockUser;

  const userId = 'testUser';
  const otherId = 'otherUser';

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    mockAuthService = _MockAuthService();
    mockUser = _MockUser();

    when(() => mockUser.uid).thenReturn(userId);
    when(() => mockAuthService.currentUser()).thenAnswer((_) async => mockUser);
  });

  Widget wrapWithProviders() => ProviderScope(
        overrides: [
          firestoreProvider.overrideWithValue(fakeFirestore),
          authServiceProvider.overrideWithValue(mockAuthService),
          bookingDraftProvider.overrideWith(
            (ref) => BookingDraftNotifier(
              firestore: fakeFirestore,
              auth: mockAuthService,
            ),
          ),
        ],
        child: MaterialApp(
          home: ChatFlowWidget(auth: mockAuthService),
        ),
      );

  testWidgets('shows welcome message and handles user input', (tester) async {
    await tester.pumpWidget(wrapWithProviders());
    await tester.pumpAndSettle();

    // Wait for the initial bot message
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    // Should show welcome message
    expect(
      find.text('Welcome! What type of appointment would you like?'),
      findsOneWidget,
    );

    // Send a message
    await tester.enterText(find.byType(TextField), 'Hello');
    await tester.tap(find.byIcon(Icons.send));
    await tester.pumpAndSettle();

    // Message should appear
    expect(find.text('Hello'), findsOneWidget);

    // Read receipt should appear for user messages
    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('handles message input and shows read receipts', (tester) async {
    await tester.pumpWidget(wrapWithProviders());
    await tester.pumpAndSettle();

    // Wait for initial state
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    // Send a message
    await tester.enterText(find.byType(TextField), 'Test message');
    await tester.tap(find.byIcon(Icons.send));
    await tester.pumpAndSettle();

    // Message should appear
    expect(find.text('Test message'), findsOneWidget);

    // Read receipt should appear
    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('shows welcome message on initialization', (tester) async {
    await tester.pumpWidget(wrapWithProviders());
    await tester.pumpAndSettle();

    // Wait for initialization
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    // Should show welcome message
    expect(
      find.text('Welcome! What type of appointment would you like?'),
      findsOneWidget,
    );
  });
}
