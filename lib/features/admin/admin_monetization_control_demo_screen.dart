// DEMO SCREEN: For onboarding/testing. For production, use MonetizationSettings and AdminMonetizationScreen.
// See lib/features/admin/admin_monetization_screen.dart for the full implementation.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Demo provider for Monetization Control
final monetizationControlProvider =
    StateNotifierProvider<MonetizationControlNotifier, MonetizationControl>(
        (ref) {
  return MonetizationControlNotifier();
});

class MonetizationControl {
  final bool isAdsEnabled;
  MonetizationControl({required this.isAdsEnabled});
}

class MonetizationControlNotifier extends StateNotifier<MonetizationControl> {
  MonetizationControlNotifier()
      : super(MonetizationControl(isAdsEnabled: true));

  void toggleAds(bool isEnabled) {
    state = MonetizationControl(isAdsEnabled: isEnabled);
    // TODO: hook into real backend (Firestore) here
  }
}

class MonetizationControlDemoScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monetizationControl = ref.watch(monetizationControlProvider);

    return Scaffold(
      appBar: AppBar(title: Text("Monetization Control")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: Text("Enable Ads"),
              value: monetizationControl.isAdsEnabled,
              onChanged: (value) {
                ref.read(monetizationControlProvider.notifier).toggleAds(value);
              },
            ),
            // In production, you could add more monetization control options here
          ],
        ),
      ),
    );
  }
}
