import 'package:flutter_riverpod/flutter_riverpod.dart';

// Staff selection provider
final staffSelectionProvider = StateProvider<String?>((ref) => null);

// Service selection provider
final serviceSelectionProvider = StateProvider<String?>((ref) => null);
final serviceNameProvider = StateProvider<String?>((ref) => null);
final serviceDurationProvider =
    StateProvider<int>((ref) => 60); // Default 60 minutes

// Time slot selection provider
final selectedSlotProvider = StateProvider<DateTime?>((ref) => null);
