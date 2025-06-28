import 'dart:io';

/// HTTP overrides for tests to prevent requests to external hosts.
class TestHttpOverrides extends HttpOverrides {
  /// Mapping from blocked hosts to the local emulator host.
  final String emulatorHost;
  final int emulatorPort;

  TestHttpOverrides({this.emulatorHost = 'localhost', this.emulatorPort = 8080});

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _InterceptingHttpClient(emulatorHost, emulatorPort);
  }
}

class _InterceptingHttpClient extends HttpClient {
  final String emulatorHost;
  final int emulatorPort;

  _InterceptingHttpClient(this.emulatorHost, this.emulatorPort);

  static const _blockedHosts = {
    'storage.googleapis.com',
    'firebase-public.firebaseio.com',
    'metadata.google.internal',
    '169.254.169.254',
  };

  Uri _redirect(Uri url) {
    if (_blockedHosts.contains(url.host)) {
      return url.replace(host: emulatorHost, port: emulatorPort, scheme: 'http');
    }
    return url;
  }

  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) {
    return super.openUrl(method, _redirect(url));
  }
}

/// Sets [HttpOverrides.global] to [TestHttpOverrides].
void initializeHttpOverrides({String host = 'localhost', int port = 8080}) {
  HttpOverrides.global = TestHttpOverrides(emulatorHost: host, emulatorPort: port);
}
