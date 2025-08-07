# Booking System

The Booking System enables users to schedule and manage appointments with service providers.

## 🎯 Overview

The booking system provides:
- Appointment scheduling and management
- Real-time availability checking
- Booking confirmation and reminders
- Calendar integration
- Payment processing

## 📁 File Structure

```
lib/features/booking/
├── booking_confirm_screen.dart      # Booking confirmation
├── booking_screen.dart              # Main booking interface
├── models/                          # Booking data models
│   ├── appointment.dart
│   └── booking_request.dart
├── services/                        # Booking business logic
│   ├── booking_service.dart
│   └── availability_service.dart
└── widgets/                         # Booking UI components
    ├── time_slot_picker.dart
    └── booking_summary.dart
```

## 🔧 Key Components

### BookingScreen
- **Purpose**: Main interface for creating appointments
- **Features**:
  - Service selection
  - Date and time picker
  - Provider selection
  - Real-time availability
  - Booking validation

### BookingConfirmScreen
- **Purpose**: Finalize and confirm bookings
- **Features**:
  - Booking summary
  - Payment integration
  - Confirmation flow
  - Calendar sync options

### BookingService
- **Purpose**: Handle booking business logic
- **Features**:
  - Create and manage appointments
  - Check availability
  - Handle conflicts
  - Send notifications

## 🔄 Booking Flow

1. **Service Selection**: User chooses service type
2. **Provider Selection**: Select from available providers
3. **Date/Time Selection**: Pick available time slot
4. **Confirmation**: Review and confirm booking
5. **Payment**: Process payment (if required)
6. **Confirmation**: Send confirmation and calendar invite

## 📅 Calendar Integration

### Google Calendar
- Automatic event creation
- Real-time sync
- Conflict detection
- Reminder management

### Outlook Calendar
- Cross-platform compatibility
- Meeting link generation
- Attendee management

## 💳 Payment Integration

- **Stripe**: Primary payment processor
- **Apple Pay**: iOS payment option
- **Google Pay**: Android payment option
- **Refund Processing**: Automated refund handling

## 🔔 Notifications

### Booking Confirmations
- Email confirmation
- SMS reminders
- Push notifications
- Calendar invites

### Reminders
- 24-hour reminder
- 1-hour reminder
- Custom reminder settings

## 🧪 Testing

Run booking-specific tests:
```bash
flutter test test/features/booking/
```

## 📊 Analytics

Track booking metrics:
- Booking conversion rates
- Popular time slots
- Service preferences
- Cancellation rates
- Revenue analytics

## 🚀 Usage

### Creating a Booking
```dart
final booking = BookingRequest(
  serviceId: 'service_123',
  providerId: 'provider_456',
  dateTime: DateTime.now().add(Duration(days: 1)),
  userId: 'user_789',
);

final appointment = await bookingService.createBooking(booking);
```

### Checking Availability
```dart
final availability = await availabilityService.getAvailability(
  providerId: 'provider_123',
  date: DateTime.now(),
);
```

## 🔐 Security

- **Validation**: Server-side booking validation
- **Authentication**: User authentication required
- **Authorization**: Provider-specific access control
- **Data Protection**: Encrypted booking data 