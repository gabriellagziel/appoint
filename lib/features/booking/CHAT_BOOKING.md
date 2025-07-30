# Chat Booking Feature

This document provides a comprehensive overview of the chat-driven booking flow in the Appoint application. It covers setup, usage instructions, integration details, and testing.

## Overview

The chat booking feature allows users to book appointments through a conversational interface. Users interact with a chat bot that guides them step-by-step through the booking process: Type → Date → Time → Notes → Confirm.

## Features

- **Conversational Interface:** Users interact with a chat bot that guides them step-by-step.
- **Structured Flow:** Follows the sequence: Type → Date → Time → Notes → Confirm.
- **Input Validation:** Validates date format (YYYY-MM-DD) and time format (HH:MM).
- **Error Handling:** Provides user-friendly prompts for invalid inputs.
- **Auto-scroll:** Automatically scrolls to display new messages.
- **State Management:** Uses Riverpod to maintain chat state.
- **Responsive Design:** Works on different screen sizes.

## Installation

1. Ensure Riverpod is added to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_riverpod: ^2.0.0
```

1. Run code generation (if using Freezed or similar):

```bash
dart run build_runner build --delete-conflicting-outputs
```

## File Structure

```text
lib/
├── providers/
│   └── booking_draft_provider.dart
├── features/booking/
│   ├── widgets/
│   │   └── chat_flow_widget.dart
│   ├── screens/
│   │   └── chat_booking_screen.dart
│   └── CHAT_BOOKING.md
├── config/
│   └── routes.dart
└── test/features/booking/
    └── chat_booking_test.dart
```

## Integration

### Provider: bookingDraftProvider

The `bookingDraftProvider` manages the structured booking flow with step-by-step progression:

```dart
final bookingDraftProvider =
    StateNotifierProvider<BookingDraftNotifier, BookingDraft>(
  (ref) => BookingDraftNotifier(),
);
```

### Widget: ChatFlowWidget

This widget renders the chat interface and binds to `bookingDraftProvider`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/booking_draft_provider.dart';

class ChatFlowWidget extends ConsumerStatefulWidget {
  const ChatFlowWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<ChatFlowWidget> createState() => _ChatFlowWidgetState();
}
```

### Screen: ChatBookingScreen

Registers the chat widget as a standalone screen:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/chat_flow_widget.dart';

class ChatBookingScreen extends ConsumerWidget {
  const ChatBookingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const ChatFlowWidget();
  }
}
```

## Routing

Add the following to your `lib/config/routes.dart`:

```dart
case '/chat-booking':
  return MaterialPageRoute(
    builder: (_) => const ChatBookingScreen(),
    settings: settings,
  );
```

## Navigation Button

Place this button in your booking screen to launch chat:

```dart
ElevatedButton.icon(
  onPressed: () => Navigator.pushNamed(context, '/chat-booking'),
  icon: const Icon(Icons.chat_bubble_outline),
  label: const Text('Book via Chat'),
);
```

## Usage

1. Navigate to the booking page.
2. Tap **Book via Chat**.
3. Follow the chat prompts:

   **Bot:** "Welcome! What type of appointment would you like?"

   **User:** "Haircut"

   **Bot:** "Great. Which date works for you? (YYYY-MM-DD)"

   **User:** "2024-01-15"

   **Bot:** "At what time? (e.g. 14:00)"

   **User:** "14:30"

   **Bot:** "Any notes to add?"

   **User:** "First time visit"

   **Bot:** "Here is your summary:
   - Type: Haircut
   - Date: 2024-01-15
   - Time: 14:30
   - Notes: First time visit
   Confirm? (yes/no)"

   **User:** "yes"

   **Bot:** "Submitting your booking... Your booking has been confirmed!"

## Flow Structure

The chat booking follows a structured flow:

1. **Welcome Message**: Bot asks for appointment type
2. **Type Selection**: User specifies appointment type
3. **Date Selection**: Bot asks for date in YYYY-MM-DD format
4. **Time Selection**: Bot asks for time in HH:MM format
5. **Notes**: Bot asks for any additional notes
6. **Confirmation**: Bot shows summary and asks for confirmation
7. **Submission**: Bot submits booking and confirms

## Components

### Models

- `ChatMessage`: Simple message representation with text and user/bot distinction
- `BookingDraft`: Holds booking data and chat history with structured flow

### Provider

- `BookingDraftNotifier`: Manages the structured booking flow with step-by-step progression

### Widgets

- `ChatFlowWidget`: The main chat interface widget
- `ChatBookingScreen`: Screen wrapper for the chat widget

## Bot Responses

The bot provides structured guidance:

- Welcome message on initialization
- Clear prompts for each booking step
- Error messages for invalid inputs
- Summary before confirmation
- Success/failure messages

## Testing

Run the chat booking test:

```bash
flutter test test/features/booking/chat_booking_test.dart
```

The tests cover:

- Screen display and UI elements
- User message handling
- Welcome message initialization
- Chat flow interaction

## Dependencies

- `flutter_riverpod`: State management
- `flutter/material.dart`: UI components
- Custom booking models and services

## Future Enhancements

Potential improvements for the chat booking feature:

- Integration with actual booking service
- More sophisticated date/time parsing
- Staff and service selection
- Calendar integration
- Appointment confirmation emails
- Multi-language support
- Voice input support
- Appointment rescheduling via chat

---

_End of documentation._
