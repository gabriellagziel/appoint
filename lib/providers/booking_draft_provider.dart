import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Represents a single chat message in the flow
class ChatMessage {
  final String text;
  final bool isUser;
  ChatMessage({required this.text, required this.isUser});
}

/// Holds the booking draft data and chat history
class BookingDraft {
  String? type;
  DateTime? date;
  String? time;
  String? notes;
  final List<ChatMessage> chatMessages;

  BookingDraft({
    this.type,
    this.date,
    this.time,
    this.notes,
    final List<ChatMessage>? chatMessages,
  }) : chatMessages = chatMessages ?? [];

  BookingDraft copyWith({
    final String? type,
    final DateTime? date,
    final String? time,
    final String? notes,
    final List<ChatMessage>? chatMessages,
  }) {
    return BookingDraft(
      type: type ?? this.type,
      date: date ?? this.date,
      time: time ?? this.time,
      notes: notes ?? this.notes,
      chatMessages: chatMessages ?? List.from(this.chatMessages),
    );
  }
}

class BookingDraftNotifier extends StateNotifier<BookingDraft> {
  BookingDraftNotifier() : super(BookingDraft()) {
    // Initialize conversation
    addBotMessage('Welcome! What type of appointment would you like?');
  }

  void addUserMessage(final String text) {
    state = state.copyWith(
      chatMessages: [
        ...state.chatMessages,
        ChatMessage(text: text, isUser: true)
      ],
    );
    _advanceFlow(text);
  }

  void addBotMessage(final String text) {
    state = state.copyWith(
      chatMessages: [
        ...state.chatMessages,
        ChatMessage(text: text, isUser: false)
      ],
    );
  }

  void _advanceFlow(final String userInput) async {
    if (state.type == null) {
      state = state.copyWith(type: userInput);
      addBotMessage('Great. Which date works for you? (YYYY-MM-DD)');
    } else if (state.date == null) {
      // parse date from user input
      DateTime? parsedDate;
      try {
        parsedDate = DateTime.parse(userInput);
      } catch (_) {
        parsedDate = null;
      }
      if (parsedDate != null) {
        state = state.copyWith(date: parsedDate);
        addBotMessage('At what time? (e.g. 14:00)');
      } else {
        addBotMessage(
            'Sorry, I didn\'t understand that date. Please use YYYY-MM-DD format.');
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
}

/// Provider for the booking draft chat flow
final bookingDraftProvider =
    StateNotifierProvider<BookingDraftNotifier, BookingDraft>(
  (final ref) => BookingDraftNotifier(),
);
