class StripeService {
  Future<void> createCheckoutSession({
    required String studioId,
    required String priceId,
  }) async {}

  Future<String?> getSubscriptionStatus(String studioId) async => null;

  Future<Map<String, dynamic>?> getSubscriptionDetails(String studioId) async {
    return null;
  }

  Future<void> updateSubscriptionStatus({
    required String studioId,
    required String status,
    String? subscriptionId,
  }) async {}

  Future<void> cancelSubscription(String studioId) async {}

  Future<bool> hasActiveSubscription(String studioId) async => false;
}
