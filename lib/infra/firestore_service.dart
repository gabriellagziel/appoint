import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;
  final FirebaseFirestore _firestore;

  Future<DocumentSnapshot<Map<String, dynamic>>> getDoc(
    String collection,
    final String id,
  ) =>
      _firestore.collection(collection).doc(id).get();

  Future<void> setDoc(
    final String collection,
    final String id,
    Map<String, dynamic> data,
  ) =>
      _firestore.collection(collection).doc(id).set(data);
}
