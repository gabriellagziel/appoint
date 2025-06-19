import '../third_party/flutter_facebook_auth_stub/lib/flutter_facebook_auth.dart';

class FacebookAuthService {
  final FacebookAuth _facebookAuth;

  FacebookAuthService({FacebookAuth? facebookAuth})
      : _facebookAuth = facebookAuth ?? FacebookAuth.instance;

  Future<AccessToken?> login() async {
    final result = await _facebookAuth.login();
    if (result.status == LoginStatus.success) {
      return result.accessToken;
    }
    return null;
  }

  Future<void> logout() async {
    await _facebookAuth.logOut();
  }

  Future<AccessToken?> getAccessToken() async {
    return _facebookAuth.accessToken;
  }
}
