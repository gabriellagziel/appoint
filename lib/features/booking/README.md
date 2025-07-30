# Chat-Driven Booking Feature

This feature provides a conversational interface for booking appointments through a structured chat flow.

## Components

### Models
- `ChatMessage`: Simple message representation with text and user/bot distinction
- `BookingDraft`: Holds booking data and chat history with structured flow

### Provider
- `BookingDraftProvider`: Manages the structured booking flow with step-by-step progression

### Widgets
- `ChatFlowWidget`: The main chat interface widget
- `ChatBookingScreen`: Screen wrapper for the chat widget

## Flow Structure

The chat booking follows a structured flow:

1. **Welcome Message**: Bot asks for appointment type
2. **Type Selection**: User specifies appointment type (e.g., "Haircut", "Massage")
3. **Date Selection**: Bot asks for date in YYYY-MM-DD format
4. **Time Selection**: Bot asks for time in HH:MM format
5. **Notes**: Bot asks for any additional notes
6. **Confirmation**: Bot shows summary and asks for confirmation
7. **Submission**: Bot submits booking and confirms

## Usage

1. Navigate to `/chat-booking` to start a chat booking session
2. Follow the bot's prompts to complete your booking
3. The system validates inputs and guides you through each step
4. Confirm your booking to complete the process

## Features

- **Structured Flow**: Step-by-step booking process
- **Input Validation**: Date format validation and error handling
- **State Management**: Tracks booking progress through Riverpod
- **Auto-scroll**: Automatically scrolls to new messages
- **Responsive Design**: Works on different screen sizes

## Bot Responses

The bot provides structured guidance:
- Welcome message on initialization
- Clear prompts for each booking step
- Error messages for invalid inputs
- Summary before confirmation
- Success/failure messages

## Integration

The chat booking feature is integrated into the existing booking flow:
- Accessible via the "Book via Chat" button in the main booking screen
- Uses the same underlying booking models and services
- Maintains consistency with the existing app architecture
- Ready for integration with actual booking service calls 