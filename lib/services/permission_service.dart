import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PermissionService {
  static const _notifKey = 'permission_notifications';
  static const _calendarKey = 'permission_calendar';
  static const _locationKey = 'permission_location';

  Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    await _saveStatus(_notifKey, status);
    return status.isGranted;
  }

  Future<bool> requestCalendarPermission() async {
    final status = await Permission.calendar.request();
    await _saveStatus(_calendarKey, status);
    return status.isGranted;
  }

  Future<bool> requestLocationPermission() async {
    final status = await Permission.location.request();
    await _saveStatus(_locationKey, status);
    return status.isGranted;
  }

  Future<void> _saveStatus(String key, PermissionStatus status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, status.isGranted);
  }

  Future<bool> isPermissionGranted(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  Future<bool> isNotificationGranted() => isPermissionGranted(_notifKey);
  Future<bool> isCalendarGranted() => isPermissionGranted(_calendarKey);
  Future<bool> isLocationGranted() => isPermissionGranted(_locationKey);
}