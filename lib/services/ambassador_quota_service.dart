import 'package:cloud_firestore/cloud_firestore.dart';

/// Service for managing ambassador quotas and automatic assignment
/// Supports 50 countries and languages with hard-capped quotas
class AmbassadorQuotaService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Variable declarations for the service
  late int quota;
  late bool isEligible;
  late bool hasSlots;
  late DocumentSnapshot<Map<String, dynamic>> userDoc;
  late Map<String, dynamic>? userData;
  late DocumentReference<Map<String, dynamic>> userRef;
  late DocumentReference<Map<String, dynamic>> ambassadorRef;
  late DocumentReference<Map<String, dynamic>> logRef;
  late Map<String, dynamic>? ambassadorData;
  late MapEntry<String, int> entry;
  late List<String> parts;
  late int currentCount;

  /// Complete ambassador quotas for all 50 countries and languages
  /// Total global slots: 6,675 ambassadors
  static const Map<String, int> ambassadorQuotas = {
    // Europe
    'PL_pl': 95, // Poland - Polish
    'FR_fr': 142, // France - French
    'DE_de': 133, // Germany - German
    'ES_es': 220, // Spain - Spanish
    'IT_it': 144, // Italy - Italian
    'RU_ru': 111, // Russia - Russian
    'UA_uk': 70, // Ukraine - Ukrainian
    'RO_ro': 72, // Romania - Romanian
    'GR_el': 66, // Greece - Greek
    'NL_nl': 61, // Netherlands - Dutch
    'CZ_cs': 59, // Czech Republic - Czech
    'HU_hu': 57, // Hungary - Hungarian
    'BG_bg': 52, // Bulgaria - Bulgarian
    'HR_hr': 50, // Croatia - Croatian
    'SK_sk': 48, // Slovakia - Slovak
    'LV_lv': 42, // Latvia - Latvian
    'LT_lt': 41, // Lithuania - Lithuanian
    'RS_sr': 40, // Serbia - Serbian
    'FI_fi': 49, // Finland - Finnish
    'SE_sv': 67, // Sweden - Swedish
    'NO_no': 44, // Norway - Norwegian
    'DK_da': 43, // Denmark - Danish
    'SI_sl': 39, // Slovenia - Slovenian

    // North America
    'US_en': 345, // United States - English
    'CA_en': 54, // Canada - English
    'CA_fr': 46, // Canada - French
    'MX_es': 173, // Mexico - Spanish

    // Asia
    'JP_ja': 116, // Japan - Japanese
    'KR_ko': 98, // South Korea - Korean
    'CN_zh': 400, // China - Chinese
    'IN_hi': 200, // India - Hindi
    'IN_ta': 84, // India - Tamil
    'IN_gu': 63, // India - Gujarati
    'PH_tl': 103, // Philippines - Tagalog
    'PK_ur': 125, // Pakistan - Urdu
    'BD_bn': 122, // Bangladesh - Bengali
    'VN_vi': 106, // Vietnam - Vietnamese
    'TR_tr': 101, // Turkey - Turkish
    'IR_fa': 77, // Iran - Persian
    'TH_th': 64, // Thailand - Thai
    'ID_id': 88, // Indonesia - Indonesian
    'MY_ms': 60, // Malaysia - Malay
    'LK_si': 39, // Sri Lanka - Sinhala
    'NP_ne': 38, // Nepal - Nepali

    // South America
    'BR_pt': 215, // Brazil - Portuguese

    // Africa
    'NG_en': 135, // Nigeria - English
    'NG_ha': 45, // Nigeria - Hausa
    'ET_am': 56, // Ethiopia - Amharic
    'KE_sw': 53, // Kenya - Swahili
    'ZA_zu': 36, // South Africa - Zulu
  };

  /// Get the quota for a specific country-language combination
  int getQuota(String countryCode, final String languageCode) {
    final key = '${countryCode}_$languageCode';
    return ambassadorQuotas[key] ?? 0;
  }

  /// Get current ambassador count for a country-language combination
  Future<int> getCurrentAmbassadorCount(
    String countryCode,
    final String languageCode,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('ambassadors')
          .where('countryCode', isEqualTo: countryCode)
          .where('languageCode', isEqualTo: languageCode)
          .where('status', isEqualTo: 'active')
          .count()
          .get();

      return snapshot.count ?? 0;
    } catch (e) {
      // Removed debug print: debugPrint('Error getting ambassador count: $e');
      return 0;
    }
  }

  /// Check if there are available slots for a country-language combination
  Future<bool> hasAvailableSlots(
    String countryCode,
    final String languageCode,
  ) async {
    final quota = getQuota(countryCode, languageCode);
    if (quota == 0) return false;

    final currentCount =
        await getCurrentAmbassadorCount(countryCode, languageCode);
    return currentCount < quota;
  }

  /// Get available slots count for a country-language combination
  Future<int> getAvailableSlots(
    String countryCode,
    final String languageCode,
  ) async {
    final quota = getQuota(countryCode, languageCode);
    if (quota == 0) return 0;

    final currentCount =
        await getCurrentAmbassadorCount(countryCode, languageCode);
    return (quota - currentCount).clamp(0, quota);
  }

  /// Check if a user is eligible to become an ambassador
  Future<bool> isUserEligible(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) return false;

      final userData = userDoc.data();
      if (userData == null) return false;

      // Check if user is an adult
      final isAdult = userData['isAdult'] == true;
      if (!isAdult) return false;

      // Check if user is not already an ambassador
      final currentRole = userData['role'] as String?;
      if (currentRole == 'ambassador') return false;

      return true;
    } catch (e) {
      // Removed debug print: debugPrint('Error checking user eligibility: $e');
      return false;
    }
  }

  /// Automatically assign ambassador role to eligible user
  /// Returns true if assignment was successful, false otherwise
  Future<bool> assignAmbassador({
    required final String userId,
    required final String countryCode,
    required final String languageCode,
  }) async {
    try {
      // Check if user is eligible
      final isEligible = await isUserEligible(userId);
      if (!isEligible) {
        // Removed debug print: debugPrint('User $userId is not eligible for ambassadorship');
        return false;
      }

      // Check if there are available slots
      final hasSlots = await hasAvailableSlots(countryCode, languageCode);
      if (!hasSlots) {
        // Removed debug print: debugPrint('No available ambassador slots for ${countryCode}_$languageCode');
        return false;
      }

      // Use a transaction to ensure atomicity
      await _firestore.runTransaction((transaction) async {
        // Double-check availability within transaction
        final currentCount =
            await getCurrentAmbassadorCount(countryCode, languageCode);
        final quota = getQuota(countryCode, languageCode);

        if (currentCount >= quota) {
          throw Exception('Quota exceeded during transaction');
        }

        // Update user role
        final userRef = _firestore.collection('users').doc(userId);
        transaction.update(userRef, {
          'role': 'ambassador',
          'ambassadorSince': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        // Create ambassador record
        final ambassadorRef = _firestore.collection('ambassadors').doc(userId);
        transaction.set(ambassadorRef, {
          'userId': userId,
          'countryCode': countryCode,
          'languageCode': languageCode,
          'status': 'active',
          'assignedAt': FieldValue.serverTimestamp(),
          'createdAt': FieldValue.serverTimestamp(),
          'referrals': 0,
          'totalEarnings': 0,
        });

        // Log the assignment
        final logRef = _firestore.collection('ambassador_assignments').doc();
        transaction.set(logRef, {
          'userId': userId,
          'countryCode': countryCode,
          'languageCode': languageCode,
          'assignedAt': FieldValue.serverTimestamp(),
          'quotaBefore': currentCount,
          'quotaAfter': currentCount + 1,
          'totalQuota': quota,
        });
      });

      // Removed debug print: debugPrint(
      //   'Successfully assigned ambassador role to user $userId for ${countryCode}_$languageCode'
      // );
      return true;
    } catch (e) {
      // Removed debug print: debugPrint('Error assigning ambassador: $e');
      return false;
    }
  }

  /// Remove ambassador role and free up slot
  Future<bool> removeAmbassador(String userId) async {
    try {
      // Get ambassador data first
      final ambassadorDoc =
          await _firestore.collection('ambassadors').doc(userId).get();
      if (!ambassadorDoc.exists) return false;

      final ambassadorData = ambassadorDoc.data();
      if (ambassadorData == null) return false;

      final countryCode = ambassadorData['countryCode'] as String?;
      final languageCode = ambassadorData['languageCode'] as String?;

      if (countryCode == null || languageCode == null) return false;

      await _firestore.runTransaction((transaction) async {
        // Update user role
        final userRef = _firestore.collection('users').doc(userId);
        transaction.update(userRef, {
          'role': 'client',
          'ambassadorRemovedAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        // Update ambassador status
        final ambassadorRef = _firestore.collection('ambassadors').doc(userId);
        transaction.update(ambassadorRef, {
          'status': 'inactive',
          'removedAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        // Log the removal
        final logRef = _firestore.collection('ambassador_removals').doc();
        transaction.set(logRef, {
          'userId': userId,
          'countryCode': countryCode,
          'languageCode': languageCode,
          'removedAt': FieldValue.serverTimestamp(),
          'reason': 'manual_removal',
        });
      });

      // Removed debug print: debugPrint('Successfully removed ambassador role from user $userId');
      return true;
    } catch (e) {
      // Removed debug print: debugPrint('Error removing ambassador: $e');
      return false;
    }
  }

  /// Get quota statistics for all countries and languages
  Future<Map<String, dynamic>> getQuotaStatistics() async {
    final stats = <String, Map<String, dynamic>>{};

    for (entry in ambassadorQuotas.entries) {
      final key = entry.key;
      final quota = entry.value;
      final parts = key.split('_');
      final countryCode = parts[0];
      final languageCode = parts[1];

      final currentCount =
          await getCurrentAmbassadorCount(countryCode, languageCode);
      final availableSlots = quota - currentCount;

      stats[key] = {
        'countryCode': countryCode,
        'languageCode': languageCode,
        'quota': quota,
        'currentCount': currentCount,
        'availableSlots': availableSlots,
        'utilizationPercentage': (currentCount / quota * 100).roundToDouble(),
      };
    }

    return stats;
  }

  /// Get total global statistics
  Future<Map<String, dynamic>> getGlobalStatistics() async {
    final totalQuota = ambassadorQuotas.values
        .fold<int>(0, (total, final quota) => total + quota);
    var totalCurrent = 0;

    for (entry in ambassadorQuotas.entries) {
      final parts = entry.key.split('_');
      final currentCount = await getCurrentAmbassadorCount(parts[0], parts[1]);
      totalCurrent += currentCount;
    }

    return {
      'totalQuota': totalQuota,
      'totalCurrent': totalCurrent,
      'totalAvailable': totalQuota - totalCurrent,
      'globalUtilizationPercentage':
          (totalCurrent / totalQuota * 100).roundToDouble(),
    };
  }

  /// Find next eligible user for ambassadorship in a specific country-language
  Future<String?> findNextEligibleUser(
    String countryCode,
    final String languageCode,
  ) async {
    try {
      // Query for eligible users in the specified country
      final usersSnapshot = await _firestore
          .collection('users')
          .where('countryCode', isEqualTo: countryCode)
          .where('isAdult', isEqualTo: true)
          .where('role', isNotEqualTo: 'ambassador')
          .orderBy('role')
          .orderBy('createdAt', descending: false) // First come, first served
          .limit(1)
          .get();

      if (usersSnapshot.docs.isEmpty) return null;

      return usersSnapshot.docs.first.id;
    } catch (e) {
      // Removed debug print: debugPrint('Error finding eligible user: $e');
      return null;
    }
  }

  /// Auto-assign ambassadors for all available slots
  /// This can be called by a scheduled Cloud Function
  Future<int> autoAssignAvailableSlots() async {
    var assignedCount = 0;

    for (entry in ambassadorQuotas.entries) {
      final key = entry.key;
      final parts = key.split('_');
      final countryCode = parts[0];
      final languageCode = parts[1];

      // Check if there are available slots
      final hasSlots = await hasAvailableSlots(countryCode, languageCode);
      if (!hasSlots) continue;

      // Find eligible user
      final eligibleUserId =
          await findNextEligibleUser(countryCode, languageCode);
      if (eligibleUserId == null) continue;

      // Assign ambassador role
      final success = await assignAmbassador(
        userId: eligibleUserId,
        countryCode: countryCode,
        languageCode: languageCode,
      );

      if (success) {
        assignedCount++;
      }
    }

    return assignedCount;
  }
}
