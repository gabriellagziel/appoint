import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/meeting.dart';
import '../services/pwa_prompt_service.dart';
import '../services/analytics_service.dart';
import '../services/user_meta_service.dart';
import '../widgets/add_to_home_screen_dialog.dart';

class MeetingService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Handle meeting creation with PWA prompt integration
  /// Call this method after successfully creating/saving a meeting
  static Future<void> onMeetingCreated(
    BuildContext context,
    Meeting meeting, {
    bool showPwaPrompt = true,
  }) async {
    if (!showPwaPrompt) return;

    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      // Get user meta to check meeting count
      final userMeta = await UserMetaService.getUserMeta(userId);
      final meetingCount = (userMeta?.userPwaPromptCount ?? 0) + 1;

      // Check if PWA prompt should be shown
      final shouldShow =
          await PwaPromptService.shouldShowPromptAfterMeeting(userId);

      // Log meeting creation analytics
      await AnalyticsService.logMeetingCreated(
        meetingType: meeting.meetingType.toString().split('.').last,
        userMeetingCount: meetingCount,
        willShowPwaPrompt: shouldShow,
        userId: userId,
      );

      if (shouldShow && context.mounted) {
        // Show PWA prompt dialog
        await _showPwaPromptDialog(context);
      }
    } catch (e) {
      print('Error handling PWA prompt after meeting creation: $e');
    }
  }

  /// Show PWA prompt dialog
  static Future<void> _showPwaPromptDialog(BuildContext context) async {
    return AddToHomeScreenDialog.show(
      context,
      onAddNow: () async {
        final userId = _auth.currentUser?.uid;

        // Track that user attempted to install
        if (PwaPromptService.isAndroidDevice &&
            PwaPromptService.isInstallPromptAvailable) {
          // Android: Try to trigger native install prompt
          await PwaPromptService.showInstallPrompt();
        } else {
          // iOS or other: Just mark as shown (user follows manual instructions)
          print('PWA: Install instructions shown to user');
        }
      },
      onNotNow: () {
        print('PWA: User dismissed prompt');
      },
    );
  }

  /// Check if PWA should be prompted for current user
  static Future<bool> shouldShowPwaPrompt(String? userId) async {
    return await PwaPromptService.shouldShowPromptAfterMeeting(userId);
  }

  /// Manually trigger PWA prompt (for testing or manual triggers)
  static Future<void> showPwaPrompt(BuildContext context) async {
    if (PwaPromptService.isMobileDevice && PwaPromptService.supportsPwa) {
      await _showPwaPromptDialog(context);
    }
  }
}

/// Extension to make integration easier
extension MeetingExtensions on Meeting {
  /// Call this after saving a meeting to trigger PWA prompt if needed
  Future<void> handlePwaPrompt(BuildContext context) async {
    await MeetingService.onMeetingCreated(context, this);
  }
}

/// Mixin for widgets that create meetings
mixin MeetingCreationMixin<T extends StatefulWidget> on State<T> {
  /// Call this method after successfully creating a meeting
  Future<void> onMeetingCreated(Meeting meeting) async {
    await MeetingService.onMeetingCreated(context, meeting);
  }

  /// Check if PWA prompt would be shown for current user
  Future<bool> willShowPwaPrompt() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    return await MeetingService.shouldShowPwaPrompt(userId);
  }

  /// Manually show PWA prompt (for testing)
  Future<void> showPwaPrompt() async {
    await MeetingService.showPwaPrompt(context);
  }
}
