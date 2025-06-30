import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/content_item.dart';
import '../services/content_service.dart';

final contentServiceProvider = Provider<ContentService>((ref) {
  return ContentService();
});

class ContentPagingNotifier
    extends StateNotifier<AsyncValue<List<ContentItem>>> {
  final ContentService _service;
  final int limit;
  final List<ContentItem> _items = [];
  DocumentSnapshot<Map<String, dynamic>>? _lastDoc;
  bool _hasMore = true;

  ContentPagingNotifier(this._service, {this.limit = 10})
      : super(const AsyncValue.loading()) {
    loadMore();
  }

  bool get hasMore => _hasMore;

  Future<void> loadMore() async {
    if (!_hasMore) return;
    try {
      final snap =
          await _service.fetchSnapshot(startAfter: _lastDoc, limit: limit);
      final newItems =
          snap.docs.map((d) => ContentItem.fromMap(d.id, d.data())).toList();
      if (snap.docs.isNotEmpty) {
        _lastDoc = snap.docs.last;
      }
      if (newItems.length < limit) {
        _hasMore = false;
      }
      _items.addAll(newItems);
      state = AsyncValue.data(List.unmodifiable(_items));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final contentPagingProvider =
    StateNotifierProvider<ContentPagingNotifier, AsyncValue<List<ContentItem>>>(
        (ref) {
  return ContentPagingNotifier(ref.read(contentServiceProvider));
});

final contentByIdProvider =
    FutureProvider.family<ContentItem?, String>((ref, id) {
  return ref.read(contentServiceProvider).fetchById(id);
});
