class UserMeta {
  final String userId;
  final int userPwaPromptCount;
  final bool hasInstalledPwa;
  final DateTime? pwaInstalledAt;
  final DateTime? lastPwaPromptShown;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserMeta({
    required this.userId,
    this.userPwaPromptCount = 0,
    this.hasInstalledPwa = false,
    this.pwaInstalledAt,
    this.lastPwaPromptShown,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserMeta.fromJson(Map<String, dynamic> json) => UserMeta(
        userId: json['userId'] ?? '',
        userPwaPromptCount: json['userPwaPromptCount'] ?? 0,
        hasInstalledPwa: json['hasInstalledPwa'] ?? false,
        pwaInstalledAt: json['pwaInstalledAt'] != null
            ? DateTime.parse(json['pwaInstalledAt'])
            : null,
        lastPwaPromptShown: json['lastPwaPromptShown'] != null
            ? DateTime.parse(json['lastPwaPromptShown'])
            : null,
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : DateTime.now(),
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'])
            : DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'userPwaPromptCount': userPwaPromptCount,
        'hasInstalledPwa': hasInstalledPwa,
        'pwaInstalledAt': pwaInstalledAt?.toIso8601String(),
        'lastPwaPromptShown': lastPwaPromptShown?.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  UserMeta copyWith({
    String? userId,
    int? userPwaPromptCount,
    bool? hasInstalledPwa,
    DateTime? pwaInstalledAt,
    DateTime? lastPwaPromptShown,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserMeta(
      userId: userId ?? this.userId,
      userPwaPromptCount: userPwaPromptCount ?? this.userPwaPromptCount,
      hasInstalledPwa: hasInstalledPwa ?? this.hasInstalledPwa,
      pwaInstalledAt: pwaInstalledAt ?? this.pwaInstalledAt,
      lastPwaPromptShown: lastPwaPromptShown ?? this.lastPwaPromptShown,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get shouldShowPwaPrompt {
    if (hasInstalledPwa) return false;
    return userPwaPromptCount % 3 == 0 && userPwaPromptCount > 0;
  }
}
