import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider for weekly usage count
final weeklyUsageProvider = StateProvider<int>((ref) => 0);

// Provider for usage monitor service
final usageMonitorProvider =
    Provider<UsageMonitorService>((ref) => UsageMonitorService());

class UsageMonitorService {
  static const int maxFreeMeetings = 21;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Checks if booking should be blocked based on weekly count and business mode
  static bool shouldBlockBooking({
    required int weeklyCount,
    required bool isBusiness,
  }) =>
      !isBusiness && weeklyCount >= maxFreeMeetings;

  /// Increments the weekly usage count
  Future<void> incrementWeeklyUsage(String userId) async {
    try {
      final weekKey = _getCurrentWeekKey();
      final userUsageRef = _firestore
          .collection('user_usage')
          .doc(userId)
          .collection('weekly_usage')
          .doc(weekKey);

      await _firestore.runTransaction((transaction) async {
        final doc = await transaction.get(userUsageRef);
        if (doc.exists) {
          final currentCount = doc.data()?['count'] ?? 0;
          transaction.update(userUsageRef, {'count': currentCount + 1});
        } else {
          transaction.set(userUsageRef, {
            'count': 1,
            'weekStart': _getWeekStart(),
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      });
    } catch (e) {
      // Log error but don't throw to prevent blocking bookings
      print('Error incrementing weekly usage: $e');
    }
  }

  /// Gets the current weekly usage count for a user
  Future<int> getWeeklyUsage(String userId) async {
    try {
      final weekKey = _getCurrentWeekKey();
      final doc = await _firestore
          .collection('user_usage')
          .doc(userId)
          .collection('weekly_usage')
          .doc(weekKey)
          .get();

      if (doc.exists) {
        return doc.data()?['count'] ?? 0;
      }
      return 0;
    } catch (e) {
      print('Error getting weekly usage: $e');
      return 0;
    }
  }

  /// Stream for real-time weekly usage updates
  Stream<int> watchWeeklyUsage(String userId) {
    final weekKey = _getCurrentWeekKey();
    return _firestore
        .collection('user_usage')
        .doc(userId)
        .collection('weekly_usage')
        .doc(weekKey)
        .snapshots()
        .map((doc) => doc.exists ? (doc.data()?['count'] as int?) ?? 0 : 0);
  }

  /// Resets weekly count if a new week has started
  static void resetWeeklyCountIfNeeded() {
    // This will be called on app launch or booking screen load
    // The actual reset happens automatically when a new week key is generated
    // No manual intervention needed as we use week-based document IDs
  }

  /// Gets the current week key (year-week format)
  String _getCurrentWeekKey() {
    final now = DateTime.now();
    final startOfWeek = _getWeekStart();
    final year = startOfWeek.year;
    final weekNumber = _getWeekNumber(startOfWeek);
    return '$year-W${weekNumber.toString().padLeft(2, '0')}';
  }

  /// Gets the start of the current week (Monday)
  DateTime _getWeekStart() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    return DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
  }

  /// Gets the week number of the year
  int _getWeekNumber(DateTime date) {
    final firstDayOfYear = DateTime(date.year);
    final firstWeekday = firstDayOfYear.weekday;
    final daysInFirstWeek = 8 - firstWeekday;
    final firstWeekEnd =
        firstDayOfYear.add(Duration(days: daysInFirstWeek - 1));

    if (date.isBefore(firstWeekEnd) || date.isAtSameMomentAs(firstWeekEnd)) {
      return 1;
    }

    final daysSinceFirstWeek = date.difference(firstWeekEnd).inDays;
    return (daysSinceFirstWeek / 7).floor() + 2;
  }
}
