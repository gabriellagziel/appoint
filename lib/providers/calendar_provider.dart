import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appoint/models/calendar_event.dart';
import 'package:appoint/services/calendar_service.dart';
import 'package:appoint/providers/auth_provider.dart';

final calendarServiceProvider =
    Provider<CalendarService>((final ref) => CalendarService());

final googleEventsProvider = StreamProvider<List<CalendarEvent>>((final ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (final user) {
      if (user == null) return const Stream.empty();
      return ref
          .read(calendarServiceProvider)
          .watchEvents(user.uid, provider: 'google');
    },
    loading: () => const Stream.empty(),
    error: (final _, final __) => const Stream.empty(),
  );
});

final outlookEventsProvider = StreamProvider<List<CalendarEvent>>((final ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (final user) {
      if (user == null) return const Stream.empty();
      return ref
          .read(calendarServiceProvider)
          .watchEvents(user.uid, provider: 'outlook');
    },
    loading: () => const Stream.empty(),
    error: (final _, final __) => const Stream.empty(),
  );
});
