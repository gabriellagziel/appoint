class PlaytimeSession {
  final String id;
  final String gameId;
  final String type; // virtual, live
  final String title;
  final String description;
  final String creatorId;
  final List<PlaytimeParticipant> participants;
  final List<String> invitedUsers;
  final DateTime? scheduledFor;
  final int duration; // minutes
  final PlaytimeLocation? location;
  final String? backgroundId;
  final String status; // pending_approval, approved, declined, active, completed, cancelled
  final PlaytimeParentApprovalStatus parentApprovalStatus;
  final PlaytimeAdminApprovalStatus adminApprovalStatus;
  final PlaytimeSafetyFlags safetyFlags;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final bool chatEnabled;
  final int maxParticipants;
  final int currentParticipants;

  PlaytimeSession({
    required this.id,
    required this.gameId,
    required this.type,
    required this.title,
    required this.description,
    required this.creatorId,
    this.participants = const [],
    this.invitedUsers = const [],
    this.scheduledFor,
    required this.duration,
    this.location,
    this.backgroundId,
    this.status = 'pending_approval',
    required this.parentApprovalStatus,
    required this.adminApprovalStatus,
    required this.safetyFlags,
    required this.createdAt,
    required this.updatedAt,
    this.startedAt,
    this.endedAt,
    this.chatEnabled = true,
    required this.maxParticipants,
    this.currentParticipants = 0,
  });

  factory PlaytimeSession.fromJson(Map<String, dynamic> json) => PlaytimeSession(
    id: json['sessionId'] ?? json['id'],
    gameId: json['gameId'],
    type: json['type'],
    title: json['title'],
    description: json['description'],
    creatorId: json['creatorId'],
    participants: (json['participants'] as List<dynamic>?)
        ?.map((p) => PlaytimeParticipant.fromJson(p))
        .toList() ?? [],
    invitedUsers: List<String>.from(json['invitedUsers'] ?? []),
    scheduledFor: json['scheduledFor'] != null 
        ? (json['scheduledFor'] is DateTime 
            ? json['scheduledFor'] 
            : DateTime.parse(json['scheduledFor']))
        : null,
    duration: json['duration'],
    location: json['location'] != null 
        ? PlaytimeLocation.fromJson(json['location'])
        : null,
    backgroundId: json['backgroundId'],
    status: json['status'] ?? 'pending_approval',
    parentApprovalStatus: PlaytimeParentApprovalStatus.fromJson(
        json['parentApprovalStatus'] ?? {}),
    adminApprovalStatus: PlaytimeAdminApprovalStatus.fromJson(
        json['adminApprovalStatus'] ?? {}),
    safetyFlags: PlaytimeSafetyFlags.fromJson(
        json['safetyFlags'] ?? {}),
    createdAt: json['createdAt'] != null 
        ? (json['createdAt'] is DateTime 
            ? json['createdAt'] 
            : DateTime.parse(json['createdAt']))
        : DateTime.now(),
    updatedAt: json['updatedAt'] != null 
        ? (json['updatedAt'] is DateTime 
            ? json['updatedAt'] 
            : DateTime.parse(json['updatedAt']))
        : DateTime.now(),
    startedAt: json['startedAt'] != null 
        ? (json['startedAt'] is DateTime 
            ? json['startedAt'] 
            : DateTime.parse(json['startedAt']))
        : null,
    endedAt: json['endedAt'] != null 
        ? (json['endedAt'] is DateTime 
            ? json['endedAt'] 
            : DateTime.parse(json['endedAt']))
        : null,
    chatEnabled: json['chatEnabled'] ?? true,
    maxParticipants: json['maxParticipants'],
    currentParticipants: json['currentParticipants'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'sessionId': id,
    'gameId': gameId,
    'type': type,
    'title': title,
    'description': description,
    'creatorId': creatorId,
    'participants': participants.map((p) => p.toJson()).toList(),
    'invitedUsers': invitedUsers,
    'scheduledFor': scheduledFor?.toIso8601String(),
    'duration': duration,
    'location': location?.toJson(),
    'backgroundId': backgroundId,
    'status': status,
    'parentApprovalStatus': parentApprovalStatus.toJson(),
    'adminApprovalStatus': adminApprovalStatus.toJson(),
    'safetyFlags': safetyFlags.toJson(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'startedAt': startedAt?.toIso8601String(),
    'endedAt': endedAt?.toIso8601String(),
    'chatEnabled': chatEnabled,
    'maxParticipants': maxParticipants,
    'currentParticipants': currentParticipants,
  };

  PlaytimeSession copyWith({
    String? id,
    String? gameId,
    String? type,
    String? title,
    String? description,
    String? creatorId,
    List<PlaytimeParticipant>? participants,
    List<String>? invitedUsers,
    DateTime? scheduledFor,
    int? duration,
    PlaytimeLocation? location,
    String? backgroundId,
    String? status,
    PlaytimeParentApprovalStatus? parentApprovalStatus,
    PlaytimeAdminApprovalStatus? adminApprovalStatus,
    PlaytimeSafetyFlags? safetyFlags,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? startedAt,
    DateTime? endedAt,
    bool? chatEnabled,
    int? maxParticipants,
    int? currentParticipants,
  }) {
    return PlaytimeSession(
      id: id ?? this.id,
      gameId: gameId ?? this.gameId,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      creatorId: creatorId ?? this.creatorId,
      participants: participants ?? this.participants,
      invitedUsers: invitedUsers ?? this.invitedUsers,
      scheduledFor: scheduledFor ?? this.scheduledFor,
      duration: duration ?? this.duration,
      location: location ?? this.location,
      backgroundId: backgroundId ?? this.backgroundId,
      status: status ?? this.status,
      parentApprovalStatus: parentApprovalStatus ?? this.parentApprovalStatus,
      adminApprovalStatus: adminApprovalStatus ?? this.adminApprovalStatus,
      safetyFlags: safetyFlags ?? this.safetyFlags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      chatEnabled: chatEnabled ?? this.chatEnabled,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      currentParticipants: currentParticipants ?? this.currentParticipants,
    );
  }

  bool get isVirtual => type == 'virtual';
  bool get isLive => type == 'live';
  bool get isPendingApproval => status == 'pending_approval';
  bool get isApproved => status == 'approved';
  bool get isActive => status == 'active';
  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled';
  bool get isScheduled => scheduledFor != null;
  bool get isImmediate => scheduledFor == null;
  bool get requiresParentApproval => parentApprovalStatus.required;
  bool get isParentApproved => !requiresParentApproval || 
      parentApprovalStatus.approvedBy.isNotEmpty;
  bool get isParentDeclined => parentApprovalStatus.declinedBy.isNotEmpty;
  bool get canStart => isApproved && !isActive && !isCompleted && !isCancelled;
  bool get canJoin => isApproved && !isCompleted && !isCancelled;
  bool get isFull => currentParticipants >= maxParticipants;
}

class PlaytimeParticipant {
  final String userId;
  final String displayName;
  final String? photoUrl;
  final String role; // creator, participant
  final DateTime joinedAt;
  final String status; // invited, joined, left, declined

  PlaytimeParticipant({
    required this.userId,
    required this.displayName,
    this.photoUrl,
    required this.role,
    required this.joinedAt,
    required this.status,
  });

  factory PlaytimeParticipant.fromJson(Map<String, dynamic> json) => PlaytimeParticipant(
    userId: json['userId'],
    displayName: json['displayName'],
    photoUrl: json['photoUrl'],
    role: json['role'],
    joinedAt: json['joinedAt'] != null 
        ? (json['joinedAt'] is DateTime 
            ? json['joinedAt'] 
            : DateTime.parse(json['joinedAt']))
        : DateTime.now(),
    status: json['status'],
  );

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'displayName': displayName,
    'photoUrl': photoUrl,
    'role': role,
    'joinedAt': joinedAt.toIso8601String(),
    'status': status,
  };

  bool get isCreator => role == 'creator';
  bool get isJoined => status == 'joined';
  bool get isInvited => status == 'invited';
  bool get hasLeft => status == 'left';
  bool get hasDeclined => status == 'declined';
}

class PlaytimeLocation {
  final String name;
  final String address;
  final Map<String, double> coordinates; // latitude, longitude

  PlaytimeLocation({
    required this.name,
    required this.address,
    required this.coordinates,
  });

  factory PlaytimeLocation.fromJson(Map<String, dynamic> json) => PlaytimeLocation(
    name: json['name'],
    address: json['address'],
    coordinates: Map<String, double>.from(json['coordinates'] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'address': address,
    'coordinates': coordinates,
  };

  double? get latitude => coordinates['latitude'];
  double? get longitude => coordinates['longitude'];
}

class PlaytimeParentApprovalStatus {
  final bool required;
  final List<String> approvedBy;
  final List<String> declinedBy;
  final DateTime? approvedAt;
  final DateTime? declinedAt;

  PlaytimeParentApprovalStatus({
    required this.required,
    this.approvedBy = const [],
    this.declinedBy = const [],
    this.approvedAt,
    this.declinedAt,
  });

  factory PlaytimeParentApprovalStatus.fromJson(Map<String, dynamic> json) => PlaytimeParentApprovalStatus(
    required: json['required'] ?? false,
    approvedBy: List<String>.from(json['approvedBy'] ?? []),
    declinedBy: List<String>.from(json['declinedBy'] ?? []),
    approvedAt: json['approvedAt'] != null 
        ? (json['approvedAt'] is DateTime 
            ? json['approvedAt'] 
            : DateTime.parse(json['approvedAt']))
        : null,
    declinedAt: json['declinedAt'] != null 
        ? (json['declinedAt'] is DateTime 
            ? json['declinedAt'] 
            : DateTime.parse(json['declinedAt']))
        : null,
  );

  Map<String, dynamic> toJson() => {
    'required': required,
    'approvedBy': approvedBy,
    'declinedBy': declinedBy,
    'approvedAt': approvedAt?.toIso8601String(),
    'declinedAt': declinedAt?.toIso8601String(),
  };

  bool get isApproved => approvedBy.isNotEmpty;
  bool get isDeclined => declinedBy.isNotEmpty;
  bool get isPending => !isApproved && !isDeclined;
}

class PlaytimeAdminApprovalStatus {
  final bool required;
  final String? approvedBy;
  final DateTime? approvedAt;

  PlaytimeAdminApprovalStatus({
    this.required = false,
    this.approvedBy,
    this.approvedAt,
  });

  factory PlaytimeAdminApprovalStatus.fromJson(Map<String, dynamic> json) => PlaytimeAdminApprovalStatus(
    required: json['required'] ?? false,
    approvedBy: json['approvedBy'],
    approvedAt: json['approvedAt'] != null 
        ? (json['approvedAt'] is DateTime 
            ? json['approvedAt'] 
            : DateTime.parse(json['approvedAt']))
        : null,
  );

  Map<String, dynamic> toJson() => {
    'required': required,
    'approvedBy': approvedBy,
    'approvedAt': approvedAt?.toIso8601String(),
  };

  bool get isApproved => approvedBy != null;
  bool get isPending => required && !isApproved;
}

class PlaytimeSafetyFlags {
  final bool reportedContent;
  final bool moderationRequired;
  final bool autoPaused;

  PlaytimeSafetyFlags({
    this.reportedContent = false,
    this.moderationRequired = false,
    this.autoPaused = false,
  });

  factory PlaytimeSafetyFlags.fromJson(Map<String, dynamic> json) => PlaytimeSafetyFlags(
    reportedContent: json['reportedContent'] ?? false,
    moderationRequired: json['moderationRequired'] ?? false,
    autoPaused: json['autoPaused'] ?? false,
  );

  Map<String, dynamic> toJson() => {
    'reportedContent': reportedContent,
    'moderationRequired': moderationRequired,
    'autoPaused': autoPaused,
  };

  bool get hasSafetyIssues => reportedContent || moderationRequired || autoPaused;
}
