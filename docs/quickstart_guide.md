# App-Oint Quick Start Guide

## Overview

This guide will walk you through the essential steps to get started with App-Oint: authentication, fetching appointments, and booking a slot.

## Prerequisites

- App-Oint SDK installed (`appoint_sdk: ^1.0.0`)
- Valid API credentials
- Flutter development environment
- Basic knowledge of Dart/Flutter

---

## Step 1: Authentication

### 1.1 Initialize the SDK

```dart
import 'package:appoint_sdk/appoint_sdk.dart';

void main() {
  final sdk = AppointSDK();
  sdk.initialize(baseUrl: 'https://api.appoint.com/v1');
}
```

**Screenshot 1**: SDK initialization in Flutter project showing import and initialization code.

### 1.2 Authenticate User

```dart
try {
  final authResponse = await sdk.authenticate(
    email: 'user@example.com',
    password: 'securepassword123',
  );
  
  // Set the authentication token
  sdk.setAuthToken(authResponse.token);
  
  print('✅ Authentication successful!');
  print('User: ${authResponse.user.name}');
} catch (e) {
  print('❌ Authentication failed: $e');
}
```

**Screenshot 2**: Authentication success screen showing user profile and token confirmation with green success indicator.

---

## Step 2: Fetch Appointments

### 2.1 Get Current User Profile

```dart
try {
  final user = await sdk.getCurrentUser();
  print('👤 Current user: ${user.name}');
  print('📧 Email: ${user.email}');
  print('🔑 Role: ${user.role}');
} catch (e) {
  print('❌ Failed to get user profile: $e');
}
```

### 2.2 Retrieve User Bookings

```dart
try {
  final bookings = await sdk.getUserBookings();
  print('📅 Found ${bookings.length} bookings:');
  
  for (final booking in bookings) {
    print('  - ${booking.serviceType} on ${booking.scheduledAt}');
    print('    Status: ${booking.status}');
  }
} catch (e) {
  print('❌ Failed to get bookings: $e');
}
```

**Screenshot 3**: Dashboard showing user profile and list of current bookings with status indicators (pending, confirmed, completed).

---

## Step 3: Book a Slot

### 3.1 Search for Businesses

```dart
try {
  final businesses = await sdk.searchBusinesses(query: 'restaurant');
  print('🏢 Found ${businesses.length} businesses:');
  
  for (final business in businesses) {
    print('  - ${business.name}');
    print('    Services: ${business.services.join(', ')}');
  }
} catch (e) {
  print('❌ Search failed: $e');
}
```

### 3.2 Get Business Details

```dart
try {
  final business = await sdk.getBusiness(businessId: 'business123');
  print('🏢 Business: ${business.name}');
  print('📍 Address: ${business.address}');
  print('📞 Phone: ${business.phone}');
  print('📧 Email: ${business.email}');
} catch (e) {
  print('❌ Failed to get business details: $e');
}
```

### 3.3 Create a Booking

```dart
try {
  final booking = await sdk.createBooking(
    businessId: 'business123',
    scheduledAt: DateTime.now().add(Duration(days: 1)),
    serviceType: 'consultation',
    notes: 'First time visit',
    location: '123 Main St',
    openCall: false,
  );
  
  print('✅ Booking created successfully!');
  print('📅 Appointment: ${booking.scheduledAt}');
  print('🔧 Service: ${booking.serviceType}');
  print('📝 Notes: ${booking.notes}');
} catch (e) {
  print('❌ Failed to create booking: $e');
}
```

**Screenshot 4**: Booking confirmation screen showing appointment details, confirmation message, and booking ID.

---

## Complete Example

```dart
import 'package:appoint_sdk/appoint_sdk.dart';

void main() async {
  final sdk = AppointSDK();
  sdk.initialize(baseUrl: 'https://api.appoint.com/v1');
  
  try {
    // Step 1: Authenticate
    final authResponse = await sdk.authenticate(
      email: 'user@example.com',
      password: 'securepassword123',
    );
    sdk.setAuthToken(authResponse.token);
    
    // Step 2: Get user info and bookings
    final user = await sdk.getCurrentUser();
    final bookings = await sdk.getUserBookings();
    
    // Step 3: Search and book
    final businesses = await sdk.searchBusinesses(query: 'restaurant');
    if (businesses.isNotEmpty) {
      final booking = await sdk.createBooking(
        businessId: businesses.first.id,
        scheduledAt: DateTime.now().add(Duration(days: 1)),
        serviceType: 'consultation',
      );
      print('✅ Booking confirmed: ${booking.id}');
    }
  } catch (e) {
    print('❌ Error: $e');
  } finally {
    sdk.dispose();
  }
}
```

---

## Five-Minute Walkthrough Storyboard

### Scene 1: Introduction (0:00 - 0:30)

- **Visual**: App-Oint logo and welcome screen with SDK installation
- **Narration**: "Welcome to App-Oint! Let's get you started in just 5 minutes."
- **Action**: Show `flutter pub add appoint_sdk` and SDK initialization
- **Code**: Display `import 'package:appoint_sdk/appoint_sdk.dart';` and `AppointSDK().initialize()`

### Scene 2: Authentication (0:30 - 1:30)

- **Visual**: Login form with email/password fields and authentication code
- **Narration**: "First, let's authenticate with your credentials."
- **Action**: Demonstrate `sdk.authenticate()` with success/error handling
- **Code**: Show `await sdk.authenticate(email, password)` and `sdk.setAuthToken()`
- **Screenshot**: Authentication success screen with user profile display

### Scene 3: User Profile (1:30 - 2:30)

- **Visual**: User dashboard with profile information and booking list
- **Narration**: "Now let's fetch your user profile and current bookings."
- **Action**: Show `sdk.getCurrentUser()` and `sdk.getUserBookings()`
- **Code**: Display user profile retrieval and booking list code
- **Screenshot**: Dashboard with user info, bookings, and status indicators

### Scene 4: Business Search (2:30 - 3:30)

- **Visual**: Search interface with business results and business detail view
- **Narration**: "Let's search for businesses and view their details."
- **Action**: Demonstrate `sdk.searchBusinesses()` and `sdk.getBusiness()`
- **Code**: Show business search and detail retrieval code
- **Screenshot**: Business search results with service types and contact information

### Scene 5: Booking Creation (3:30 - 4:30)

- **Visual**: Booking form with date/time picker and service selection
- **Narration**: "Finally, let's create a new booking."
- **Action**: Show `sdk.createBooking()` with all parameters
- **Code**: Display complete booking creation with validation
- **Screenshot**: Booking confirmation screen with appointment details and booking ID

### Scene 6: Summary (4:30 - 5:00)

- **Visual**: Success screen with next steps and complete code example
- **Narration**: "That's it! You're ready to use App-Oint."
- **Action**: Show complete working example with all three steps
- **Code**: Display the full working example from the guide
- **Screenshot**: Final success screen with links to documentation and API playground

---

## Next Steps

1. **Explore the API**: Check out our [API Documentation](https://docs.appoint.com/api)
2. **SDK Reference**: View the complete [SDK Documentation](https://docs.appoint.com/sdk)
3. **Examples**: Browse our [Code Examples](https://docs.appoint.com/examples)
4. **Support**: Get help from our [Developer Community](https://community.appoint.com)

---

## Troubleshooting

### Common Issues

**Authentication Failed**

- Verify your API credentials
- Check network connectivity
- Ensure correct base URL

**No Bookings Found**

- Confirm user has existing bookings
- Check authentication token is valid
- Verify API permissions

**Booking Creation Failed**

- Validate business ID exists
- Check date/time format
- Ensure required fields are provided

### Getting Help

- 📧 Email: <support@appoint.com>
- 💬 Slack: [App-Oint Developers](https://appoint.slack.com)
- 📖 Documentation: [docs.appoint.com](https://docs.appoint.com)
- 🐛 Bug Reports: [GitHub Issues](https://github.com/appoint/issues)
