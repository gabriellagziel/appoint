class LinkMeta {
  final String? shareId;
  final String? source;
  final String? creatorId;
  const LinkMeta({this.shareId, this.source, this.creatorId});

  static LinkMeta fromUri(Uri u) => LinkMeta(
        shareId: u.queryParameters['shareId'],
        source: u.queryParameters['source'],
        creatorId: u.queryParameters['creatorId'],
      );
}
