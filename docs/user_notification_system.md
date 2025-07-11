# User Notification System for Offline Booking

## Overview

This document describes the comprehensive user notification system implemented for the offline booking feature. The system provides real-time feedback to users about sync status, conflicts, and errors through snackbars, dialogs, and other UI notifications.

## Architecture

### Core Components

1. **UINotificationService** - Abstract interface for showing notifications
2. **ScaffoldNotificationService** - Implementation using ScaffoldMessenger
3. **MockNotificationService** - Test implementation for unit testing
4. **SyncNotificationHelper** - Helper class for sync-specific notifications
5. **BookingConflictDialog** - Dialog for resolving booking conflicts
6. **Riverpod Providers** - Dependency injection and state management

## Implementation Details

### 1. Notification Service Interface

```dart
abstract class UINotificationService {
  void showInfo(String message);
  void showWarning(String message);
  void showError(String message);
  void showSuccess(String message);
}
```

**Features:**
- Four notification types with distinct visual styles
- Consistent API across different implementations
- Easy to test with mock implementations

### 2. Scaffold Implementation

```dart
class ScaffoldNotificationService implements UINotificationService {
  final GlobalKey<ScaffoldMessengerState> messengerKey;
  
  // Shows snackbars with icons, colors, and dismiss actions
}
```

**Features:**
- Uses Material Design snackbars
- Color-coded notifications (blue, orange, red, green)
- Icons for visual clarity
- Dismiss action for user control
- 4-second auto-dismiss duration

### 3. Sync Notification Helper

```dart
class SyncNotificationHelper {
  void showSyncStarted();
  void showSyncCompleted(int syncedCount);
  void showSyncFailed(String error);
  void showConflictDetected(String bookingId);
  void showPendingOperations(int count);
  void showCircuitBreakerOpen();
  void showCircuitBreakerClosed();
  void showPermanentFailure(String bookingId);
}
```

**Features:**
- Pre-built messages for common sync scenarios
- Pluralization handling (booking vs bookings)
- Context-aware messaging

### 4. Conflict Resolution Dialog

```dart
class BookingConflictDialog extends StatelessWidget {
  final BookingConflictException conflict;
  final VoidCallback? onKeepLocal;
  final VoidCallback? onKeepRemote;
  final VoidCallback? onMerge;
}
```

**Features:**
- Detailed conflict information display
- Timestamp comparison visualization
- Three resolution options (keep local, keep remote, merge)
- Optional merge functionality
- Callback support for custom actions

## Integration Guide

### 1. Setup in main.dart

```dart
void main() {
  final messengerKey = GlobalKey<ScaffoldMessengerState>();
  
  runApp(
    ProviderScope(
      overrides: [
        uiNotificationServiceProvider.overrideWithValue(
          ScaffoldNotificationService(messengerKey),
        ),
      ],
      child: MyApp(messengerKey: messengerKey),
    ),
  );
}

class MyApp extends StatelessWidget {
  final GlobalKey<ScaffoldMessengerState> messengerKey;
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: messengerKey,
      home: HomePage(),
    );
  }
}
```

### 2. Using in Repository

```dart
class OfflineBookingRepository {
  final UINotificationService? _notificationService;
  
  Future<void> syncPendingChanges() async {
    _notificationService?.showInfo('Syncing bookings...');
    
    try {
      // Sync logic here
      _notificationService?.showSuccess('Successfully synced $count bookings');
    } catch (e) {
      _notificationService?.showError('Sync failed: $e');
      rethrow;
    }
  }
}
```

### 3. Handling Conflicts in UI

```dart
Future<void> handleBookingSync(BuildContext context, WidgetRef ref) async {
  try {
    await repository.syncPendingChanges();
  } on BookingConflictException catch (e) {
    final resolution = await showBookingConflictDialog(
      context,
      e,
      onKeepLocal: () => handleKeepLocal(e.bookingId),
      onKeepRemote: () => handleKeepRemote(e.bookingId),
    );
    
    switch (resolution) {
      case ConflictResolution.keepLocal:
        await forceLocalVersion(e.bookingId);
        break;
      case ConflictResolution.keepRemote:
        await discardLocalVersion(e.bookingId);
        break;
      case ConflictResolution.merge:
        await mergeVersions(e.bookingId);
        break;
    }
  }
}
```

## Testing

### 1. Unit Tests

```dart
test('should track notification messages', () {
  final service = MockNotificationService();
  
  service.showInfo('Test message');
  
  expect(service.infoMessages.length, equals(1));
  expect(service.infoMessages.first, equals('Test message'));
});
```

### 2. Widget Tests

```dart
testWidgets('should show conflict dialog', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) => ElevatedButton(
          onPressed: () => showBookingConflictDialog(context, conflict),
          child: Text('Show Dialog'),
        ),
      ),
    ),
  );
  
  await tester.tap(find.text('Show Dialog'));
  await tester.pumpAndSettle();
  
  expect(find.text('Booking Conflict'), findsOneWidget);
});
```

### 3. Boolean Return Value Tests

```dart
testWidgets('"Keep Mine" should return true', (tester) async {
  final result = await showBookingConflictDialog(context, conflict);
  expect(result == ConflictResolution.keepLocal, isTrue);
});

testWidgets('"Keep Server" should return false', (tester) async {
  final result = await showBookingConflictDialog(context, conflict);
  expect(result == ConflictResolution.keepLocal, isFalse);
});
```

## CI Integration

The user notification system's widget tests have been integrated into the existing GitHub Actions CI pipeline to ensure reliable validation on every code change. This integration provides early failure detection, cross-platform validation, and clear reporting for the notification system's critical UI components.

### 1. CI Configuration Changes

A dedicated step was added to the `unit-widget-tests` job in `.github/workflows/ci.yml`:

```yaml
# Run widget tests for conflict dialog (explicit verification)
- name: Run widget tests for conflict dialog
  run: |
    echo "🧪 Running BookingConflictDialog widget tests..."
    
    # Run comprehensive widget test
    echo "Running comprehensive widget test..."
    flutter test test/widgets/REDACTED_TOKEN.dart --no-pub
    
    # Run simple widget test
    echo "Running simple widget test..."
    flutter test test/widgets/REDACTED_TOKEN.dart --no-pub
    
    echo "✅ All BookingConflictDialog widget tests passed"
    
    # Verify test files exist
    if [ ! -f "test/widgets/REDACTED_TOKEN.dart" ]; then
      echo "❌ Error: REDACTED_TOKEN.dart not found"
      exit 1
    fi
    
    if [ ! -f "test/widgets/REDACTED_TOKEN.dart" ]; then
      echo "❌ Error: REDACTED_TOKEN.dart not found"
      exit 1
    fi
```

### 2. File Existence Checks

The CI step includes robust file validation before test execution:

- **Pre-execution Validation**: Verifies both test files exist before running any tests
- **Fail-Fast Behavior**: Stops execution immediately if files are missing
- **Clear Error Messages**: Provides specific failure reasons with file paths
- **Prevents Silent Failures**: Ensures missing test files don't go unnoticed

### 3. Logging & Execution

The step provides comprehensive logging throughout the test execution:

- **🧪 Initial Indicator**: Clear start message with emoji
- **📋 Progress Tracking**: Shows which specific test is currently running
- **✅ Success Confirmation**: Clear confirmation when all tests pass
- **❌ Error Indicators**: Visual cues for failures with specific error messages
- **📊 Test Outcomes**: Individual test results are clearly reported

### 4. Matrix Integration

The widget tests integrate seamlessly into the existing CI matrix strategy:

```yaml
unit-widget-tests:
  runs-on: ${{ matrix.os }}
  strategy:
    matrix:
      os: [ubuntu-latest, macos-latest, windows-latest]
```

**Cross-Platform Validation:**
- **Ubuntu**: Validates Linux compatibility and behavior
- **macOS**: Ensures macOS-specific UI behavior is correct
- **Windows**: Confirms Windows platform compatibility
- **Consistent Results**: All platforms must pass for the build to succeed

### 5. Benefits

#### Early Failure Detection
- **Immediate Visibility**: Widget test failures appear as a separate step in GitHub Actions
- **Quick Debugging**: Easy identification of which specific test failed
- **Faster Feedback**: Developers get immediate notification of UI issues
- **Reduced Debug Time**: Failures are caught before full test suite completion

#### Separate Logging
- **Dedicated Step**: Widget tests run as a distinct CI step with its own logs
- **Clear Separation**: Easy to distinguish widget test failures from unit test failures
- **Focused Debugging**: Logs are specific to notification system components
- **Better Organization**: CI pipeline is more structured and maintainable

#### Cross-Platform Validation
- **Platform Consistency**: Ensures notification dialogs work correctly on all platforms
- **UI Compatibility**: Validates Material Design behavior across operating systems
- **Integration Testing**: Confirms the notification system integrates properly with the app
- **Quality Assurance**: Provides confidence in cross-platform deployment

### Test Execution Flow

1. **Full Test Suite** (`flutter test --coverage --no-pub`) - runs all tests including widget tests
2. **Widget Tests for Conflict Dialog** - explicit verification of notification system tests
3. **Coverage Generation** - includes widget test results in overall coverage report

### Monitoring and Maintenance

#### GitHub Actions UI Monitoring
The widget tests appear as a separate step in the GitHub Actions UI:
- ✅ **Success**: "Run widget tests for conflict dialog" step passes
- ❌ **Failure**: Step fails with specific error messages and file validation
- 📊 **Matrix Results**: Individual results for Ubuntu, macOS, and Windows

#### Adding New Widget Tests
To extend the CI pipeline with additional widget tests:
1. Create the test file in `test/widgets/`
2. Add the test file to the CI step with appropriate logging
3. Update the file existence checks to include the new test file
4. Verify the test passes on all matrix platforms

## Notification Types and Use Cases

### Info Notifications
- **Sync Started**: "Syncing bookings..."
- **No Changes**: "No changes to sync"
- **Pending Operations**: "3 bookings pending sync"
- **Circuit Breaker Closed**: "Sync resumed"

### Warning Notifications
- **Conflicts**: "Conflict detected for booking ABC123"
- **Server Cancellation**: "Booking ABC123 was cancelled by the service provider"
- **Double Booking**: "Booking ABC123 conflicts with existing appointment"
- **Circuit Breaker Open**: "Sync temporarily disabled due to repeated failures"

### Error Notifications
- **Sync Failed**: "Sync failed: Network error"
- **Permanent Failure**: "Booking ABC123 failed to sync permanently"
- **General Errors**: "Operation failed: [error message]"

### Success Notifications
- **Sync Completed**: "Successfully synced 5 bookings"
- **Operation Success**: "Booking created successfully"

## Best Practices

### 1. Message Guidelines
- Keep messages concise and actionable
- Use consistent terminology
- Include relevant IDs for debugging
- Provide context when helpful

### 2. User Experience
- Don't overwhelm users with too many notifications
- Use appropriate notification types
- Provide clear next steps when possible
- Allow users to dismiss notifications

### 3. Error Handling
- Always catch and handle BookingConflictException
- Provide fallback behavior for unexpected errors
- Log errors for debugging while showing user-friendly messages
- Don't block the UI for non-critical errors

### 4. Testing
- Test all notification types
- Verify conflict dialog behavior
- Test error scenarios
- Ensure notifications don't interfere with app functionality

## Performance Considerations

### 1. Notification Queuing
- Avoid showing too many notifications simultaneously
- Consider debouncing rapid notifications
- Clear old notifications when showing new ones

### 2. Memory Management
- Dispose of notification services properly
- Avoid memory leaks in dialog callbacks
- Clean up timers and subscriptions

### 3. UI Responsiveness
- Keep notification operations non-blocking
- Use async/await properly
- Don't block the main thread

## Future Enhancements

### 1. Advanced Features
- **Notification History**: Track and display notification history
- **Custom Styling**: Allow theme customization
- **Sound/Vibration**: Add audio and haptic feedback
- **Rich Content**: Support for images and formatted text

### 2. Accessibility
- **Screen Reader Support**: Proper ARIA labels
- **High Contrast**: Support for accessibility themes
- **Voice Commands**: Voice control for notifications

### 3. Analytics
- **Notification Tracking**: Monitor which notifications are shown
- **User Interaction**: Track how users respond to conflicts
- **Performance Metrics**: Monitor notification system performance

## Troubleshooting

### Common Issues

1. **Notifications not showing**
   - Check if messengerKey is properly set
   - Verify provider override in main.dart
   - Ensure context is available

2. **Conflict dialog not appearing**
   - Check if BookingConflictException is being thrown
   - Verify dialog is called on main thread
   - Ensure proper context is passed

3. **Test failures**
   - Use MockNotificationService for unit tests
   - Verify test setup includes proper imports
   - Check for async/await issues in tests

### Debug Tips

1. **Enable logging** to track notification calls
2. **Use debug prints** to verify exception flow
3. **Test with mock services** to isolate issues
4. **Check provider setup** in widget tree

## Conclusion

The user notification system provides a comprehensive solution for keeping users informed about the offline booking system's status. It handles conflicts gracefully, provides clear feedback, and maintains a good user experience even when things go wrong.

The modular design makes it easy to test, extend, and customize for different use cases. The integration with Riverpod ensures proper dependency injection and state management throughout the app. 