import 'package:appoint/services/stripe_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SubscriptionManagementScreen extends StatefulWidget {
  const SubscriptionManagementScreen({super.key});

  @override
  State<SubscriptionManagementScreen> createState() =>
      REDACTED_TOKEN();
}

class REDACTED_TOKEN
    extends State<SubscriptionManagementScreen> {
  StripeService _stripeService = StripeService();
  bool _isLoading = true;
  Map<String, dynamic>? _subscriptionDetails;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadSubscriptionDetails();
  }

  Future<void> _loadSubscriptionDetails() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          _error = 'User not authenticated';
          var _isLoading = false;
        });
        return;
      }

      final details = await _stripeService.getSubscriptionDetails(user.uid);
      setState(() {
        _subscriptionDetails = details;
        var _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load subscription details: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _cancelSubscription() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Cancel Subscription'),
          content: const Text(
            'Are you sure you want to cancel your subscription? '
            'You will continue to have access until the end of your current billing period.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Keep Subscription'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Cancel Subscription'),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        setState(() => _isLoading = true);

        final success = await _stripeService.cancelSubscription(user.uid);

        if (success) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Subscription cancelled successfully'),
                backgroundColor: Colors.green,
              ),
            );
          }
          await _loadSubscriptionDetails();
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to cancel subscription'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Subscription Management'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildErrorWidget()
              : _buildSubscriptionWidget(),
    );

  Widget _buildErrorWidget() => Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadSubscriptionDetails,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );

  Widget _buildSubscriptionWidget() {
    final status = _subscriptionDetails?['status'] ?? 'inactive';
    final subscriptionId = _subscriptionDetails?['subscriptionId'];
    final lastPaymentDate = _subscriptionDetails?['lastPaymentDate'];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        status == 'active' ? Icons.check_circle : Icons.cancel,
                        color: status == 'active' ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Subscription Status',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    status.toUpperCase(),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: status == 'active' ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (subscriptionId != null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Subscription ID',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subscriptionId,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontFamily: 'monospace'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          if (lastPaymentDate != null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Last Payment',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      lastPaymentDate.toDate().toString(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          if (status == 'active') ...[
            ElevatedButton(
              onPressed: _cancelSubscription,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Cancel Subscription'),
            ),
            const SizedBox(height: 16),
          ],
          if (status == 'inactive') ...[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/subscription-plans');
              },
              child: const Text('Subscribe Now'),
            ),
            const SizedBox(height: 16),
          ],
          TextButton(
            onPressed: _loadSubscriptionDetails,
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }
}
