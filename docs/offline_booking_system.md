# Offline-First Booking System

This document describes the implementation of an offline-first booking system for the APP-OINT Flutter application using Hive for local storage and connectivity_plus for network monitoring.

## Overview

The offline booking system provides:
- **Offline-first architecture**: All operations work offline and sync when connectivity is restored
- **Automatic conflict resolution**: Resolves conflicts between local and remote data using timestamp-based resolution
- **Queue-based sync**: Pending operations are queued locally and applied in batch when online
- **Real-time connectivity monitoring**: Automatically detects online/offline state changes
- **Comprehensive error handling**: Graceful handling of sync failures with retry mechanisms

## Architecture

### Core Components

1. **OfflineBookingRepository**: Main repository class that handles all offline operations
2. **OfflineBooking**: Hive-compatible model for storing booking data locally
3. **OfflineServiceOffering**: Hive-compatible model for storing service data locally
4. **Hive Adapters**: Custom adapters for serializing/deserializing models

### Data Flow

```
User Action → OfflineBookingRepository → Local Storage (Hive)
                                    ↓
                              Connectivity Check
                                    ↓
                              Online? → Firestore Sync
                              Offline? → Queue for Later
```

## Models

### OfflineBooking

Extends the base `Booking` model with offline-specific fields:

```dart
class OfflineBooking {
  // Core booking fields
  final String id;
  final String userId;
  final String staffId;
  final String serviceId;
  final String serviceName;
  final DateTime dateTime;
  final int durationInMinutes;
  final String? notes;
  final bool isConfirmed;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  
  // Offline-specific fields
  final String syncStatus; // 'pending', 'synced', 'failed'
  final String operation; // 'create', 'update', 'delete'
  final DateTime lastSyncAttempt;
  final String? syncError;
}
```

### OfflineServiceOffering

Similar structure for service offerings with offline capabilities.

## Repository Methods

### Core Operations

```dart
class OfflineBookingRepository {
  // Get all bookings (local + remote with conflict resolution)
  Future<List<Booking>> getBookings();
  
  // Add a new booking
  Future<void> addBooking(Booking booking);
  
  // Cancel a booking
  Future<void> cancelBooking(String bookingId);
  
  // Update an existing booking
  Future<void> updateBooking(Booking booking);
  
  // Sync all pending changes to Firestore
  Future<void> syncPendingChanges();
}
```

### Utility Methods

```dart
// Check connectivity status
bool get isOnline;

// Get count of pending operations
int getPendingOperationsCount();

// Get sync status for a specific booking
String? getBookingSyncStatus(String bookingId);

// Get sync error for a specific booking
String? getBookingSyncError(String bookingId);

// Clear all local data
Future<void> clearAllData();
```

## Conflict Resolution

The system uses a timestamp-based conflict resolution strategy:

1. **Local vs Remote Comparison**: Compares `updatedAt` timestamps
2. **Latest Wins**: The version with the most recent `updatedAt` is preferred
3. **Automatic Merging**: When online, conflicts are resolved automatically
4. **User Notification**: Failed syncs are tracked and can be reported to users

### Conflict Resolution Logic

```dart
// Example conflict resolution
final localUpdatedAt = localVersion.updatedAt ?? localVersion.createdAt ?? DateTime(1970);
final remoteUpdatedAt = remoteDoc.data()['updatedAt'] as Timestamp? ?? 
                       remoteDoc.data()['createdAt'] as Timestamp? ?? 
                       Timestamp.fromDate(DateTime(1970));

if (remoteUpdatedAt.toDate().isAfter(localUpdatedAt)) {
  // Remote is newer, update local
  await _bookingsBox.put(doc.id, updatedOfflineBooking);
  return remoteBooking;
} else {
  // Local is newer or same, keep local
  return localVersion.toBooking();
}
```

## Connectivity Monitoring

The system automatically monitors connectivity changes:

```dart
_connectivitySubscription = _connectivity.onConnectivityChanged.listen(
  (ConnectivityResult result) {
    final wasOnline = _isOnline;
    _isOnline = result != ConnectivityResult.none;
    
    // If we just came back online, sync pending changes
    if (!wasOnline && _isOnline) {
      syncPendingChanges();
    }
  },
);
```

## Sync Operations

### Batch Sync

When connectivity is restored, all pending operations are applied in a single Firestore batch:

```dart
Future<void> syncPendingChanges() async {
  final batch = _firestore.batch();
  
  // Process pending bookings
  for (final offlineBooking in _bookingsBox.values) {
    if (offlineBooking.syncStatus == 'pending') {
      final bookingRef = _firestore.collection('bookings').doc(offlineBooking.id);
      
      switch (offlineBooking.operation) {
        case 'create':
          batch.set(bookingRef, offlineBooking.toBooking().toJson());
          break;
        case 'update':
          batch.update(bookingRef, offlineBooking.toBooking().toJson());
          break;
        case 'delete':
          batch.delete(bookingRef);
          break;
      }
    }
  }
  
  // Commit the batch
  await batch.commit();
}
```

### Error Handling

Failed sync operations are tracked with error details:

```dart
try {
  await batch.commit();
  // Mark as synced
  await _bookingsBox.put(id, booking.copyWith(syncStatus: 'synced'));
} catch (e) {
  // Mark as failed with error details
  await _bookingsBox.put(id, booking.copyWith(
    syncStatus: 'failed',
    syncError: e.toString(),
    lastSyncAttempt: DateTime.now(),
  ));
  throw e;
}
```

## Initialization

### Main.dart Setup

```dart
Future<void> initializeOfflineBookingSystem() async {
  // Initialize Hive
  await Hive.initFlutter();
  
  // Register adapters
  Hive.registerAdapter(OfflineBookingAdapter());
  Hive.registerAdapter(OfflineServiceOfferingAdapter());
  
  // Initialize the offline booking repository
  final offlineRepository = OfflineBookingRepository();
  await offlineRepository.initialize();
}
```

### Riverpod Integration

```dart
final REDACTED_TOKEN = Provider<OfflineBookingRepository>((ref) {
  return OfflineBookingRepository();
});

final bookingsProvider = FutureProvider<List<Booking>>((ref) async {
  final repository = ref.read(REDACTED_TOKEN);
  return repository.getBookings();
});
```

## Testing

### Unit Tests

The system includes comprehensive unit tests covering:

- **Offline Operations**: Adding/canceling bookings while offline
- **Sync Behavior**: Automatic syncing when coming back online
- **Conflict Resolution**: Timestamp-based conflict resolution
- **Error Handling**: Graceful handling of sync failures
- **Connectivity Changes**: Automatic sync on connectivity restoration

### Test Structure

```dart
group('OfflineBookingRepository', () {
  group('Adding bookings offline', () {
    test('should store booking locally when offline', () async {
      // Test implementation
    });
    
    test('should sync booking immediately when online', () async {
      // Test implementation
    });
  });
  
  group('Conflict resolution', () {
    test('should prefer remote version when remote is newer', () async {
      // Test implementation
    });
  });
});
```

## Usage Examples

### Creating a Booking

```dart
final repository = OfflineBookingRepository();
await repository.initialize();

final booking = Booking(
  id: 'booking-1',
  userId: 'user-1',
  staffId: 'staff-1',
  serviceId: 'service-1',
  serviceName: 'Haircut',
  dateTime: DateTime.now(),
  duration: Duration(minutes: 60),
);

await repository.addBooking(booking);
```

### Getting All Bookings

```dart
final bookings = await repository.getBookings();
for (final booking in bookings) {
  print('Booking: ${booking.serviceName} at ${booking.dateTime}');
}
```

### Canceling a Booking

```dart
await repository.cancelBooking('booking-1');
```

### Manual Sync

```dart
if (repository.isOnline) {
  await repository.syncPendingChanges();
}
```

### Checking Sync Status

```dart
final pendingCount = repository.getPendingOperationsCount();
if (pendingCount > 0) {
  print('$pendingCount operations pending sync');
}

final syncStatus = repository.getBookingSyncStatus('booking-1');
if (syncStatus == 'failed') {
  final error = repository.getBookingSyncError('booking-1');
  print('Sync failed: $error');
}
```

## Dependencies

### Required Packages

```yaml
dependencies:
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  connectivity_plus: ^4.0.1

dev_dependencies:
  hive_test: ^2.0.1
  mockito: ^5.4.6
```

### Hive Adapters

The system requires custom Hive adapters for proper serialization:

```dart
class OfflineBookingAdapter extends TypeAdapter<OfflineBooking> {
  @override
  final int typeId = 1;
  
  @override
  OfflineBooking read(BinaryReader reader) {
    // Implementation
  }
  
  @override
  void write(BinaryWriter writer, OfflineBooking obj) {
    // Implementation
  }
}
```

## Best Practices

### Performance

1. **Batch Operations**: Use Firestore batch operations for multiple sync operations
2. **Lazy Loading**: Load data on-demand rather than all at once
3. **Index Management**: Ensure proper Firestore indexes for queries

### Error Handling

1. **Graceful Degradation**: Always provide fallback behavior when offline
2. **User Feedback**: Inform users about sync status and errors
3. **Retry Logic**: Implement retry mechanisms for failed operations

### Data Consistency

1. **Timestamp Tracking**: Always track creation and update timestamps
2. **Conflict Resolution**: Implement clear conflict resolution strategies
3. **Data Validation**: Validate data before storing locally and remotely

## Troubleshooting

### Common Issues

1. **Hive Adapter Not Registered**: Ensure all adapters are registered before use
2. **Connectivity Detection**: Verify connectivity_plus permissions on Android
3. **Sync Failures**: Check Firestore security rules and authentication
4. **Data Corruption**: Implement data validation and backup strategies

### Debug Information

```dart
// Enable debug logging
print('Online status: ${repository.isOnline}');
print('Pending operations: ${repository.getPendingOperationsCount()}');
print('Sync status: ${repository.getBookingSyncStatus('booking-1')}');
```

## Future Enhancements

1. **Incremental Sync**: Only sync changed data instead of full sync
2. **Background Sync**: Implement background sync using WorkManager
3. **Data Compression**: Compress data for better storage efficiency
4. **Multi-Device Sync**: Support sync across multiple devices
5. **Offline Analytics**: Track offline usage patterns 