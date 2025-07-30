import 'dart:io';

import 'package:appoint/models/ambassador_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// Advanced analytics service for Ambassador program
class AmbassadorAnalyticsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get country leaderboard with privacy controls
  Future<List<AmbassadorLeaderboardEntry>> getCountryLeaderboard({
    required String countryCode,
    int limit = 50,
    bool includePrivateProfiles = false,
  }) async {
    try {
      Query query = _firestore
          .collection('ambassador_profiles')
          .where('countryCode', isEqualTo: countryCode)
          .where('status', isEqualTo: 'approved');

      if (!includePrivateProfiles) {
        query = query.where('leaderboardOptIn', isEqualTo: true);
      }

      final snapshot = await query
          .orderBy('totalReferrals', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs.asMap().entries.map((entry) {
        final index = entry.key;
        final doc = entry.value;
        final data = doc.data()! as Map<String, dynamic>;

        return AmbassadorLeaderboardEntry(
          rank: index + 1,
          userId: data['userId'] ?? '',
          displayName: data['displayName'] ?? 'Anonymous Ambassador',
          totalReferrals: data['totalReferrals'] ?? 0,
          monthlyReferrals: data['monthlyReferrals'] ?? 0,
          tier: AmbassadorTier.values.firstWhere(
            (tier) => tier.name == data['tier'],
            orElse: () => AmbassadorTier.basic,
          ),
          conversionRate: data['conversionRate']?.toDouble() ?? 0.0,
          countryCode: data['countryCode'] ?? '',
          languageCode: data['languageCode'] ?? 'en',
          isOptedInToLeaderboard: data['leaderboardOptIn'] ?? false,
        );
      }).toList();
    } catch (e) {
      debugPrint('Error fetching country leaderboard: $e');
      return [];
    }
  }

  /// Get global leaderboard across all countries
  Future<List<AmbassadorLeaderboardEntry>> getGlobalLeaderboard({
    int limit = 100,
    bool includePrivateProfiles = false,
  }) async {
    try {
      Query query = _firestore
          .collection('ambassador_profiles')
          .where('status', isEqualTo: 'approved');

      if (!includePrivateProfiles) {
        query = query.where('leaderboardOptIn', isEqualTo: true);
      }

      final snapshot = await query
          .orderBy('totalReferrals', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs.asMap().entries.map((entry) {
        final index = entry.key;
        final doc = entry.value;
        final data = doc.data()! as Map<String, dynamic>;

        return AmbassadorLeaderboardEntry(
          rank: index + 1,
          userId: data['userId'] ?? '',
          displayName: data['displayName'] ?? 'Anonymous Ambassador',
          totalReferrals: data['totalReferrals'] ?? 0,
          monthlyReferrals: data['monthlyReferrals'] ?? 0,
          tier: AmbassadorTier.values.firstWhere(
            (tier) => tier.name == data['tier'],
            orElse: () => AmbassadorTier.basic,
          ),
          conversionRate: data['conversionRate']?.toDouble() ?? 0.0,
          countryCode: data['countryCode'] ?? '',
          languageCode: data['languageCode'] ?? 'en',
          isOptedInToLeaderboard: data['leaderboardOptIn'] ?? false,
        );
      }).toList();
    } catch (e) {
      debugPrint('Error fetching global leaderboard: $e');
      return [];
    }
  }

  /// Get time series data for referrals over time
  Future<List<TimeSeriesDataPoint>> getReferralTimeSeries({
    String? countryCode,
    String? languageCode,
    DateTime? startDate,
    DateTime? endDate,
    TimeSeriesGranularity granularity = TimeSeriesGranularity.daily,
  }) async {
    try {
      Query query = _firestore.collection('ambassador_referrals');

      if (countryCode != null) {
        // Join with ambassador profiles to filter by country
        final ambassadors = await _firestore
            .collection('ambassador_profiles')
            .where('countryCode', isEqualTo: countryCode)
            .get();

        final ambassadorIds = ambassadors.docs.map((doc) => doc.id).toList();
        if (ambassadorIds.isEmpty) return [];

        query = query.where('ambassadorId',
            whereIn: ambassadorIds.take(10).toList());
      }

      if (startDate != null) {
        query = query.where('referredAt',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startDate));
      }

      if (endDate != null) {
        query = query.where('referredAt',
            isLessThanOrEqualTo: Timestamp.fromDate(endDate));
      }

      final snapshot = await query.orderBy('referredAt').get();

      // Group data by time periods
      final groupedData = <DateTime, int>{};

      for (final doc in snapshot.docs) {
        final data = doc.data()! as Map<String, dynamic>;
        final timestamp = data['referredAt'] as Timestamp?;
        if (timestamp == null) continue;

        final date = timestamp.toDate();
        final groupedDate = _groupDateByGranularity(date, granularity);

        groupedData.update(groupedDate, (value) => value + 1,
            ifAbsent: () => 1);
      }

      return groupedData.entries
          .map(
            (entry) => TimeSeriesDataPoint(
              date: entry.key,
              value: entry.value,
            ),
          )
          .toList()
        ..sort((a, b) => a.date.compareTo(b.date));
    } catch (e) {
      debugPrint('Error fetching referral time series: $e');
      return [];
    }
  }

  /// Get active users time series
  Future<List<TimeSeriesDataPoint>> getActiveUsersTimeSeries({
    String? countryCode,
    DateTime? startDate,
    DateTime? endDate,
    TimeSeriesGranularity granularity = TimeSeriesGranularity.daily,
  }) async {
    try {
      Query query =
          _firestore.collection('users').where('isActive', isEqualTo: true);

      if (countryCode != null) {
        query = query.where('countryCode', isEqualTo: countryCode);
      }

      if (startDate != null) {
        query = query.where('lastActiveAt',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startDate));
      }

      if (endDate != null) {
        query = query.where('lastActiveAt',
            isLessThanOrEqualTo: Timestamp.fromDate(endDate));
      }

      final snapshot = await query.get();

      // Group data by time periods
      final groupedData = <DateTime, Set<String>>{};

      for (final doc in snapshot.docs) {
        final data = doc.data()! as Map<String, dynamic>;
        final timestamp = data['lastActiveAt'] as Timestamp?;
        if (timestamp == null) continue;

        final date = timestamp.toDate();
        final groupedDate = _groupDateByGranularity(date, granularity);

        groupedData.putIfAbsent(groupedDate, () => <String>{}).add(doc.id);
      }

      return groupedData.entries
          .map(
            (entry) => TimeSeriesDataPoint(
              date: entry.key,
              value: entry.value.length,
            ),
          )
          .toList()
        ..sort((a, b) => a.date.compareTo(b.date));
    } catch (e) {
      debugPrint('Error fetching active users time series: $e');
      return [];
    }
  }

  /// Calculate conversion rates per ambassador
  Future<List<AmbassadorConversionRate>> getConversionRates({
    String? countryCode,
    int? minimumReferrals = 5,
  }) async {
    try {
      Query query = _firestore
          .collection('ambassador_profiles')
          .where('status', isEqualTo: 'approved');

      if (countryCode != null) {
        query = query.where('countryCode', isEqualTo: countryCode);
      }

      if (minimumReferrals != null) {
        query = query.where('totalReferrals',
            isGreaterThanOrEqualTo: minimumReferrals);
      }

      final snapshot = await query.get();

      final conversionRates = <AmbassadorConversionRate>[];

      for (final doc in snapshot.docs) {
        final profile = doc.data()! as Map<String, dynamic>;
        final ambassadorId = doc.id;

        // Get referral data for this ambassador
        final referralsSnapshot = await _firestore
            .collection('ambassador_referrals')
            .where('ambassadorId', isEqualTo: ambassadorId)
            .get();

        final totalReferrals = referralsSnapshot.size;
        final activeReferrals = referralsSnapshot.docs
            .where((doc) => doc.data()['isActive'] == true)
            .length;

        final conversionRate =
            totalReferrals > 0 ? (activeReferrals / totalReferrals) * 100 : 0.0;

        conversionRates.add(
          AmbassadorConversionRate(
            ambassadorId: ambassadorId,
            displayName: profile['displayName'] ?? 'Anonymous',
            totalReferrals: totalReferrals,
            activeReferrals: activeReferrals,
            conversionRate: conversionRate,
            countryCode: profile['countryCode'] ?? '',
            tier: AmbassadorTier.values.firstWhere(
              (tier) => tier.name == profile['tier'],
              orElse: () => AmbassadorTier.basic,
            ),
          ),
        );
      }

      // Sort by conversion rate
      conversionRates
          .sort((a, b) => b.conversionRate.compareTo(a.conversionRate));

      return conversionRates;
    } catch (e) {
      debugPrint('Error calculating conversion rates: $e');
      return [];
    }
  }

  /// Get regional performance summary
  Future<List<RegionalPerformance>> getRegionalPerformance() async {
    try {
      final snapshot = await _firestore
          .collection('ambassador_profiles')
          .where('status', isEqualTo: 'approved')
          .get();

      final regionData = <String, RegionalPerformanceData>{};

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final countryCode = data['countryCode'] as String? ?? 'Unknown';

        if (!regionData.containsKey(countryCode)) {
          regionData[countryCode] = RegionalPerformanceData(
            ambassadorCount: 0,
            totalReferrals: 0,
            averageReferrals: 0,
            conversionRate: 0,
          );
        }

        final regionStats = regionData[countryCode]!;
        regionStats.ambassadorCount++;
        regionStats.totalReferrals += data['totalReferrals'] as int? ?? 0;
      }

      // Calculate averages and conversion rates
      final performance = <RegionalPerformance>[];

      for (final entry in regionData.entries) {
        final countryCode = entry.key;
        final stats = entry.value;

        final avgReferrals = stats.ambassadorCount > 0
            ? stats.totalReferrals / stats.ambassadorCount
            : 0.0;

        // Get conversion rate for this region
        final conversionRates =
            await getConversionRates(countryCode: countryCode);
        final avgConversionRate = conversionRates.isNotEmpty
            ? conversionRates
                    .map((cr) => cr.conversionRate)
                    .reduce((a, b) => a + b) /
                conversionRates.length
            : 0.0;

        performance.add(
          RegionalPerformance(
            countryCode: countryCode,
            countryName: _getCountryName(countryCode),
            ambassadorCount: stats.ambassadorCount,
            totalReferrals: stats.totalReferrals,
            averageReferrals: avgReferrals,
            conversionRate: avgConversionRate,
          ),
        );
      }

      // Sort by total referrals
      performance.sort((a, b) => b.totalReferrals.compareTo(a.totalReferrals));

      return performance;
    } catch (e) {
      debugPrint('Error fetching regional performance: $e');
      return [];
    }
  }

  /// Export analytics data to CSV
  Future<String> exportAnalyticsToCSV({
    required AnalyticsExportType exportType,
    String? countryCode,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      var csvData = <List<dynamic>>[];

      switch (exportType) {
        case AnalyticsExportType.leaderboard:
          csvData = await _exportLeaderboardToCSV(countryCode);
        case AnalyticsExportType.conversionRates:
          csvData = await _exportConversionRatesToCSV(countryCode);
        case AnalyticsExportType.timeSeries:
          csvData =
              await _exportTimeSeriesToCSV(countryCode, startDate, endDate);
        case AnalyticsExportType.regionalPerformance:
          csvData = await _exportRegionalPerformanceToCSV();
      }

      final csvString = const ListToCsvConverter().convert(csvData);

      // Save to file
      final directory = await REDACTED_TOKEN();
      final fileName =
          'ambassador_${exportType.name}_${DateTime.now().millisecondsSinceEpoch}.csv';
      final file = File('${directory.path}/$fileName');
      await file.writeAsString(csvString);

      return file.path;
    } catch (e) {
      debugPrint('Error exporting analytics to CSV: $e');
      throw Exception('Failed to export analytics data');
    }
  }

  /// Private helper methods

  DateTime _groupDateByGranularity(
      DateTime date, TimeSeriesGranularity granularity) {
    switch (granularity) {
      case TimeSeriesGranularity.hourly:
        return DateTime(date.year, date.month, date.day, date.hour);
      case TimeSeriesGranularity.daily:
        return DateTime(date.year, date.month, date.day);
      case TimeSeriesGranularity.weekly:
        final dayOfWeek = date.weekday;
        final startOfWeek = date.subtract(Duration(days: dayOfWeek - 1));
        return DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
      case TimeSeriesGranularity.monthly:
        return DateTime(date.year, date.month);
      case TimeSeriesGranularity.yearly:
        return DateTime(date.year);
    }
  }

  String _getCountryName(String countryCode) {
    // Simple country code to name mapping
    final countryNames = {
      'US': 'United States',
      'CA': 'Canada',
      'GB': 'United Kingdom',
      'DE': 'Germany',
      'FR': 'France',
      'ES': 'Spain',
      'IT': 'Italy',
      'BR': 'Brazil',
      'MX': 'Mexico',
      'AR': 'Argentina',
      'IN': 'India',
      'CN': 'China',
      'JP': 'Japan',
      'KR': 'South Korea',
      'AU': 'Australia',
      'NZ': 'New Zealand',
      'ZA': 'South Africa',
      'NG': 'Nigeria',
      'EG': 'Egypt',
      'SA': 'Saudi Arabia',
      'AE': 'United Arab Emirates',
      'TR': 'Turkey',
      'RU': 'Russia',
      'PL': 'Poland',
      'UA': 'Ukraine',
      'RO': 'Romania',
      'GR': 'Greece',
      'NL': 'Netherlands',
      'CZ': 'Czech Republic',
      'HU': 'Hungary',
      'BG': 'Bulgaria',
      'HR': 'Croatia',
      'SK': 'Slovakia',
      'LV': 'Latvia',
      'LT': 'Lithuania',
      'RS': 'Serbia',
      'FI': 'Finland',
      'SE': 'Sweden',
      'NO': 'Norway',
      'DK': 'Denmark',
      'SI': 'Slovenia',
      'ID': 'Indonesia',
      'TH': 'Thailand',
      'VN': 'Vietnam',
      'PH': 'Philippines',
      'MY': 'Malaysia',
      'SG': 'Singapore',
      'TW': 'Taiwan',
      'HK': 'Hong Kong',
      'BD': 'Bangladesh',
      'PK': 'Pakistan',
      'IR': 'Iran',
      'IL': 'Israel',
      'CO': 'Colombia',
      'PE': 'Peru',
      'CL': 'Chile',
      'VE': 'Venezuela',
      'EC': 'Ecuador',
      'UY': 'Uruguay',
      'KE': 'Kenya',
      'GH': 'Ghana',
      'ET': 'Ethiopia',
      'TZ': 'Tanzania',
      'UG': 'Uganda',
      'ZW': 'Zimbabwe',
      'ZM': 'Zambia',
    };

    return countryNames[countryCode] ?? countryCode;
  }

  Future<List<List<dynamic>>> _exportLeaderboardToCSV(
      String? countryCode) async {
    final leaderboard = countryCode != null
        ? await getCountryLeaderboard(countryCode: countryCode, limit: 1000)
        : await getGlobalLeaderboard(limit: 1000);

    final csvData = <List<dynamic>>[
      [
        'Rank',
        'Ambassador ID',
        'Display Name',
        'Total Referrals',
        'Monthly Referrals',
        'Tier',
        'Conversion Rate',
        'Country',
        'Language'
      ],
    ];

    for (final entry in leaderboard) {
      csvData.add([
        entry.rank,
        entry.userId,
        entry.displayName,
        entry.totalReferrals,
        entry.monthlyReferrals,
        entry.tier.displayName,
        '${entry.conversionRate.toStringAsFixed(2)}%',
        entry.countryCode,
        entry.languageCode,
      ]);
    }

    return csvData;
  }

  Future<List<List<dynamic>>> _exportConversionRatesToCSV(
      String? countryCode) async {
    final conversionRates = await getConversionRates(countryCode: countryCode);

    final csvData = <List<dynamic>>[
      [
        'Ambassador ID',
        'Display Name',
        'Total Referrals',
        'Active Referrals',
        'Conversion Rate',
        'Country',
        'Tier'
      ],
    ];

    for (final rate in conversionRates) {
      csvData.add([
        rate.ambassadorId,
        rate.displayName,
        rate.totalReferrals,
        rate.activeReferrals,
        '${rate.conversionRate.toStringAsFixed(2)}%',
        rate.countryCode,
        rate.tier.displayName,
      ]);
    }

    return csvData;
  }

  Future<List<List<dynamic>>> _exportTimeSeriesToCSV(
      String? countryCode, DateTime? startDate, DateTime? endDate) async {
    final referralSeries = await getReferralTimeSeries(
      countryCode: countryCode,
      startDate: startDate,
      endDate: endDate,
    );

    final csvData = <List<dynamic>>[
      ['Date', 'Referrals Count'],
    ];

    for (final point in referralSeries) {
      csvData.add([
        point.date.toIso8601String().substring(0, 10), // Date only
        point.value,
      ]);
    }

    return csvData;
  }

  Future<List<List<dynamic>>> _exportRegionalPerformanceToCSV() async {
    final regionalPerformance = await getRegionalPerformance();

    final csvData = <List<dynamic>>[
      [
        'Country Code',
        'Country Name',
        'Ambassador Count',
        'Total Referrals',
        'Average Referrals',
        'Conversion Rate'
      ],
    ];

    for (final region in regionalPerformance) {
      csvData.add([
        region.countryCode,
        region.countryName,
        region.ambassadorCount,
        region.totalReferrals,
        region.averageReferrals.toStringAsFixed(2),
        '${region.conversionRate.toStringAsFixed(2)}%',
      ]);
    }

    return csvData;
  }
}

// Data models for analytics

class AmbassadorLeaderboardEntry {
  AmbassadorLeaderboardEntry({
    required this.rank,
    required this.userId,
    required this.displayName,
    required this.totalReferrals,
    required this.monthlyReferrals,
    required this.tier,
    required this.conversionRate,
    required this.countryCode,
    required this.languageCode,
    required this.isOptedInToLeaderboard,
  });
  final int rank;
  final String userId;
  final String displayName;
  final int totalReferrals;
  final int monthlyReferrals;
  final AmbassadorTier tier;
  final double conversionRate;
  final String countryCode;
  final String languageCode;
  final bool isOptedInToLeaderboard;
}

class TimeSeriesDataPoint {
  TimeSeriesDataPoint({
    required this.date,
    required this.value,
  });
  final DateTime date;
  final int value;
}

class AmbassadorConversionRate {
  AmbassadorConversionRate({
    required this.ambassadorId,
    required this.displayName,
    required this.totalReferrals,
    required this.activeReferrals,
    required this.conversionRate,
    required this.countryCode,
    required this.tier,
  });
  final String ambassadorId;
  final String displayName;
  final int totalReferrals;
  final int activeReferrals;
  final double conversionRate;
  final String countryCode;
  final AmbassadorTier tier;
}

class RegionalPerformance {
  RegionalPerformance({
    required this.countryCode,
    required this.countryName,
    required this.ambassadorCount,
    required this.totalReferrals,
    required this.averageReferrals,
    required this.conversionRate,
  });
  final String countryCode;
  final String countryName;
  final int ambassadorCount;
  final int totalReferrals;
  final double averageReferrals;
  final double conversionRate;
}

class RegionalPerformanceData {
  RegionalPerformanceData({
    required this.ambassadorCount,
    required this.totalReferrals,
    required this.averageReferrals,
    required this.conversionRate,
  });
  int ambassadorCount;
  int totalReferrals;
  double averageReferrals;
  double conversionRate;
}

enum TimeSeriesGranularity {
  hourly,
  daily,
  weekly,
  monthly,
  yearly,
}

enum AnalyticsExportType {
  leaderboard,
  conversionRates,
  timeSeries,
  regionalPerformance,
}
