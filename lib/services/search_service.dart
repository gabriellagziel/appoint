class SearchService {
  Future<List<String>> search(final String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (query.isEmpty) return [];
    return List.generate(5, (final index) => '$query result ${index + 1}');
  }
}
