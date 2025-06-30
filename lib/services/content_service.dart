import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/content_item.dart';

/// Service for interacting with the content collection in Firestore.
class ContentService {
  final FirebaseFirestore _firestore;

  ContentService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection('content_items');

  /// Fetches a page of content items.
  Future<QuerySnapshot<Map<String, dynamic>>> fetchSnapshot({
    DocumentSnapshot<Map<String, dynamic>>? startAfter,
    int limit = 20,
  }) {
    Query<Map<String, dynamic>> query =
        _col.orderBy('createdAt', descending: true).limit(limit);
    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }
    return query.get();
  }

  Future<List<ContentItem>> fetchContent({
    DocumentSnapshot<Map<String, dynamic>>? startAfter,
    int limit = 20,
  }) async {
    final snap = await fetchSnapshot(startAfter: startAfter, limit: limit);
    return snap.docs.map((d) => ContentItem.fromMap(d.id, d.data())).toList();
  }

  Future<ContentItem?> fetchById(String id) async {
    final doc = await _col.doc(id).get();
    if (!doc.exists) return null;
    return ContentItem.fromMap(doc.id, doc.data()!);
  }
}
