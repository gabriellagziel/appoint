import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appoint/services/google_calendar_service.dart';

final googleCalendarServiceProvider =
    Provider<GoogleCalendarService>((final ref) => GoogleCalendarService());
