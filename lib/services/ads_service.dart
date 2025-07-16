import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/providers/subscription_provider.dart';
import 'package:appoint/services/ad_service.dart';

class AdsService {
  /// Shows an interstitial ad if the user is not premium
  static Future<void> showAdIfNotPremium(WidgetRef ref) async {
    final shouldShowAds = ref.read(shouldShowAdsProvider);
    
    if (shouldShowAds) {
      await AdService.showInterstitialAd();
    }
  }

  /// Checks if ads should be shown for the current user
  static bool shouldShowAds(WidgetRef ref) {
    return ref.read(shouldShowAdsProvider);
  }
}