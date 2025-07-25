import 'package:appoint/features/subscriptions/models/subscription.dart';
import 'package:appoint/features/subscriptions/services/subscription_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final subscriptionServiceProvider = Provider<SubscriptionService>((ref) => SubscriptionService());

final availablePlansProvider = FutureProvider<List<SubscriptionPlan>>((ref) async {
  final service = ref.read(subscriptionServiceProvider);
  return service.getAvailablePlans();
});

final userSubscriptionProvider = FutureProvider<UserSubscription?>((ref) async {
  final service = ref.read(subscriptionServiceProvider);
  return service.getUserSubscription();
});

final subscriptionStatusProvider = FutureProvider<SubscriptionStatus>((ref) async {
  final service = ref.read(subscriptionServiceProvider);
  return service.getCurrentStatus();
});

class SubscriptionScreen extends ConsumerWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final plansAsync = ref.watch(availablePlansProvider);
    final userSubscriptionAsync = ref.watch(userSubscriptionProvider);
    final statusAsync = ref.watch(subscriptionStatusProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscription Plans'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => _showBillingHistory(context, ref),
          ),
        ],
      ),
      body: plansAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text('Failed to load plans'),
              const SizedBox(height: 8),
              Text(error.toString()),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(availablePlansProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (plans) => _buildPlansList(context, ref, plans, userSubscriptionAsync, statusAsync, l10n),
      ),
    );
  }

  Widget _buildPlansList(
    BuildContext context,
    WidgetRef ref,
    List<SubscriptionPlan> plans,
    AsyncValue<UserSubscription?> userSubscriptionAsync,
    AsyncValue<SubscriptionStatus> statusAsync,
    AppLocalizations l10n,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Current subscription status
        _buildCurrentStatus(userSubscriptionAsync, statusAsync, l10n),
        
        const SizedBox(height: 24),
        
        // Plans
        Text(
          'Choose Your Plan',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        
        ...plans.map((plan) => _buildPlanCard(context, ref, plan, userSubscriptionAsync, l10n)),
        
        const SizedBox(height: 24),
        
        // Features comparison
        _buildFeaturesComparison(plans, l10n),
      ],
    );
  }

  Widget _buildCurrentStatus(
    AsyncValue<UserSubscription?> userSubscriptionAsync,
    AsyncValue<SubscriptionStatus> statusAsync,
    AppLocalizations l10n,
  ) {
    return statusAsync.when(
      loading: () => const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Loading subscription status...'),
            ],
          ),
        ),
      ),
      error: (error, stack) => Card(
        color: Colors.red[50],
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.error, color: Colors.red),
              const SizedBox(width: 16),
              Expanded(
                child: Text('Error loading subscription: $error'),
              ),
            ],
          ),
        ),
      ),
      data: (status) => userSubscriptionAsync.when(
        loading: () => const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text('Loading subscription details...'),
              ],
            ),
          ),
        ),
        error: (error, stack) => Card(
          color: Colors.red[50],
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.error, color: Colors.red),
                const SizedBox(width: 16),
                Expanded(
                  child: Text('Error loading subscription: $error'),
                ),
              ],
            ),
          ),
        ),
        data: (userSubscription) => Card(
          color: status == SubscriptionStatus.active ? Colors.green[50] : Colors.orange[50],
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      status == SubscriptionStatus.active ? Icons.check_circle : Icons.warning,
                      color: status == SubscriptionStatus.active ? Colors.green : Colors.orange,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getStatusText(status),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          if (userSubscription != null)
                            Text(
                              userSubscription.currentPlan.name,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (userSubscription != null) ...[
                  const SizedBox(height: 16),
                  _buildUsageStats(userSubscription.usageStats),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard(
    BuildContext context,
    WidgetRef ref,
    SubscriptionPlan plan,
    AsyncValue<UserSubscription?> userSubscriptionAsync,
    AppLocalizations l10n,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Plan header
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        plan.description,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                if (plan.isPopular)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'POPULAR',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Price
            Row(
              children: [
                Text(
                  '\$${plan.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '/${_getIntervalText(plan.interval)}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                    if (plan.hasDiscount)
                      Text(
                        '\$${plan.originalPrice!.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 14,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Features
            ...plan.features.map((feature) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(Icons.check, color: Colors.green, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      feature,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            )),
            
            const SizedBox(height: 24),
            
            // Subscribe button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _subscribeToPlan(context, ref, plan),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: plan.isPopular ? Theme.of(context).primaryColor : null,
                  foregroundColor: plan.isPopular ? Colors.white : null,
                ),
                child: Text(
                  _getSubscribeButtonText(plan, userSubscriptionAsync),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsageStats(UsageStats stats) {
    return Column(
      children: [
        _buildUsageBar('Bookings', stats.bookingsUsagePercentage, stats.bookingsThisMonth.toDouble(), stats.bookingsLimit.toDouble()),
        const SizedBox(height: 8),
        _buildUsageBar('Messages', stats.messagesUsagePercentage, stats.messagesThisMonth.toDouble(), stats.messagesLimit.toDouble()),
        const SizedBox(height: 8),
        _buildUsageBar('Storage', stats.storageUsagePercentage, stats.storageUsed, stats.storageLimit),
      ],
    );
  }

  Widget _buildUsageBar(String label, double percentage, double used, double limit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 14)),
            Text('${used.toInt()}/${limit.toInt()}', style: const TextStyle(fontSize: 14)),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: percentage / 100,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(
            percentage > 80 ? Colors.red : Colors.green),
        ),
      ],
    );
  }

  Widget _buildFeaturesComparison(List<SubscriptionPlan> plans, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Plan Comparison',
              style: Theme.of(context).textTheme.titleLarge!,
            ),
            const SizedBox(height: 16),
            // This would be a detailed comparison table
            Text('Detailed feature comparison coming soon...'),
          ],
        ),
      ),
    );
  }

  String _getStatusText(SubscriptionStatus status) {
    switch (status) {
      case SubscriptionStatus.active:
        return 'Active Subscription';
      case SubscriptionStatus.canceled:
        return 'Subscription Canceled';
      case SubscriptionStatus.pastDue:
        return 'Payment Past Due';
      case SubscriptionStatus.unpaid:
        return 'No Active Subscription';
      case SubscriptionStatus.trialing:
        return 'Free Trial';
    }
  }

  String _getIntervalText(SubscriptionInterval interval) {
    switch (interval) {
      case SubscriptionInterval.weekly:
        return 'week';
      case SubscriptionInterval.monthly:
        return 'month';
      case SubscriptionInterval.yearly:
        return 'year';
    }
  }

  String _getSubscribeButtonText(SubscriptionPlan plan, AsyncValue<UserSubscription?> userSubscriptionAsync) {
    return userSubscriptionAsync.when(
      loading: () => 'Loading...',
      error: (error, stack) => 'Subscribe',
      data: (userSubscription) {
        if (userSubscription == null) return 'Subscribe';
        if (userSubscription.currentPlan.id == plan.id) return 'Current Plan';
        return 'Switch Plan';
      },
    );
  }

  void _subscribeToPlan(BuildContext context, WidgetRef ref, SubscriptionPlan plan) async {
    try {
      final service = ref.read(subscriptionServiceProvider);
      await service.subscribeToPlan(plan.id);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Successfully subscribed to ${plan.name}!')),
        );
        ref.invalidate(userSubscriptionProvider);
        ref.invalidate(subscriptionStatusProvider);
      }
    } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to subscribe: $e')),
        );
      }
    }
  }

  void _showBillingHistory(BuildContext context, WidgetRef ref) {
    // TODO: Implement billing history screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Billing history coming soon!')),
    );
  } 