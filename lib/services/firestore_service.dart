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
  static Stream<QuerySnapshot> getCollectionStream(final String collectionPath) {
    try {
      return _firestore.collection(collectionPath).snapshots();
    } catch (e) {
      // Removed debug print: print('🚨 Firestore collection stream error: $e');
      rethrow;
    }
  }

  // Generic method to get document with error handling
  static Future<DocumentSnapshot> getDocument(
      final String collectionPath, final String documentId) async {
    try {
      return await _firestore.collection(collectionPath).doc(documentId).get();
    } catch (e) {
      // Removed debug print: print('🚨 Firestore document get error: $e');
      rethrow;
    }
  }

  // Generic method to get document stream with error handling
  static Stream<DocumentSnapshot> getDocumentStream(
      final String collectionPath, final String documentId) {
    try {
      return _firestore.collection(collectionPath).doc(documentId).snapshots();
    } catch (e) {
      // Removed debug print: print('🚨 Firestore document stream error: $e');
      rethrow;
    }
  }

  // Generic method to add document with error handling
  static Future<DocumentReference> addDocument(
      final String collectionPath, final Map<String, dynamic> data) async {
    try {
      return await _firestore.collection(collectionPath).add(data);
    } catch (e) {
      // Removed debug print: print('🚨 Firestore add document error: $e');
      rethrow;
    }
  }

  // Generic method to update document with error handling
  static Future<void> updateDocument(final String collectionPath, final String documentId,
      final Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collectionPath).doc(documentId).update(data);
    } catch (e) {
      // Removed debug print: print('🚨 Firestore update document error: $e');
      rethrow;
    }
  }

  // Generic method to delete document with error handling
  static Future<void> deleteDocument(
      final String collectionPath, final String documentId) async {
    try {
      await _firestore.collection(collectionPath).doc(documentId).delete();
    } catch (e) {
      // Removed debug print: print('🚨 Firestore delete document error: $e');
      rethrow;
    }
  }

  // Generic method to query collection with error handling
  static Future<QuerySnapshot> queryCollection(
    final String collectionPath, {
    final Query<Object?> Function(Query<Object?> query)? queryBuilder,
  }) async {
    try {
      Query<Object?> query = _firestore.collection(collectionPath);
      if (queryBuilder != null) {
        query = queryBuilder(query);
      }
      return await query.get();
    } catch (e) {
      // Removed debug print: print('🚨 Firestore query error: $e');
      rethrow;
    }
  }

  // Business-specific methods
  static Stream<QuerySnapshot> getBusinessesStream() {
    return getCollectionStream('businesses');
  }

  static Stream<QuerySnapshot> getStudiosStream() {
    return getCollectionStream('studios');
  }

  static Stream<QuerySnapshot> getAppointmentsStream() {
    return getCollectionStream('appointments');
  }

  static Stream<QuerySnapshot> getClientsStream() {
    return getCollectionStream('clients');
  }

  static Stream<QuerySnapshot> getStaffStream() {
    return getCollectionStream('staff');
  }

  static Stream<QuerySnapshot> getServicesStream() {
    return getCollectionStream('services');
  }

  static Stream<QuerySnapshot> getBookingsStream() {
    return getCollectionStream('bookings');
  }

  static Stream<QuerySnapshot> getUsersStream() {
    return getCollectionStream('users');
  }
}
