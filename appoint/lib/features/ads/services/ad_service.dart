import '../models/ad_impression.dart';

class AdService {
  static final List<AdImpression> _impressions = [];

  // Mock premium status - in real app this would come from user profile
  static bool isPremiumUser = false;

  // Show mock ad and return completion status
  static Future<bool> showAd(AdImpressionType type) async {
    // Simulate ad loading
    await Future.delayed(const Duration(seconds: 1));

    // Log impression
    final impression = AdImpression(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: type,
      status: AdImpressionStatus.shown,
      timestamp: DateTime.now(),
      userId: 'user1', // TODO: Get from auth
      isPremium: isPremiumUser,
    );

    _impressions.add(impression);

    // Mock ad completion (90% completion rate)
    final random = DateTime.now().millisecondsSinceEpoch % 100;
    final completed = random < 90;

    // Update impression status
    final finalStatus =
        completed ? AdImpressionStatus.completed : AdImpressionStatus.skipped;
    final updatedImpression = impression.copyWith(status: finalStatus);
    final index = _impressions.indexOf(impression);
    if (index != -1) {
      _impressions[index] = updatedImpression;
    }

    return completed;
  }

  // Log ad impression
  static void logImpression(AdImpression impression) {
    _impressions.add(impression);
    // TODO: Send to analytics/Firebase
    print(
        'Ad impression logged: ${impression.type.name} - ${impression.status.name}');
  }

  // Get impression history
  static List<AdImpression> getImpressions() {
    return List.from(_impressions);
  }

  // Check if user should see ads
  static bool shouldShowAds() {
    return !isPremiumUser;
  }

  // Set premium status (for testing)
  static void setPremiumStatus(bool isPremium) {
    isPremiumUser = isPremium;
  }

  // Get completion rate
  static double getCompletionRate() {
    if (_impressions.isEmpty) return 0.0;

    final completed = _impressions
        .where((i) => i.status == AdImpressionStatus.completed)
        .length;
    return completed / _impressions.length;
  }
}



