import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static void initialize() {
    // Set global Firestore settings
    _firestore.settings = const Settings(
      persistenceEnabled: true,
      host: 'firestore.googleapis.com',
      sslEnabled: true,
    );
  }

  // Generic method to get collection with error handling
  static Stream<QuerySnapshot> getCollectionStream(
      String collectionPath) {
    try {
      return _firestore.collection(collectionPath).snapshots();
    } catch (e) {
      // Removed debug print: debugPrint('🚨 Firestore collection stream error: $e');
      rethrow;
    }
  }

  // Generic method to get document with error handling
  static Future<DocumentSnapshot> getDocument(
      String collectionPath, final String documentId,) async {
    try {
      return await _firestore.collection(collectionPath).doc(documentId).get();
    } catch (e) {
      // Removed debug print: debugPrint('🚨 Firestore document get error: $e');
      rethrow;
    }
  }

  // Generic method to get document stream with error handling
  static Stream<DocumentSnapshot> getDocumentStream(
      String collectionPath, final String documentId,) {
    try {
      return _firestore.collection(collectionPath).doc(documentId).snapshots();
    } catch (e) {
      // Removed debug print: debugPrint('🚨 Firestore document stream error: $e');
      rethrow;
    }
  }

  // Generic method to add document with error handling
  static Future<DocumentReference> addDocument(
      String collectionPath, final Map<String, dynamic> data,) async {
    try {
      return await _firestore.collection(collectionPath).add(data);
    } catch (e) {
      // Removed debug print: debugPrint('🚨 Firestore add document error: $e');
      rethrow;
    }
  }

  // Generic method to update document with error handling
  static Future<void> updateDocument(final String collectionPath,
      String documentId, final Map<String, dynamic> data,) async {
    try {
      await _firestore.collection(collectionPath).doc(documentId).update(data);
    } catch (e) {
      // Removed debug print: debugPrint('🚨 Firestore update document error: $e');
      rethrow;
    }
  }

  // Generic method to delete document with error handling
  static Future<void> deleteDocument(
      String collectionPath, final String documentId,) async {
    try {
      await _firestore.collection(collectionPath).doc(documentId).delete();
    } catch (e) {
      // Removed debug print: debugPrint('🚨 Firestore delete document error: $e');
      rethrow;
    }
  }

  // Generic method to query collection with error handling
  static Future<QuerySnapshot> queryCollection(
    final String collectionPath, {
    Query<Object?> Function(Query<Object?> query)? queryBuilder,
  }) async {
    try {
      Query<Object?> query = _firestore.collection(collectionPath);
      if (queryBuilder != null) {
        query = queryBuilder(query);
      }
      return await query.get();
    } catch (e) {
      // Removed debug print: debugPrint('🚨 Firestore query error: $e');
      rethrow;
    }
  }

  // Business-specific methods
  static Stream<QuerySnapshot> getBusinessesStream() => getCollectionStream('businesses');

  static Stream<QuerySnapshot> getStudiosStream() => getCollectionStream('studios');

  static Stream<QuerySnapshot> getAppointmentsStream() => getCollectionStream('appointments');

  static Stream<QuerySnapshot> getClientsStream() => getCollectionStream('clients');

  static Stream<QuerySnapshot> getStaffStream() => getCollectionStream('staff');

  static Stream<QuerySnapshot> getServicesStream() => getCollectionStream('services');

  static Stream<QuerySnapshot> getBookingsStream() => getCollectionStream('bookings');

  static Stream<QuerySnapshot> getUsersStream() => getCollectionStream('users');
}
