class DynamicLinkService {
  Future<String> createLink(String path) async {
    return 'https://example.com/$path';
  }
}
