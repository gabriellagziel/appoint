import 'package:flutter/material.dart';
import '../providers/ad_logic_provider.dart';
import '../services/ad_service.dart';
import '../services/ad_logging_service.dart';
import '../services/mock_ad_service.dart';
import '../services/ecpm_settings_service.dart';
import '../services/coppa_service.dart';
import '../services/stripe_payment_service.dart';
import '../services/admin_service.dart';
import 'booking_confirmation_sheet.dart';
import 'save_reminder_flow.dart';

/// Demo screen to test the ad system
class AdDemoScreen extends StatefulWidget {
  const AdDemoScreen({Key? key}) : super(key: key);

  @override
  State<AdDemoScreen> createState() => _AdDemoScreenState();
}

class _AdDemoScreenState extends State<AdDemoScreen> {
  final AdLogicNotifier _adLogic = AdLogicNotifier();
  Map<String, dynamic> _adStats = {};
  Map<String, dynamic> _adminStats = {};
  Map<String, dynamic> _systemStats = {};
  Map<String, dynamic> _ecpmStats = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    setState(() {
      _isLoading = true;
    });

    await _adLogic.initialize();
    await _loadStats();

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadStats() async {
    final stats = await _adLogic.getAdStats();
    final adminStats = await AdminService.getAdRevenueStats();
    final systemStats = await AdLoggingService.getSystemAdStats();
    final ecpmStats = await ECPMSettingsService.getECPMStats();

    setState(() {
      _adStats = stats;
      _adminStats = adminStats;
      _systemStats = systemStats;
      _ecpmStats = ecpmStats;
    });
  }

  Future<void> _testAdFlow() async {
    final adCompleted = await AdService.showInterstitialAd(
      location: 'demo_screen',
      meetingId: 'demo_meeting_123',
      userId: 'demo_user_123',
      isPremium: false,
      isChild: false,
      context: context,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          adCompleted
              ? 'Ad completed successfully!'
              : 'Ad was skipped or failed.',
        ),
        backgroundColor: adCompleted ? Colors.green : Colors.orange,
      ),
    );

    await _loadStats();
  }

  Future<void> _testMockAd() async {
    final adCompleted = await MockAdService.showMockAd(
      userId: 'demo_user_123',
      type: 'demo',
      meetingId: 'demo_meeting_456',
      isPremium: false,
      isChild: false,
      context: context,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          adCompleted
              ? 'Mock ad completed successfully!'
              : 'Mock ad was skipped.',
        ),
        backgroundColor: adCompleted ? Colors.green : Colors.orange,
      ),
    );

    await _loadStats();
  }

  void _showBookingConfirmation() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (context) => BookingConfirmationSheet(
            meetingId: 'demo_meeting_456',
            meetingTitle: 'Demo Meeting',
            meetingTime: DateTime.now().add(Duration(days: 1)),
            onConfirm: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Meeting confirmed!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            onCancel: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Meeting cancelled.'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
          ),
    );
  }

  void _showReminderSave() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (context) => SaveReminderFlow(
            reminderId: 'demo_reminder_789',
            reminderTitle: 'Demo Reminder',
            reminderTime: DateTime.now().add(Duration(hours: 2)),
            onSave: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Reminder saved!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            onCancel: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Reminder cancelled.'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
          ),
    );
  }

  void _testCoppaCompliance() {
    final testCases = [
      {
        'name': 'Adult User (25 years old)',
        'birthDate': DateTime.now().subtract(Duration(days: 25 * 365)),
        'isChildAccount': false,
        'isPremium': false,
        'isAdminFreeAccess': false,
      },
      {
        'name': 'Child User (10 years old)',
        'birthDate': DateTime.now().subtract(Duration(days: 10 * 365)),
        'isChildAccount': false,
        'isPremium': false,
        'isAdminFreeAccess': false,
      },
      {
        'name': 'Premium User',
        'birthDate': DateTime.now().subtract(Duration(days: 30 * 365)),
        'isChildAccount': false,
        'isPremium': true,
        'isAdminFreeAccess': false,
      },
      {
        'name': 'Child Account Flag',
        'birthDate': DateTime.now().subtract(Duration(days: 15 * 365)),
        'isChildAccount': true,
        'isPremium': false,
        'isAdminFreeAccess': false,
      },
    ];

    for (final testCase in testCases) {
      final compliance = CoppaService.getComplianceStatus(
        birthDate: testCase['birthDate'] as DateTime,
        isChildAccountFlag: testCase['isChildAccount'] as bool,
        isPremium: testCase['isPremium'] as bool,
        isAdminFreeAccess: testCase['isAdminFreeAccess'] as bool,
      );

      debugPrint('${testCase['name']}: ${compliance['reason']}');
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('COPPA compliance tests logged to console.'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _testUpgradeFlow() async {
    await StripePaymentService.openUpgradePage(
      userId: 'demo_user_123',
      userEmail: 'demo@example.com',
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Upgrade flow initiated!'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _testECPMCalculation() async {
    final impressions = 1000;
    final revenueEstimate = await ECPMSettingsService.getRevenueEstimate(
      impressions,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Revenue estimate for $impressions impressions: $revenueEstimate',
        ),
        backgroundColor: Colors.purple,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ad System Demo'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Ad Logic Status
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ad Logic Status',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text('Should Show Ads: ${_adLogic.shouldShowAds}'),
                            Text('Is Premium: ${_adLogic.isPremium}'),
                            Text(
                              'Is Child Account: ${_adLogic.isChildAccount}',
                            ),
                            Text('Is Loading: ${_adLogic.isLoading}'),
                            if (_adLogic.error != null)
                              Text(
                                'Error: ${_adLogic.error}',
                                style: TextStyle(color: Colors.red),
                              ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Test Buttons
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Test Functions',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _testAdFlow,
                              child: Text('Test Ad Flow'),
                            ),
                            SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: _testMockAd,
                              child: Text('Test Mock Ad'),
                            ),
                            SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: _showBookingConfirmation,
                              child: Text('Test Booking Confirmation'),
                            ),
                            SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: _showReminderSave,
                              child: Text('Test Reminder Save'),
                            ),
                            SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: _testCoppaCompliance,
                              child: Text('Test COPPA Compliance'),
                            ),
                            SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: _testUpgradeFlow,
                              child: Text('Test Upgrade Flow'),
                            ),
                            SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: _testECPMCalculation,
                              child: Text('Test eCPM Calculation'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Ad Statistics
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ad Statistics',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text('Total Views: ${_adStats['totalViews'] ?? 0}'),
                            Text(
                              'Completed Views: ${_adStats['completedViews'] ?? 0}',
                            ),
                            Text(
                              'Skipped Views: ${_adStats['skippedViews'] ?? 0}',
                            ),
                            Text(
                              'Failed Views: ${_adStats['failedViews'] ?? 0}',
                            ),
                            Text(
                              'Completion Rate: ${((_adStats['completionRate'] ?? 0.0) * 100).toStringAsFixed(1)}%',
                            ),
                            Text(
                              'Total Revenue: \$${(_adStats['totalRevenue'] ?? 0.0).toStringAsFixed(2)}',
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // System Statistics
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'System Statistics',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Total Impressions: ${_systemStats['totalImpressions'] ?? 0}',
                            ),
                            Text(
                              'Total Revenue: \$${(_systemStats['totalRevenue'] ?? 0.0).toStringAsFixed(2)}',
                            ),
                            Text(
                              'Premium Users: ${_systemStats['premiumUsers'] ?? 0}',
                            ),
                            Text(
                              'Child Users: ${_systemStats['childUsers'] ?? 0}',
                            ),
                            Text(
                              'Free Users: ${_systemStats['freeUsers'] ?? 0}',
                            ),
                            Text(
                              'Average eCPM: \$${(_systemStats['averageECPM'] ?? 0.0).toStringAsFixed(3)}',
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // eCPM Statistics
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'eCPM Statistics',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Current eCPM: \$${(_ecpmStats['currentECPM'] ?? 0.0).toStringAsFixed(3)}',
                            ),
                            Text(
                              'Average eCPM: \$${(_ecpmStats['averageECPM'] ?? 0.0).toStringAsFixed(3)}',
                            ),
                            Text(
                              'Min eCPM: \$${(_ecpmStats['minECPM'] ?? 0.0).toStringAsFixed(3)}',
                            ),
                            Text(
                              'Max eCPM: \$${(_ecpmStats['maxECPM'] ?? 0.0).toStringAsFixed(3)}',
                            ),
                            Text(
                              'Revenue per 1000: \$${(_ecpmStats['revenuePerThousand'] ?? 0.0).toStringAsFixed(2)}',
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Admin Statistics
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Admin Statistics',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Total Impressions: ${_adminStats['totalImpressions'] ?? 0}',
                            ),
                            Text(
                              'Total Revenue: \$${(_adminStats['totalRevenue'] ?? 0.0).toStringAsFixed(2)}',
                            ),
                            Text(
                              'Average eCPM: \$${(_adminStats['averageECPM'] ?? 0.0).toStringAsFixed(2)}',
                            ),
                            Text(
                              'Completion Rate: ${((_adminStats['completionRate'] ?? 0.0) * 100).toStringAsFixed(1)}%',
                            ),
                            Text(
                              'Premium Conversions: ${_adminStats['premiumConversions'] ?? 0}',
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Refresh Button
                    ElevatedButton(
                      onPressed: _loadStats,
                      child: Text('Refresh Statistics'),
                    ),
                  ],
                ),
              ),
    );
  }

  @override
  void dispose() {
    _adLogic.dispose();
    super.dispose();
  }
}
