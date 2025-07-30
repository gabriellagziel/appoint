import 'package:googleapis/calendar/v3.dart';

class GoogleConfig {
  static const clientId = 'appoint-prod.apps.googleusercontent.com';
  static const redirectUri = 'com.app.oint:/oauth2redirect';
  static const List<String> scopes = [CalendarApi.calendarScope];
}
