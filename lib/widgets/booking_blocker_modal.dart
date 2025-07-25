import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/models/personal_subscription.dart';

class BookingBlockerModal extends ConsumerWidget {
  const BookingBlockerModal({
    super.key,
    this.subscriptionStatus,
    this.freeMeetingsRemaining,
    this.weeklyMeetingsRemaining,
  });

  final PersonalSubscriptionStatus? subscriptionStatus;
  final int? freeMeetingsRemaining;
  final int? weeklyMeetingsRemaining;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.business_center,
                size: 48,
                color: Colors.orange.shade600,
              ),
            ),
            const SizedBox(height: 16),
            
            // Title
            Text(
              _getTitle(),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            
            // Message
            Text(
              _getMessage(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Close'),
                  ),
                ),
                const SizedBox(width: 12),
                                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _getButtonColor(),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(_getButtonText()),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getTitle() {
    if (subscriptionStatus == null) {
      return 'Using App-Oint for Business?';
    }

    switch (subscriptionStatus!) {
      case PersonalSubscriptionStatus.free:
        return 'Free Meetings Limit Reached';
      case PersonalSubscriptionStatus.premium:
        return 'Weekly Meeting Limit Reached';
      case PersonalSubscriptionStatus.adSupported:
      case PersonalSubscriptionStatus.expired:
        return 'Need More Meetings?';
    }
  }

  String _getMessage() {
    if (subscriptionStatus == null) {
      return 'You\'ve reached the weekly limit of 21 meetings. Open a business profile to continue booking without limits.';
    }

    switch (subscriptionStatus!) {
      case PersonalSubscriptionStatus.free:
        return 'You\'ve used your 5 free meetings with full features. Upgrade to Premium for €4/month or open a business profile for unlimited meetings.';
      case PersonalSubscriptionStatus.premium:
        return 'You\'ve reached your weekly limit of ${weeklyMeetingsRemaining ?? 20} meetings. Upgrade to our Business platform for unlimited meetings.';
      case PersonalSubscriptionStatus.adSupported:
        return 'Upgrade to Premium for €4/month to remove ads and get map access, or open a business profile for unlimited meetings.';
      case PersonalSubscriptionStatus.expired:
        return 'Your Premium subscription has expired. Renew for €4/month or open a business profile for unlimited meetings.';
    }
  }

  String _getButtonText() {
    if (subscriptionStatus == null) {
      return 'Open Business Profile';
    }

    switch (subscriptionStatus!) {
      case PersonalSubscriptionStatus.free:
      case PersonalSubscriptionStatus.adSupported:
      case PersonalSubscriptionStatus.expired:
        return 'Upgrade Options';
      case PersonalSubscriptionStatus.premium:
        return 'Business Plans';
    }
  }

  Color _getButtonColor() {
    if (subscriptionStatus == null) {
      return Colors.orange.shade600;
    }

    switch (subscriptionStatus!) {
      case PersonalSubscriptionStatus.free:
      case PersonalSubscriptionStatus.adSupported:
      case PersonalSubscriptionStatus.expired:
        return Colors.blue.shade600;
      case PersonalSubscriptionStatus.premium:
        return Colors.orange.shade600;
    }
  }
}

/// Helper function to show the booking blocker modal
Future<bool?> showBookingBlockerModal(
  BuildContext context, {
  PersonalSubscriptionStatus? subscriptionStatus,
  int? freeMeetingsRemaining,
  int? weeklyMeetingsRemaining,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => BookingBlockerModal(
      subscriptionStatus: subscriptionStatus,
      freeMeetingsRemaining: freeMeetingsRemaining,
      weeklyMeetingsRemaining: weeklyMeetingsRemaining,
    ),
  );
}