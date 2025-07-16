# Notification System Documentation

## Overview

The notification system has been implemented with both local and FCM (Firebase Cloud Messaging) support. Currently, FCM is implemented as a stub for future integration.

## Features

### ✅ Completed Features

1. **Local Notifications**
   - `sendLocalNotification(title, body)` - Send immediate local notifications
   - `scheduleNotification(title, body, datetime)` - Schedule notifications for future delivery
   - Permission request logic for Android

2. **FCM Stub**
   - `sendPushNotification(fcmToken, title, body)` - Stub implementation for FCM
   - `sendNotificationToUser(uid, title, body)` - Send to user by UID
   - Ready for real FCM integration

3. **Provider Integration**
   - `notificationServiceProvider` - Main service provider
   - `notificationHelperProvider` - Helper methods provider
   - `notificationPermissionsProvider` - Permission state
   - `pendingNotificationsProvider` - Pending notifications state

4. **App Integration**
   - Permission request on app startup (Android only)
   - Notification call when booking is confirmed
   - Error handling and logging

## Usage Examples

### Sending Local Notifications

```dart
// Using the service directly
final notificationService = NotificationService();
await notificationService.sendLocalNotification(
  title: 'Booking Confirmed',
  body: 'Your booking has been confirmed!',
  payload: 'booking_confirmed',
);

// Using the provider
final helper = ref.read(notificationHelperProvider);
await helper.sendLocalNotification(
  title: 'Booking Confirmed',
  body: 'Your booking has been confirmed!',
);
```

### Scheduling Notifications

```dart
final helper = ref.read(notificationHelperProvider);
await helper.scheduleNotification(
  title: 'Appointment Reminder',
  body: 'Your appointment is in 1 hour',
  scheduledDate: DateTime.now().add(Duration(hours: 1)),
);
```

### Sending FCM Notifications (Stub)

```dart
final helper = ref.read(notificationHelperProvider);
await helper.sendNotificationToUser(
  uid: 'user123',
  title: 'New Booking Request',
  body: 'You have a new booking request',
);
```

### Requesting Permissions

```dart
final helper = ref.read(notificationHelperProvider);
final hasPermission = await helper.requestPermissions();
```

## File Structure

```
lib/
├── services/
│   └── notification_service.dart          # Main notification service
├── providers/
│   └── notification_provider.dart         # Provider wrappers
├── features/booking/
│   └── booking_confirm_screen.dart       # Integration example
└── main.dart                             # App startup with permissions
```

## Dependencies Added

- `flutter_local_notifications: ^19.3.0` - Local notifications
- `timezone: ^0.9.2` - Timezone support for scheduled notifications

## Future Enhancements

1. **Real FCM Integration**
   - Replace stub with actual Firebase Cloud Functions calls
   - Add proper error handling for FCM failures
   - Implement token refresh logic

2. **Enhanced Features**
   - Rich notifications with images
   - Action buttons on notifications
   - Notification categories and channels
   - Notification history and management

3. **Platform Support**
   - iOS-specific notification features
   - Web push notifications
   - Desktop notifications

## Testing

The notification system includes basic tests in `test/services/notification_service_test.dart` that verify:
- Service instantiation
- Method availability
- Parameter handling
- Stub functionality

## Notes

- FCM implementation is currently a stub that logs to console
- Permission requests are Android-only for now
- Local notifications work on both Android and iOS
- Error handling is in place for graceful degradation