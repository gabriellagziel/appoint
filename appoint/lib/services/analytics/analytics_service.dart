class AnalyticsService {
  /// Track an analytics event
  static void track(String eventName, Map<String, dynamic> properties) {
    // TODO: Implement real analytics (Firebase, Mixpanel, etc.)
    print('ANALYTICS: $eventName - $properties');
  }

  /// Track share invite clicked
  static void trackShareInviteClicked({
    required String src,
    required String meetingId,
    String? platform,
  }) {
    track('share_invite_clicked', {
      'src': src,
      'meetingId': meetingId,
      'platform': platform ?? 'unknown',
    });
  }



  /// Track group created from invite
  static void trackGroupCreatedFromInvite({
    required String src,
    required String groupId,
  }) {
    track('group_created_from_invite', {
      'src': src,
      'groupId': groupId,
    });
  }

  /// Track invite opened
  static void trackInviteOpened({
    required String token,
    required String src,
    required String meetingId,
  }) {
    track('invite_opened', {
      'token': token,
      'src': src,
      'meetingId': meetingId,
    });
  }

  /// Track invite accepted
  static void trackInviteAccepted({
    required String token,
    required String src,
    required String meetingId,
  }) {
    track('invite_accepted', {
      'token': token,
      'src': src,
      'meetingId': meetingId,
    });
  }

  /// Track invite declined
  static void trackInviteDeclined({
    required String token,
    required String src,
    required String meetingId,
  }) {
    track('invite_declined', {
      'token': token,
      'src': src,
      'meetingId': meetingId,
    });
  }
}
