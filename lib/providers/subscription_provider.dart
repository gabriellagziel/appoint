import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/providers/user_provider.dart';

class SubscriptionProvider extends StateNotifier<bool> {
  SubscriptionProvider() : super(false);

  bool get isPremium => state;

  void setPremiumStatus(bool isPremium) {
    state = isPremium;
  }

  Future<void> upgradeToPremium() async {
    // TODO: Implement real payment flow
    // For now, just show a placeholder message
    // This would integrate with Stripe, in-app purchases, etc.
    state = true;
  }
}

final subscriptionProvider = StateNotifierProvider<SubscriptionProvider, bool>(
  (ref) => SubscriptionProvider(),
);

// Provider that checks if user should see ads
final shouldShowAdsProvider = Provider<bool>((ref) {
  final user = ref.watch(userProvider);
  final isPremium = ref.watch(subscriptionProvider);
  
  // Show ads if user is not premium
  return !(isPremium || user?.isPremium == true);
});

// Provider for premium upgrade functionality
final premiumUpgradeProvider = Provider<SubscriptionProvider>((ref) {
  return ref.watch(subscriptionProvider.notifier);
});