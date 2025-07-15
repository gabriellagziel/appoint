import 'package:appoint/features/studio_business/models/business_subscription.dart';
import 'package:appoint/features/studio_business/providers/business_subscription_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BusinessSubscriptionScreen extends ConsumerStatefulWidget {
  const BusinessSubscriptionScreen({super.key});

  @override
  ConsumerState<BusinessSubscriptionScreen> createState() =>
      _BusinessSubscriptionScreenState();
}

class _BusinessSubscriptionScreenState
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

  Future<void> _subscribeToBasic() async {
    setState(() => _isLoading = true);

    try {
      final service = ref.read(businessSubscriptionServiceProvider);
      await service.subscribeBasic();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Redirecting to Stripe checkout for Basic plan...'),
            backgroundColor: Colors.blue,
          ),
        );
      }
    } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to start Basic subscription: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _subscribeToPro() async {
    setState(() => _isLoading = true);

    try {
      final service = ref.read(businessSubscriptionServiceProvider);
      await service.subscribePro();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Redirecting to Stripe checkout for Pro plan...'),
            backgroundColor: Colors.blue,
          ),
        );
      }
    } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to start Pro subscription: $e'),
            backgroundColor: Colors.red,
          ),
        );
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
      final service = ref.read(businessSubscriptionServiceProvider);
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to apply promo code: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isApplyingPromo = false);
      }
    }
  }

  Future<void> _openCustomerPortal() async {
    try {
      final service = ref.read(businessSubscriptionServiceProvider);
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to open customer portal: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final subscriptionAsync = ref.watch(currentSubscriptionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Subscription'),
        actions: [
          if (subscriptionAsync.value != null)
            TextButton(
              onPressed: _openCustomerPortal,
              child: const Text('Manage Subscription'),
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
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current Plan: ${subscription.plan.name}',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Status: ${subscription.status.displayName}',
                            style: TextStyle(
                              color: subscription.status.color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Next billing: ${_formatDate(subscription.currentPeriodEnd)}',
                          ),
                          if (subscription.trialEnd != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Trial ends: ${_formatDate(subscription.trialEnd!)}',
                              style: const TextStyle(color: Colors.orange),
                            ),
                          ],
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _openCustomerPortal,
                              child: const Text('Change Plan'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
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
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Promo Code',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: _isApplyingPromo ? null : _applyPromoCode,
                          child: _isApplyingPromo
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text('Apply'),
                        ),
                      ],
                    ),
                    if (_selectedPromoCode != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Applied: $_selectedPromoCode',
                        style: const TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold,),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Subscription plans
            const Text(
              'Choose Your Plan',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Basic Plan Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _subscribeToBasic,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.grey[100],
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Subscribe to Basic (€4.99/mo)'),
              ),
            ),

            const SizedBox(height: 12),

            // Pro Plan Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _subscribeToPro,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Subscribe to Pro (€14.99/mo)'),
              ),
            ),

            const SizedBox(height: 24),

            // Features comparison
            _buildFeaturesComparison(),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesComparison() => Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Plan Comparison',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildComparisonRow('Meetings per month', '20', 'Unlimited'),
            _buildComparisonRow(
                'Calendar views', 'Daily only', 'Daily + Monthly',),
            _buildComparisonRow('Analytics', 'No', 'Yes'),
            _buildComparisonRow('CSV Export', 'No', 'Yes'),
            _buildComparisonRow('Email Reminders', 'No', 'Yes'),
            _buildComparisonRow('Client List', 'No', 'Yes'),
            _buildComparisonRow('Priority Support', 'No', 'Yes'),
          ],
        ),
      ),
    );

  Widget _buildComparisonRow(
      String feature, final String basic, final String pro,) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(feature,
                style: const TextStyle(fontWeight: FontWeight.w500),),
          ),
          Expanded(
            child: Text(basic,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),),
          ),
          Expanded(
            child: Text(pro,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),),
          ),
        ],
      ),
    );

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}
