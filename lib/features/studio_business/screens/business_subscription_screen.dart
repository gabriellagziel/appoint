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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _manageApiAccess() async {
    setState(() => _isLoading = true);

    try {
      // Navigate to API management screen
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Redirecting to API Access Management...'),
            backgroundColor: Colors.blue,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to access API management: $e'),
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

  @override
  Widget build(BuildContext context) {
    final subscriptionAsync = ref.watch(currentSubscriptionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Business API Management'),
        actions: [
          TextButton(
            onPressed: _manageApiAccess,
            child: const Text('Manage API Access'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Current API status
            subscriptionAsync.when(
              data: (subscription) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'B2B API Access',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Status: Active',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'API Quota: 1000/month',
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Map Usage Charges: €0.007 per call',
                          style: TextStyle(color: Colors.orange),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _manageApiAccess,
                            child: const Text('View API Keys'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              loading: () => const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
              error: (error, stack) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Error loading API status: $error'),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // API Usage Information
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Usage-Based Billing',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '• Standard API calls are included in your monthly quota\n'
                      '• Map API calls are charged separately at €0.007 per request\n'
                      '• Monthly invoices are generated automatically\n'
                      '• Payment due within 7 days to maintain service',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // API Features
            const Text(
              'API Features',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // API Access Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _manageApiAccess,
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
                    : const Text('Access API Dashboard'),
              ),
            ),

            const SizedBox(height: 24),

            // Features overview
            _buildFeaturesOverview(),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesOverview() => Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'API Capabilities',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildFeatureRow('Appointment Management', 'Create, update, cancel appointments'),
            _buildFeatureRow('Calendar Integration', 'Sync with business calendars'),
            _buildFeatureRow('Map Services', 'Location-based features (charged per use)'),
            _buildFeatureRow('Usage Analytics', 'Track API consumption'),
            _buildFeatureRow('Webhook Support', 'Real-time notifications'),
          ],
        ),
      ),
    );

  Widget _buildFeatureRow(String feature, String description) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(feature, style: const TextStyle(fontWeight: FontWeight.w500)),
                Text(description, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
}
