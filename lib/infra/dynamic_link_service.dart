class DynamicLinkService {
  Future<String> createLink(final String path) async {
    return 'https://example.com/$path';
  }
}
