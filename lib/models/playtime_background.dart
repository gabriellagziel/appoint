class PlaytimeBackground {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String thumbnailUrl;
  final String uploadedBy;
  final String uploadedByDisplayName;
  final String category; // outdoor, indoor, educational, creative
  final List<String> tags;
  final String status; // pending_approval, approved, declined, disabled
  final PlaytimeApprovalStatus approvalStatus;
  final int usageCount;
  final bool isSystemBackground;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int fileSize;
  final Map<String, int> dimensions; // width, height
  final String safetyLevel; // safe, moderate, supervised
  final Map<String, int> ageAppropriate; // minAge, maxAge

  PlaytimeBackground({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.thumbnailUrl,
    required this.uploadedBy,
    required this.uploadedByDisplayName,
    required this.category,
    this.tags = const [],
    this.status = 'pending_approval',
    required this.approvalStatus,
    this.usageCount = 0,
    this.isSystemBackground = false,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    this.fileSize = 0,
    this.dimensions = const {},
    this.safetyLevel = 'safe',
    this.ageAppropriate = const {},
  });

  factory PlaytimeBackground.fromJson(Map<String, dynamic> json) => PlaytimeBackground(
    id: json['backgroundId'] ?? json['id'],
    name: json['name'],
    description: json['description'],
    imageUrl: json['imageUrl'],
    thumbnailUrl: json['thumbnailUrl'],
    uploadedBy: json['uploadedBy'],
    uploadedByDisplayName: json['uploadedByDisplayName'],
    category: json['category'],
    tags: List<String>.from(json['tags'] ?? []),
    status: json['status'] ?? 'pending_approval',
    approvalStatus: PlaytimeApprovalStatus.fromJson(
        json['approvalStatus'] ?? {}),
    usageCount: json['usageCount'] ?? 0,
    isSystemBackground: json['isSystemBackground'] ?? false,
    isActive: json['isActive'] ?? true,
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
    fileSize: json['fileSize'] ?? 0,
    dimensions: Map<String, int>.from(json['dimensions'] ?? {}),
    safetyLevel: json['safetyLevel'] ?? 'safe',
    ageAppropriate: Map<String, int>.from(json['ageAppropriate'] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    'backgroundId': id,
    'name': name,
    'description': description,
    'imageUrl': imageUrl,
    'thumbnailUrl': thumbnailUrl,
    'uploadedBy': uploadedBy,
    'uploadedByDisplayName': uploadedByDisplayName,
    'category': category,
    'tags': tags,
    'status': status,
    'approvalStatus': approvalStatus.toJson(),
    'usageCount': usageCount,
    'isSystemBackground': isSystemBackground,
    'isActive': isActive,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'fileSize': fileSize,
    'dimensions': dimensions,
    'safetyLevel': safetyLevel,
    'ageAppropriate': ageAppropriate,
  };

  PlaytimeBackground copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    String? thumbnailUrl,
    String? uploadedBy,
    String? uploadedByDisplayName,
    String? category,
    List<String>? tags,
    String? status,
    PlaytimeApprovalStatus? approvalStatus,
    int? usageCount,
    bool? isSystemBackground,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? fileSize,
    Map<String, int>? dimensions,
    String? safetyLevel,
    Map<String, int>? ageAppropriate,
  }) {
    return PlaytimeBackground(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      uploadedBy: uploadedBy ?? this.uploadedBy,
      uploadedByDisplayName: uploadedByDisplayName ?? this.uploadedByDisplayName,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      status: status ?? this.status,
      approvalStatus: approvalStatus ?? this.approvalStatus,
      usageCount: usageCount ?? this.usageCount,
      isSystemBackground: isSystemBackground ?? this.isSystemBackground,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      fileSize: fileSize ?? this.fileSize,
      dimensions: dimensions ?? this.dimensions,
      safetyLevel: safetyLevel ?? this.safetyLevel,
      ageAppropriate: ageAppropriate ?? this.ageAppropriate,
    );
  }

  bool get isPendingApproval => status == 'pending_approval';
  bool get isApproved => status == 'approved';
  bool get isDeclined => status == 'declined';
  bool get isDisabled => status == 'disabled';
  bool get isAvailable => isApproved && isActive;
  bool get isUserUploaded => !isSystemBackground;
  int get width => dimensions['width'] ?? 0;
  int get height => dimensions['height'] ?? 0;
  int get minAge => ageAppropriate['minAge'] ?? 0;
  int get maxAge => ageAppropriate['maxAge'] ?? 18;
  bool get isSafe => safetyLevel == 'safe';
  bool get isModerate => safetyLevel == 'moderate';
  bool get isSupervised => safetyLevel == 'supervised';
}

class PlaytimeApprovalStatus {
  final String? reviewedBy;
  final DateTime? reviewedAt;
  final String? reason;

  PlaytimeApprovalStatus({
    this.reviewedBy,
    this.reviewedAt,
    this.reason,
  });

  factory PlaytimeApprovalStatus.fromJson(Map<String, dynamic> json) => PlaytimeApprovalStatus(
    reviewedBy: json['reviewedBy'],
    reviewedAt: json['reviewedAt'] != null 
        ? (json['reviewedAt'] is DateTime 
            ? json['reviewedAt'] 
            : DateTime.parse(json['reviewedAt']))
        : null,
    reason: json['reason'],
  );

  Map<String, dynamic> toJson() => {
    'reviewedBy': reviewedBy,
    'reviewedAt': reviewedAt?.toIso8601String(),
    'reason': reason,
  };

  bool get isReviewed => reviewedBy != null;
  bool get isApproved => isReviewed && reason == null;
  bool get isDeclined => isReviewed && reason != null;
}
