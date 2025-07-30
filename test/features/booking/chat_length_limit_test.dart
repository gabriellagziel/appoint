import 'package:appoint/features/booking/widgets/chat_flow_widget.dart';
import 'package:appoint/l10n/app_localizations.dart';
import 'package:appoint/providers/firebase_providers.dart';
import 'package:appoint/services/auth_service.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../firebase_test_helper.dart';
import 'chat_length_limit_test.mocks.dart';

@GenerateMocks([FirebaseAuth, User])
void main() {
  setUpAll(() async {
    await initializeTestFirebase();
  });

  group('Chat Message Length Limit Tests', () {
    late MockFirebaseAuth mockAuth;
    late MockUser mockUser;
    late FakeFirebaseFirestore fakeFirestore;

    setUp(() {
      mockAuth = MockFirebaseAuth();
      mockUser = MockUser();
      when(mockUser.uid).thenReturn('testUser');
      when(mockAuth.currentUser).thenReturn(mockUser);
      when(mockAuth.authStateChanges())
          .thenAnswer((_) => Stream.value(mockUser));
      fakeFirestore = FakeFirebaseFirestore();

      // Seed empty chat
      fakeFirestore.collection('chats').doc('chatId').set({
        'sessionId': 'chatId',
        'messages': [],
        'typing': false,
      });
    });

    Widget createTestWidget() => ProviderScope(
          overrides: [
            firebaseAuthProvider.overrideWithValue(mockAuth),
            firestoreProvider.overrideWithValue(fakeFirestore),
          ],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: ChatFlowWidget(auth: AuthService()),
          ),
        );

    testWidgets('shows correct character counter for 400 characters',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find the TextField
      textField = find.byType(TextField);
      expect(textField, findsOneWidget);

      // Enter 400 characters
      final testMessage = 'A' * 400;
      await tester.enterText(textField, testMessage);
      await tester.pump();

      // Check character counter shows "400/500"
      expect(find.text('400/500'), findsOneWidget);

      // Check send button is enabled
      sendButton = find.byIcon(Icons.send);
      expect(sendButton, findsOneWidget);
      expect(tester.widget<IconButton>(sendButton).onPressed, isNotNull);
    });

    testWidgets('shows correct character counter for 500 characters',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find the TextField
      textField = find.byType(TextField);
      expect(textField, findsOneWidget);

      // Enter 500 characters
      final testMessage = 'A' * 500;
      await tester.enterText(textField, testMessage);
      await tester.pump();

      // Check character counter shows "500/500"
      expect(find.text('500/500'), findsOneWidget);

      // Check send button is enabled (at exact limit)
      sendButton = find.byIcon(Icons.send);
      expect(sendButton, findsOneWidget);
      expect(tester.widget<IconButton>(sendButton).onPressed, isNotNull);

      // Check no error message is shown
      expect(find.text('Message too long'), findsNothing);
    });

    testWidgets('shows error and disables send for 501 characters',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find the TextField
      textField = find.byType(TextField);
      expect(textField, findsOneWidget);

      // Enter 501 characters
      final testMessage = 'A' * 501;
      await tester.enterText(textField, testMessage);
      await tester.pump();

      // Check character counter shows "501/500"
      expect(find.text('501/500'), findsOneWidget);

      // Check error message is shown
      expect(find.text('Message too long'), findsOneWidget);

      // Check send button is disabled
      sendButton = find.byIcon(Icons.send);
      expect(sendButton, findsOneWidget);
      expect(tester.widget<IconButton>(sendButton).onPressed, isNull);
    });

    testWidgets('prevents sending message over limit', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find the TextField
      textField = find.byType(TextField);
      expect(textField, findsOneWidget);

      // Enter 501 characters
      final testMessage = 'A' * 501;
      await tester.enterText(textField, testMessage);
      await tester.pump();

      // Try to send by pressing Enter
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      // Verify no message was sent (check if addUserMessage was not called)
      // This is verified by checking that the message input is still there
      expect(find.text(testMessage), findsOneWidget);

      // Try to send by clicking send button (should be disabled)
      sendButton = find.byIcon(Icons.send);
      await tester.tap(sendButton);
      await tester.pump();

      // Verify no message was sent
      expect(find.text(testMessage), findsOneWidget);
    });

    testWidgets('allows sending message at exact limit', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find the TextField
      textField = find.byType(TextField);
      expect(textField, findsOneWidget);

      // Enter 500 characters
      final testMessage = 'A' * 500;
      await tester.enterText(textField, testMessage);
      await tester.pump();

      // Send by pressing Enter
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      // Verify message was sent (input should be cleared)
      expect(find.text(testMessage), findsNothing);
    });

    testWidgets('updates counter in real-time as user types', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find the TextField
      textField = find.byType(TextField);
      expect(textField, findsOneWidget);

      // Start typing
      await tester.enterText(textField, 'Hello');
      await tester.pump();

      // Check counter shows "5/500"
      expect(find.text('5/500'), findsOneWidget);

      // Add more text
      await tester.enterText(textField, 'Hello World!');
      await tester.pump();

      // Check counter shows "12/500"
      expect(find.text('12/500'), findsOneWidget);

      // Clear text
      await tester.enterText(textField, '');
      await tester.pump();

      // Check counter shows "0/500"
      expect(find.text('0/500'), findsOneWidget);
    });
  });
}
