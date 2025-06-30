import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as encrypt;

import '../config/google_config.dart';

class GoogleCalendarService {
  static const _credentialKey = 'google_calendar_credentials';
  static const _encryptionKeyKey = 'google_calendar_encryption_key';

  final FlutterSecureStorage _storage;
  AutoRefreshingAuthClient? _client;

  GoogleCalendarService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  Future<encrypt.Key> _getEncryptionKey() async {
    final existing = await _storage.read(key: _encryptionKeyKey);
    if (existing != null) {
      return encrypt.Key.fromBase64(existing);
    }
    final key = encrypt.Key.fromSecureRandom(32);
    await _storage.write(key: _encryptionKeyKey, value: key.base64);
    return key;
  }

  Future<void> signInWithGoogleCalendar() async {
    // If credentials already stored, just load them.
    final creds = await _loadCredentials();
    if (creds != null) {
      _setClientFromCredentials(creds);
      return;
    }

    final authUrl = Uri.https('accounts.google.com', '/o/oauth2/v2/auth', {
      'response_type': 'code',
      'client_id': GoogleConfig.clientId,
      'redirect_uri': GoogleConfig.redirectUri,
      'scope': GoogleConfig.scopes.join(' '),
      'access_type': 'offline',
      'prompt': 'consent',
    });

    final result = await FlutterWebAuth2.authenticate(
      url: authUrl.toString(),
      callbackUrlScheme: Uri.parse(GoogleConfig.redirectUri).scheme,
    );

    final code = Uri.parse(result).queryParameters['code'];
    if (code == null || code.isEmpty) {
      throw Exception('Authorization code not found');
    }

    final tokenResp = await http.post(
      Uri.parse('https://oauth2.googleapis.com/token'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'code': code,
        'client_id': GoogleConfig.clientId,
        'redirect_uri': GoogleConfig.redirectUri,
        'grant_type': 'authorization_code',
      },
    );

    if (tokenResp.statusCode != 200) {
      throw Exception('Token exchange failed: ${tokenResp.body}');
    }

    final Map<String, dynamic> data = jsonDecode(tokenResp.body);
    final accessToken = AccessToken(
      'Bearer',
      data['access_token'] as String,
      DateTime.now().add(Duration(seconds: data['expires_in'] as int)),
    );

    final credentials = AccessCredentials(
      accessToken,
      data['refresh_token'] as String?,
      GoogleConfig.scopes,
      idToken: data['id_token'] as String?,
    );

    await _saveCredentials(credentials);
    _setClientFromCredentials(credentials);
  }

  Future<List<CalendarListEntry>> getCalendars() async {
    final client = await _getClient();
    final api = CalendarApi(client);
    final list = await api.calendarList.list();
    return list.items ?? <CalendarListEntry>[];
  }

  Future<void> createEvent(
    String calendarId, {
    required String summary,
    required DateTime start,
    required DateTime end,
    String? description,
  }) async {
    final client = await _getClient();
    final api = CalendarApi(client);
    final event = Event()
      ..summary = summary
      ..description = description
      ..start = (EventDateTime()..dateTime = start.toUtc())
      ..end = (EventDateTime()..dateTime = end.toUtc());

    await api.events.insert(event, calendarId);
  }

  Future<AutoRefreshingAuthClient> _getClient() async {
    if (_client != null) return _client!;
    final creds = await _loadCredentials();
    if (creds == null) {
      throw Exception('Not authenticated with Google');
    }
    return _setClientFromCredentials(creds);
  }

  AutoRefreshingAuthClient _setClientFromCredentials(AccessCredentials creds) {
    final clientId = ClientId(GoogleConfig.clientId, null);
    final client = autoRefreshingClient(clientId, creds, http.Client());
    client.credentialUpdates.listen(_saveCredentials);
    _client = client;
    return client;
  }

  Future<AccessCredentials?> _loadCredentials() async {
    final stored = await _storage.read(key: _credentialKey);
    if (stored == null) return null;
    try {
      final key = await _getEncryptionKey();
      final wrapper = jsonDecode(stored) as Map<String, dynamic>;
      final iv = encrypt.IV.fromBase64(wrapper['iv'] as String);
      final encryptedData = wrapper['data'] as String;
      final encrypter = encrypt.Encrypter(encrypt.AES(key));
      final decrypted = encrypter.decrypt64(encryptedData, iv: iv);
      final data = jsonDecode(decrypted) as Map<String, dynamic>;
      return AccessCredentials.fromJson(data);
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveCredentials(AccessCredentials credentials) async {
    final key = await _getEncryptionKey();
    final iv = encrypt.IV.fromSecureRandom(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final jsonData = jsonEncode(credentials.toJson());
    final encrypted = encrypter.encrypt(jsonData, iv: iv);
    final wrapper = jsonEncode({'iv': iv.base64, 'data': encrypted.base64});
    await _storage.write(key: _credentialKey, value: wrapper);
  }
}
