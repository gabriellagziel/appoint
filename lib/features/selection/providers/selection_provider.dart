import 'package:flutter_riverpod/flutter_riverpod.dart';

// Staff selection provider
final staffSelectionProvider = StateProvider<String?>((ref) => null);

// Service selection provider
final serviceSelectionProvider = StateProvider<String?>((ref) => null);

// Service name provider
final serviceNameProvider = StateProvider<String?>((ref) => null);

// Time slot selection provider
final selectedSlotProvider = StateProvider<DateTime?>((ref) => null);

// Service duration provider
final serviceDurationProvider = StateProvider<Duration?>((ref) => null);
