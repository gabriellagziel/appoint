
/// Fake implementation of ShareService for testing
class FakeShareService {
  bool _canShare = true;
  bool _shouldThrow = false;
  String? _lastSharedText;
  String? _lastSharedUrl;

  Future<bool> canShare() async {
    if (_shouldThrow) throw Exception('Share service error');
    return _canShare;
  }

  Future<bool> share(String text, {String? url}) async {
    if (_shouldThrow) throw Exception('Share service error');
    _lastSharedText = text;
    _lastSharedUrl = url;
    return _canShare;
  }

  Future<bool> copyToClipboard(String text) async {
    if (_shouldThrow) throw Exception('Copy service error');
    _lastSharedText = text;
    return true;
  }

  void setCanShare(bool canShare) {
    _canShare = canShare;
  }

  void setShouldThrow(bool shouldThrow) {
    _shouldThrow = shouldThrow;
  }

  void reset() {
    _canShare = true;
    _shouldThrow = false;
    _lastSharedText = null;
    _lastSharedUrl = null;
  }

  String? get lastSharedText => _lastSharedText;
  String? get lastSharedUrl => _lastSharedUrl;
}
