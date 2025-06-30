import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/content_item.dart';
import '../services/content_library_service.dart';

final contentLibraryServiceProvider =
    Provider<ContentLibraryService>((ref) => ContentLibraryService());

class ContentLibraryNotifier
    extends StateNotifier<AsyncValue<List<ContentItem>>> {
  final ContentLibraryService _service;
  DocumentSnapshot<Map<String, dynamic>>? _lastDoc;
  bool _hasMore = true;

  ContentLibraryNotifier(this._service) : super(const AsyncValue.loading()) {
    load();
  }

  bool get hasMore => _hasMore;

  Future<void> load() async {
    _lastDoc = null;
    _hasMore = true;
    try {
      final res = await _service.fetchItems();
      _lastDoc = res.lastDoc;
      _hasMore = res.hasMore;
      state = AsyncValue.data(res.items);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> loadMore() async {
    if (!_hasMore) return;
    try {
      final res = await _service.fetchItems(startAfter: _lastDoc);
      _lastDoc = res.lastDoc;
      _hasMore = res.hasMore;
      state = state.whenData((items) => [...items, ...res.items]);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final contentLibraryProvider = StateNotifierProvider<ContentLibraryNotifier,
    AsyncValue<List<ContentItem>>>(
  (ref) => ContentLibraryNotifier(ref.read(contentLibraryServiceProvider)),
);

final contentItemProvider =
    FutureProvider.family<ContentItem?, String>((ref, id) async {
  final service = ref.read(contentLibraryServiceProvider);
  return service.getItem(id);
});
