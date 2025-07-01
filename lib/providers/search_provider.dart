import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appoint/services/search_service.dart';

final searchServiceProvider = Provider<SearchService>((final ref) => SearchService());

final searchQueryProvider = StateProvider<String>((final ref) => '');

final searchResultsProvider = FutureProvider.autoDispose<List<String>>((final ref) {
  final query = ref.watch(searchQueryProvider);
  final service = ref.read(searchServiceProvider);
  return service.search(query);
});
