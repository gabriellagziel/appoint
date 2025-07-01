import 'package:flutter_riverpod/flutter_riverpod.dart';

// Staff selection provider
final staffSelectionProvider = StateProvider<String?>((final ref) => null);

// Service selection provider
final serviceSelectionProvider = StateProvider<String?>((final ref) => null);
final serviceNameProvider = StateProvider<String?>((final ref) => null);
final serviceDurationProvider =
    StateProvider<int>((final ref) => 60); // Default 60 minutes

// Time slot selection provider
final selectedSlotProvider = StateProvider<DateTime?>((final ref) => null);
