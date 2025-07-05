import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:appoint/features/studio/models/slot.dart';
import 'package:appoint/features/studio/services/staff_availability_service.dart';

// Provider for current studio ID (you can modify this based on your app's logic)
final currentStudioIdProvider =
    StateProvider<String>((final ref) => 'default-studio');

// Staff availability service provider
final staffAvailabilityServiceProvider =
    Provider<StaffAvailabilityService>((final ref) {
  final studioId = ref.watch(currentStudioIdProvider);
  return StaffAvailabilityService(studioId);
});

// Staff availability provider (read-only for existing slots)
final staffAvailabilityProvider =
    StreamProvider.autoDispose<List<Slot>>((final ref) {
  final studioId = ref.watch(currentStudioIdProvider);
  // Removed debug print: print('🔍 Fetching staff availability for studio: $studioId');

  return FirebaseFirestore.instance
      .collection('studio')
      .doc(studioId)
      .collection('staff_availability')
      .snapshots()
      .map((final snap) {
    // Removed debug print: print('📊 Received ${snap.docs.length} slots from Firestore');
    return snap.docs.map((final doc) {
      // Removed debug print: print('📋 Processing slot: ${doc.id}');
      return Slot.fromFirestore(doc);
    }).toList();
  }).handleError((final error) {
    // Removed debug print: print('❌ Firestore error: $error');
    throw error;
  });
});

// Staff availability provider with IDs (for CRUD operations)
final staffSlotsWithIdProvider =
    StreamProvider.autoDispose<List<SlotWithId>>((final ref) {
  final studioId = ref.watch(currentStudioIdProvider);
  // Removed debug print: print('🔍 Fetching staff availability with IDs for studio: $studioId');

  return FirebaseFirestore.instance
      .collection('studio')
      .doc(studioId)
      .collection('staff_availability')
      .snapshots()
      .map((final snap) {
    // Removed debug print: print('📊 Received ${snap.docs.length} slots from Firestore');
    return snap.docs.map((final doc) {
      // Removed debug print: print('📋 Processing slot with ID: ${doc.id}');
      return SlotWithId.fromFirestore(doc);
    }).toList();
  }).handleError((final error) {
    // Removed debug print: print('❌ Firestore error: $error');
    throw error;
  });
});
