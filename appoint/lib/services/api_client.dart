class ApiClient {
  static const String _base =
      String.fromEnvironment('API_BASE', defaultValue: '');

  static Uri uri(String path, {Map<String, dynamic>? query}) {
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    if (_base.isEmpty) {
      return Uri.parse(normalizedPath)
          .replace(queryParameters: _encodeQuery(query));
    }
    final base =
        _base.endsWith('/') ? _base.substring(0, _base.length - 1) : _base;
    return Uri.parse('$base$normalizedPath')
        .replace(queryParameters: _encodeQuery(query));
  }

  static Map<String, String>? _encodeQuery(Map<String, dynamic>? query) {
    if (query == null) return null;
    return query.map((k, v) => MapEntry(k, v?.toString() ?? ''));
  }
}






