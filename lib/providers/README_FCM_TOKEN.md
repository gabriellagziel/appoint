# FCM Token Provider Documentation

## Overview

The FCM Token Provider is a comprehensive solution for managing Firebase Cloud Messaging (FCM) tokens in the APP-OINT application. It handles token retrieval, storage, backend synchronization, and automatic token refresh.

## Features

- ✅ **Automatic Token Retrieval**: Gets FCM token on app initialization
- ✅ **Permission Handling**: Requests notification permissions from users
- ✅ **Token Refresh**: Automatically handles token refresh events
- ✅ **Backend Sync**: Sends tokens to backend API for server-side storage
- ✅ **Authentication Integration**: Syncs tokens when users log in/out
- ✅ **Error Handling**: Comprehensive error handling and state management
- ✅ **Platform Detection**: Detects and reports platform (Android/iOS/Web)
- ✅ **State Management**: Uses Riverpod for reactive state management

## Architecture

```
FCMTokenProvider
├── State Management (Riverpod)
├── Firebase Messaging Integration
├── Backend API Integration
├── Authentication State Monitoring
└── Error Handling & Logging
```

## Usage

### Basic Usage

```dart
// In a widget
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fcmState = ref.watch(fcmTokenProvider);
    
    return Column(
      children: [
        Text('Token: ${fcmState.token ?? 'Not available'}'),
        Text('Loading: ${fcmState.isLoading}'),
        Text('Error: ${fcmState.error ?? 'None'}'),
      ],
    );
  }
}
```

### Manual Token Refresh

```dart
// Refresh token manually
ref.read(fcmTokenProvider.notifier).refreshToken();
```

### Check Token Status

```dart
final fcmState = ref.watch(fcmTokenProvider);

if (fcmState.hasToken) {
  // Token is available
  print('Token: ${fcmState.currentToken}');
}

if (fcmState.isLoading) {
  // Token is being retrieved
  showLoadingIndicator();
}

if (fcmState.hasError) {
  // Handle error
  showErrorMessage(fcmState.error!);
}
```

## State Management

### FCMTokenState

```dart
class FCMTokenState {
  final String? token;      // Current FCM token
  final bool isLoading;      // Whether token is being retrieved
  final String? error;       // Error message if any
}
```

### State Transitions

1. **Initial** → **Loading** → **Success** (with token)
2. **Initial** → **Loading** → **Error** (if failed)
3. **Success** → **Loading** → **Success** (on refresh)
4. **Any State** → **Initial** (on logout)

## Backend Integration

### API Endpoint

The provider sends tokens to: `POST /users/fcm-token`

### Request Payload

```json
{
  "token": "fcm_token_string",
  "platform": "android|ios|web",
  "appVersion": "1.0.0"
}
```

### Backend Requirements

Your backend should:

1. **Store tokens**: Associate FCM tokens with user accounts
2. **Handle updates**: Update tokens when they change
3. **Send notifications**: Use stored tokens to send push notifications
4. **Clean up**: Remove invalid/expired tokens

## Error Handling

### Common Errors

- **Permission Denied**: User denied notification permissions
- **Token Retrieval Failed**: Firebase couldn't generate token
- **Network Error**: Failed to send token to backend
- **Authentication Error**: User not logged in

### Error Recovery

```dart
// Handle errors gracefully
if (fcmState.hasError) {
  // Show user-friendly error message
  showSnackBar(context, 'Notification setup failed: ${fcmState.error}');
  
  // Optionally retry
  if (shouldRetry) {
    ref.read(fcmTokenProvider.notifier).refreshToken();
  }
}
```

## Testing

### Unit Tests

```dart
// Test state transitions
test('should transition from loading to success', () async {
  // Test implementation
});

// Test error handling
test('should handle permission denied', () async {
  // Test implementation
});
```

### Integration Tests

```dart
// Test with real Firebase
test('should get real FCM token', () async {
  // Test implementation
});
```

## Configuration

### Firebase Setup

1. **Add Firebase to your project**
2. **Configure firebase_messaging package**
3. **Add required permissions** (Android/iOS)

### Android Permissions

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.WAKE_LOCK" />
<uses-permission android:name="com.google.android.c2dm.permission.RECEIVE" />
```

### iOS Permissions

```xml
<!-- Add to Info.plist -->
<key>UIBackgroundModes</key>
<array>
    <string>remote-notification</string>
</array>
```

## Best Practices

### 1. Initialize Early

```dart
// Initialize in main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // FCM Token Provider will auto-initialize
  runApp(ProviderScope(child: MyApp()));
}
```

### 2. Handle Permissions Gracefully

```dart
// Show permission request dialog
if (!fcmState.hasToken && !fcmState.hasError) {
  showPermissionDialog(context);
}
```

### 3. Monitor Token Changes

```dart
// Listen for token changes
ref.listen<FCMTokenState>(fcmTokenProvider, (previous, next) {
  if (previous?.token != next.token && next.token != null) {
    // Token changed, update UI or backend
    updateBackendToken(next.token!);
  }
});
```

### 4. Error Recovery

```dart
// Implement retry logic
if (fcmState.hasError) {
  Timer(Duration(seconds: 5), () {
    ref.read(fcmTokenProvider.notifier).refreshToken();
  });
}
```

## Troubleshooting

### Common Issues

1. **Token not available**
   - Check notification permissions
   - Verify Firebase configuration
   - Check network connectivity

2. **Backend sync fails**
   - Verify API endpoint
   - Check authentication state
   - Review network logs

3. **Token refresh issues**
   - Check Firebase project settings
   - Verify app signing
   - Review Firebase console logs

### Debug Tools

Use the `FCMTokenDebugWidget` for development:

```dart
// Only in debug builds
if (kDebugMode) {
  FCMTokenDebugWidget(),
}
```

## Security Considerations

1. **Token Storage**: Tokens are sensitive, store securely
2. **Backend Validation**: Validate tokens on server side
3. **Token Rotation**: Handle token refresh securely
4. **User Consent**: Always request permission before enabling notifications

## Performance

- **Lazy Loading**: Token is retrieved only when needed
- **Caching**: Token is cached locally
- **Minimal Network**: Only syncs when token changes
- **Background Processing**: Handles token refresh in background

## Future Enhancements

- [ ] **Multi-device Support**: Handle multiple devices per user
- [ ] **Topic Subscription**: Subscribe to notification topics
- [ ] **Analytics Integration**: Track notification engagement
- [ ] **Advanced Error Recovery**: Implement exponential backoff
- [ ] **Token Validation**: Validate tokens before sending to backend 