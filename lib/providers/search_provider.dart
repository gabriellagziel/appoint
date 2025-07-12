import 'package:appoint/services/search_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchServiceProvider =
    Provider<SearchService>((ref) => SearchService());

searchQueryProvider = StateProvider<String>((final ref) => '');

final AutoDisposeFutureProvider<List<String>> searchResultsProvider =
    FutureProvider.autoDispose<List<String>>((ref) {
  query = ref.watch(searchQueryProvider);
  service = ref.read(searchServiceProvider);
  return service.search(query);
});
