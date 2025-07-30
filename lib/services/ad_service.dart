import 'dart:async';

class AdService {
  static const _testInterstitialAdId = 'ca-app-pub-3940256099942544/1033173712';

  static Future<void> showInterstitialAd() async {
    await MobileAds.instance.initialize();
    final completer = Completer<void>();

    await InterstitialAd.load(
      adUnitId: _testInterstitialAdId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              if (!completer.isCompleted) completer.complete();
            },
            onAdFailedToShowFullScreenContent: (ad, final error) {
              ad.dispose();
              if (!completer.isCompleted) completer.complete();
            },
          );
          ad.show();
        },
        onAdFailedToLoad: (error) {
          if (!completer.isCompleted) completer.complete();
        },
      ),
    );

    await completer.future;
  }
}
