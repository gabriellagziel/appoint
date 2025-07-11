import 'package:flutter_riverpod/flutter_riverpod.dart';

// Staff selection provider
staffSelectionProvider = StateProvider<String?>((final ref) => null);

// Service selection provider
serviceSelectionProvider = StateProvider<String?>((final ref) => null);
serviceNameProvider = StateProvider<String?>((final ref) => null);
final serviceDurationProvider =
    StateProvider<int>((ref) => 60); // Default 60 minutes

// Time slot selection provider
selectedSlotProvider = StateProvider<DateTime?>((final ref) => null);
