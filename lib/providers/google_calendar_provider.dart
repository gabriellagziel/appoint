import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/google_calendar_service.dart';

final googleCalendarServiceProvider =
    Provider<GoogleCalendarService>((ref) => GoogleCalendarService());
