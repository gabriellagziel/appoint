import 'package:flutter/material.dart';
import '../providers/ad_logic_provider.dart';
import '../services/ad_service.dart'; // keeps ad flow usage below
import 'package:url_launcher/url_launcher.dart';
import '../services/stripe_payment_service.dart';

/// Booking confirmation sheet with ad integration
class BookingConfirmationSheet extends StatefulWidget {
  final String meetingId;
  final String meetingTitle;
  final DateTime meetingTime;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const BookingConfirmationSheet({
    Key? key,
    required this.meetingId,
    required this.meetingTitle,
    required this.meetingTime,
    required this.onConfirm,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<BookingConfirmationSheet> createState() =>
      _BookingConfirmationSheetState();
}

class _BookingConfirmationSheetState extends State<BookingConfirmationSheet> {
  final AdLogicNotifier _adLogic = AdLogicNotifier();
  bool _isLoading = false;
  bool _adCompleted = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeAdLogic();
  }

  Future<void> _initializeAdLogic() async {
    await _adLogic.initialize();
    setState(() {});
  }

  Future<void> _confirmMeeting() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Check if user should see ads
      if (_adLogic.shouldShowAds) {
        // Show ad before confirming
        final adCompleted = await _adLogic.showAd(
          location: 'booking_confirmation',
          meetingId: widget.meetingId,
        );

        if (!adCompleted) {
          setState(() {
            _error = 'Please watch the ad to confirm your meeting.';
            _isLoading = false;
          });
          return;
        }

        setState(() {
          _adCompleted = true;
        });
      }

      // Proceed with confirmation
      widget.onConfirm();

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to confirm meeting: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.calendar_today, color: Colors.blue),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Confirm Meeting',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(onPressed: widget.onCancel, icon: Icon(Icons.close)),
            ],
          ),
          SizedBox(height: 20),

          // Meeting details
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.meetingTitle,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8),
                Text(
                  'Time: ${_formatDateTime(widget.meetingTime)}',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),

          // Ad status indicator
          if (_adLogic.shouldShowAds && !_adCompleted)
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange[700]),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Please watch a short ad to confirm your meeting',
                      style: TextStyle(color: Colors.orange[700], fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),

          // Error message
          if (_error != null)
            Container(
              margin: EdgeInsets.only(top: 12),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red[700]),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _error!,
                      style: TextStyle(color: Colors.red[700], fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),

          SizedBox(height: 20),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _isLoading ? null : widget.onCancel,
                  child: Text('Cancel'),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _confirmMeeting,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text('Confirm Meeting'),
                ),
              ),
            ],
          ),

          // Upgrade CTA
          if (_adLogic.shouldShowAds)
            Container(
              margin: EdgeInsets.only(top: 16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.amber[100]!, Colors.amber[200]!],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber[700]),
                      SizedBox(width: 8),
                      Text(
                        'Upgrade to Premium',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber[900],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Remove ads and unlock exclusive features',
                    style: TextStyle(fontSize: 14, color: Colors.amber[800]),
                  ),
                  SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _openUpgradePage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[700],
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Upgrade Now'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _openUpgradePage() {
    // Integrate with StripePaymentService to obtain a real Checkout link
    // Inline note: Uses backend to create a session, then opens the URL.
    (() async {
      final link = await StripePaymentService.createUpgradePaymentLink(
        userId: 'current-user',
        userEmail: 'user@example.com',
        amount: 9.99,
      );
      if (link == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to obtain payment link')),
        );
        return;
      }
      // Use url_launcher to open link if available
      final uri = Uri.parse(link);
      // ignore: use_build_context_synchronously
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cannot open payment link')));
      }
    })();
  }

  @override
  void dispose() {
    _adLogic.dispose();
    super.dispose();
  }
}
