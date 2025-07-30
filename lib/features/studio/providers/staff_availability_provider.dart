import 'package:appoint/features/studio/models/slot.dart';
import 'package:appoint/features/studio/services/staff_availability_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider for current studio ID (you can modify this based on your app's logic)
final currentStudioIdProvider =
    StateProvider<String>((ref) => 'default-studio');

// Staff availability service provider
final staffAvailabilityServiceProvider =
    Provider<StaffAvailabilityService>((ref) {
  final studioId = ref.watch(currentStudioIdProvider);
  return StaffAvailabilityService(studioId);
});

// Staff availability provider (read-only for existing slots)
final AutoDisposeStreamProvider<List<Slot>> staffAvailabilityProvider =
    StreamProvider.autoDispose<List<Slot>>((ref) {
  final studioId = ref.watch(currentStudioIdProvider);
  // Removed debug print: debugPrint('🔍 Fetching staff availability for studio: $studioId');

  return FirebaseFirestore.instance
      .collection('studio')
      .doc(studioId)
      .collection('staff_availability')
      .snapshots()
      .map((snap) {
    // Removed debug print: debugPrint('📊 Received ${snap.docs.length} slots from Firestore');
    return snap.docs.map((doc) {
      // Removed debug print: debugPrint('📋 Processing slot: ${doc.id}');
      return Slot.fromFirestore(doc);
    }).toList();
  }).handleError((error) {
    // Removed debug print: debugPrint('❌ Firestore error: $error');
    throw error;
  });
});

// Staff availability provider with IDs (for CRUD operations)
final AutoDisposeStreamProvider<List<SlotWithId>> staffSlotsWithIdProvider =
    StreamProvider.autoDispose<List<SlotWithId>>((ref) {
  final studioId = ref.watch(currentStudioIdProvider);
  // Removed debug print: debugPrint('🔍 Fetching staff availability with IDs for studio: $studioId');

  return FirebaseFirestore.instance
      .collection('studio')
      .doc(studioId)
      .collection('staff_availability')
      .snapshots()
      .map((snap) {
    // Removed debug print: debugPrint('📊 Received ${snap.docs.length} slots from Firestore');
    return snap.docs.map((doc) {
      // Removed debug print: debugPrint('📋 Processing slot with ID: ${doc.id}');
      return SlotWithId.fromFirestore(doc);
    }).toList();
  }).handleError((error) {
    // Removed debug print: debugPrint('❌ Firestore error: $error');
    throw error;
  });
});
