import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/providers/ad_logic_provider.dart';
import 'package:appoint/providers/user_subscription_provider.dart';
import 'package:appoint/services/ad_service.dart';

class BookingConfirmationSheet extends ConsumerStatefulWidget {

  const BookingConfirmationSheet({
    required this.onConfirm,
    required this.onCancel,
    required this.summaryText,
    super.key,
  });
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final String summaryText;

  @override
  ConsumerState<BookingConfirmationSheet> createState() =>
      _BookingConfirmationSheetState();
}

class _BookingConfirmationSheetState extends ConsumerState<BookingConfirmationSheet> {
  bool _isLoadingAd = false;

  Future<void> _handleConfirm() async {
    final shouldShowAds = ref.read(shouldShowAdsProvider);
    
    if (shouldShowAds) {
      setState(() => _isLoadingAd = true);
      try {
        await AdService.showInterstitialAd();
      } catch (e) {
        // Continue even if ad fails
      } finally {
        if (mounted) setState(() => _isLoadingAd = false);
      }
    }
    
    widget.onConfirm();
  }

  Future<void> _upgradeToPremium() async {
    final upgradeService = ref.read(premiumUpgradeProvider);
    await upgradeService.upgradeToPremium();
    
    // TODO: Implement real payment flow
    // For now, just show a placeholder message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Premium upgrade coming soon! This would integrate with Stripe or in-app purchases.'),
          backgroundColor: Colors.amber,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final subscriptionAsync = ref.watch(userSubscriptionProvider);
    final shouldShowAds = ref.watch(shouldShowAdsProvider);

    final isPremium = subscriptionAsync.maybeWhen(
      data: (isPremium) => isPremium,
      orElse: () => false,
    );

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Confirm Appointment',
              style: Theme.of(context).textTheme.titleLarge,),
          const SizedBox(height: 12),
          Text(widget.summaryText),
          
          // Premium upgrade section
          if (!isPremium) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Upgrade to Premium',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Remove ads and enjoy a premium experience',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _upgradeToPremium,
                      icon: const Icon(Icons.star, size: 16),
                      label: const Text('Upgrade to Premium'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.onCancel,
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isLoadingAd ? null : _handleConfirm,
                  child: _isLoadingAd
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(shouldShowAds ? 'Confirm (with Ad)' : 'Confirm'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
