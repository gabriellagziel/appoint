import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/ambassador_stats.dart';
import '../models/business_analytics.dart';

class AmbassadorService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<AmbassadorStats>> fetchAmbassadorStats({
    String? country,
    String? language,
    DateTimeRange? dateRange,
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
              AmbassadorStats.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Return mock data for development
      return _getMockAmbassadorStats();
    }
  }

  List<AmbassadorStats> _getMockAmbassadorStats() {
    final now = DateTime.now();
    return [
      AmbassadorStats(
        country: 'United States',
        language: 'English',
        ambassadors: 45,
        referrals: 128,
        surveyScore: 4.2,
        date: now.subtract(const Duration(days: 30)),
      ),
      AmbassadorStats(
        country: 'Spain',
        language: 'Spanish',
        ambassadors: 32,
        referrals: 89,
        surveyScore: 4.5,
        date: now.subtract(const Duration(days: 25)),
      ),
      AmbassadorStats(
        country: 'Germany',
        language: 'German',
        ambassadors: 28,
        referrals: 76,
        surveyScore: 4.1,
        date: now.subtract(const Duration(days: 20)),
      ),
      AmbassadorStats(
        country: 'France',
        language: 'French',
        ambassadors: 35,
        referrals: 94,
        surveyScore: 4.3,
        date: now.subtract(const Duration(days: 15)),
      ),
      AmbassadorStats(
        country: 'Italy',
        language: 'Italian',
        ambassadors: 22,
        referrals: 67,
        surveyScore: 4.0,
        date: now.subtract(const Duration(days: 10)),
      ),
      AmbassadorStats(
        country: 'United Kingdom',
        language: 'English',
        ambassadors: 38,
        referrals: 112,
        surveyScore: 4.4,
        date: now.subtract(const Duration(days: 5)),
      ),
      AmbassadorStats(
        country: 'Canada',
        language: 'English',
        ambassadors: 25,
        referrals: 73,
        surveyScore: 4.1,
        date: now.subtract(const Duration(days: 2)),
      ),
    ];
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
      final totalAmbassadors =
          countryStats.fold<int>(0, (sum, stat) => sum + stat.ambassadors);
      final totalReferrals =
          countryStats.fold<int>(0, (sum, stat) => sum + stat.referrals);
      final avgSurveyScore =
          countryStats.fold<double>(0, (sum, stat) => sum + stat.surveyScore) /
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

  Future<List<TimeSeriesPoint>> fetchReferralTrend({
    String? country,
    String? language,
    DateTimeRange? dateRange,
  }) async {
    try {
      Query query = _firestore.collection('ambassador_stats').orderBy('date');

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
      final Map<DateTime, int> counts = {};

      for (final doc in snapshot.docs) {
        final ts = doc.data()['date'] as Timestamp?;
        final referrals = doc.data()['referrals'] as int? ?? 0;
        if (ts == null) continue;
        final date = DateTime(ts.toDate().year, ts.toDate().month, ts.toDate().day);
        counts.update(date, (v) => v + referrals, ifAbsent: () => referrals);
      }

      final points = counts.entries
          .map((e) => TimeSeriesPoint(date: e.key, count: e.value))
          .toList()
        ..sort((a, b) => a.date.compareTo(b.date));

      return points;
    } catch (e) {
      final now = DateTime.now();
      return List.generate(7, (i) {
        return TimeSeriesPoint(
            date: now.subtract(Duration(days: 6 - i)), count: (i + 1) * 4);
      });
    }
  }
}
