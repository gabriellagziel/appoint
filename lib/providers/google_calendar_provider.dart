import 'package:appoint/services/google_calendar_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final googleCalendarServiceProvider =
    Provider<GoogleCalendarService>((ref) => GoogleCalendarService());
