import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static const _testInterstitialAdId = 'ca-app-pub-3940256099942544/1033173712';

  static Future<void> showInterstitialAd() async {
    await MobileAds.instance.initialize();
    final completer = Completer<void>();

    await InterstitialAd.load(
      adUnitId: _testInterstitialAdId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (final ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (final ad) {
              ad.dispose();
              if (!completer.isCompleted) completer.complete();
            },
            onAdFailedToShowFullScreenContent: (final ad, final error) {
              ad.dispose();
              if (!completer.isCompleted) completer.complete();
            },
          );
          ad.show();
        },
        onAdFailedToLoad: (final error) {
          if (!completer.isCompleted) completer.complete();
        },
      ),
    );

    await completer.future;
  }
}
