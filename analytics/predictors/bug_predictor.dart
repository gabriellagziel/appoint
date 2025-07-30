import 'dart:math';

/// Bug Predictor for Predictive Quality Analytics
///
/// Predicts the likelihood of bugs in code changes using heuristics and ML stubs.
class BugPredictor {
  /// Predicts bug likelihood for a code change
  static Future<BugPrediction> predictBugLikelihood({
    required String filePath,
    required List<String> changedLines,
    required double riskScore,
    required double complexity,
    required double coverageImpact,
    Map<String, dynamic>? context,
  }) async {
    // Heuristic: more complex, high-risk, low-coverage changes are more likely to introduce bugs
    double baseLikelihood =
        0.1 + (riskScore * 0.5) + (complexity * 0.2) - (coverageImpact * 0.3);
    baseLikelihood = baseLikelihood.clamp(0.0, 1.0);

    // ML stub: add random noise for simulation
    final mlNoise = Random().nextDouble() * 0.1 - 0.05;
    final likelihood = (baseLikelihood + mlNoise).clamp(0.0, 1.0);

    // Confidence increases with risk and complexity
    final confidence =
        (0.5 + riskScore * 0.3 + complexity * 0.2).clamp(0.0, 1.0);

    // Generate recommendations
    final recommendations = <String>[];
    if (likelihood > 0.7) {
      recommendations.add('High bug risk: Add more tests and code reviews.');
    } else if (likelihood > 0.4) {
      recommendations.add('Moderate bug risk: Consider targeted testing.');
    } else {
      recommendations.add('Low bug risk: Standard QA process.');
    }

    return BugPrediction(
      filePath: filePath,
      likelihood: likelihood,
      confidence: confidence,
      recommendations: recommendations,
    );
  }
}

class BugPrediction {
  final String filePath;
  final double likelihood;
  final double confidence;
  final List<String> recommendations;

  BugPrediction({
    required this.filePath,
    required this.likelihood,
    required this.confidence,
    required this.recommendations,
  });

  @override
  String toString() {
    return 'BugPrediction(file: $filePath, likelihood: ${likelihood.toStringAsFixed(2)}, confidence: ${confidence.toStringAsFixed(2)}, recommendations: $recommendations)';
  }
}
