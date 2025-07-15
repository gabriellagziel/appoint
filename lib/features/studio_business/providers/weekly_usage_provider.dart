import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final weeklyUsageProvider =
    StateNotifierProvider<WeeklyUsageNotifier, int>((ref) => WeeklyUsageNotifier());

class WeeklyUsageNotifier extends StateNotifier<int> {
  WeeklyUsageNotifier() : super(0) {
    _loadWeeklyUsage();
  }

  static const String _usageKey = 'weekly_booking_count';
  static const String _lastResetKey = 'last_weekly_reset';

  Future<void> _loadWeeklyUsage() async {
    final prefs = await SharedPreferences.getInstance();
    final lastReset = prefs.getString(_lastResetKey);
    final now = DateTime.now();

    // Check if we need to reset (new week)
    if (lastReset != null) {
      final lastResetDate = DateTime.parse(lastReset);
      final daysSinceReset = now.difference(lastResetDate).inDays;

      if (daysSinceReset >= 7) {
        // Reset for new week
        await _resetWeeklyUsage();
        return;
      }
    } else {
      // First time, set last reset to now
      await prefs.setString(_lastResetKey, now.toIso8601String());
    }

    // Load current usage
    final usage = prefs.getInt(_usageKey) ?? 0;
    state = usage;
  }

  Future<void> _resetWeeklyUsage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_usageKey, 0);
    await prefs.setString(_lastResetKey, DateTime.now().toIso8601String());
    state = 0;
  }

  Future<void> incrementUsage() async {
    final prefs = await SharedPreferences.getInstance();
    final newUsage = state + 1;
    await prefs.setInt(_usageKey, newUsage);
    state = newUsage;
  }

  bool get shouldShowUpgradeModal => state > 21;

  String get upgradeCode {
    // Generate a simple upgrade code based on current user and timestamp
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'UPGRADE_${timestamp.toString().substring(timestamp.toString().length - 6)}';
  }
}
