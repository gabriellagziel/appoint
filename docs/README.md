# AppointSDK

Official Dart/Flutter client SDK for the App-Oint appointment booking system.

## Features

- 🔐 **Authentication** - Secure user login with JWT tokens
- 👤 **User Management** - Get user profiles and manage account information
- 🏢 **Business Search** - Find and explore businesses in your area
- 📅 **Booking Management** - Create, view, and manage appointments
- 🏥 **Health Checks** - Monitor API service status
- 🛡️ **Error Handling** - Comprehensive exception handling with detailed error messages

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  appoint_sdk: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Quick Start

### 1. Initialize the SDK

```dart
import 'package:appoint_sdk/appoint_sdk.dart';

void main() {
  final sdk = AppointSDK();
  sdk.initialize(baseUrl: 'https://api.appoint.com/v1');
}
```

### 2. Authenticate User

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

### 3. Get User Profile

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

### 4. Search for Businesses

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

### 5. Create a Booking

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
} catch (e) {
  print('❌ Failed to create booking: $e');
}
```

## API Reference

### AppointSDK

The main SDK class that provides all API functionality.

#### Methods

- `initialize(baseUrl)` - Initialize the SDK with API base URL
- `setAuthToken(token)` - Set authentication token for API requests
- `clearAuthToken()` - Clear the current authentication token
- `authenticate(email, password)` - Authenticate user and get token
- `getCurrentUser()` - Get current user's profile
- `searchBusinesses(query)` - Search for businesses
- `getBusiness(businessId)` - Get detailed business information
- `getUserBookings()` - Get all bookings for current user
- `createBooking(...)` - Create a new booking
- `checkLiveness()` - Check if API service is alive
- `checkReadiness()` - Check if API service is ready
- `dispose()` - Clean up resources

### Models

#### User

```dart
class User {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  final DateTime createdAt;
}
```

#### Business

```dart
class Business {
  final String id;
  final String name;
  final String description;
  final String address;
  final String phone;
  final String email;
  final List<String> services;
}
```

#### Booking

```dart
class Booking {
  final String id;
  final String userId;
  final String businessId;
  final DateTime scheduledAt;
  final String serviceType;
  final BookingStatus status;
  final String? notes;
  final String? location;
  final DateTime createdAt;
}
```

#### AuthResponse

```dart
class AuthResponse {
  final String token;
  final User user;
}
```

### Enums

#### UserRole

- `user` - Regular user
- `business` - Business owner/manager
- `admin` - System administrator

#### BookingStatus

- `pending` - Booking is pending confirmation
- `confirmed` - Booking has been confirmed
- `cancelled` - Booking has been cancelled
- `completed` - Appointment has been completed

### Exceptions

#### AppointException

Custom exception thrown by the SDK with detailed error information:

```dart
class AppointException {
  final String message;
  final String? code;
  final int? statusCode;
}
```

## Error Handling

The SDK provides comprehensive error handling with detailed exception messages:

```dart
try {
  final user = await sdk.getCurrentUser();
} on AppointException catch (e) {
  switch (e.message) {
    case 'Authentication required':
      // Handle authentication error
      break;
    case 'User not found':
      // Handle user not found
      break;
    default:
      // Handle other errors
      print('Error: ${e.message}');
  }
}
```

## Health Checks

Monitor the API service status:

```dart
// Check if service is alive
final isAlive = await sdk.checkLiveness();
print('Service alive: $isAlive');

// Check if service is ready
final isReady = await sdk.checkReadiness();
print('Service ready: $isReady');
```

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

## Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

- 📧 Email: <support@appoint.com>
- 💬 Slack: [App-Oint Developers](https://appoint.slack.com)
- 📖 Documentation: [docs.appoint.com](https://docs.appoint.com)
- 🐛 Bug Reports: [GitHub Issues](https://github.com/appoint/appoint-sdk-dart/issues)
