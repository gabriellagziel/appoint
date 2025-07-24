import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:appoint/services/age_verification_service.dart';

class AgeVerificationResult {
  final int age;
  final bool isMinor;
  final bool requiresParentalConsent;
  final DateTime birthDate;

  const AgeVerificationResult({
    required this.age,
    required this.isMinor,
    required this.requiresParentalConsent,
    required this.birthDate,
  });
}

class AgeVerificationNotifier extends StateNotifier<AsyncValue<AgeVerificationResult?>> {
  AgeVerificationNotifier(this._ageVerificationService) : super(const AsyncValue.data(null));

  final AgeVerificationService _ageVerificationService;

  Future<AgeVerificationResult> verifyAge(DateTime birthDate) async {
    state = const AsyncValue.loading();

    try {
      final now = DateTime.now();
      final age = now.difference(birthDate).inDays ~/ 365;
      
      // COPPA compliance: users under 13 are considered minors
      final isMinor = age < 13;
      
      // Users under 18 require some form of parental awareness
      final requiresParentalConsent = age < 18;

      final result = AgeVerificationResult(
        age: age,
        isMinor: isMinor,
        requiresParentalConsent: requiresParentalConsent,
        birthDate: birthDate,
      );

      // Log the age verification attempt for audit purposes
      await _ageVerificationService.logAgeVerification(result);

      // Check against platform family controls if available
      await _ageVerificationService.validateAgainstPlatformControls(birthDate, age);

      state = AsyncValue.data(result);
      return result;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> reportFakeAge(String userId, DateTime reportedAge, DateTime actualAge) async {
    try {
      await _ageVerificationService.reportFakeAge(userId, reportedAge, actualAge);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void clearVerification() {
    state = const AsyncValue.data(null);
  }
}

final ageVerificationServiceProvider = Provider<AgeVerificationService>((ref) {
  return AgeVerificationService(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  );
});

final ageVerificationProvider = StateNotifierProvider<AgeVerificationNotifier, AsyncValue<AgeVerificationResult?>>((ref) {
  final service = ref.watch(ageVerificationServiceProvider);
  return AgeVerificationNotifier(service);
});

// Provider for checking if current user is a minor
final isMinorProvider = FutureProvider<bool>((ref) async {
  final auth = FirebaseAuth.instance;
  final user = auth.currentUser;
  
  if (user == null) return false;
  
  final doc = await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .get();
  
  if (!doc.exists) return false;
  
  final data = doc.data()!;
  final birthDate = (data['birthDate'] as Timestamp?)?.toDate();
  
  if (birthDate == null) return false;
  
  final age = DateTime.now().difference(birthDate).inDays ~/ 365;
  return age < 13;
});

// Provider for getting user's age
final userAgeProvider = FutureProvider<int?>((ref) async {
  final auth = FirebaseAuth.instance;
  final user = auth.currentUser;
  
  if (user == null) return null;
  
  final doc = await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .get();
  
  if (!doc.exists) return null;
  
  final data = doc.data()!;
  final birthDate = (data['birthDate'] as Timestamp?)?.toDate();
  
  if (birthDate == null) return null;
  
  return DateTime.now().difference(birthDate).inDays ~/ 365;
});