import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService({final FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<DocumentSnapshot<Map<String, dynamic>>> getDoc(
      final String collection, final String id) {
    return _firestore.collection(collection).doc(id).get();
  }

  Future<void> setDoc(
      final String collection, final String id, final Map<String, dynamic> data) {
    return _firestore.collection(collection).doc(id).set(data);
  }
}
