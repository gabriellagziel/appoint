class PlaytimeGame {
  final String id;
  final String name;
  final String description;
  final String icon;
  final String category; // educational, creative, physical, social
  final Map<String, int> ageRange; // min, max
  final String type; // virtual, live, both
  final int maxParticipants;
  final int estimatedDuration; // minutes
  final bool isSystemGame;
  final bool isPublic;
  final String creatorId;
  final bool parentApprovalRequired;
  final String safetyLevel; // safe, moderate, supervised
  final int usageCount;
  final double averageRating;
  final int totalRatings;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  PlaytimeGame({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.category,
    required this.ageRange,
    required this.type,
    required this.maxParticipants,
    required this.estimatedDuration,
    required this.isSystemGame,
    required this.isPublic,
    required this.creatorId,
    required this.parentApprovalRequired,
    required this.safetyLevel,
    this.usageCount = 0,
    this.averageRating = 0.0,
    this.totalRatings = 0,
    this.tags = const [],
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
  });

  factory PlaytimeGame.fromJson(Map<String, dynamic> json) => PlaytimeGame(
    id: json['gameId'] ?? json['id'],
    name: json['name'],
    description: json['description'],
    icon: json['icon'],
    category: json['category'],
    ageRange: Map<String, int>.from(json['ageRange'] ?? {}),
    type: json['type'],
    maxParticipants: json['maxParticipants'],
    estimatedDuration: json['estimatedDuration'],
    isSystemGame: json['isSystemGame'] ?? false,
    isPublic: json['isPublic'] ?? true,
    creatorId: json['creatorId'],
    parentApprovalRequired: json['parentApprovalRequired'] ?? false,
    safetyLevel: json['safetyLevel'] ?? 'safe',
    usageCount: json['usageCount'] ?? 0,
    averageRating: (json['averageRating'] ?? 0.0).toDouble(),
    totalRatings: json['totalRatings'] ?? 0,
    tags: List<String>.from(json['tags'] ?? []),
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
    isActive: json['isActive'] ?? true,
  );

  Map<String, dynamic> toJson() => {
    'gameId': id,
    'name': name,
    'description': description,
    'icon': icon,
    'category': category,
    'ageRange': ageRange,
    'type': type,
    'maxParticipants': maxParticipants,
    'estimatedDuration': estimatedDuration,
    'isSystemGame': isSystemGame,
    'isPublic': isPublic,
    'creatorId': creatorId,
    'parentApprovalRequired': parentApprovalRequired,
    'safetyLevel': safetyLevel,
    'usageCount': usageCount,
    'averageRating': averageRating,
    'totalRatings': totalRatings,
    'tags': tags,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'isActive': isActive,
  };

  PlaytimeGame copyWith({
    String? id,
    String? name,
    String? description,
    String? icon,
    String? category,
    Map<String, int>? ageRange,
    String? type,
    int? maxParticipants,
    int? estimatedDuration,
    bool? isSystemGame,
    bool? isPublic,
    String? creatorId,
    bool? parentApprovalRequired,
    String? safetyLevel,
    int? usageCount,
    double? averageRating,
    int? totalRatings,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return PlaytimeGame(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      category: category ?? this.category,
      ageRange: ageRange ?? this.ageRange,
      type: type ?? this.type,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      isSystemGame: isSystemGame ?? this.isSystemGame,
      isPublic: isPublic ?? this.isPublic,
      creatorId: creatorId ?? this.creatorId,
      parentApprovalRequired: parentApprovalRequired ?? this.parentApprovalRequired,
      safetyLevel: safetyLevel ?? this.safetyLevel,
      usageCount: usageCount ?? this.usageCount,
      averageRating: averageRating ?? this.averageRating,
      totalRatings: totalRatings ?? this.totalRatings,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  bool get isVirtual => type == 'virtual' || type == 'both';
  bool get isLive => type == 'live' || type == 'both';
  int get minAge => ageRange['min'] ?? 0;
  int get maxAge => ageRange['max'] ?? 18;
}
