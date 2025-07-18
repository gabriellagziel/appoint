import 'dart:async';

import 'package:appoint/models/playtime_chat.dart';
import 'package:appoint/providers/auth_provider.dart';
import 'package:appoint/providers/firebase_providers.dart';
import 'package:appoint/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Holds the booking draft data and chat history
class BookingDraft {

  BookingDraft({
    this.type,
    this.date,
    this.time,
    this.notes,
    final List<ChatMessage>? chatMessages,
    this.chatSessionId,
    this.isOtherUserTyping = false,
  }) : chatMessages = chatMessages ?? [];
  String? type;
  DateTime? date;
  String? time;
  String? notes;
  final List<ChatMessage> chatMessages;
  final String? chatSessionId;
  final bool isOtherUserTyping;

  BookingDraft copyWith({
    final String? type,
    final DateTime? date,
    final String? time,
    final String? notes,
    final List<ChatMessage>? chatMessages,
    final String? chatSessionId,
    final bool? isOtherUserTyping,
  }) => BookingDraft(
      type: type ?? this.type,
      date: date ?? this.date,
      time: time ?? this.time,
      notes: notes ?? this.notes,
      chatMessages: chatMessages ?? List.from(this.chatMessages),
      chatSessionId: chatSessionId ?? this.chatSessionId,
      isOtherUserTyping: isOtherUserTyping ?? this.isOtherUserTyping,
    );
}

class BookingDraftNotifier extends StateNotifier<BookingDraft> {

  BookingDraftNotifier({
    required FirebaseFirestore firestore,
    required AuthService auth,
  })  : _firestore = firestore,
        _auth = auth,
        super(BookingDraft()) {
    _initializeChat();
  }
  final FirebaseFirestore _firestore;
  final AuthService _auth;
  StreamSubscription<DocumentSnapshot>? _chatSubscription;
  StreamSubscription<DocumentSnapshot>? _typingSubscription;

  Future<void> _initializeChat() async {
    final currentUser = await _auth.currentUser();
    if (currentUser != null) {
      final sessionId =
          'booking_${currentUser.uid}_${DateTime.now().millisecondsSinceEpoch}';
      state = state.copyWith(chatSessionId: sessionId);
      _setupChatListeners(sessionId, currentUser.uid);
      // Initialize conversation
      addBotMessage('Welcome! What type of appointment would you like?');
    }
  }

  void _setupChatListeners(String sessionId, String currentUserId) {
    final chatDoc = _firestore.collection('chats').doc(sessionId);

    // Listen to chat messages
    final _chatSubscription = chatDoc.snapshots().listen((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data()!;
        final messages = (data['messages'] as List<dynamic>?)
                ?.map((msg) =>
                    ChatMessage.fromJson(Map<String, dynamic>.from(msg)),)
                .toList() ??
            [];

        state = state.copyWith(chatMessages: messages);
      }
    });

    // Listen to typing status
    final _typingSubscription = chatDoc.snapshots().listen((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data()!;
        final typingUsers = List<String>.from(data['typing'] ?? []);
        final isOtherUserTyping =
            typingUsers.isNotEmpty && !typingUsers.contains(currentUserId);

        state = state.copyWith(isOtherUserTyping: isOtherUserTyping);
      }
    });
  }

  Future<void> addUserMessage(String text) async {
    final currentUser = await _auth.currentUser();
    if (currentUser == null || state.chatSessionId == null) return;

    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: currentUser.uid,
      content: text,
      timestamp: DateTime.now(),
      readBy: [currentUser.uid], // User has read their own message
    );

    // Add to local state immediately
    state = state.copyWith(
      chatMessages: [...state.chatMessages, message],
    );

    // Update Firestore
    await _updateChatInFirestore(message);

    // Mark as typing
    await _setTypingStatus(true);

    _advanceFlow(text);
  }

  Future<void> addBotMessage(String text) async {
    final currentUser = await _auth.currentUser();
    if (currentUser == null || state.chatSessionId == null) return;

    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'bot',
      content: text,
      timestamp: DateTime.now(),
      readBy: [], // Bot messages start unread
    );

    // Add to local state immediately
    state = state.copyWith(
      chatMessages: [...state.chatMessages, message],
    );

    // Update Firestore
    await _updateChatInFirestore(message);

    // Stop typing
    await _setTypingStatus(false);
  }

  Future<void> _updateChatInFirestore(ChatMessage message) async {
    if (state.chatSessionId == null) return;

    final chatDoc = _firestore.collection('chats').doc(state.chatSessionId);
    final messages = state.chatMessages.map((msg) => msg.toJson()).toList();

    await chatDoc.set({
      'sessionId': state.chatSessionId,
      'messages': messages,
      'lastUpdated': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true),);
  }

  Future<void> _setTypingStatus(bool isTyping) async {
    final currentUser = await _auth.currentUser();
    if (currentUser == null || state.chatSessionId == null) return;

    final chatDoc = _firestore.collection('chats').doc(state.chatSessionId);

    if (isTyping) {
      await chatDoc.update({
        'typing': FieldValue.arrayUnion([currentUser.uid]),
      });
    } else {
      await chatDoc.update({
        'typing': FieldValue.arrayRemove([currentUser.uid]),
      });
    }
  }

  Future<void> markMessageAsRead(String messageId) async {
    final currentUser = await _auth.currentUser();
    if (currentUser == null || state.chatSessionId == null) return;

    final updatedMessages = state.chatMessages.map((message) {
      if (message.id == messageId &&
          !message.readBy.contains(currentUser.uid)) {
        return message.copyWith(
          readBy: [...message.readBy, currentUser.uid],
        );
      }
      return message;
    }).toList();

    state = state.copyWith(chatMessages: updatedMessages);

    // Update Firestore
    final chatDoc = _firestore.collection('chats').doc(state.chatSessionId);
    final messages = updatedMessages.map((msg) => msg.toJson()).toList();

    await chatDoc.update({
      'messages': messages,
    });
  }

  Future<void> _advanceFlow(String userInput) async {
    if (state.type == null) {
      state = state.copyWith(type: userInput);
      addBotMessage('Great. Which date works for you? (YYYY-MM-DD)');
    } else if (state.date == null) {
      // parse date from user input
      DateTime? parsedDate;
      try {
        final parsedDate = DateTime.parse(userInput);
      } catch (e) {
        parsedDate = null;
      }
      if (parsedDate != null) {
        state = state.copyWith(date: parsedDate);
        addBotMessage('At what time? (e.g. 14:00)');
      } else {
        addBotMessage(
            "Sorry, I didn't understand that date. Please use YYYY-MM-DD format.",);
      }
    } else if (state.time == null) {
      // assume valid time format
      state = state.copyWith(time: userInput);
      addBotMessage('Any notes to add?');
    } else if (state.notes == null) {
              state = state.copyWith(notes: userInput);
      final summary = 'Here is your summary:\n'
          'Type: ${state.type}\n'
          'Date: ${state.date}\n'
          'Time: ${state.time}\n'
          'Notes: ${state.notes}\n'
          'Confirm? (yes/no)';
      addBotMessage(summary);
    } else {
      if (userInput.toLowerCase() == 'yes') {
        addBotMessage('Submitting your booking...');
        // For now, we'll just show a success message
        // In a real implementation, you'd call the booking service here
        try {
          // Simulate booking submission
          await Future.delayed(const Duration(seconds: 1));
          addBotMessage('Your booking has been confirmed!');
        } catch (e) {
          addBotMessage('Failed to submit booking. Please try again later.');
        }
      } else {
        addBotMessage('Booking cancelled. Start over?');
      }
    }
  }

  @override
  void dispose() {
    _chatSubscription?.cancel();
    _typingSubscription?.cancel();
    super.dispose();
  }
}

/// Provider for the booking draft chat flow
final bookingDraftProvider =
    StateNotifierProvider<BookingDraftNotifier, BookingDraft>(
  (ref) => BookingDraftNotifier(
    firestore: ref.read(firestoreProvider),
    auth: ref.read(authServiceProvider),
  ),
);
