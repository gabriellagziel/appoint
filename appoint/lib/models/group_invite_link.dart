class GroupInviteLink {
  final String meetingId; // or groupId when creating a reusable group
  final String token; // random, short-lived
  final DateTime expiresAt;
  final String url; // canonical https://app-oint.com/join?token=...&src=...
  final bool singleUse; // whether this invite can only be used once
  final DateTime? consumedAt; // when this invite was consumed (if single-use)

  const GroupInviteLink({
    required this.meetingId,
    required this.token,
    required this.expiresAt,
    required this.url,
    this.singleUse = false,
    this.consumedAt,
  });

  factory GroupInviteLink.fromMap(Map<String, dynamic> data) {
    return GroupInviteLink(
      meetingId: data['meetingId'] ?? '',
      token: data['token'] ?? '',
      expiresAt: data['expiresAt'] != null
          ? DateTime.parse(data['expiresAt'])
          : DateTime.now().add(const Duration(days: 7)),
      url: data['url'] ?? '',
      singleUse: data['singleUse'] ?? false,
      consumedAt: data['consumedAt'] != null
          ? DateTime.parse(data['consumedAt'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'meetingId': meetingId,
      'token': token,
      'expiresAt': expiresAt.toIso8601String(),
      'url': url,
      'singleUse': singleUse,
      'consumedAt': consumedAt?.toIso8601String(),
    };
  }

  GroupInviteLink copyWith({
    String? meetingId,
    String? token,
    DateTime? expiresAt,
    String? url,
    bool? singleUse,
    DateTime? consumedAt,
  }) {
    return GroupInviteLink(
      meetingId: meetingId ?? this.meetingId,
      token: token ?? this.token,
      expiresAt: expiresAt ?? this.expiresAt,
      url: url ?? this.url,
      singleUse: singleUse ?? this.singleUse,
      consumedAt: consumedAt ?? this.consumedAt,
    );
  }

  // Add source parameter to URL for analytics
  String withSource(String? src) {
    if (src == null || src.isEmpty) return url;

    final separator = url.contains('?') ? '&' : '?';
    return '$url${separator}src=$src';
  }

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  bool get isConsumed => consumedAt != null;

  bool get isValid => !isExpired && token.isNotEmpty && meetingId.isNotEmpty;

  bool get isActive => !isExpired && !isConsumed;

  // Get time until expiration
  Duration get timeUntilExpiration => expiresAt.difference(DateTime.now());

  // Format expiration for display
  String get expirationDisplay {
    final duration = timeUntilExpiration;
    if (duration.isNegative) return 'Expired';

    final days = duration.inDays;
    final hours = duration.inHours % 24;

    if (days > 0) {
      return 'Expires in $days day${days > 1 ? 's' : ''}';
    } else if (hours > 0) {
      return 'Expires in $hours hour${hours > 1 ? 's' : ''}';
    } else {
      return 'Expires soon';
    }
  }
}
