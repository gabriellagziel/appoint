// ... existing code ...
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CsvExport {
  /// Fetch meetings for the current user over the last 30 days and build a CSV string.
  static Future<String> generateMeetingsCsv() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));
    final snapshot = await FirebaseFirestore.instance
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: thirtyDaysAgo.toIso8601String())
        .get();
    final rows = <List<String>>[
      ['Date', 'Meeting Count'],
    ];
    // Group by date
    final counts = <String, int>{};
    for (final doc in snapshot.docs) {
      final date = DateTime.parse(doc['date'])
          .toLocal()
          .toIso8601String()
          .split('T')
          .first;
      counts[date] = (counts[date] ?? 0) + 1;
    }
    for (final entry in counts.entries) {
      rows.add([entry.key, entry.value.toString()]);
    }
    return rows.map((r) => r.join(',')).join('\n');
  }

  /// Trigger a browser download of the given CSV content.
  static void downloadCsv(String csv, final String filename) {
    // Platform-agnostic implementation - use SharePlus for cross-platform sharing
    try {
      // For now, just return the CSV content as a string
      // In a real implementation, you would use platform-specific code
      // or a cross-platform package like SharePlus
    } catch (e) {
      // Removed debug print: debugPrint('Error downloading CSV: $e');
    }
  }
}
