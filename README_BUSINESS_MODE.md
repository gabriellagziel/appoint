# Business Usage Monitor Implementation

## Overview
This implementation adds a Business Usage Detection System to the App-Oint project that tracks weekly meeting creation and enforces a 21-meeting limit for free users.

## Features Implemented

### ✅ Weekly Usage Monitoring
- **File**: `lib/services/usage_monitor.dart`
- **Provider**: `weeklyUsageProvider` and `usageMonitorProvider`
- **Functionality**: 
  - Tracks meetings created per user per week
  - Automatically resets weekly counts using week-based document IDs
  - Provides real-time usage updates via Firestore streams
  - Handles errors gracefully to prevent booking disruption

### ✅ User Business Mode Fields
- **File**: `lib/models/user_profile.dart`
- **Added Fields**:
  - `businessMode: bool` (defaults to false)
  - `businessProfileId: String?` (optional business profile reference)
- **Serialization**: Properly serialized to/from JSON for Firestore storage

### ✅ Business Mode Provider
- **File**: `lib/providers/user_provider.dart`
- **Provider**: `isBusinessProvider`
- **Functionality**: Exposes whether the current user is in business mode

### ✅ Booking Blocker Modal
- **File**: `lib/widgets/booking_blocker_modal.dart`
- **Features**:
  - Professional design with business-focused messaging
  - Two actions: "Close" and "Open Business Profile"
  - Non-dismissible modal to ensure user awareness
  - Helper function `showBookingBlockerModal()`

### ✅ Booking Flow Integration
- **File**: `lib/features/booking/booking_helper.dart`
- **New Methods**:
  - `canCreateBooking()`: Checks if user can create booking based on limits
  - Enhanced `submitBooking()`: Increments usage counter after successful booking
- **File**: `lib/features/booking/screens/booking_screen.dart`
- **Integration**: Usage check before booking confirmation

### ✅ Weekly Reset Functionality
- **Implementation**: Automatic reset using week-based document IDs
- **Initialization**: Called on app launch (`main.dart`) and booking screen load
- **Method**: `UsageMonitorService.resetWeeklyCountIfNeeded()`

## Technical Implementation

### Usage Tracking Architecture
```dart
// Firestore Structure
/user_usage/{userId}/weekly_usage/{weekKey}
{
  "count": 5,
  "weekStart": "2024-01-15T00:00:00Z",
  "createdAt": serverTimestamp
}
```

### Business Logic Flow
1. **Booking Attempt**: User tries to create a booking
2. **Usage Check**: System checks current weekly usage vs. limit
3. **Business Mode Check**: If user has business mode, skip limit
4. **Limit Enforcement**: If over limit, show upgrade modal
5. **Booking Creation**: If allowed, create booking and increment counter

### Key Constants
- `UsageMonitorService.maxFreeMeetings = 21`
- Weekly reset happens automatically on Monday (start of week)

## Usage Example

```dart
// Check if user can create booking
final canBook = await BookingHelper(ref).canCreateBooking();

// Show modal if blocked
if (!canBook) {
  final upgrade = await showBookingBlockerModal(context);
  if (upgrade == true) {
    // Handle business mode upgrade
  }
}
```

## Future Enhancements (TODO)

1. **Business Profile Setup**: Complete business mode upgrade flow
2. **Stripe Integration**: Business billing and subscription management
3. **Analytics**: Track usage patterns and conversion rates
4. **Notifications**: Weekly usage reminders and limit warnings
5. **Admin Panel**: Business mode management and analytics dashboard

## Testing Notes

- Weekly usage resets automatically based on week boundaries
- Business mode users bypass all limits
- Usage tracking is fault-tolerant (errors don't block bookings)
- Modal provides clear upgrade path for business users
- All providers are properly integrated with Riverpod state management

## Files Modified/Created

### New Files:
- `lib/services/usage_monitor.dart`
- `lib/widgets/booking_blocker_modal.dart`
- `README_BUSINESS_MODE.md`

### Modified Files:
- `lib/models/user_profile.dart` (added business mode fields)
- `lib/providers/user_provider.dart` (added business mode provider)
- `lib/features/booking/booking_helper.dart` (added usage checks)
- `lib/features/booking/screens/booking_screen.dart` (integrated blocking logic)
- `lib/main.dart` (added usage monitor initialization)

## Completion Status

✅ **COMPLETE**: All requirements from the original specification have been implemented and are ready for testing.

The system is now fully functional and will:
- Track weekly meeting creation
- Block users after 21 meetings
- Offer business mode upgrade
- Reset weekly counts automatically
- Maintain proper state management