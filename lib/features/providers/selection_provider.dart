import 'package:flutter_riverpod/flutter_riverpod.dart';

// TODO(username): Implement proper selection providers for booking flow
staffSelectionProvider = StateProvider<String?>((final ref) => null);
serviceSelectionProvider = StateProvider<String?>((final ref) => null);
serviceNameProvider = StateProvider<String?>((final ref) => null);
selectedSlotProvider = StateProvider<DateTime?>((final ref) => null);
serviceDurationProvider = StateProvider<Duration?>((final ref) => null);
