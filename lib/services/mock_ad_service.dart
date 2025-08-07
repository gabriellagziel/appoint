import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'ad_logging_service.dart';

/// Mock ad service for testing and development
class MockAdService {
  static final MockAdService _instance = MockAdService._internal();
  factory MockAdService() => _instance;
  MockAdService._internal();

  /// Shows a mock ad with configurable duration
  static Future<bool> showMockAd({
    Duration duration = const Duration(seconds: 6),
    required String userId,
    required String type, // "meeting" | "reminder"
    String? meetingId,
    String? reminderId,
    required bool isPremium,
    required bool isChild,
    double eCPM = 0.012,
    BuildContext? context,
  }) async {
    bool completed = false;
    bool skipped = false;

    // Log ad started
    await AdLoggingService.logAdEventToFirestore(
      userId: userId,
      status: 'started',
      type: type,
      meetingId: meetingId,
      reminderId: reminderId,
      isPremium: isPremium,
      isChild: isChild,
      eCPM: eCPM,
    );

    // Show mock ad dialog
    if (context != null) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return WillPopScope(
            onWillPop: () async => false, // Prevent back button
            child: AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.play_circle, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('Watch Ad'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue[100]!, Colors.purple[100]!],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.play_arrow,
                          size: 48,
                          color: Colors.blue[700],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Test Ad',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'This is a test ad for development',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.timer, color: Colors.orange),
                      SizedBox(width: 8),
                      Text(
                        'Wait ${duration.inSeconds} seconds',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.orange[700],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  LinearProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    skipped = true;
                    Navigator.of(dialogContext).pop();
                  },
                  child: Text('Skip'),
                ),
              ],
            ),
          );
        },
      );

      // Simulate ad duration
      await Future.delayed(duration);

      // Close dialog if not already closed
      if (!skipped) {
        Navigator.of(context).pop();
        completed = true;
      }
    }

    // Log ad result
    await AdLoggingService.logAdEventToFirestore(
      userId: userId,
      status: completed ? 'completed' : 'skipped',
      type: type,
      meetingId: meetingId,
      reminderId: reminderId,
      isPremium: isPremium,
      isChild: isChild,
      eCPM: eCPM,
    );

    return completed;
  }

  /// Shows a mock ad with upgrade CTA
  static Future<bool> showMockAdWithUpgrade({
    Duration duration = const Duration(seconds: 6),
    required String userId,
    required String type,
    String? meetingId,
    String? reminderId,
    required bool isPremium,
    required bool isChild,
    double eCPM = 0.012,
    BuildContext? context,
  }) async {
    bool completed = false;
    bool skipped = false;

    // Log ad started
    await AdLoggingService.logAdEventToFirestore(
      userId: userId,
      status: 'started',
      type: type,
      meetingId: meetingId,
      reminderId: reminderId,
      isPremium: isPremium,
      isChild: isChild,
      eCPM: eCPM,
    );

    // Show mock ad dialog with upgrade CTA
    if (context != null) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.play_circle, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('Watch Ad'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue[100]!, Colors.purple[100]!],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.play_arrow,
                          size: 48,
                          color: Colors.blue[700],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Test Ad',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'This is a test ad for development',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.timer, color: Colors.orange),
                      SizedBox(width: 8),
                      Text(
                        'Wait ${duration.inSeconds} seconds',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.orange[700],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  LinearProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                  SizedBox(height: 16),
                  // Upgrade CTA
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.amber[100]!, Colors.amber[200]!],
                      ),
                      borderRadius: BorderRadius.circular(8),
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
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber[900],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Remove ads and unlock features',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.amber[800],
                          ),
                        ),
                        SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => _openUpgradePage(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber[700],
                            foregroundColor: Colors.white,
                            minimumSize: Size(double.infinity, 32),
                          ),
                          child: Text('Upgrade Now'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    skipped = true;
                    Navigator.of(dialogContext).pop();
                  },
                  child: Text('Skip'),
                ),
              ],
            ),
          );
        },
      );

      // Simulate ad duration
      await Future.delayed(duration);

      // Close dialog if not already closed
      if (!skipped) {
        Navigator.of(context).pop();
        completed = true;
      }
    }

    // Log ad result
    await AdLoggingService.logAdEventToFirestore(
      userId: userId,
      status: completed ? 'completed' : 'skipped',
      type: type,
      meetingId: meetingId,
      reminderId: reminderId,
      isPremium: isPremium,
      isChild: isChild,
      eCPM: eCPM,
    );

    return completed;
  }

  /// Opens the upgrade page
  static void _openUpgradePage() {
    // TODO: Implement Stripe payment link
    debugPrint('Opening upgrade page...');
  }

  /// Shows error message when ad is required but not completed
  static void showAdRequiredError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You must watch the full ad to continue.'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  /// Shows success message when ad is completed
  static void showAdCompletedMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ad completed successfully!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
