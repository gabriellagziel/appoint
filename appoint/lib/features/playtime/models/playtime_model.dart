import 'package:flutter/material.dart';

enum PlaytimeType {
  physical,
  virtual,
}

enum PlaytimePlatform {
  discord,
  psn,
  xbox,
  pc,
  mobile,
  other,
}

class PlaytimeConfig {
  final PlaytimeType type;
  final PlaytimePlatform? platform;
  final String? roomCode;
  final String? serverCode;
  final String? game;
  final String? location;
  final int? maxPlayers;
  final bool isCompetitive;
  final bool isFamilyFriendly;

  const PlaytimeConfig({
    required this.type,
    this.platform,
    this.roomCode,
    this.serverCode,
    this.game,
    this.location,
    this.maxPlayers,
    this.isCompetitive = false,
    this.isFamilyFriendly = true,
  });

  factory PlaytimeConfig.fromMap(Map<String, dynamic> data) {
    return PlaytimeConfig(
      type: PlaytimeType.values.firstWhere(
        (e) => e.name == data['type'],
        orElse: () => PlaytimeType.physical,
      ),
      platform: data['platform'] != null
          ? PlaytimePlatform.values.firstWhere(
              (e) => e.name == data['platform'],
              orElse: () => PlaytimePlatform.other,
            )
          : null,
      roomCode: data['roomCode'],
      serverCode: data['serverCode'],
      game: data['game'],
      location: data['location'],
      maxPlayers: data['maxPlayers'],
      isCompetitive: data['isCompetitive'] ?? false,
      isFamilyFriendly: data['isFamilyFriendly'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'platform': platform?.name,
      'roomCode': roomCode,
      'serverCode': serverCode,
      'game': game,
      'location': location,
      'maxPlayers': maxPlayers,
      'isCompetitive': isCompetitive,
      'isFamilyFriendly': isFamilyFriendly,
    };
  }

  PlaytimeConfig copyWith({
    PlaytimeType? type,
    PlaytimePlatform? platform,
    String? roomCode,
    String? serverCode,
    String? game,
    String? location,
    int? maxPlayers,
    bool? isCompetitive,
    bool? isFamilyFriendly,
  }) {
    return PlaytimeConfig(
      type: type ?? this.type,
      platform: platform ?? this.platform,
      roomCode: roomCode ?? this.roomCode,
      serverCode: serverCode ?? this.serverCode,
      game: game ?? this.game,
      location: location ?? this.location,
      maxPlayers: maxPlayers ?? this.maxPlayers,
      isCompetitive: isCompetitive ?? this.isCompetitive,
      isFamilyFriendly: isFamilyFriendly ?? this.isFamilyFriendly,
    );
  }

  bool get isPhysical => type == PlaytimeType.physical;
  bool get isVirtual => type == PlaytimeType.virtual;

  String get displayName {
    switch (type) {
      case PlaytimeType.physical:
        return 'Physical Playtime';
      case PlaytimeType.virtual:
        return 'Virtual Playtime';
    }
  }

  String get description {
    switch (type) {
      case PlaytimeType.physical:
        return 'In-person games and activities';
      case PlaytimeType.virtual:
        return 'Online games and virtual activities';
    }
  }

  IconData get icon {
    switch (type) {
      case PlaytimeType.physical:
        return Icons.sports_soccer;
      case PlaytimeType.virtual:
        return Icons.games;
    }
  }

  Color get color {
    switch (type) {
      case PlaytimeType.physical:
        return Colors.green;
      case PlaytimeType.virtual:
        return Colors.purple;
    }
  }

  String? get platformDisplayName {
    if (platform == null) return null;

    switch (platform!) {
      case PlaytimePlatform.discord:
        return 'Discord';
      case PlaytimePlatform.psn:
        return 'PlayStation Network';
      case PlaytimePlatform.xbox:
        return 'Xbox Live';
      case PlaytimePlatform.pc:
        return 'PC';
      case PlaytimePlatform.mobile:
        return 'Mobile';
      case PlaytimePlatform.other:
        return 'Other';
    }
  }

  bool get requiresLocation => isPhysical;
  bool get requiresPlatform => isVirtual;
  bool get requiresRoomCode => isVirtual && platform != null;
  bool get requiresServerCode =>
      isVirtual && platform == PlaytimePlatform.discord;

  bool get isValid {
    if (isPhysical) {
      return location != null && location!.isNotEmpty;
    } else {
      return platform != null;
    }
  }

  String? get validationError {
    if (isPhysical && (location == null || location!.isEmpty)) {
      return 'Location is required for physical playtime';
    }
    if (isVirtual && platform == null) {
      return 'Platform is required for virtual playtime';
    }
    return null;
  }
}

// Popular games for quick selection
class PopularGame {
  final String name;
  final String? icon;
  final PlaytimePlatform? platform;
  final bool isCompetitive;
  final bool isFamilyFriendly;

  const PopularGame({
    required this.name,
    this.icon,
    this.platform,
    this.isCompetitive = false,
    this.isFamilyFriendly = true,
  });
}

final popularGames = [
  // Physical games
  const PopularGame(name: 'Football', icon: '⚽', isFamilyFriendly: true),
  const PopularGame(name: 'Basketball', icon: '🏀', isFamilyFriendly: true),
  const PopularGame(name: 'Chess', icon: '♟️', isFamilyFriendly: true),
  const PopularGame(name: 'Board Games', icon: '🎲', isFamilyFriendly: true),
  const PopularGame(name: 'Swimming', icon: '🏊', isFamilyFriendly: true),
  const PopularGame(name: 'Tennis', icon: '🎾', isFamilyFriendly: true),

  // Virtual games
  const PopularGame(
    name: 'Minecraft',
    icon: '⛏️',
    platform: PlaytimePlatform.pc,
    isFamilyFriendly: true,
  ),
  const PopularGame(
    name: 'Fortnite',
    icon: '🏆',
    platform: PlaytimePlatform.pc,
    isCompetitive: true,
    isFamilyFriendly: true,
  ),
  const PopularGame(
    name: 'Among Us',
    icon: '👥',
    platform: PlaytimePlatform.mobile,
    isFamilyFriendly: true,
  ),
  const PopularGame(
    name: 'Call of Duty',
    icon: '🎯',
    platform: PlaytimePlatform.pc,
    isCompetitive: true,
    isFamilyFriendly: false,
  ),
  const PopularGame(
    name: 'Roblox',
    icon: '🧱',
    platform: PlaytimePlatform.pc,
    isFamilyFriendly: true,
  ),
  const PopularGame(
    name: 'FIFA',
    icon: '⚽',
    platform: PlaytimePlatform.psn,
    isCompetitive: true,
    isFamilyFriendly: true,
  ),
];



