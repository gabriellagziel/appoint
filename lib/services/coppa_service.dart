import 'package:cloud_firestore/cloud_firestore.dart';

/// Service for COPPA (Children's Online Privacy Protection Act) compliance
/// and age-based restrictions for playtime sessions
class COPPAService {
  static const int coppaAgeThreshold = 13;
  static const int adultAgeThreshold = 18;

  /// Check if a user is subject to COPPA regulations (under 13)
  static bool isSubjectToCOPPA(int age) {
    return age < coppaAgeThreshold;
  }

  /// Check if a user is a minor (under 18)
  static bool isMinor(int age) {
    return age < adultAgeThreshold;
  }

  /// Check if a user is an adult (18 or over)
  static bool isAdult(int age) {
    return age >= adultAgeThreshold;
  }

  /// Get age category for a user
  static String getAgeCategory(int age) {
    if (isSubjectToCOPPA(age)) {
      return 'child'; // Under 13
    } else if (isMinor(age)) {
      return 'teen'; // 13-17
    } else {
      return 'adult'; // 18+
    }
  }

  /// Check if a game is age-appropriate for a user
  static bool isGameAgeAppropriate(int userAge, int gameMinAge) {
    return userAge >= gameMinAge;
  }

  /// Check if parent approval is required for a playtime session
  static bool requiresParentApproval(int userAge, int gameMinAge) {
    // Always require parent approval for children under 13
    if (isSubjectToCOPPA(userAge)) {
      return true;
    }

    // Require parent approval for teens playing games above their age
    if (isMinor(userAge) && !isGameAgeAppropriate(userAge, gameMinAge)) {
      return true;
    }

    // Adults don't need parent approval
    return false;
  }

  /// Get user age from Firestore
  static Future<int?> getUserAge(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (doc.exists) {
        return doc.data()?['age'] as int?;
      }
      return null;
    } catch (e) {
      print('Error fetching user age: $e');
      return null;
    }
  }

  /// Get parent ID for a user
  static Future<String?> getParentId(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (doc.exists) {
        return doc.data()?['parentUid'] as String?;
      }
      return null;
    } catch (e) {
      print('Error fetching parent ID: $e');
      return null;
    }
  }

  /// Check if a user can create a playtime session without restrictions
  static Future<bool> canCreateSessionWithoutApproval(
      String userId, String gameId) async {
    try {
      // Get user age
      final userAge = await getUserAge(userId);
      if (userAge == null) return false;

      // Adults can always create sessions without approval
      if (isAdult(userAge)) return true;

      // Get game minimum age
      final gameDoc = await FirebaseFirestore.instance
          .collection('playtime_games')
          .doc(gameId)
          .get();

      if (!gameDoc.exists) return false;

      final gameMinAge = gameDoc.data()?['minAge'] as int? ?? 0;

      // Check if approval is required
      return !requiresParentApproval(userAge, gameMinAge);
    } catch (e) {
      print('Error checking session creation permissions: $e');
      return false;
    }
  }

  /// Validate a playtime session for COPPA compliance
  static Future<Map<String, dynamic>> validateSessionForCOPPA(
    String userId,
    String gameId,
  ) async {
    try {
      final userAge = await getUserAge(userId);
      if (userAge == null) {
        return {
          'valid': false,
          'reason': 'User age not found',
          'requiresParentApproval': false,
        };
      }

      final gameDoc = await FirebaseFirestore.instance
          .collection('playtime_games')
          .doc(gameId)
          .get();

      if (!gameDoc.exists) {
        return {
          'valid': false,
          'reason': 'Game not found',
          'requiresParentApproval': false,
        };
      }

      final gameMinAge = gameDoc.data()?['minAge'] as int? ?? 0;
      final isAgeAppropriate = isGameAgeAppropriate(userAge, gameMinAge);
      final needsApproval = requiresParentApproval(userAge, gameMinAge);

      return {
        'valid': true,
        'userAge': userAge,
        'gameMinAge': gameMinAge,
        'isAgeAppropriate': isAgeAppropriate,
        'requiresParentApproval': needsApproval,
        'ageCategory': getAgeCategory(userAge),
      };
    } catch (e) {
      return {
        'valid': false,
        'reason': 'Validation error: $e',
        'requiresParentApproval': false,
      };
    }
  }
}
