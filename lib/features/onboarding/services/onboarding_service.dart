import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingService {
  OnboardingService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  /// Check if user has completed onboarding
  Future<bool> hasCompletedOnboarding() async {
    final user = _auth.currentUser;
    if (user == null) return false;

    // Check Firestore
    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    if (userDoc.exists) {
      final data = userDoc.data()!;
      return data['onboardingCompleted'] == true;
    }

    // Check local storage as fallback
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboarding_completed') ?? false;
  }

  /// Complete onboarding
  Future<void> completeOnboarding(Map<String, dynamic> onboardingData) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    // Save to Firestore
    await _firestore.collection('users').doc(user.uid).update({
      'onboardingCompleted': true,
      'onboardingData': onboardingData,
      'userType': onboardingData['userType']?.toString(),
      'language': onboardingData['language'],
      'name': onboardingData['name'],
      'email': onboardingData['email'],
      'phone': onboardingData['phone'],
      'interests': onboardingData['interests'],
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // Save to local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    await prefs.setString('user_type', onboardingData['userType']?.toString() ?? '');
    await prefs.setString('language', onboardingData['language'] as String? ?? 'en');
  }

  /// Get onboarding data
  Future<Map<String, dynamic>?> getOnboardingData() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    if (!userDoc.exists) return null;

    final data = userDoc.data()!;
    return data['onboardingData'] as Map<String, dynamic>?;
  }

  /// Reset onboarding (for testing or re-onboarding)
  Future<void> resetOnboarding() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    // Clear from Firestore
    await _firestore.collection('users').doc(user.uid).update({
      'onboardingCompleted': false,
      'onboardingData': null,
    });

    // Clear from local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('onboarding_completed');
    await prefs.remove('user_type');
    await prefs.remove('language');
  }

  /// Get user type
  Future<String?> getUserType() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    if (!userDoc.exists) return null;

    final data = userDoc.data()!;
    return data['userType'] as String?;
  }

  /// Get user language preference
  Future<String> getUserLanguage() async {
    final user = _auth.currentUser;
    if (user == null) return 'en';

    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    if (!userDoc.exists) return 'en';

    final data = userDoc.data()!;
    return data['language'] as String? ?? 'en';
  }

  /// Update user preferences
  Future<void> updateUserPreferences(Map<String, dynamic> preferences) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    await _firestore.collection('users').doc(user.uid).update({
      ...preferences,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Get onboarding analytics
  Future<Map<String, dynamic>> getOnboardingAnalytics() async {
    final snapshot = await _firestore.collection('users').get();
    final users = snapshot.docs;
    
    int totalUsers = users.length;
    int completedOnboarding = 0;
    Map<String, int> userTypeCounts = {};
    Map<String, int> languageCounts = {};

    for (final user in users) {
      final data = user.data();
      if (data['onboardingCompleted'] == true) {
        completedOnboarding++;
      }

      final userType = data['userType'] as String?;
      if (userType != null) {
        userTypeCounts[userType] = (userTypeCounts[userType] ?? 0) + 1;
      }

      final language = data['language'] as String?;
      if (language != null) {
        languageCounts[language] = (languageCounts[language] ?? 0) + 1;
      }
    }

    return {
      'totalUsers': totalUsers,
      'completedOnboarding': completedOnboarding,
      'completionRate': totalUsers > 0 ? (completedOnboarding / totalUsers) * 100 : 0,
      'userTypeDistribution': userTypeCounts,
      'languageDistribution': languageCounts,
    };
  }
} 