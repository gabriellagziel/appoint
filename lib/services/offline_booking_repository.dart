import 'dart:async';
import 'dart:math';

import 'package:appoint/models/booking.dart';
import 'package:appoint/models/offline_booking.dart';
import 'package:appoint/models/offline_service_offering.dart';
import 'package:appoint/services/ui_notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class OfflineBookingRepository {
  // Track the timer created in _retryFailedOperations

  OfflineBookingRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    Connectivity? connectivity,
    UINotificationService? notificationService,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance,
        _connectivity = connectivity ?? Connectivity(),
        _notificationService = notificationService;
  static const String _bookingsBoxName = 'offline_bookings';
  static const String _servicesBoxName = 'offline_services';
  static const String _pendingOperationsBoxName = 'pending_operations';

  // Retry configuration
  static const int _maxRetryAttempts = 5;
  static const Duration _baseRetryDelay = Duration(seconds: 1);
  static const Duration _maxRetryDelay = Duration(minutes: 5);

  late Box<OfflineBooking> _bookingsBox;
  late Box<OfflineServiceOffering> _servicesBox;
  late Box<String> _pendingOperationsBox;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final Connectivity _connectivity;
  final UINotificationService? _notificationService;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isOnline = false;
  bool _circuitBreakerOpen = false;
  Timer? _retryTimer;
  Timer? _exponentialBackoffTimer;

  /// Initialize Hive boxes and connectivity monitoring
  Future<void> initialize() async {
    // Initialize Hive boxes
    _bookingsBox = await Hive.openBox<OfflineBooking>(_bookingsBoxName);
    _servicesBox = await Hive.openBox<OfflineServiceOffering>(_servicesBoxName);
    _pendingOperationsBox =
        await Hive.openBox<String>(_pendingOperationsBoxName);

    // Check initial connectivity
    final connectivityResult = await _connectivity.checkConnectivity();
    _isOnline = connectivityResult != ConnectivityResult.none;

    // Start monitoring connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> results) {
        final wasOnline = _isOnline;
        _isOnline =
            results.isNotEmpty && results.first != ConnectivityResult.none;

        // If we just came back online, sync pending changes
        if (!wasOnline && _isOnline) {
          syncPendingChanges();
        }
      },
    );
  }

  /// Dispose resources
  Future<void> dispose() async {
    // Cancel connectivity subscription
    await _connectivitySubscription?.cancel();
    _connectivitySubscription = null;

    // Cancel retry timer
    _retryTimer?.cancel();
    _retryTimer = null;

    // Cancel exponential backoff timer
    _exponentialBackoffTimer?.cancel();
    _exponentialBackoffTimer = null;

    // Close Hive boxes
    await _bookingsBox.close();
    await _servicesBox.close();
    await _pendingOperationsBox.close();
  }

  /// Calculate exponential backoff delay
  Duration _calculateRetryDelay(int attempt) {
    final delay = Duration(
      milliseconds: (_baseRetryDelay.inMilliseconds * pow(2, attempt)).toInt(),
    );
    return delay > _maxRetryDelay ? _maxRetryDelay : delay;
  }

  /// Check if circuit breaker should be opened
  bool _shouldOpenCircuitBreaker() {
    if (_circuitBreakerOpen) {
      return true;
    }

    // Count recent failures
    var recentFailures = 0;
    final cutoffTime = DateTime.now().subtract(const Duration(minutes: 5));

    for (final booking in _bookingsBox.values) {
      if (booking.syncStatus == 'failed' &&
          booking.lastSyncAttempt.isAfter(cutoffTime)) {
        recentFailures++;
      }
    }

    return recentFailures >=
        10; // Open circuit breaker after 10 recent failures
  }

  /// Retry failed operations with exponential backoff
  Future<void> _retryFailedOperations() async {
    if (!_isOnline || _shouldOpenCircuitBreaker()) return;

    final failedBookings = _bookingsBox.values
        .where((booking) => booking.syncStatus == 'failed')
        .toList();

    if (failedBookings.isEmpty) return;

    // Show retry notification
    _notificationService?.showInfo(
      'Retrying ${failedBookings.length} failed booking${failedBookings.length == 1 ? '' : 's'}...',
    );

    for (final booking in failedBookings) {
      final retryCount = _getRetryCount(booking.id);
      if (retryCount >= _maxRetryAttempts) {
        // Mark as permanently failed
        await _bookingsBox.put(
          booking.id,
          booking.copyWith(
            syncStatus: 'permanently_failed',
            syncError: 'Max retry attempts exceeded',
          ),
        );

        // Show permanent failure notification
        _notificationService
            ?.showError('Booking ${booking.id} failed to sync permanently');
        continue;
      }

      try {
        await _retryBookingOperation(booking);
      } catch (e) {
        // Update retry count and schedule next retry
        await _bookingsBox.put(
          booking.id,
          booking.copyWith(
            lastSyncAttempt: DateTime.now(),
            syncError: e.toString(),
          ),
        );

        // Schedule retry with exponential backoff
        final delay = _calculateRetryDelay(retryCount);
        _exponentialBackoffTimer = Timer(delay, _retryFailedOperations);
      }
    }
  }

  /// Get retry count for a booking
  int _getRetryCount(String bookingId) {
    final booking = _bookingsBox.get(bookingId);
    if (booking == null) return 0;

    // Count failed attempts in the last hour
    final cutoffTime = DateTime.now().subtract(const Duration(hours: 1));
    var count = 0;

    // This is a simplified approach - in a real implementation,
    // you might want to store retry count explicitly
    if (booking.syncStatus == 'failed' &&
        booking.lastSyncAttempt.isAfter(cutoffTime)) {
      count = 1; // Simplified - assumes one retry per hour
    }

    return count;
  }

  /// Retry a specific booking operation
  Future<void> _retryBookingOperation(OfflineBooking booking) async {
    final bookingRef = _firestore.collection('bookings').doc(booking.id);

    switch (booking.operation) {
      case 'create':
        await bookingRef.set(booking.toBooking().toJson());
      case 'update':
        await bookingRef.update(booking.toBooking().toJson());
      case 'delete':
        await bookingRef.delete();
    }

    // Mark as synced
    if (booking.operation == 'delete') {
      await _bookingsBox.delete(booking.id);
    } else {
      await _bookingsBox.put(
        booking.id,
        booking.copyWith(syncStatus: 'synced'),
      );
    }
  }

  /// Get all bookings (local + remote)
  Future<List<Booking>> getBookings() async {
    final bookings = <Booking>[];

    // Get local bookings
    for (final offlineBooking in _bookingsBox.values) {
      bookings.add(offlineBooking.toBooking());
    }

    // If online, also fetch from Firestore
    if (_isOnline) {
      try {
        final user = _auth.currentUser;
        if (user != null) {
          final snapshot = await _firestore
              .collection('bookings')
              .where('userId', isEqualTo: user.uid)
              .orderBy('dateTime')
              .get();

          for (final doc in snapshot.docs) {
            final remoteBooking =
                Booking.fromJson({...doc.data(), 'id': doc.id});

            // Check if we have a local version
            final localVersion = _bookingsBox.get(doc.id);
            if (localVersion == null) {
              // No local version, add remote booking
              bookings.add(remoteBooking);
            } // else: local version exists, ignore remote
          }
        }
      } catch (e) {
        // If remote fetch fails, continue with local data
        debugPrint('Failed to fetch remote bookings: $e');
      }
    }

    // Sort by dateTime
    bookings.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return bookings;
  }

  /// Add a new booking
  Future<void> addBooking(Booking booking) async {
    final offlineBooking = OfflineBooking.fromBooking(
      booking,
      syncStatus: _isOnline ? 'synced' : 'pending',
    );

    await _bookingsBox.put(booking.id, offlineBooking);

    // If online, immediately sync to Firestore
    if (_isOnline) {
      try {
        await _firestore
            .collection('bookings')
            .doc(booking.id)
            .set(booking.toJson());
        await _bookingsBox.put(
          booking.id,
          offlineBooking.copyWith(syncStatus: 'synced'),
        );
      } catch (e) {
        await _bookingsBox.put(
          booking.id,
          offlineBooking.copyWith(
            syncStatus: 'failed',
            syncError: e.toString(),
          ),
        );
        rethrow;
      }
    }
  }

  /// Cancel a booking
  Future<void> cancelBooking(String bookingId) async {
    final offlineBooking = _bookingsBox.get(bookingId);
    if (offlineBooking == null) {
      throw Exception('Booking not found');
    }

    // Mark for deletion
    final updatedOfflineBooking = offlineBooking.copyWith(
      operation: 'delete',
      syncStatus: _isOnline ? 'synced' : 'pending',
      updatedAt: DateTime.now(),
    );

    await _bookingsBox.put(bookingId, updatedOfflineBooking);

    // If online, immediately delete from Firestore
    if (_isOnline) {
      try {
        await _firestore.collection('bookings').doc(bookingId).delete();
        await _bookingsBox.delete(bookingId);
      } catch (e) {
        await _bookingsBox.put(
          bookingId,
          updatedOfflineBooking.copyWith(
            syncStatus: 'failed',
            syncError: e.toString(),
          ),
        );
        rethrow;
      }
    }
  }

  /// Update an existing booking
  Future<void> updateBooking(Booking booking) async {
    final offlineBooking = _bookingsBox.get(booking.id);
    if (offlineBooking == null) {
      throw Exception('Booking not found');
    }

    final updatedOfflineBooking = OfflineBooking.fromBooking(
      booking,
      syncStatus: _isOnline ? 'synced' : 'pending',
      operation: 'update',
    );

    await _bookingsBox.put(booking.id, updatedOfflineBooking);

    // If online, immediately update Firestore
    if (_isOnline) {
      try {
        await _firestore
            .collection('bookings')
            .doc(booking.id)
            .update(booking.toJson());
        await _bookingsBox.put(
          booking.id,
          updatedOfflineBooking.copyWith(syncStatus: 'synced'),
        );
      } catch (e) {
        await _bookingsBox.put(
          booking.id,
          updatedOfflineBooking.copyWith(
            syncStatus: 'failed',
            syncError: e.toString(),
          ),
        );
        rethrow;
      }
    }
  }

  /// Sync all pending changes to Firestore with batching and prioritization
  Future<void> syncPendingChanges() async {
    if (!_isOnline) {
      throw Exception('Cannot sync while offline');
    }

    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    // Show sync started notification
    _notificationService?.showInfo('Syncing bookings...');

    // Get pending operations sorted by priority
    final pendingOperations = _getPendingOperationsSorted();

    if (pendingOperations.isEmpty) {
      _notificationService?.showInfo('No changes to sync');
      return;
    }

    // Process in batches of 500 (Firestore batch limit)
    const batchSize = 500;
    var totalSynced = 0;

    for (var i = 0; i < pendingOperations.length; i += batchSize) {
      final batch = _firestore.batch();
      final batchOperations =
          pendingOperations.skip(i).take(batchSize).toList();
      final syncedIds = <String>[];

      try {
        // Process batch operations
        for (final operation in batchOperations) {
          final bookingRef =
              _firestore.collection('bookings').doc(operation.id);

          switch (operation.operation) {
            case 'create':
              batch.set(bookingRef, operation.toBooking().toJson());
            case 'update':
              batch.update(bookingRef, operation.toBooking().toJson());
            case 'delete':
              batch.delete(bookingRef);
          }

          syncedIds.add(operation.id);
        }

        // Commit the batch
        await batch.commit();

        // Update sync status for successful operations
        await _updateSyncStatusBatch(syncedIds, 'synced');
        totalSynced += syncedIds.length;
      } catch (e) {
        // Mark failed operations
        await _updateSyncStatusBatch(syncedIds, 'failed', error: e.toString());

        // Show error notification
        _notificationService?.showError('Sync failed: $e');
        rethrow;
      }
    }

    // Show success notification
    if (totalSynced > 0) {
      _notificationService?.showSuccess(
        'Successfully synced $totalSynced booking${totalSynced == 1 ? '' : 's'}',
      );
    }
  }

  /// Get pending operations sorted by priority
  List<OfflineBooking> _getPendingOperationsSorted() {
    final pendingBookings = _bookingsBox.values
        .where((booking) => booking.syncStatus == 'pending')
        .toList();

    // Sort by priority: deletes first, then creates, then updates
    pendingBookings.sort((a, b) {
      final priorityA = _getOperationPriority(a.operation);
      final priorityB = _getOperationPriority(b.operation);

      if (priorityA != priorityB) {
        return priorityA.compareTo(priorityB);
      }

      // Then sort by timestamp (oldest first)
      final timeA = a.createdAt ?? DateTime(1970);
      final timeB = b.createdAt ?? DateTime(1970);
      return timeA.compareTo(timeB);
    });

    return pendingBookings;
  }

  /// Get priority for operation type (lower number = higher priority)
  int _getOperationPriority(String operation) {
    switch (operation) {
      case 'delete':
        return 1; // Highest priority
      case 'create':
        return 2;
      case 'update':
        return 3; // Lowest priority
      default:
        return 4;
    }
  }

  /// Update sync status for a batch of operations
  Future<void> _updateSyncStatusBatch(
    List<String> ids,
    String status, {
    String? error,
  }) async {
    for (final id in ids) {
      final booking = _bookingsBox.get(id);
      if (booking != null) {
        if (status == 'synced' && booking.operation == 'delete') {
          await _bookingsBox.delete(id);
        } else {
          await _bookingsBox.put(
            id,
            booking.copyWith(
              syncStatus: status,
              syncError: error,
              lastSyncAttempt: DateTime.now(),
            ),
          );
        }
      }
    }
  }

  /// Clean up stale entries (older than 30 days)
  Future<void> cleanupStaleEntries() async {
    final cutoffDate = DateTime.now().subtract(const Duration(days: 30));

    final staleBookings = _bookingsBox.values
        .where(
          (booking) =>
              booking.syncStatus == 'synced' &&
              booking.lastSyncAttempt.isBefore(cutoffDate),
        )
        .map((booking) => booking.id)
        .toList();

    for (final id in staleBookings) {
      await _bookingsBox.delete(id);
    }

    // Also clean up permanently failed entries older than 7 days
    final failedCutoffDate = DateTime.now().subtract(const Duration(days: 7));
    final failedBookings = _bookingsBox.values
        .where(
          (booking) =>
              booking.syncStatus == 'permanently_failed' &&
              booking.lastSyncAttempt.isBefore(failedCutoffDate),
        )
        .map((booking) => booking.id)
        .toList();

    for (final id in failedBookings) {
      await _bookingsBox.delete(id);
    }
  }

  /// Get pending operations count
  int getPendingOperationsCount() {
    var count = 0;
    for (final booking in _bookingsBox.values) {
      if (booking.syncStatus == 'pending') count++;
    }
    for (final service in _servicesBox.values) {
      if (service.syncStatus == 'pending') count++;
    }
    return count;
  }

  /// Get detailed sync statistics
  Map<String, dynamic> getSyncStatistics() {
    var pending = 0;
    var synced = 0;
    var failed = 0;
    var permanentlyFailed = 0;

    for (final booking in _bookingsBox.values) {
      switch (booking.syncStatus) {
        case 'pending':
          pending++;
        case 'synced':
          synced++;
        case 'failed':
          failed++;
        case 'permanently_failed':
          permanentlyFailed++;
      }
    }

    return {
      'pending': pending,
      'synced': synced,
      'failed': failed,
      'permanently_failed': permanentlyFailed,
      'total': _bookingsBox.length,
      'isOnline': _isOnline,
      'circuitBreakerOpen': _circuitBreakerOpen,
    };
  }

  /// Get sync history for a specific booking
  List<Map<String, dynamic>> getBookingSyncHistory(String bookingId) {
    final booking = _bookingsBox.get(bookingId);
    if (booking == null) return [];

    return [
      {
        'timestamp': booking.lastSyncAttempt.toIso8601String(),
        'status': booking.syncStatus,
        'operation': booking.operation,
        'error': booking.syncError,
      }
    ];
  }

  /// Check if currently online
  bool get isOnline => _isOnline;

  /// Check if circuit breaker is open
  bool get isCircuitBreakerOpen => _circuitBreakerOpen;

  /// Get sync status for a specific booking
  String? getBookingSyncStatus(String bookingId) =>
      _bookingsBox.get(bookingId)?.syncStatus;

  /// Get sync error for a specific booking
  String? getBookingSyncError(String bookingId) =>
      _bookingsBox.get(bookingId)?.syncError;

  /// Force retry of failed operations
  Future<void> retryFailedOperations() async {
    if (!_isOnline) {
      throw Exception('Cannot retry while offline');
    }

    await _retryFailedOperations();
  }

  /// Reset circuit breaker
  void resetCircuitBreaker() {
    _circuitBreakerOpen = false;
  }

  /// Clear all local data (for testing or reset)
  Future<void> clearAllData() async {
    await _bookingsBox.clear();
    await _servicesBox.clear();
    await _pendingOperationsBox.clear();
  }
}
