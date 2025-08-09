import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/ad_service.dart';
import '../models/ad_impression.dart';

class AdGateController extends StateNotifier<bool> {
  AdGateController() : super(false);

  // Check if user should see ad gate
  bool shouldShowAdGate() {
    return AdService.shouldShowAds();
  }

  // Show ad gate and return completion status
  Future<bool> showAdGate(AdImpressionType type) async {
    if (!shouldShowAdGate()) {
      return true; // Premium users bypass
    }

    state = true; // Show ad gate

    try {
      final completed = await AdService.showAd(type);

      // Log the impression
      final impression = AdImpression(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: type,
        status: completed
            ? AdImpressionStatus.completed
            : AdImpressionStatus.skipped,
        timestamp: DateTime.now(),
        userId: 'user1', // TODO: Get from auth
        isPremium: AdService.isPremiumUser,
      );

      AdService.logImpression(impression);

      return completed;
    } finally {
      state = false; // Hide ad gate
    }
  }

  // Skip ad gate
  void skipAdGate(AdImpressionType type) {
    final impression = AdImpression(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: type,
      status: AdImpressionStatus.skipped,
      timestamp: DateTime.now(),
      userId: 'user1', // TODO: Get from auth
      isPremium: AdService.isPremiumUser,
    );

    AdService.logImpression(impression);
    state = false;
  }

  // Close ad gate
  void closeAdGate(AdImpressionType type) {
    final impression = AdImpression(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: type,
      status: AdImpressionStatus.closed,
      timestamp: DateTime.now(),
      userId: 'user1', // TODO: Get from auth
      isPremium: AdService.isPremiumUser,
    );

    AdService.logImpression(impression);
    state = false;
  }

  // Get ad statistics
  Map<String, dynamic> getAdStats() {
    final impressions = AdService.getImpressions();
    final total = impressions.length;
    final completed = impressions
        .where((i) => i.status == AdImpressionStatus.completed)
        .length;
    final skipped =
        impressions.where((i) => i.status == AdImpressionStatus.skipped).length;
    final closed =
        impressions.where((i) => i.status == AdImpressionStatus.closed).length;

    return {
      'total': total,
      'completed': completed,
      'skipped': skipped,
      'closed': closed,
      'completionRate':
          total > 0 ? (completed / total * 100).toStringAsFixed(1) : '0.0',
    };
  }
}

final adGateControllerProvider =
    StateNotifierProvider<AdGateController, bool>((ref) {
  return AdGateController();
});

final adGateStatsProvider = Provider<Map<String, dynamic>>((ref) {
  final controller = ref.watch(adGateControllerProvider.notifier);
  return controller.getAdStats();
});



