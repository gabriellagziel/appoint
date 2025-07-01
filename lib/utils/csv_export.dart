// ignore: deprecated_member_use
import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

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
      ['Date', 'Meeting Count']
    ];
    // Group by date
    final counts = <String, int>{};
    for (var doc in snapshot.docs) {
      final date = DateTime.parse(doc['date'])
          .toLocal()
          .toIso8601String()
          .split('T')
          .first;
      counts[date] = (counts[date] ?? 0) + 1;
    }
    for (var entry in counts.entries) {
      rows.add([entry.key, entry.value.toString()]);
    }
    return rows.map((final r) => r.join(',')).join('\n');
  }

  /// Trigger a browser download of the given CSV content.
  static void downloadCsv(final String csv, final String filename) {
    try {
      final bytes = utf8.encode(csv);
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', filename);

      // Ensure the anchor element is properly added to the DOM
      final body = html.document.body;
      if (body != null) {
        body.append(anchor);
        anchor.click();
        anchor.remove();
      } else {
        // Fallback if body is null
        anchor.click();
      }

      html.Url.revokeObjectUrl(url);
    } catch (e) {
      // Removed debug print: print('Error downloading CSV: $e');
    }
  }
}
