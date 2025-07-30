class SearchService {
  Future<List<String>> search(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (query.isEmpty) return [];
    return List.generate(5, (index) => '$query result ${index + 1}');
  }
}
