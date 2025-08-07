/// Quality Trend Predictor for Predictive Analytics
///
/// Analyzes historical quality metrics and predicts future quality trends.
class QualityTrendPredictor {
  /// Predicts quality trends based on historical data
  static Future<QualityTrendPrediction> predictQualityTrend({
    required List<QualityMetric> historicalMetrics,
    required Duration predictionWindow,
  }) async {
    if (historicalMetrics.length < 3) {
      return QualityTrendPrediction(
        direction: TrendDirection.stable,
        slope: 0.0,
        confidence: 0.0,
        forecast: [],
        reason: 'Insufficient historical data',
      );
    }

    // Calculate trend direction and slope
    final trend = _calculateTrend(historicalMetrics);

    // Generate forecast
    final forecast =
        _generateForecast(historicalMetrics, predictionWindow, trend);

    // Calculate confidence based on data consistency
    final confidence = _calculateConfidence(historicalMetrics, trend);

    return QualityTrendPrediction(
      direction: trend.direction,
      slope: trend.slope,
      confidence: confidence,
      forecast: forecast,
      reason: _generateReason(trend, confidence),
    );
  }

  static TrendAnalysis _calculateTrend(List<QualityMetric> metrics) {
    final values = metrics.map((m) => m.value).toList();
    final timestamps =
        metrics.map((m) => m.timestamp.millisecondsSinceEpoch).toList();

    // Simple linear regression
    final n = values.length;
    final sumX = timestamps.reduce((a, b) => a + b);
    final sumY = values.reduce((a, b) => a + b);
    double sumXY = 0;
    final sumX2 = timestamps.map((x) => x * x).reduce((a, b) => a + b);

    for (int i = 0; i < n; i++) {
      sumXY += timestamps[i] * values[i];
    }

    final slope = (n * sumXY - sumX * sumY) / (n * sumX2 - sumX * sumX);
    final intercept = (sumY - slope * sumX) / n;

    TrendDirection direction;
    if (slope > 0.01) {
      direction = TrendDirection.improving;
    } else if (slope < -0.01) {
      direction = TrendDirection.declining;
    } else {
      direction = TrendDirection.stable;
    }

    return TrendAnalysis(
      direction: direction,
      slope: slope,
      intercept: intercept,
    );
  }

  static List<QualityMetric> _generateForecast(
    List<QualityMetric> historicalMetrics,
    Duration predictionWindow,
    TrendAnalysis trend,
  ) {
    final forecast = <QualityMetric>[];
    final lastTimestamp = historicalMetrics.last.timestamp;
    final daysToPredict = predictionWindow.inDays;

    for (int day = 1; day <= daysToPredict; day++) {
      final futureTimestamp = lastTimestamp.add(Duration(days: day));
      final predictedValue = trend.intercept +
          trend.slope * futureTimestamp.millisecondsSinceEpoch;

      forecast.add(QualityMetric(
        name: 'predicted_quality',
        value: predictedValue.clamp(0.0, 1.0),
        timestamp: futureTimestamp,
        type: MetricType.predicted,
      ));
    }

    return forecast;
  }

  static double _calculateConfidence(
      List<QualityMetric> metrics, TrendAnalysis trend) {
    final values = metrics.map((m) => m.value).toList();
    final variance = _calculateVariance(values);
    final trendStrength =
        (trend.slope * 1000).abs(); // Scale slope for confidence

    // Higher confidence for consistent data and strong trends
    double confidence = 0.5;
    confidence += (1.0 - variance) * 0.3;
    confidence += (trendStrength / 10.0).clamp(0.0, 0.2);

    return confidence.clamp(0.0, 1.0);
  }

  static double _calculateVariance(List<double> values) {
    if (values.isEmpty) return 0.0;

    final mean = values.reduce((a, b) => a + b) / values.length;
    final squaredDifferences =
        values.map((value) => (value - mean) * (value - mean));
    final sum = squaredDifferences.reduce((a, b) => a + b);

    return sum / values.length;
  }

  static String _generateReason(TrendAnalysis trend, double confidence) {
    final direction = trend.direction.toString().split('.').last;
    final confidencePercent = (confidence * 100).round();

    return 'Quality trend is $direction with $confidencePercent% confidence';
  }
}

class QualityTrendPrediction {
  final TrendDirection direction;
  final double slope;
  final double confidence;
  final List<QualityMetric> forecast;
  final String reason;

  QualityTrendPrediction({
    required this.direction,
    required this.slope,
    required this.confidence,
    required this.forecast,
    required this.reason,
  });

  @override
  String toString() {
    return 'QualityTrendPrediction(direction: $direction, slope: ${slope.toStringAsFixed(3)}, confidence: ${confidence.toStringAsFixed(2)}, forecast: ${forecast.length} points)';
  }
}

class TrendAnalysis {
  final TrendDirection direction;
  final double slope;
  final double intercept;

  TrendAnalysis({
    required this.direction,
    required this.slope,
    required this.intercept,
  });
}

enum TrendDirection {
  improving,
  declining,
  stable,
}

class QualityMetric {
  final String name;
  final double value;
  final DateTime timestamp;
  final MetricType type;

  QualityMetric({
    required this.name,
    required this.value,
    required this.timestamp,
    this.type = MetricType.actual,
  });
}

enum MetricType {
  actual,
  predicted,
}
