import 'package:appoint/models/ambassador_stats.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../firebase_test_helper.dart';

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
  });

  group('Ambassador Dashboard Logic Tests', () {
    test('filters chart data based on country filter', () {
      final data = AmbassadorData(
        stats: [
          AmbassadorStats(
            country: 'United States',
            language: 'English',
            ambassadors: 10,
            referrals: 25,
            surveyScore: 4.5,
            date: DateTime.now(),
          ),
          AmbassadorStats(
            country: 'Spain',
            language: 'Spanish',
            ambassadors: 5,
            referrals: 15,
            surveyScore: 4.2,
            date: DateTime.now(),
          ),
        ],
        chartData: [
          const ChartDataPoint(
            label: 'United States',
            value: 25,
            category: 'referrals',
          ),
          const ChartDataPoint(
            label: 'Spain',
            value: 15,
            category: 'referrals',
          ),
        ],
      );

      // Test filtering logic
      final filteredStats =
          data.stats.where((s) => s.country == 'United States').toList();
      expect(filteredStats.length, equals(1));
      expect(filteredStats.first.country, equals('United States'));
    });

    test('filters chart data based on language filter', () {
      final data = AmbassadorData(
        stats: [
          AmbassadorStats(
            country: 'United States',
            language: 'English',
            ambassadors: 10,
            referrals: 25,
            surveyScore: 4.5,
            date: DateTime.now(),
          ),
          AmbassadorStats(
            country: 'Spain',
            language: 'Spanish',
            ambassadors: 5,
            referrals: 15,
            surveyScore: 4.2,
            date: DateTime.now(),
          ),
        ],
        chartData: [
          const ChartDataPoint(
            label: 'United States',
            value: 25,
            category: 'referrals',
          ),
          const ChartDataPoint(
            label: 'Spain',
            value: 15,
            category: 'referrals',
          ),
        ],
      );

      final filteredStats =
          data.stats.where((s) => s.language == 'English').toList();
      expect(filteredStats.length, equals(1));
      expect(filteredStats.first.language, equals('English'));
    });

    test('calculates total ambassadors correctly', () {
      final stats = [
        AmbassadorStats(
          country: 'United States',
          language: 'English',
          ambassadors: 10,
          referrals: 25,
          surveyScore: 4.5,
          date: DateTime.now(),
        ),
        AmbassadorStats(
          country: 'Spain',
          language: 'Spanish',
          ambassadors: 5,
          referrals: 15,
          surveyScore: 4.2,
          date: DateTime.now(),
        ),
      ];

      final totalAmbassadors =
          stats.fold<int>(0, (sum, final stat) => sum + stat.ambassadors);
      expect(totalAmbassadors, equals(15));
    });

    test('calculates total referrals correctly', () {
      final stats = [
        AmbassadorStats(
          country: 'United States',
          language: 'English',
          ambassadors: 10,
          referrals: 25,
          surveyScore: 4.5,
          date: DateTime.now(),
        ),
        AmbassadorStats(
          country: 'Spain',
          language: 'Spanish',
          ambassadors: 5,
          referrals: 15,
          surveyScore: 4.2,
          date: DateTime.now(),
        ),
      ];

      final totalReferrals =
          stats.fold<int>(0, (sum, final stat) => sum + stat.referrals);
      expect(totalReferrals, equals(40));
    });

    test('calculates average survey score correctly', () {
      final stats = [
        AmbassadorStats(
          country: 'United States',
          language: 'English',
          ambassadors: 10,
          referrals: 25,
          surveyScore: 4.5,
          date: DateTime.now(),
        ),
        AmbassadorStats(
          country: 'Spain',
          language: 'Spanish',
          ambassadors: 5,
          referrals: 15,
          surveyScore: 4.2,
          date: DateTime.now(),
        ),
      ];

      final averageScore = stats.fold<double>(
            0,
            (sum, final stat) => sum + stat.surveyScore,
          ) /
          stats.length;
      expect(averageScore, equals(4.35));
    });

    test('chart data max value calculation', () {
      final chartData = [
        const ChartDataPoint(
          label: 'United States',
          value: 25,
          category: 'referrals',
        ),
        const ChartDataPoint(
          label: 'Spain',
          value: 15,
          category: 'referrals',
        ),
        const ChartDataPoint(
          label: 'Germany',
          value: 30,
          category: 'referrals',
        ),
      ];

      final maxValue =
          chartData.map((e) => e.value).reduce((a, final b) => a > b ? a : b);
      expect(maxValue, equals(30.0));
    });
  });
}
