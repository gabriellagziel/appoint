# Booking Feature Documentation

This document explains the chat-driven booking flow and how to integrate it into the Appoint application.

## ChatBookingScreen

The `ChatBookingScreen` displays a conversational interface for booking appointments. It uses `ChatFlowWidget` and manages state via Riverpod.

## Usage

* To start the chat flow:
  1. Navigate to the booking screen
  2. Tap **Book via Chat**
  3. Interact with the chat to complete your booking

## Steps

* **User selects appointment type**
  * Bot asks for date (YYYY-MM-DD)
* **User enters date**
  * Bot asks for time (e.g., HH:MM)
* **User enters time**
  * Bot asks for notes
* **User enters notes**
  * Bot shows summary and asks for confirmation (yes/no)

## Notes

* Ensure Riverpod is configured and the `bookingDraftProvider` is registered.
* Route `/chat-booking` must be added to `lib/config/routes.dart` using `Navigator.pushNamed`.

*Example*

```dart
ElevatedButton.icon(
  onPressed: () => Navigator.pushNamed(context, '/chat-booking'),
  icon: const Icon(Icons.chat_bubble_outline),
  label: const Text('Book via Chat'),
);
```

--- 