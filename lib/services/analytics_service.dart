import 'package:appoint/models/admin_broadcast_message.dart';
import 'package:appoint/models/custom_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TimeRange {
  today,
  last7Days,
  last30Days,
  custom,
}

enum AnalyticsMetric {
  openRate,
  clickRate,
  responseRate,
  deliveryRate,
  engagementRate,
}

class AnalyticsFilter {
  final TimeRange timeRange;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? country;
  final String? language;
  final String? segment;
  final BroadcastMessageType? messageType;

  const AnalyticsFilter({
    this.timeRange = TimeRange.last7Days,
    this.startDate,
    this.endDate,
    this.country,
    this.language,
    this.segment,
    this.messageType,
  });

  AnalyticsFilter copyWith({
    TimeRange? timeRange,
    DateTime? startDate,
    DateTime? endDate,
    String? country,
    String? language,
    String? segment,
    BroadcastMessageType? messageType,
  }) {
    return AnalyticsFilter(
      timeRange: timeRange ?? this.timeRange,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      country: country ?? this.country,
      language: language ?? this.language,
      segment: segment ?? this.segment,
      messageType: messageType ?? this.messageType,
    );
  }

  DateTime get effectiveStartDate {
    if (timeRange == TimeRange.custom) {
      return startDate ?? DateTime.now().subtract(const Duration(days: 7));
    }
    
    final now = DateTime.now();
    switch (timeRange) {
      case TimeRange.today:
        return DateTime(now.year, now.month, now.day);
      case TimeRange.last7Days:
        return now.subtract(const Duration(days: 7));
      case TimeRange.last30Days:
        return now.subtract(const Duration(days: 30));
      case TimeRange.custom:
        return startDate ?? now.subtract(const Duration(days: 7));
    }
  }

  DateTime get effectiveEndDate {
    if (timeRange == TimeRange.custom) {
      return endDate ?? DateTime.now();
    }
    return DateTime.now();
  }
}

class AnalyticsSummary {
  final int totalBroadcasts;
  final int totalRecipients;
  final int totalSent;
  final int totalOpened;
  final int totalClicked;
  final int totalResponses;
  final double openRate;
  final double clickRate;
  final double responseRate;
  final double deliveryRate;
  final double engagementRate;
  final Map<String, int> countryBreakdown;
  final Map<String, int> languageBreakdown;
  final Map<String, int> typeBreakdown;
  final Map<String, int> statusBreakdown;

  const AnalyticsSummary({
    required this.totalBroadcasts,
    required this.totalRecipients,
    required this.totalSent,
    required this.totalOpened,
    required this.totalClicked,
    required this.totalResponses,
    required this.openRate,
    required this.clickRate,
    required this.responseRate,
    required this.deliveryRate,
    required this.engagementRate,
    required this.countryBreakdown,
    required this.languageBreakdown,
    required this.typeBreakdown,
    required this.statusBreakdown,
  });
}

class AnalyticsTimeSeriesData {
  final DateTime date;
  final int sent;
  final int opened;
  final int clicked;
  final int responses;

  const AnalyticsTimeSeriesData({
    required this.date,
    required this.sent,
    required this.opened,
    required this.clicked,
    required this.responses,
  });
}

class BroadcastAnalyticsDetail {
  final AdminBroadcastMessage message;
  final AnalyticsSummary summary;
  final List<FormFieldStatistics>? formStatistics;
  final Map<String, dynamic> rawAnalytics;

  const BroadcastAnalyticsDetail({
    required this.message,
    required this.summary,
    this.formStatistics,
    required this.rawAnalytics,
  });
}

class AnalyticsService {
  AnalyticsService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  // Collection references
  CollectionReference<Map<String, dynamic>> get _broadcastsCollection =>
      _firestore.collection('admin_broadcasts');

  CollectionReference<Map<String, dynamic>> get _analyticsCollection =>
      _firestore.collection('broadcast_analytics');

  CollectionReference<Map<String, dynamic>> get _responsesCollection =>
      _firestore.collection('broadcast_form_responses');

  /// Get comprehensive analytics summary
  Future<AnalyticsSummary> getAnalyticsSummary(AnalyticsFilter filter) async {
    try {
      // Build query for broadcasts
      Query<Map<String, dynamic>> broadcastQuery = _broadcastsCollection
          .where('createdAt', isGreaterThanOrEqualTo: filter.effectiveStartDate)
          .where('createdAt', isLessThanOrEqualTo: filter.effectiveEndDate);

      if (filter.messageType != null) {
        broadcastQuery = broadcastQuery.where('type', isEqualTo: filter.messageType!.name);
      }

      final broadcastDocs = await broadcastQuery.get();
      final messageIds = broadcastDocs.docs.map((doc) => doc.id).toList();

      if (messageIds.isEmpty) {
        return _getEmptyAnalyticsSummary();
      }

      // Get analytics for these messages
      final analyticsData = await _getAnalyticsForMessages(messageIds, filter);

      // Calculate summary metrics
      int totalBroadcasts = broadcastDocs.docs.length;
      int totalRecipients = 0;
      int totalSent = 0;
      int totalOpened = 0;
      int totalClicked = 0;
      int totalResponses = 0;

      Map<String, int> countryBreakdown = {};
      Map<String, int> languageBreakdown = {};
      Map<String, int> typeBreakdown = {};
      Map<String, int> statusBreakdown = {};

      for (final doc in broadcastDocs.docs) {
        final data = doc.data();
        final message = AdminBroadcastMessage.fromJson({'id': doc.id, ...data});

        totalRecipients += message.actualRecipients ?? 0;
        totalSent += message.actualRecipients ?? 0;
        totalOpened += message.openedCount ?? 0;
        totalClicked += message.clickedCount ?? 0;
        totalResponses += message.pollResponseCount ?? 0;

        // Breakdown by type
        final typeKey = message.type.name;
        typeBreakdown[typeKey] = (typeBreakdown[typeKey] ?? 0) + 1;

        // Breakdown by status
        final statusKey = message.status.name;
        statusBreakdown[statusKey] = (statusBreakdown[statusKey] ?? 0) + 1;

        // Country/language breakdown from targeting filters
        if (message.targetingFilters?.countries != null) {
          for (final country in message.targetingFilters!.countries!) {
            countryBreakdown[country] = (countryBreakdown[country] ?? 0) + (message.actualRecipients ?? 0);
          }
        }

        if (message.targetingFilters?.languages != null) {
          for (final language in message.targetingFilters!.languages!) {
            languageBreakdown[language] = (languageBreakdown[language] ?? 0) + (message.actualRecipients ?? 0);
          }
        }
      }

      // Calculate rates
      double openRate = totalSent > 0 ? (totalOpened / totalSent) * 100 : 0;
      double clickRate = totalOpened > 0 ? (totalClicked / totalOpened) * 100 : 0;
      double responseRate = totalSent > 0 ? (totalResponses / totalSent) * 100 : 0;
      double deliveryRate = totalRecipients > 0 ? (totalSent / totalRecipients) * 100 : 0;
      double engagementRate = totalSent > 0 ? ((totalOpened + totalClicked) / totalSent) * 100 : 0;

      return AnalyticsSummary(
        totalBroadcasts: totalBroadcasts,
        totalRecipients: totalRecipients,
        totalSent: totalSent,
        totalOpened: totalOpened,
        totalClicked: totalClicked,
        totalResponses: totalResponses,
        openRate: openRate,
        clickRate: clickRate,
        responseRate: responseRate,
        deliveryRate: deliveryRate,
        engagementRate: engagementRate,
        countryBreakdown: countryBreakdown,
        languageBreakdown: languageBreakdown,
        typeBreakdown: typeBreakdown,
        statusBreakdown: statusBreakdown,
      );
    } catch (e) {
      throw Exception('Failed to get analytics summary: $e');
    }
  }

  /// Get time series data for charts
  Future<List<AnalyticsTimeSeriesData>> getTimeSeriesData(AnalyticsFilter filter) async {
    try {
      final startDate = filter.effectiveStartDate;
      final endDate = filter.effectiveEndDate;
      final daysDiff = endDate.difference(startDate).inDays;

      List<AnalyticsTimeSeriesData> timeSeriesData = [];

      for (int i = 0; i <= daysDiff; i++) {
        final currentDate = startDate.add(Duration(days: i));
        final nextDate = currentDate.add(const Duration(days: 1));

        // Get analytics for this day
        final analyticsQuery = _analyticsCollection
            .where('timestamp', isGreaterThanOrEqualTo: currentDate)
            .where('timestamp', isLessThan: nextDate);

        final analyticsSnapshot = await analyticsQuery.get();

        int sent = 0;
        int opened = 0;
        int clicked = 0;
        int responses = 0;

        for (final doc in analyticsSnapshot.docs) {
          final data = doc.data();
          final event = data['event'] as String;

          switch (event) {
            case 'sent':
              sent++;
              break;
            case 'opened':
              opened++;
              break;
            case 'clicked':
              clicked++;
              break;
            case 'form_response':
            case 'form_field_response':
            case 'poll_response':
              responses++;
              break;
          }
        }

        timeSeriesData.add(AnalyticsTimeSeriesData(
          date: currentDate,
          sent: sent,
          opened: opened,
          clicked: clicked,
          responses: responses,
        ));
      }

      return timeSeriesData;
    } catch (e) {
      throw Exception('Failed to get time series data: $e');
    }
  }

  /// Get detailed analytics for a specific broadcast
  Future<BroadcastAnalyticsDetail> getBroadcastAnalyticsDetail(String messageId) async {
    try {
      // Get the broadcast message
      final messageDoc = await _broadcastsCollection.doc(messageId).get();
      if (!messageDoc.exists) {
        throw Exception('Broadcast message not found');
      }

      final message = AdminBroadcastMessage.fromJson({
        'id': messageDoc.id,
        ...messageDoc.data()!,
      });

      // Get analytics for this message
      final analyticsSnapshot = await _analyticsCollection
          .where('messageId', isEqualTo: messageId)
          .get();

      Map<String, int> eventCounts = {};
      Map<String, dynamic> rawAnalytics = {};

      for (final doc in analyticsSnapshot.docs) {
        final data = doc.data();
        final event = data['event'] as String;
        eventCounts[event] = (eventCounts[event] ?? 0) + 1;
      }

      rawAnalytics['eventCounts'] = eventCounts;
      rawAnalytics['totalEvents'] = analyticsSnapshot.docs.length;

      // Create summary for this broadcast
      final summary = AnalyticsSummary(
        totalBroadcasts: 1,
        totalRecipients: message.actualRecipients ?? 0,
        totalSent: message.actualRecipients ?? 0,
        totalOpened: message.openedCount ?? 0,
        totalClicked: message.clickedCount ?? 0,
        totalResponses: message.pollResponseCount ?? 0,
        openRate: message.actualRecipients != null && message.actualRecipients! > 0
            ? ((message.openedCount ?? 0) / message.actualRecipients!) * 100
            : 0,
        clickRate: message.openedCount != null && message.openedCount! > 0
            ? ((message.clickedCount ?? 0) / message.openedCount!) * 100
            : 0,
        responseRate: message.actualRecipients != null && message.actualRecipients! > 0
            ? ((message.pollResponseCount ?? 0) / message.actualRecipients!) * 100
            : 0,
        deliveryRate: message.actualRecipients != null && message.actualRecipients! > 0
            ? ((message.actualRecipients ?? 0) / message.actualRecipients!) * 100
            : 0,
        engagementRate: message.actualRecipients != null && message.actualRecipients! > 0
            ? (((message.openedCount ?? 0) + (message.clickedCount ?? 0)) / message.actualRecipients!) * 100
            : 0,
        countryBreakdown: {},
        languageBreakdown: {},
        typeBreakdown: {message.type.name: 1},
        statusBreakdown: {message.status.name: 1},
      );

      // Get form statistics if it's a form message
      List<FormFieldStatistics>? formStatistics;
      if (message.type == BroadcastMessageType.form && message.formFields != null) {
        formStatistics = await _getFormStatistics(messageId, message.formFields!);
      }

      return BroadcastAnalyticsDetail(
        message: message,
        summary: summary,
        formStatistics: formStatistics,
        rawAnalytics: rawAnalytics,
      );
    } catch (e) {
      throw Exception('Failed to get broadcast analytics detail: $e');
    }
  }

  /// Get form statistics for a message
  Future<List<FormFieldStatistics>> _getFormStatistics(
    String messageId,
    List<CustomFormField> formFields,
  ) async {
    try {
      final responsesSnapshot = await _responsesCollection
          .where('messageId', isEqualTo: messageId)
          .get();

      final responses = responsesSnapshot.docs.map((doc) => {
        'id': doc.id,
        ...doc.data(),
      }).toList();

      List<FormFieldStatistics> statistics = [];

      for (final field in formFields) {
        final fieldResponses = responses
            .where((response) => 
                response['responses'] != null && 
                response['responses'][field.id] != null)
            .map((response) => response['responses'][field.id])
            .toList();

        final validResponses = fieldResponses
            .where((value) => value != null && value.toString().trim().isNotEmpty)
            .toList();

        // Calculate statistics based on field type
        double? averageValue;
        String? mostCommonValue;
        Map<String, int>? choiceDistribution;

        switch (field.type) {
          case CustomFormFieldType.number:
          case CustomFormFieldType.rating:
            final numericValues = validResponses
                .map((v) => double.tryParse(v.toString()))
                .where((v) => v != null)
                .cast<double>()
                .toList();
            
            if (numericValues.isNotEmpty) {
              averageValue = numericValues.reduce((a, b) => a + b) / numericValues.length;
            }
            break;

          case CustomFormFieldType.choice:
          case CustomFormFieldType.boolean:
            choiceDistribution = <String, int>{};
            for (final value in validResponses) {
              final stringValue = value.toString();
              choiceDistribution[stringValue] = (choiceDistribution[stringValue] ?? 0) + 1;
            }
            
            if (choiceDistribution.isNotEmpty) {
              mostCommonValue = choiceDistribution.entries
                  .reduce((a, b) => a.value > b.value ? a : b)
                  .key;
            }
            break;

          case CustomFormFieldType.multiselect:
            choiceDistribution = <String, int>{};
            for (final value in validResponses) {
              if (value is List) {
                for (final item in value) {
                  final stringValue = item.toString();
                  choiceDistribution[stringValue] = (choiceDistribution[stringValue] ?? 0) + 1;
                }
              }
            }
            break;

          default:
            // For text fields, find most common response
            final stringResponses = validResponses.map((v) => v.toString()).toList();
            if (stringResponses.isNotEmpty) {
              final frequency = <String, int>{};
              for (final response in stringResponses) {
                frequency[response] = (frequency[response] ?? 0) + 1;
              }
              mostCommonValue = frequency.entries
                  .reduce((a, b) => a.value > b.value ? a : b)
                  .key;
            }
            break;
        }

        statistics.add(FormFieldStatistics(
          fieldId: field.id,
          fieldLabel: field.label,
          fieldType: field.type,
          totalResponses: fieldResponses.length,
          validResponses: validResponses.length,
          averageValue: averageValue,
          mostCommonValue: mostCommonValue,
          choiceDistribution: choiceDistribution,
          allResponses: validResponses.map((v) => v.toString()).toList(),
        ));
      }

      return statistics;
    } catch (e) {
      throw Exception('Failed to get form statistics: $e');
    }
  }

  /// Export analytics data as CSV
  Future<String> exportAnalyticsCSV(AnalyticsFilter filter) async {
    try {
      final summary = await getAnalyticsSummary(filter);
      final timeSeriesData = await getTimeSeriesData(filter);

      final csvLines = <String>[];

      // Header
      csvLines.add('"Analytics Export - ${filter.effectiveStartDate.toIso8601String()} to ${filter.effectiveEndDate.toIso8601String()}"');
      csvLines.add('');

      // Summary
      csvLines.add('"Summary"');
      csvLines.add('"Total Broadcasts","${summary.totalBroadcasts}"');
      csvLines.add('"Total Recipients","${summary.totalRecipients}"');
      csvLines.add('"Total Sent","${summary.totalSent}"');
      csvLines.add('"Total Opened","${summary.totalOpened}"');
      csvLines.add('"Total Clicked","${summary.totalClicked}"');
      csvLines.add('"Total Responses","${summary.totalResponses}"');
      csvLines.add('"Open Rate","${summary.openRate.toStringAsFixed(2)}%"');
      csvLines.add('"Click Rate","${summary.clickRate.toStringAsFixed(2)}%"');
      csvLines.add('"Response Rate","${summary.responseRate.toStringAsFixed(2)}%"');
      csvLines.add('"Delivery Rate","${summary.deliveryRate.toStringAsFixed(2)}%"');
      csvLines.add('"Engagement Rate","${summary.engagementRate.toStringAsFixed(2)}%"');
      csvLines.add('');

      // Time series data
      csvLines.add('"Daily Metrics"');
      csvLines.add('"Date","Sent","Opened","Clicked","Responses"');
      for (final data in timeSeriesData) {
        csvLines.add('"${data.date.toIso8601String().split('T')[0]}","${data.sent}","${data.opened}","${data.clicked}","${data.responses}"');
      }
      csvLines.add('');

      // Breakdown data
      csvLines.add('"Country Breakdown"');
      csvLines.add('"Country","Recipients"');
      for (final entry in summary.countryBreakdown.entries) {
        csvLines.add('"${entry.key}","${entry.value}"');
      }
      csvLines.add('');

      csvLines.add('"Language Breakdown"');
      csvLines.add('"Language","Recipients"');
      for (final entry in summary.languageBreakdown.entries) {
        csvLines.add('"${entry.key}","${entry.value}"');
      }
      csvLines.add('');

      csvLines.add('"Message Type Breakdown"');
      csvLines.add('"Type","Count"');
      for (final entry in summary.typeBreakdown.entries) {
        csvLines.add('"${entry.key}","${entry.value}"');
      }

      return csvLines.join('\n');
    } catch (e) {
      throw Exception('Failed to export analytics CSV: $e');
    }
  }

  /// Get analytics for specific messages
  Future<Map<String, dynamic>> _getAnalyticsForMessages(
    List<String> messageIds,
    AnalyticsFilter filter,
  ) async {
    final analytics = <String, dynamic>{};

    // Implementation would include filtering logic for analytics events
    // based on the filter parameters

    return analytics;
  }

  /// Get empty analytics summary
  AnalyticsSummary _getEmptyAnalyticsSummary() {
    return const AnalyticsSummary(
      totalBroadcasts: 0,
      totalRecipients: 0,
      totalSent: 0,
      totalOpened: 0,
      totalClicked: 0,
      totalResponses: 0,
      openRate: 0,
      clickRate: 0,
      responseRate: 0,
      deliveryRate: 0,
      engagementRate: 0,
      countryBreakdown: {},
      languageBreakdown: {},
      typeBreakdown: {},
      statusBreakdown: {},
    );
  }

  /// Get analytics stream for real-time updates
  Stream<AnalyticsSummary> getAnalyticsStream(AnalyticsFilter filter) {
    return Stream.periodic(const Duration(seconds: 30), (_) async {
      return await getAnalyticsSummary(filter);
    }).asyncMap((future) => future);
  }

  /// Get broadcast list with analytics
  Future<List<BroadcastAnalyticsDetail>> getBroadcastList(AnalyticsFilter filter) async {
    try {
      Query<Map<String, dynamic>> query = _broadcastsCollection
          .where('createdAt', isGreaterThanOrEqualTo: filter.effectiveStartDate)
          .where('createdAt', isLessThanOrEqualTo: filter.effectiveEndDate)
          .orderBy('createdAt', descending: true);

      if (filter.messageType != null) {
        query = query.where('type', isEqualTo: filter.messageType!.name);
      }

      final snapshot = await query.get();
      final List<BroadcastAnalyticsDetail> broadcastDetails = [];

      for (final doc in snapshot.docs) {
        try {
          final detail = await getBroadcastAnalyticsDetail(doc.id);
          broadcastDetails.add(detail);
        } catch (e) {
          print('Error getting analytics for broadcast ${doc.id}: $e');
          // Continue with other broadcasts
        }
      }

      return broadcastDetails;
    } catch (e) {
      throw Exception('Failed to get broadcast list: $e');
    }
  }

  /// Track feature usage (stub implementation)
  Future<void> trackFeatureUsage(String feature, {Map<String, dynamic>? properties}) async {
    // TODO: Implement feature usage tracking
    // For now, this is a stub to prevent undefined method errors
  }

  /// Track onboarding start (stub implementation)
  Future<void> trackOnboardingStart() async {
    // TODO: Implement onboarding start tracking
  }

  /// Track onboarding step (stub implementation)
  Future<void> trackOnboardingStep(String step) async {
    // TODO: Implement onboarding step tracking
  }

  /// Track onboarding complete (stub implementation)
  Future<void> trackOnboardingComplete() async {
    // TODO: Implement onboarding completion tracking
  }

  /// Log screen view (stub implementation)
  Future<void> logScreenView(String screenName) async {
    // TODO: Implement screen view logging
  }

  /// Log event (stub implementation)
  Future<void> logEvent(String eventName, {Map<String, dynamic>? parameters}) async {
    // TODO: Implement event logging
  }
}

// Providers
final analyticsServiceProvider = Provider<AnalyticsService>(
  (ref) => AnalyticsService(),
);

final analyticsFilterProvider = StateProvider<AnalyticsFilter>(
  (ref) => const AnalyticsFilter(),
);

final analyticsSummaryProvider = FutureProvider<AnalyticsSummary>((ref) async {
  final analyticsService = ref.watch(analyticsServiceProvider);
  final filter = ref.watch(analyticsFilterProvider);
  return analyticsService.getAnalyticsSummary(filter);
});

final analyticsTimeSeriesProvider = FutureProvider<List<AnalyticsTimeSeriesData>>((ref) async {
  final analyticsService = ref.watch(analyticsServiceProvider);
  final filter = ref.watch(analyticsFilterProvider);
  return analyticsService.getTimeSeriesData(filter);
});

final broadcastListProvider = FutureProvider<List<BroadcastAnalyticsDetail>>((ref) async {
  final analyticsService = ref.watch(analyticsServiceProvider);
  final filter = ref.watch(analyticsFilterProvider);
  return analyticsService.getBroadcastList(filter);
});

final broadcastAnalyticsDetailProvider = FutureProvider.family<BroadcastAnalyticsDetail, String>((ref, messageId) async {
  final analyticsService = ref.watch(analyticsServiceProvider);
  return analyticsService.getBroadcastAnalyticsDetail(messageId);
});

final analyticsExportProvider = FutureProvider<String>((ref) async {
  final analyticsService = ref.watch(analyticsServiceProvider);
  final filter = ref.watch(analyticsFilterProvider);
  return analyticsService.exportAnalyticsCSV(filter);
});

final analyticsStreamProvider = StreamProvider<AnalyticsSummary>((ref) {
  final analyticsService = ref.watch(analyticsServiceProvider);
  final filter = ref.watch(analyticsFilterProvider);
  return analyticsService.getAnalyticsStream(filter);
});
