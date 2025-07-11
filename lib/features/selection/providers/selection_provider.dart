import 'package:flutter_riverpod/flutter_riverpod.dart';

// Staff selection provider
staffSelectionProvider = StateProvider<String?>((final ref) => null);

// Service selection provider
serviceSelectionProvider = StateProvider<String?>((final ref) => null);

// Service name provider
serviceNameProvider = StateProvider<String?>((final ref) => null);

// Time slot selection provider
selectedSlotProvider = StateProvider<DateTime?>((final ref) => null);

// Service duration provider
serviceDurationProvider = StateProvider<Duration?>((final ref) => null);
