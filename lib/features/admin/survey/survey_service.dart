import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SurveyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Fetch surveys from Firestore
  Stream<List<Map<String, dynamic>>> fetchSurveys() => _firestore
      .collection('surveys')
      .where('status', isEqualTo: 'active')
      .snapshots()
      .map(
        (snapshot) =>
            snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList(),
      );

  // Submit survey response
  Future<void> submitResponse(
    String surveyId,
    final Map<String, dynamic> response,
  ) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    await _firestore
        .collection('surveys')
        .doc(surveyId)
        .collection('responses')
        .doc(user.uid)
        .set({
      'userId': user.uid,
      'userEmail': user.email,
      'response': response,
      'submittedAt': FieldValue.serverTimestamp(),
    });

    // Trigger rewards logic
    await _grantReward(user.uid, surveyId);
  }

  // Create new survey
  Future<String> createSurvey(Map<String, dynamic> surveyData) async {
    final docRef = await _firestore.collection('surveys').add({
      ...surveyData,
      'createdAt': FieldValue.serverTimestamp(),
      'status': 'active',
    });
    return docRef.id;
  }

  // Update survey
  Future<void> updateSurvey(
    String surveyId,
    final Map<String, dynamic> updates,
  ) async {
    await _firestore.collection('surveys').doc(surveyId).update({
      ...updates,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Delete survey
  Future<void> deleteSurvey(String surveyId) async {
    await _firestore.collection('surveys').doc(surveyId).delete();
  }

  // Grant reward for survey completion
  Future<void> _grantReward(String userId, final String surveyId) async {
    // Get survey details to determine reward
    final surveyDoc =
        await _firestore.collection('surveys').doc(surveyId).get();
    final surveyData = surveyDoc.data();

    if (surveyData != null && surveyData['rewardPoints'] != null) {
      final points = surveyData['rewardPoints'] as int;

      // Update user's reward points
      await _firestore.collection('users').doc(userId).update({
        'rewardPoints': FieldValue.increment(points),
        'lastSurveyCompleted': surveyId,
        'lastSurveyCompletedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // Get survey responses for admin
  Stream<List<Map<String, dynamic>>> getSurveyResponses(String surveyId) =>
      _firestore
          .collection('surveys')
          .doc(surveyId)
          .collection('responses')
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .map((doc) => {'id': doc.id, ...doc.data()})
                .toList(),
          );
}
