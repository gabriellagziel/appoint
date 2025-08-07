enum MeetingType {
  personal,
  event,
  playtime,
}

enum MeetingStatus {
  draft,
  scheduled,
  active,
  completed,
  cancelled,
}

enum ParticipantRole {
  organizer,
  admin,
  participant,
}

class Meeting {
  final String id;
  final String organizerId;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime endTime;
  final String? location;
  final String? virtualMeetingUrl;
  final List<MeetingParticipant> participants;
  final MeetingType meetingType;
  final MeetingStatus status;
  final String? customFormId;
  final String? checklistId;
  final String? groupChatId;
  final String? businessProfileId;
  final bool isRecurring;
  final String? recurringPattern;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // Playtime-specific fields
  final String? subtype; // physical, virtual
  final bool? isChildInitiated;
  final bool? parentApproved;
  final String? virtualLink;
  final String? notes;

  Meeting({
    required this.id,
    required this.organizerId,
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    this.location,
    this.virtualMeetingUrl,
    required this.participants,
    required this.meetingType,
    this.status = MeetingStatus.draft,
    this.customFormId,
    this.checklistId,
    this.groupChatId,
    this.businessProfileId,
    this.isRecurring = false,
    this.recurringPattern,
    required this.createdAt,
    required this.updatedAt,
    // Playtime fields
    this.subtype,
    this.isChildInitiated,
    this.parentApproved,
    this.virtualLink,
    this.notes,
  });

  factory Meeting.fromJson(Map<String, dynamic> json) => Meeting(
    id: json['id'],
    organizerId: json['organizerId'],
    title: json['title'],
    description: json['description'],
    startTime: DateTime.parse(json['startTime']),
    endTime: DateTime.parse(json['endTime']),
    location: json['location'],
    virtualMeetingUrl: json['virtualMeetingUrl'],
    participants: (json['participants'] as List<dynamic>?)
        ?.map((p) => MeetingParticipant.fromJson(p))
        .toList() ?? [],
    meetingType: MeetingType.values.firstWhere(
      (e) => e.toString().split('.').last == json['meetingType'],
      orElse: () => MeetingType.personal,
    ),
    status: MeetingStatus.values.firstWhere(
      (e) => e.toString().split('.').last == json['status'],
      orElse: () => MeetingStatus.draft,
    ),
    customFormId: json['customFormId'],
    checklistId: json['checklistId'],
    groupChatId: json['groupChatId'],
    businessProfileId: json['businessProfileId'],
    isRecurring: json['isRecurring'] ?? false,
    recurringPattern: json['recurringPattern'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    // Playtime fields
    subtype: json['subtype'],
    isChildInitiated: json['isChildInitiated'],
    parentApproved: json['parentApproved'],
    virtualLink: json['virtualLink'],
    notes: json['notes'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'organizerId': organizerId,
    'title': title,
    'description': description,
    'startTime': startTime.toIso8601String(),
    'endTime': endTime.toIso8601String(),
    'location': location,
    'virtualMeetingUrl': virtualMeetingUrl,
    'participants': participants.map((p) => p.toJson()).toList(),
    'meetingType': meetingType.toString().split('.').last,
    'status': status.toString().split('.').last,
    'customFormId': customFormId,
    'checklistId': checklistId,
    'groupChatId': groupChatId,
    'businessProfileId': businessProfileId,
    'isRecurring': isRecurring,
    'recurringPattern': recurringPattern,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    // Playtime fields
    'subtype': subtype,
    'isChildInitiated': isChildInitiated,
    'parentApproved': parentApproved,
    'virtualLink': virtualLink,
    'notes': notes,
  };

  Meeting copyWith({
    String? id,
    String? organizerId,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    String? location,
    String? virtualMeetingUrl,
    List<MeetingParticipant>? participants,
    MeetingType? meetingType,
    MeetingStatus? status,
    String? customFormId,
    String? checklistId,
    String? groupChatId,
    String? businessProfileId,
    bool? isRecurring,
    String? recurringPattern,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? subtype,
    bool? isChildInitiated,
    bool? parentApproved,
    String? virtualLink,
    String? notes,
  }) {
    return Meeting(
      id: id ?? this.id,
      organizerId: organizerId ?? this.organizerId,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      virtualMeetingUrl: virtualMeetingUrl ?? this.virtualMeetingUrl,
      participants: participants ?? this.participants,
      meetingType: meetingType ?? this.meetingType,
      status: status ?? this.status,
      customFormId: customFormId ?? this.customFormId,
      checklistId: checklistId ?? this.checklistId,
      groupChatId: groupChatId ?? this.groupChatId,
      businessProfileId: businessProfileId ?? this.businessProfileId,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringPattern: recurringPattern ?? this.recurringPattern,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      subtype: subtype ?? this.subtype,
      isChildInitiated: isChildInitiated ?? this.isChildInitiated,
      parentApproved: parentApproved ?? this.parentApproved,
      virtualLink: virtualLink ?? this.virtualLink,
      notes: notes ?? this.notes,
    );
  }

  // Computed properties
  bool get isPersonalMeeting => meetingType == MeetingType.personal;
  bool get isEvent => meetingType == MeetingType.event;
  bool get isPlaytime => meetingType == MeetingType.playtime;
  bool get isVirtualPlaytime => isPlaytime && subtype == 'virtual';
  bool get isPhysicalPlaytime => isPlaytime && subtype == 'physical';
  
  int get totalParticipantCount => participants.length + 1; // +1 for organizer
  
  String get typeDisplayName {
    switch (meetingType) {
      case MeetingType.personal:
        return 'Meeting';
      case MeetingType.event:
        return 'Event';
      case MeetingType.playtime:
        return 'Playtime';
    }
  }

  bool get hasCustomForm => customFormId != null;
  bool get hasChecklist => checklistId != null;
  bool get hasGroupChat => groupChatId != null;

  bool isOrganizer(String userId) => organizerId == userId;
  bool isAdmin(String userId) {
    if (isOrganizer(userId)) return true;
    final participant = getParticipant(userId);
    return participant?.role == ParticipantRole.admin;
  }

  bool canAccessEventFeatures(String userId) {
    if (!isEvent) return false;
    return isOrganizer(userId) || isAdmin(userId);
  }

  MeetingParticipant? getParticipant(String userId) {
    try {
      return participants.firstWhere((p) => p.userId == userId);
    } catch (e) {
      return null;
    }
  }

  String? validateMeetingCreation() {
    if (participants.isEmpty) {
      return 'Meeting must have at least one participant';
    }
    if (startTime.isAfter(endTime)) {
      return 'Start time must be before end time';
    }
    return null;
  }
}

class MeetingParticipant {
  final String userId;
  final String name;
  final String? email;
  final ParticipantRole role;
  final bool hasResponded;
  final bool willAttend;
  final DateTime? respondedAt;

  MeetingParticipant({
    required this.userId,
    required this.name,
    this.email,
    this.role = ParticipantRole.participant,
    this.hasResponded = false,
    this.willAttend = true,
    this.respondedAt,
  });

  factory MeetingParticipant.fromJson(Map<String, dynamic> json) => MeetingParticipant(
    userId: json['userId'],
    name: json['name'],
    email: json['email'],
    role: ParticipantRole.values.firstWhere(
      (e) => e.toString().split('.').last == json['role'],
      orElse: () => ParticipantRole.participant,
    ),
    hasResponded: json['hasResponded'] ?? false,
    willAttend: json['willAttend'] ?? true,
    respondedAt: json['respondedAt'] != null 
        ? DateTime.parse(json['respondedAt'])
        : null,
  );

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'name': name,
    'email': email,
    'role': role.toString().split('.').last,
    'hasResponded': hasResponded,
    'willAttend': willAttend,
    'respondedAt': respondedAt?.toIso8601String(),
  };

  MeetingParticipant copyWith({
    String? userId,
    String? name,
    String? email,
    ParticipantRole? role,
    bool? hasResponded,
    bool? willAttend,
    DateTime? respondedAt,
  }) {
    return MeetingParticipant(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      hasResponded: hasResponded ?? this.hasResponded,
      willAttend: willAttend ?? this.willAttend,
      respondedAt: respondedAt ?? this.respondedAt,
    );
  }
}
