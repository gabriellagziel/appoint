import 'package:appoint/features/studio_business/models/business_subscription.dart';
import 'package:appoint/features/studio_business/providers/business_subscription_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BusinessSubscriptionScreen extends ConsumerStatefulWidget {
  const BusinessSubscriptionScreen({super.key});

  @override
  ConsumerState<BusinessSubscriptionScreen> createState() =>
      REDACTED_TOKEN();
}

class REDACTED_TOKEN
    extends ConsumerState<BusinessSubscriptionScreen> {
  TextEditingController _promoCodeController = TextEditingController();
  String? _selectedPromoCode;
  bool _isLoading = false;
  bool _isApplyingPromo = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _promoCodeController.dispose();
    super.dispose();
  }

  Future<void> _subscribeToStarter() async {
    setState(() => _isLoading = true);

    try {
      final service = ref.read(REDACTED_TOKEN);
      await service.subscribeStarter();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Redirecting to Stripe checkout for Starter plan...'),
            backgroundColor: Colors.blue,
          ),
        );
      }
    } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to start Starter subscription: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _subscribeToProfessional() async {
    setState(() => _isLoading = true);

    try {
      final service = ref.read(REDACTED_TOKEN);
      await service.subscribeProfessional();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Redirecting to Stripe checkout for Professional plan...'),
            backgroundColor: Colors.blue,
          ),
        );
      }
    } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to start Professional subscription: $e'),
            backgroundColor: Colors.red,
          ),
        );
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _subscribeToBusinessPlus() async {
    setState(() => _isLoading = true);

    try {
      final service = ref.read(REDACTED_TOKEN);
      await service.subscribeBusinessPlus();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Redirecting to Stripe checkout for Business Plus plan...'),
            backgroundColor: Colors.blue,
          ),
        );
      }
    } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to start Business Plus subscription: $e'),
            backgroundColor: Colors.red,
          ),
        );
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _applyPromoCode() async {
    final code = _promoCodeController.text.trim();
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a promo code'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isApplyingPromo = true);

    try {
      final service = ref.read(REDACTED_TOKEN);
      await service.applyPromoCode(code);
      setState(() => _selectedPromoCode = code);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Promo applied! Your next bill is free.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to apply promo code: $e'),
            backgroundColor: Colors.red,
          ),
        );
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isApplyingPromo = false);
      }
    }
  }

  Future<void> _openCustomerPortal() async {
    try {
      final service = ref.read(REDACTED_TOKEN);
      await service.openCustomerPortal();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Opening customer portal...'),
            backgroundColor: Colors.blue,
          ),
        );
      }
    } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to open customer portal: $e'),
            backgroundColor: Colors.red,
          ),
        );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final subscriptionAsync = ref.watch(currentSubscriptionProvider);
    final mapUsageStats = ref.watch(mapUsageStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Subscription'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        actions: [
          if (subscriptionAsync.value != null)
            TextButton(
              onPressed: _openCustomerPortal,
              child: const Text(
                'Manage Subscription',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Current subscription status
            subscriptionAsync.when(
              data: (subscription) {
                if (subscription != null) {
                  return _buildCurrentSubscriptionCard(subscription, mapUsageStats);
                }
                return const SizedBox.shrink();
              },
              loading: () => const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
              error: (error, final stack) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Error loading subscription: $error'),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Promo code section
            _buildPromoCodeSection(),

            const SizedBox(height: 24),

            // Subscription plans
            const Text(
              'Choose Your Plan',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Select the plan that best fits your business needs',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Plan cards
            _buildPlanCard(
              plan: SubscriptionPlan.starter,
              onSubscribe: _subscribeToStarter,
              isCurrentPlan: subscriptionAsync.value?.plan == SubscriptionPlan.starter,
            ),
            const SizedBox(height: 16),

            _buildPlanCard(
              plan: SubscriptionPlan.professional,
              onSubscribe: _subscribeToProfessional,
              isCurrentPlan: subscriptionAsync.value?.plan == SubscriptionPlan.professional,
            ),
            const SizedBox(height: 16),

            _buildPlanCard(
              plan: SubscriptionPlan.businessPlus,
              onSubscribe: _subscribeToBusinessPlus,
              isCurrentPlan: subscriptionAsync.value?.plan == SubscriptionPlan.businessPlus,
            ),

            const SizedBox(height: 32),

            // Features comparison
            _buildFeaturesComparison(),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentSubscriptionCard(BusinessSubscription subscription, Map<String, dynamic> mapUsageStats) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: subscription.plan.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.workspace_premium,
                    color: subscription.plan.color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Plan: ${subscription.plan.name}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        subscription.plan.priceDisplay,
                        style: TextStyle(
                          fontSize: 16,
                          color: subscription.plan.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: subscription.status.color,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    subscription.status.displayName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Usage stats
            if (mapUsageStats['hasLimit']) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Map Usage This Period',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: mapUsageStats['limit'] > 0 
                                ? (mapUsageStats['current'] / mapUsageStats['limit']).clamp(0.0, 1.0)
                                : 0.0,
                            backgroundColor: Colors.grey.shade300,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              mapUsageStats['remaining'] > 0 ? Colors.green : Colors.red,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${mapUsageStats['current']}/${mapUsageStats['limit']}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    if (mapUsageStats['overage'] > 0) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Overage charges: €${mapUsageStats['overage'].toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Colors.orange.shade800,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            Text(
              'Next billing: ${_formatDate(subscription.currentPeriodEnd)}',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            if (subscription.trialEnd != null) ...[
              const SizedBox(height: 4),
              Text(
                'Trial ends: ${_formatDate(subscription.trialEnd!)}',
                style: const TextStyle(color: Colors.orange),
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _openCustomerPortal,
                icon: const Icon(Icons.settings),
                label: const Text('Manage Plan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: subscription.plan.color,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoCodeSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Promo Code',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _promoCodeController,
                    decoration: const InputDecoration(
                      hintText: 'Enter promo code',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.discount),
                    ),
                    textCapitalization: TextCapitalization.characters,
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _isApplyingPromo ? null : _applyPromoCode,
                  child: _isApplyingPromo
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Apply'),
                ),
              ],
            ),
            if (_selectedPromoCode != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.green.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green.shade600, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Applied: $_selectedPromoCode',
                      style: TextStyle(
                        color: Colors.green.shade800,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required SubscriptionPlan plan,
    required VoidCallback onSubscribe,
    required bool isCurrentPlan,
  }) {
    return Card(
      elevation: plan.isRecommended ? 4 : 2,
      child: Container(
        decoration: plan.isRecommended
            ? BoxDecoration(
                border: Border.all(color: plan.color, width: 2),
                borderRadius: BorderRadius.circular(12),
              )
            : null,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: plan.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _getPlanIcon(plan),
                          color: plan.color,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            plan.name,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            plan.priceDisplay,
                            style: TextStyle(
                              color: plan.color,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (plan.isRecommended)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: plan.color,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        'RECOMMENDED',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              
              Text(
                plan.description,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              
              // Features
              ...plan.features.map((feature) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(Icons.check, color: plan.color, size: 20),
                    const SizedBox(width: 8),
                    Expanded(child: Text(feature)),
                  ],
                ),
              )),
              const SizedBox(height: 20),
              
              // Subscribe button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isCurrentPlan || _isLoading ? null : onSubscribe,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isCurrentPlan ? Colors.grey : plan.color,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          isCurrentPlan ? 'Current Plan' : 'Subscribe',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturesComparison() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Plan Comparison',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            _buildComparisonHeader(),
            const Divider(),
            
            _buildComparisonRow('Meetings per month', '20', 'Unlimited', 'Unlimited'),
            _buildComparisonRow('Business branding', '✗', '✓', '✓'),
            _buildComparisonRow('Map loads/month', '0', '200', '500'),
            _buildComparisonRow('Calendar views', 'Daily only', 'Daily + Monthly', 'Daily + Monthly'),
            _buildComparisonRow('Analytics', '✗', '✓', 'Advanced'),
            _buildComparisonRow('CRM & client list', '✗', '✓', '✓'),
            _buildComparisonRow('CSV export', '✗', '✓', '✓'),
            _buildComparisonRow('Email reminders', '✗', '✓', '✓'),
            _buildComparisonRow('Support', 'Email', 'Email', 'Priority'),
            _buildComparisonRow('Map overage cost', 'N/A', '€0.01/load', '€0.01/load'),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonHeader() {
    return Row(
      children: [
        const Expanded(flex: 2, child: Text('')),
        Expanded(
          child: Text(
            'Starter',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: SubscriptionPlan.starter.color,
            ),
          ),
        ),
        Expanded(
          child: Text(
            'Professional',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: SubscriptionPlan.professional.color,
            ),
          ),
        ),
        Expanded(
          child: Text(
            'Business Plus',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: SubscriptionPlan.businessPlus.color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildComparisonRow(String feature, String starter, String professional, String businessPlus) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              feature,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              starter,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: starter == '✗' ? Colors.red : Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              professional,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: professional == '✗' ? Colors.red : 
                       professional == '✓' ? Colors.green : Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              businessPlus,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: businessPlus == '✗' ? Colors.red : 
                       businessPlus == '✓' || businessPlus == 'Advanced' || businessPlus == 'Priority' 
                       ? Colors.green : Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getPlanIcon(SubscriptionPlan plan) {
    switch (plan) {
      case SubscriptionPlan.starter:
        return Icons.rocket_launch_outlined;
      case SubscriptionPlan.professional:
        return Icons.business_center;
      case SubscriptionPlan.businessPlus:
        return Icons.workspace_premium;
    }
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}
