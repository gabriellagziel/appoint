import 'package:appoint/models/business_analytics.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BusinessAnalyticsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<TimeSeriesPoint>> fetchBookingsOverTime({
    final DateTimeRange? range,
  }) async {
    try {
      var query = _firestore.collection('appointments').orderBy('dateTime');
      if (range != null) {
        query = query
            .where('dateTime', isGreaterThanOrEqualTo: range.start)
            .where('dateTime', isLessThanOrEqualTo: range.end);
      }
      final snapshot = await query.get();
      final counts = <DateTime, int>{};
      for (doc in snapshot.docs) {
        final ts = doc.data()['dateTime'] as Timestamp?;
        if (ts == null) continue;
        final date =
            DateTime(ts.toDate().year, ts.toDate().month, ts.toDate().day);
        counts.update(date, (value) => value + 1, ifAbsent: () => 1);
      }
      return counts.entries
          .map((e) => TimeSeriesPoint(date: e.key, count: e.value))
          .toList()
        ..sort((a, final b) => a.date.compareTo(b.date));
    } catch (e) {
      // Return sample data when offline or on error
      final now = DateTime.now();
      return List.generate(
        7,
        (i) => TimeSeriesPoint(
          date: now.subtract(Duration(days: 6 - i)),
          count: (i + 1) * 3,
        ),
      );
    }
  }

  Future<List<ServiceDistribution>> fetchServiceDistribution() async {
    try {
      final snapshot = await _firestore.collection('appointments').get();
      final counts = <String, int>{};
      for (doc in snapshot.docs) {
        final service = doc.data()['serviceName'] as String? ?? 'Unknown';
        counts.update(service, (value) => value + 1, ifAbsent: () => 1);
      }
      return counts.entries
          .map(
            (e) => ServiceDistribution(service: e.key, bookings: e.value),
          )
          .toList();
    } catch (e) {
      return [
        ServiceDistribution(service: 'Hair Cut', bookings: 20),
        ServiceDistribution(service: 'Color', bookings: 15),
        ServiceDistribution(service: 'Styling', bookings: 10),
      ];
    }
  }

  Future<List<RevenueByStaff>> fetchRevenueByStaff() async {
    try {
      final snapshot = await _firestore.collection('payments').get();
      final totals = <String, double>{};
      for (doc in snapshot.docs) {
        final staff = doc.data()['staffId'] as String? ?? 'unknown';
        final amount = (doc.data()['amount'] as num?)?.toDouble() ?? 0;
        totals.update(
          staff,
          (value) => value + amount,
          ifAbsent: () => amount,
        );
      }
      return totals.entries
          .map((e) => RevenueByStaff(staff: e.key, revenue: e.value))
          .toList();
    } catch (e) {
      return [
        RevenueByStaff(staff: 'Alice', revenue: 1200),
        RevenueByStaff(staff: 'Bob', revenue: 950),
        RevenueByStaff(staff: 'Carla', revenue: 760),
      ];
    }
  }
}
