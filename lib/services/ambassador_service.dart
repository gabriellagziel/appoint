import 'package:appoint/models/ambassador_stats.dart';
import 'package:appoint/models/business_analytics.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AmbassadorService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<AmbassadorStats>> fetchAmbassadorStats({
    final String? country,
    final String? language,
    final DateTimeRange? dateRange,
  }) async {
    try {
      Query query = _firestore.collection('ambassador_stats');

      if (country != null) {
        query = query.where('country', isEqualTo: country);
      }

      if (language != null) {
        query = query.where('language', isEqualTo: language);
      }

      if (dateRange != null) {
        query = query
            .where('date', isGreaterThanOrEqualTo: dateRange.start)
            .where('date', isLessThanOrEqualTo: dateRange.end);
      }

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) =>
              AmbassadorStats.fromJson(doc.data()!),)
          .toList();
    } catch (e) {
      // TODO(username): Implement proper error handling and fallback data
      return [];
    }
  }

  List<ChartDataPoint> generateChartData(List<AmbassadorStats> stats) {
    final chartData = <ChartDataPoint>[];

    // Group by country for chart
    final countryGroups = <String, List<AmbassadorStats>>{};
    for (final stat in stats) {
      countryGroups.putIfAbsent(stat.country, () => []).add(stat);
    }

    for (final entry in countryGroups.entries) {
      final countryStats = entry.value;
      final totalAmbassadors = countryStats.fold<int>(
          0, (total, final stat) => total + stat.ambassadors,);
      final totalReferrals = countryStats.fold<int>(
          0, (total, final stat) => total + stat.referrals,);
      final avgSurveyScore = countryStats.fold<double>(
              0, (total, final stat) => total + stat.surveyScore,) /
          countryStats.length;

      chartData.addAll([
        ChartDataPoint(
          label: entry.key,
          value: totalAmbassadors.toDouble(),
          category: 'Ambassadors',
        ),
        ChartDataPoint(
          label: entry.key,
          value: totalReferrals.toDouble(),
          category: 'Referrals',
        ),
        ChartDataPoint(
          label: entry.key,
          value: avgSurveyScore,
          category: 'Survey Score',
        ),
      ]);
    }

    return chartData;
  }

  Future<List<TimeSeriesPoint>> fetchAmbassadorsOverTime({
    final DateTimeRange? range,
  }) async {
    try {
      Query query = _firestore.collection('ambassador_stats').orderBy('date');
      if (range != null) {
        query = query
            .where('date', isGreaterThanOrEqualTo: range.start)
            .where('date', isLessThanOrEqualTo: range.end);
      }

      final snapshot = await query.get();
      final counts = <DateTime, int>{};
      for (final doc in snapshot.docs) {
        final ts = doc['date'] as Timestamp?;
        if (ts == null) continue;
        final date =
            DateTime(ts.toDate().year, ts.toDate().month, ts.toDate().day);
        final ambassadors = (doc['ambassadors'] as int?) ?? 0;
        counts.update(date, (v) => v + ambassadors,
            ifAbsent: () => ambassadors,);
      }

      final list = counts.entries
          .map((e) => TimeSeriesPoint(date: e.key, count: e.value))
          .toList();
      list.sort((a, final b) => a.date.compareTo(b.date));
      return list;
    } catch (e) {
      final now = DateTime.now();
      return List.generate(7, (i) => TimeSeriesPoint(
            date: now.subtract(Duration(days: 6 - i)), count: (i + 1) * 4,),);
    }
  }
}
