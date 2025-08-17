import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class GroupUsageMetrics {
  final int groupsCount;
  final int membersCount;
  final int meetingsCount;
  final int storageMb;
  final Map<String, dynamic> raw;

  const GroupUsageMetrics({
    required this.groupsCount,
    required this.membersCount,
    required this.meetingsCount,
    required this.storageMb,
    required this.raw,
  });

  bool get nearLimit => membersCount >= 90 || meetingsCount >= 90;
  bool get atOrOverLimit => membersCount >= 100 || meetingsCount >= 100;
}

class GroupMetricsService {
  final String baseFunctionsUrl;
  final Duration pollInterval;

  GroupMetricsService({
    String? baseUrl,
    this.pollInterval = const Duration(seconds: 20),
  }) : baseFunctionsUrl = baseUrl ?? _defaultBaseUrl();

  static String _defaultBaseUrl() {
    // Default to local functions on port 8080 for dev
    return const String.fromEnvironment('FUNCTIONS_URL',
        defaultValue: 'http://localhost:8080');
  }

  Future<GroupUsageMetrics> fetchMetrics() async {
    final uri = Uri.parse('$baseFunctionsUrl/api/groups/metrics');
    final res = await http.get(uri, headers: {'Accept': 'application/json'});
    if (res.statusCode != 200) {
      throw Exception('Failed to fetch metrics: ${res.statusCode}');
    }
    final data = json.decode(res.body) as Map<String, dynamic>;
    return GroupUsageMetrics(
      groupsCount:
          data['groupsCount'] as int? ?? data['groups']?['count'] as int? ?? 0,
      membersCount: data['membersCount'] as int? ??
          data['members']?['count'] as int? ??
          0,
      meetingsCount: data['meetingsCount'] as int? ??
          data['meetings']?['count'] as int? ??
          0,
      storageMb:
          data['storageMb'] as int? ?? data['storage']?['mb'] as int? ?? 0,
      raw: data,
    );
  }

  Stream<GroupUsageMetrics> streamMetrics() async* {
    while (true) {
      try {
        final metrics = await fetchMetrics();
        yield metrics;
      } catch (e) {
        if (kDebugMode) {
          debugPrint('GroupMetricsService fetch error: $e');
        }
      }
      await Future.delayed(pollInterval);
    }
  }
}
