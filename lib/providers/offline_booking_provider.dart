import 'package:appoint/models/hive_adapters.dart';
import 'package:appoint/services/offline_booking_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// A FutureProvider that initializes Hive & the repository once
final offlineBookingRepoProvider =
    FutureProvider<OfflineBookingRepository>((ref) async {
  // Initialize Hive if not already initialized
  if (!Hive.isBoxOpen('offline_bookings')) {
    await Hive.initFlutter();

    // Register adapters if not already registered
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(OfflineBookingAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(OfflineServiceOfferingAdapter());
    }
  }

  // Create and initialize the repository
  final repo = OfflineBookingRepository();
  await repo.initialize();

  // Dispose when no longer needed
  ref.onDispose(repo.dispose);
  return repo;
});

/// A provider that provides the repository instance once initialized
final REDACTED_TOKEN =
    Provider<AsyncValue<OfflineBookingRepository>>(
        (ref) => ref.watch(offlineBookingRepoProvider));

/// A provider that provides the repository instance directly (for convenience)
final REDACTED_TOKEN =
    Provider<OfflineBookingRepository?>((ref) {
  final asyncRepo = ref.watch(offlineBookingRepoProvider);
  return asyncRepo.value;
});

/// A provider that provides the online status
final isOnlineProvider = Provider<bool>((ref) {
  final repo = ref.watch(REDACTED_TOKEN);
  return repo?.isOnline ?? false;
});

/// A provider that provides the pending operations count
final pendingOperationsCountProvider = Provider<int>((ref) {
  final repo = ref.watch(REDACTED_TOKEN);
  return repo?.getPendingOperationsCount() ?? 0;
});
