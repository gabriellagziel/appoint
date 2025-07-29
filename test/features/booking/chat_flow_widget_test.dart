import 'package:appoint/features/booking/widgets/chat_flow_widget.dart';
import 'package:appoint/models/playtime_chat.dart';
import 'package:appoint/providers/booking_draft_provider.dart';
import 'package:appoint/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../firebase_test_helper.dart';

class MockBookingDraftNotifier extends Mock implements BookingDraftNotifier {}

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
  });

  group('ChatFlowWidget', () {
    late MockBookingDraftNotifier mockNotifier;
    late ProviderContainer container;

    setUp(() {
      mockNotifier = MockBookingDraftNotifier();

      container = ProviderContainer(
        overrides: [
          bookingDraftProvider.overrideWith((ref) => mockNotifier),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    Widget createTestWidget() => ProviderScope(
          parent: container,
          child: MaterialApp(
            home: ChatFlowWidget(auth: AuthService()),
          ),
        );

    group('Typing Indicator', () {
      testWidgets('should show typing indicator when other user is typing',
          (WidgetTester tester) async {
        // Arrange
        when(() => mockNotifier.state).thenReturn(
          BookingDraft(isOtherUserTyping: true),
        );

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        expect(find.text('Typing'), findsOneWidget);
        expect(find.byType(AnimatedContainer), findsNWidgets(3)); // Typing dots
      });

      testWidgets('should not show typing indicator when no one is typing',
          (WidgetTester tester) async {
        // Arrange
        when(() => mockNotifier.state).thenReturn(
          BookingDraft(),
        );

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        expect(find.text('Typing'), findsNothing);
      });
    });

    group('Read Receipts', () {
      testWidgets(
          'should show read receipt on user messages that have been read',
          (WidgetTester tester) async {
        // Arrange
        final readMessage = ChatMessage(
          id: '1',
          senderId: 'test-user-id',
          content: 'Test message',
          timestamp: DateTime.now(),
          readBy: ['test-user-id'],
        );

        when(() => mockNotifier.state).thenReturn(
          BookingDraft(chatMessages: [readMessage]),
        );

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        expect(find.byIcon(Icons.check), findsOneWidget);
      });

      testWidgets('should not show read receipt on unread messages',
          (WidgetTester tester) async {
        // Arrange
        final unreadMessage = ChatMessage(
          id: '1',
          senderId: 'test-user-id',
          content: 'Test message',
          timestamp: DateTime.now(),
          readBy: [], // Not read
        );

        when(() => mockNotifier.state).thenReturn(
          BookingDraft(chatMessages: [unreadMessage]),
        );

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        expect(find.byIcon(Icons.check), findsNothing);
      });

      testWidgets('should not show read receipt on bot messages',
          (WidgetTester tester) async {
        // Arrange
        final botMessage = ChatMessage(
          id: '1',
          senderId: 'bot',
          content: 'Bot message',
          timestamp: DateTime.now(),
          readBy: ['test-user-id'],
        );

        when(() => mockNotifier.state).thenReturn(
          BookingDraft(chatMessages: [botMessage]),
        );

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        expect(find.byIcon(Icons.check), findsNothing);
      });
    });

    group('Message Length Limit', () {
      testWidgets('should show character counter', (WidgetTester tester) async {
        // Arrange
        when(() => mockNotifier.state).thenReturn(BookingDraft());

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        expect(find.text('0/500'), findsOneWidget);
      });

      testWidgets('should update character counter when typing',
          (WidgetTester tester) async {
        // Arrange
        when(() => mockNotifier.state).thenReturn(BookingDraft());

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        await tester.enterText(find.byType(TextField), 'Hello');
        await tester.pump();

        // Assert
        expect(find.text('5/500'), findsOneWidget);
      });

      testWidgets('should show error when message exceeds limit',
          (WidgetTester tester) async {
        // Arrange
        when(() => mockNotifier.state).thenReturn(BookingDraft());

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        final longMessage = 'a' * 501;
        await tester.enterText(find.byType(TextField), longMessage);
        await tester.pump();

        // Assert
        expect(find.text('Message too long'), findsOneWidget);
        expect(find.text('501/500'), findsOneWidget);
      });

      testWidgets('should disable send button when message is empty',
          (WidgetTester tester) async {
        // Arrange
        when(() => mockNotifier.state).thenReturn(BookingDraft());

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        sendButton = find.byIcon(Icons.send);
        expect(tester.widget<IconButton>(sendButton).onPressed, isNull);
      });

      testWidgets('should disable send button when message exceeds limit',
          (WidgetTester tester) async {
        // Arrange
        when(() => mockNotifier.state).thenReturn(BookingDraft());

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        final longMessage = 'a' * 501;
        await tester.enterText(find.byType(TextField), longMessage);
        await tester.pump();

        // Assert
        sendButton = find.byIcon(Icons.send);
        expect(tester.widget<IconButton>(sendButton).onPressed, isNull);
      });

      testWidgets('should enable send button for valid message',
          (WidgetTester tester) async {
        // Arrange
        when(() => mockNotifier.state).thenReturn(BookingDraft());

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        await tester.enterText(find.byType(TextField), 'Valid message');
        await tester.pump();

        // Assert
        sendButton = find.byIcon(Icons.send);
        expect(tester.widget<IconButton>(sendButton).onPressed, isNotNull);
      });
    });

    group('Message Display', () {
      testWidgets('should display user messages', (WidgetTester tester) async {
        // Arrange
        final userMessage = ChatMessage(
          id: '1',
          senderId: 'test-user-id',
          content: 'User message',
          timestamp: DateTime.now(),
        );

        when(() => mockNotifier.state).thenReturn(
          BookingDraft(chatMessages: [userMessage]),
        );

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        expect(find.text('User message'), findsOneWidget);
      });

      testWidgets('should display bot messages', (WidgetTester tester) async {
        // Arrange
        final botMessage = ChatMessage(
          id: '1',
          senderId: 'bot',
          content: 'Bot message',
          timestamp: DateTime.now(),
        );

        when(() => mockNotifier.state).thenReturn(
          BookingDraft(chatMessages: [botMessage]),
        );

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        expect(find.text('Bot message'), findsOneWidget);
      });
    });

    group('Message Sending', () {
      testWidgets('should call addUserMessage when send button is pressed',
          (WidgetTester tester) async {
        // Arrange
        when(() => mockNotifier.state).thenReturn(BookingDraft());
        when(() => mockNotifier.addUserMessage(any())).thenReturn(null);

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        await tester.enterText(find.byType(TextField), 'Test message');
        await tester.pump();
        await tester.tap(find.byIcon(Icons.send));
        await tester.pump();

        // Assert
        verify(() => mockNotifier.addUserMessage('Test message')).called(1);
      });

      testWidgets('should clear input after sending message',
          (WidgetTester tester) async {
        // Arrange
        when(() => mockNotifier.state).thenReturn(BookingDraft());
        when(() => mockNotifier.addUserMessage(any())).thenReturn(null);

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        await tester.enterText(find.byType(TextField), 'Test message');
        await tester.pump();
        await tester.tap(find.byIcon(Icons.send));
        await tester.pump();

        // Assert
        expect(find.text('0/500'), findsOneWidget); // Counter should be reset
      });

      testWidgets('should not call addUserMessage for empty message',
          (WidgetTester tester) async {
        // Arrange
        when(() => mockNotifier.state).thenReturn(BookingDraft());
        when(() => mockNotifier.addUserMessage(any())).thenReturn(null);

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Try to tap send button (should be disabled)
        sendButton = find.byIcon(Icons.send);
        expect(tester.widget<IconButton>(sendButton).onPressed, isNull);

        // Assert
        verifyNever(() => mockNotifier.addUserMessage(any()));
      });
    });
  });
}
