class AccessToken {
  final String token;
  AccessToken({required this.token});
}

enum LoginStatus { success, failed, cancelled }

class LoginResult {
  final LoginStatus status;
  final AccessToken? accessToken;
  LoginResult({required this.status, this.accessToken});
}

class FacebookAuth {
  FacebookAuth._();
  static final instance = FacebookAuth._();

  AccessToken? _token;

  Future<LoginResult> login({List<String> permissions = const []}) async {
    _token = AccessToken(token: 'stub-token');
    return LoginResult(status: LoginStatus.success, accessToken: _token);
  }

  Future<void> logOut() async {
    _token = null;
  }

  Future<AccessToken?> get accessToken async => _token;
}
