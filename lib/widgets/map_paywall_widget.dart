import 'package:flutter/material.dart';
import 'package:appoint/models/personal_subscription.dart';

class MapPaywallWidget extends StatelessWidget {
  const MapPaywallWidget({
    super.key,
    required this.subscriptionStatus,
    this.onUpgrade,
    this.height = 200,
  });

  final PersonalSubscriptionStatus subscriptionStatus;
  final VoidCallback? onUpgrade;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.map_outlined,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          
          Text(
            _getTitle(),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              _getMessage(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          
          if (_shouldShowUpgradeButton())
            ElevatedButton.icon(
              onPressed: onUpgrade,
              icon: const Icon(Icons.upgrade, size: 20),
              label: Text(_getButtonText()),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _getTitle() {
    switch (subscriptionStatus) {
      case PersonalSubscriptionStatus.adSupported:
        return 'Map Access Requires Subscription';
      case PersonalSubscriptionStatus.expired:
        return 'Subscription Expired';
      case PersonalSubscriptionStatus.free:
      case PersonalSubscriptionStatus.premium:
        return 'Map Not Available';
    }
  }

  String _getMessage() {
    switch (subscriptionStatus) {
      case PersonalSubscriptionStatus.adSupported:
        return 'You\'ve used your 5 free meetings with map access. Upgrade to Premium for just €4/month to continue using maps and remove ads.';
      case PersonalSubscriptionStatus.expired:
        return 'Your Premium subscription has expired. Renew to restore map access and remove ads.';
      case PersonalSubscriptionStatus.free:
        return 'Map access is temporarily unavailable. Please try again later.';
      case PersonalSubscriptionStatus.premium:
        return 'You\'ve reached your weekly meeting limit. Consider upgrading to our Business platform for unlimited meetings.';
    }
  }

  String _getButtonText() {
    switch (subscriptionStatus) {
      case PersonalSubscriptionStatus.adSupported:
        return 'Upgrade to Premium €4/month';
      case PersonalSubscriptionStatus.expired:
        return 'Renew Subscription';
      case PersonalSubscriptionStatus.free:
        return 'Try Again';
      case PersonalSubscriptionStatus.premium:
        return 'Explore Business Plans';
    }
  }

  bool _shouldShowUpgradeButton() {
    return onUpgrade != null && subscriptionStatus != PersonalSubscriptionStatus.free;
  }
}

class MapPaywallDialog extends StatelessWidget {
  const MapPaywallDialog({
    super.key,
    required this.subscriptionStatus,
    this.onUpgrade,
  });

  final PersonalSubscriptionStatus subscriptionStatus;
  final VoidCallback? onUpgrade;

  @override
  Widget build(BuildContext context) {
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
                color: Colors.blue.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.map,
                size: 48,
                color: Colors.blue.shade600,
              ),
            ),
            const SizedBox(height: 16),
            
            // Title
            Text(
              _getDialogTitle(),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            
            // Message
            Text(
              _getDialogMessage(),
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
                if (_shouldShowUpgradeButton()) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                        onUpgrade?.call();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
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
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getDialogTitle() {
    switch (subscriptionStatus) {
      case PersonalSubscriptionStatus.adSupported:
        return 'Upgrade for Map Access';
      case PersonalSubscriptionStatus.expired:
        return 'Renew Your Subscription';
      case PersonalSubscriptionStatus.free:
      case PersonalSubscriptionStatus.premium:
        return 'Map Access Unavailable';
    }
  }

  String _getDialogMessage() {
    switch (subscriptionStatus) {
      case PersonalSubscriptionStatus.adSupported:
        return 'You\'ve used your 5 free meetings with full features. Upgrade to Premium for €4/month to restore map access and remove ads.';
      case PersonalSubscriptionStatus.expired:
        return 'Your Premium subscription has expired. Renew to continue enjoying map access and ad-free experience.';
      case PersonalSubscriptionStatus.free:
        return 'Map access is currently unavailable. This might be a temporary issue.';
      case PersonalSubscriptionStatus.premium:
        return 'You\'ve reached your weekly meeting limit of 20. Consider our Business platform for unlimited meetings.';
    }
  }

  String _getButtonText() {
    switch (subscriptionStatus) {
      case PersonalSubscriptionStatus.adSupported:
        return 'Upgrade Now';
      case PersonalSubscriptionStatus.expired:
        return 'Renew';
      case PersonalSubscriptionStatus.free:
        return 'Retry';
      case PersonalSubscriptionStatus.premium:
        return 'Business Plans';
    }
  }

  bool _shouldShowUpgradeButton() {
    return onUpgrade != null;
  }
}

/// Helper function to show the map paywall dialog
Future<bool?> showMapPaywallDialog({
  required BuildContext context,
  required PersonalSubscriptionStatus subscriptionStatus,
  VoidCallback? onUpgrade,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (context) => MapPaywallDialog(
      subscriptionStatus: subscriptionStatus,
      onUpgrade: onUpgrade,
    ),
  );
}