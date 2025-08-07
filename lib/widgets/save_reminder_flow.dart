import 'package:flutter/material.dart';
import '../providers/ad_logic_provider.dart';
import '../services/ad_service.dart';

/// Reminder save flow with ad integration
class SaveReminderFlow extends StatefulWidget {
  final String reminderId;
  final String reminderTitle;
  final DateTime reminderTime;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const SaveReminderFlow({
    Key? key,
    required this.reminderId,
    required this.reminderTitle,
    required this.reminderTime,
    required this.onSave,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<SaveReminderFlow> createState() => _SaveReminderFlowState();
}

class _SaveReminderFlowState extends State<SaveReminderFlow> {
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

  Future<void> _saveReminder() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Check if user should see ads
      if (_adLogic.shouldShowAds) {
        // Show ad before saving
        final adCompleted = await _adLogic.showAd(
          location: 'reminder_save',
          reminderId: widget.reminderId,
        );

        if (!adCompleted) {
          setState(() {
            _error = 'Please watch the ad to save your reminder.';
            _isLoading = false;
          });
          return;
        }

        setState(() {
          _adCompleted = true;
        });
      }

      // Proceed with saving
      widget.onSave();

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to save reminder: $e';
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
              Icon(Icons.alarm, color: Colors.orange),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Save Reminder',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(onPressed: widget.onCancel, icon: Icon(Icons.close)),
            ],
          ),
          SizedBox(height: 20),

          // Reminder details
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
                  widget.reminderTitle,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8),
                Text(
                  'Time: ${_formatDateTime(widget.reminderTime)}',
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
                      'Please watch a short ad to save your reminder',
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
                  onPressed: _isLoading ? null : _saveReminder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  child:
                      _isLoading
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
                          : Text('Save Reminder'),
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
    // TODO: Implement Stripe payment link
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening upgrade page...'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  @override
  void dispose() {
    _adLogic.dispose();
    super.dispose();
  }
}
