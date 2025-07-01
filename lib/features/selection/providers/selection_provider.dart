import 'package:flutter_riverpod/flutter_riverpod.dart';

// Staff selection provider
final staffSelectionProvider = StateProvider<String?>((final ref) => null);

// Service selection provider
final serviceSelectionProvider = StateProvider<String?>((final ref) => null);

// Service name provider
final serviceNameProvider = StateProvider<String?>((final ref) => null);

// Time slot selection provider
final selectedSlotProvider = StateProvider<DateTime?>((final ref) => null);

// Service duration provider
final serviceDurationProvider = StateProvider<Duration?>((final ref) => null);
