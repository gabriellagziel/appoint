import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/search_service.dart';

final searchServiceProvider = Provider<SearchService>((ref) => SearchService());

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = FutureProvider.autoDispose<List<String>>((ref) {
  final query = ref.watch(searchQueryProvider);
  final service = ref.read(searchServiceProvider);
  return service.search(query);
});
