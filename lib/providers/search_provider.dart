import 'package:appoint/services/search_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchServiceProvider = Provider<SearchService>((ref) => SearchService());

final searchQueryProvider = StateProvider<String>((ref) => '');

final AutoDisposeFutureProvider<List<String>> searchResultsProvider =
    FutureProvider.autoDispose<List<String>>((ref) {
  final query = ref.watch(searchQueryProvider);
  final service = ref.read(searchServiceProvider);
  return service.search(query);
});
