/// Custom exceptions for Playtime system age restrictions
library playtime_exceptions;

/// Base exception for all Playtime-related errors
abstract class PlaytimeException implements Exception {
  final String message;
  final String? code;
  final Map<String, dynamic>? details;

  const PlaytimeException(this.message, {this.code, this.details});

  @override
  String toString() => 'PlaytimeException: $message';
}

/// Thrown when a user is too young or too old for a specific game
class AgeRestrictedError extends PlaytimeException {
  final int userAge;
  final int? minAge;
  final int? maxAge;
  final String gameId;
  final String gameName;

  const AgeRestrictedError({
    required this.userAge,
    required this.gameId,
    required this.gameName,
    this.minAge,
    this.maxAge,
  }) : super(
          'User age $userAge is outside the allowed range for "$gameName"',
          code: 'AGE_RESTRICTED',
          details: const {
            'userAge': null, // Will be set in constructor
            'minAge': null,  // Will be set in constructor
            'maxAge': null,  // Will be set in constructor
            'gameId': null,  // Will be set in constructor
            'gameName': null, // Will be set in constructor
          },
        );

  /// Returns true if user is too young
  bool get isTooYoung => minAge != null && userAge < minAge!;

  /// Returns true if user is too old
  bool get isTooOld => maxAge != null && userAge > maxAge!;

  /// Gets formatted age range string
  String get ageRangeString {
    if (minAge != null && maxAge != null) {
      return '$minAge-$maxAge years';
    } else if (minAge != null) {
      return '$minAge+ years';
    } else if (maxAge != null) {
      return 'Under $maxAge years';
    }
    return 'Age restricted';
  }

  @override
  String toString() => 'AgeRestrictedError: $message (Range: $ageRangeString)';
}

/// Thrown when a child user attempts to create a session without parent approval
class ParentApprovalRequiredError extends PlaytimeException {
  final String userId;
  final String gameId;
  final String gameName;
  final bool isChildUser;

  const ParentApprovalRequiredError({
    required this.userId,
    required this.gameId,
    required this.gameName,
    required this.isChildUser,
  }) : super(
          'Parent approval required for child user to access "$gameName"',
          code: 'PARENT_APPROVAL_REQUIRED',
          details: {
            'userId': userId,
            'gameId': gameId,
            'gameName': gameName,
            'isChildUser': isChildUser,
          },
        );

  @override
  String toString() => 'ParentApprovalRequiredError: $message';
}

/// Thrown when a session cannot be created due to safety restrictions
class SafetyRestrictedError extends PlaytimeException {
  final String userId;
  final String gameId;
  final String safetyLevel;
  final String reason;

  const SafetyRestrictedError({
    required this.userId,
    required this.gameId,
    required this.safetyLevel,
    required this.reason,
  }) : super(
          'Session creation blocked due to safety restrictions: $reason',
          code: 'SAFETY_RESTRICTED',
          details: {
            'userId': userId,
            'gameId': gameId,
            'safetyLevel': safetyLevel,
            'reason': reason,
          },
        );

  @override
  String toString() => 'SafetyRestrictedError: $message';
}

/// Thrown when user data is missing required fields for age validation
class UserDataIncompleteError extends PlaytimeException {
  final String userId;
  final List<String> missingFields;

  const UserDataIncompleteError({
    required this.userId,
    required this.missingFields,
  }) : super(
          'User data incomplete. Missing: ${missingFields.join(', ')}',
          code: 'USER_DATA_INCOMPLETE',
          details: {
            'userId': userId,
            'missingFields': missingFields,
          },
        );

  @override
  String toString() => 'UserDataIncompleteError: $message';
}

/// Thrown when a game is not found or not accessible
class GameNotFoundError extends PlaytimeException {
  final String gameId;

  const GameNotFoundError({
    required this.gameId,
  }) : super(
          'Game not found or not accessible: $gameId',
          code: 'GAME_NOT_FOUND',
          details: {
            'gameId': gameId,
          },
        );

  @override
  String toString() => 'GameNotFoundError: $message';
}

/// Thrown when maximum participants limit is reached
class MaxParticipantsReachedError extends PlaytimeException {
  final String sessionId;
  final int maxParticipants;
  final int currentParticipants;

  const MaxParticipantsReachedError({
    required this.sessionId,
    required this.maxParticipants,
    required this.currentParticipants,
  }) : super(
          'Maximum participants ($maxParticipants) reached for session',
          code: 'MAX_PARTICIPANTS_REACHED',
          details: {
            'sessionId': sessionId,
            'maxParticipants': maxParticipants,
            'currentParticipants': currentParticipants,
          },
        );

  @override
  String toString() => 'MaxParticipantsReachedError: $message';
}

