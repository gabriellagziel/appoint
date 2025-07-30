import 'dart:async';
import 'dart:math';

/// Pipeline Monitor for Self-Healing CI/CD
///
/// Monitors pipeline health and detects issues in real-time.
class PipelineMonitor {
  static const Duration _checkInterval = Duration(minutes: 1);
  static const int _maxRetries = 3;

  Timer? _monitoringTimer;
  final List<PipelineHealthEvent> _healthEvents = [];

  /// Starts monitoring the pipeline
  void startMonitoring({
    required String pipelineId,
    required Function(PipelineHealthEvent) onHealthEvent,
  }) {
    _monitoringTimer = Timer.periodic(_checkInterval, (timer) async {
      final health = await _checkPipelineHealth(pipelineId);
      final event = PipelineHealthEvent(
        pipelineId: pipelineId,
        health: health,
        timestamp: DateTime.now(),
      );

      _healthEvents.add(event);
      onHealthEvent(event);

      // Keep only last 100 events
      if (_healthEvents.length > 100) {
        _healthEvents.removeRange(0, _healthEvents.length - 100);
      }
    });
  }

  /// Stops monitoring the pipeline
  void stopMonitoring() {
    _monitoringTimer?.cancel();
    _monitoringTimer = null;
  }

  /// Checks pipeline health
  Future<PipelineHealth> _checkPipelineHealth(String pipelineId) async {
    try {
      // Simulate health check
      final isHealthy = Random().nextBool();
      final issues = isHealthy ? <PipelineIssue>[] : _generateMockIssues();

      return PipelineHealth(
        status: isHealthy ? HealthStatus.healthy : HealthStatus.degraded,
        issues: issues,
        uptime: _calculateUptime(),
        responseTime: Duration(milliseconds: Random().nextInt(5000) + 100),
      );
    } catch (e) {
      return PipelineHealth(
        status: HealthStatus.critical,
        issues: [
          PipelineIssue(
            type: IssueType.system,
            severity: IssueSeverity.critical,
            description: 'Pipeline monitoring error: $e',
          )
        ],
        uptime: 0.0,
        responseTime: Duration.zero,
      );
    }
  }

  List<PipelineIssue> _generateMockIssues() {
    final issues = <PipelineIssue>[];
    final random = Random();

    if (random.nextBool()) {
      issues.add(PipelineIssue(
        type: IssueType.test,
        severity: IssueSeverity.warning,
        description: 'Some tests are taking longer than expected',
      ));
    }

    if (random.nextBool()) {
      issues.add(PipelineIssue(
        type: IssueType.build,
        severity: IssueSeverity.error,
        description: 'Build process is failing intermittently',
      ));
    }

    return issues;
  }

  double _calculateUptime() {
    if (_healthEvents.isEmpty) return 1.0;

    final healthyEvents = _healthEvents
        .where((e) => e.health.status == HealthStatus.healthy)
        .length;
    return healthyEvents / _healthEvents.length;
  }

  /// Gets pipeline health history
  List<PipelineHealthEvent> getHealthHistory() {
    return List.unmodifiable(_healthEvents);
  }

  /// Gets current pipeline status
  HealthStatus getCurrentStatus() {
    if (_healthEvents.isEmpty) return HealthStatus.unknown;
    return _healthEvents.last.health.status;
  }
}

class PipelineHealth {
  final HealthStatus status;
  final List<PipelineIssue> issues;
  final double uptime;
  final Duration responseTime;

  PipelineHealth({
    required this.status,
    required this.issues,
    required this.uptime,
    required this.responseTime,
  });

  @override
  String toString() {
    return 'PipelineHealth(status: $status, issues: ${issues.length}, uptime: ${(uptime * 100).toStringAsFixed(1)}%, responseTime: ${responseTime.inMilliseconds}ms)';
  }
}

class PipelineHealthEvent {
  final String pipelineId;
  final PipelineHealth health;
  final DateTime timestamp;

  PipelineHealthEvent({
    required this.pipelineId,
    required this.health,
    required this.timestamp,
  });
}

class PipelineIssue {
  final IssueType type;
  final IssueSeverity severity;
  final String description;

  PipelineIssue({
    required this.type,
    required this.severity,
    required this.description,
  });

  @override
  String toString() {
    return 'PipelineIssue(type: $type, severity: $severity, description: $description)';
  }
}

enum HealthStatus {
  healthy,
  degraded,
  critical,
  unknown,
}

enum IssueType {
  test,
  build,
  deployment,
  system,
}

enum IssueSeverity {
  info,
  warning,
  error,
  critical,
}
