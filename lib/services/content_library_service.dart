import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/content_item.dart';

class PaginatedContent {
  final List<ContentItem> items;
  final DocumentSnapshot<Map<String, dynamic>>? lastDoc;
  final bool hasMore;

  PaginatedContent({
    required this.items,
    required this.lastDoc,
    required this.hasMore,
  });
}

class ContentLibraryService {
  final FirebaseFirestore _firestore;
  ContentLibraryService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection('content_items');

  Future<PaginatedContent> fetchItems({
    DocumentSnapshot<Map<String, dynamic>>? startAfter,
    int limit = 10,
  }) async {
    Query<Map<String, dynamic>> q =
        _col.orderBy('createdAt', descending: true).limit(limit);
    if (startAfter != null) {
      q = q.startAfterDocument(startAfter);
    }
    final snap = await q.get();
    final items = snap.docs
        .map((d) => ContentItem.fromJson({...d.data(), 'id': d.id}))
        .toList();
    final last = snap.docs.isNotEmpty ? snap.docs.last : null;
    return PaginatedContent(
      items: items,
      lastDoc: last,
      hasMore: snap.docs.length == limit,
    );
  }

  Future<ContentItem?> getItem(String id) async {
    final doc = await _col.doc(id).get();
    if (!doc.exists) return null;
    return ContentItem.fromJson({...doc.data()!, 'id': doc.id});
  }
}
