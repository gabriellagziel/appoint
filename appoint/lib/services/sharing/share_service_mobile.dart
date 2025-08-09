// Mobile-compatible share service stub
import '../../models/group_invite_link.dart';
import '../analytics/analytics_service.dart';

class ShareServiceWeb {
  /// Share invite link with optional source tracking
  static Future<void> shareInviteLink(GroupInviteLink link,
      {String? src}) async {
    // Mobile implementation would go here
    // For now, just track analytics
    AnalyticsService.track("share_invite_clicked", {
      "src": src ?? "unknown",
      "meetingId": link.meetingId,
      "platform": "mobile",
    });
  }
}
