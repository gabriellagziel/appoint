import 'package:flutter_riverpod/flutter_riverpod.dart';

// TODO(username): Implement proper selection providers for booking flow
final staffSelectionProvider = StateProvider<String?>((ref) => null);
final serviceSelectionProvider = StateProvider<String?>((ref) => null);
final serviceNameProvider = StateProvider<String?>((ref) => null);
final selectedSlotProvider = StateProvider<DateTime?>((ref) => null);
final serviceDurationProvider = StateProvider<Duration?>((ref) => null);
