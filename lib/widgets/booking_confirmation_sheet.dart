import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:appoint/providers/user_subscription_provider.dart';
import 'package:appoint/services/ad_service.dart';
import 'package:appoint/features/studio_business/providers/booking_provider.dart';

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
  bool _isUpgrading = false;

  Future<void> _handleConfirm() async {
    final isPremium = ref.read(userSubscriptionProvider).maybeWhen(
          data: (isPremium) => isPremium,
          orElse: () => false,
        );

    if (!isPremium) {
      // Show ad for non-premium users
      setState(() => _isLoadingAd = true);
      try {
        await AdService.showInterstitialAd();
      } catch (e) {
        // Continue even if ad fails
      } finally {
        if (mounted) setState(() => _isLoadingAd = false);
      }
    }

    // Call the original onConfirm callback
    widget.onConfirm();
  }

  void _handleUpgrade() {
    setState(() => _isUpgrading = true);
    
    // Simulate upgrade process
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isUpgrading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Premium upgrade feature coming soon!'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final subscriptionState = ref.watch(userSubscriptionProvider);
    final bookingState = ref.watch(bookingProvider);
    
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.confirm_appointment_button,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Text(widget.summaryText),
          const SizedBox(height: 24),
          
          // Show booking state
          bookingState.when(
            data: (booking) {
              if (booking != null) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Booking created successfully!',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, stack) => Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Error: $error',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Premium upgrade section for non-premium users
          subscriptionState.when(
            data: (isPremium) {
              if (!isPremium) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange.withOpacity(0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.orange, size: 20),
                              const SizedBox(width: 8),
                                                        Text(
                            l10n.upgrade_button,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange[700],
                            ),
                          ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.upgrade_prompt_description,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isUpgrading ? null : _handleUpgrade,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                        ),
                        icon: _isUpgrading 
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Icon(Icons.star, size: 16),
                        label: Text(_isUpgrading ? 'Upgrading...' : l10n.upgrade_button),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: bookingState.isLoading ? null : widget.onCancel,
                  child: Text(l10n.cancel),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: (_isLoadingAd || bookingState.isLoading) ? null : _handleConfirm,
                  child: (_isLoadingAd || bookingState.isLoading)
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.confirm_appointment_button),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
