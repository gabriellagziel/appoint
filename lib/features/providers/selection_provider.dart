import 'package:flutter_riverpod/flutter_riverpod.dart';

// TODO: Implement proper selection providers for booking flow
final staffSelectionProvider = StateProvider<String?>((final ref) => null);
final serviceSelectionProvider = StateProvider<String?>((final ref) => null);
final serviceNameProvider = StateProvider<String?>((final ref) => null);
final selectedSlotProvider = StateProvider<DateTime?>((final ref) => null);
final serviceDurationProvider = StateProvider<Duration?>((final ref) => null);
