import 'dart:convert';

import 'package:appoint/config/google_config.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:http/http.dart' as http;

class GoogleCalendarService {

  GoogleCalendarService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();
  static const _credentialKey = 'google_calendar_credentials';
  static const _encryptionKeyKey = 'google_calendar_encryption_key';

  final FlutterSecureStorage _storage;
  AutoRefreshingAuthClient? _client;

  Future<encrypt.Key> _getEncryptionKey() async {
    final existing = await _storage.read(key: _encryptionKeyKey);
    if (existing != null) {
      return encrypt.Key.fromBase64(existing);
    }
    final key = encrypt.Key.fromSecureRandom(32);
    await _storage.write(key: _encryptionKeyKey, value: key.base64);
    return key;
  }

  Future<String> _encryptData(String plainText) async {
    final key = await _getEncryptionKey();
    final iv = encrypt.IV.fromSecureRandom(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return jsonEncode({'iv': iv.base64, 'data': encrypted.base64});
  }

  Future<String> _decryptData(String payload) async {
    final key = await _getEncryptionKey();
    final map = jsonDecode(payload) as Map<String, dynamic>;
    final iv = encrypt.IV.fromBase64(map['iv'] as String);
    final data = map['data'] as String;
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    return encrypter.decrypt64(data, iv: iv);
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

    Map<String, dynamic> data = jsonDecode(tokenResp.body);
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
    final String calendarId, {
    required final String summary,
    required final DateTime start,
    required final DateTime end,
    final String? description,
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

  AutoRefreshingAuthClient _setClientFromCredentials(
      AccessCredentials creds) {
    final clientId = ClientId(GoogleConfig.clientId);
    final client = autoRefreshingClient(clientId, creds, http.Client());
    client.credentialUpdates.listen(_saveCredentials);
    _client = client;
    return client;
  }

  Future<AccessCredentials?> _loadCredentials() async {
    final encrypted = await _storage.read(key: _credentialKey);
    if (encrypted == null) return null;
    try {
      final decrypted = await _decryptData(encrypted);
      final data = jsonDecode(decrypted) as Map<String, dynamic>;
      return AccessCredentials.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  Future<void> _saveCredentials(AccessCredentials credentials) async {
    final jsonData = jsonEncode(credentials.toJson());
    final encrypted = await _encryptData(jsonData);
    await _storage.write(key: _credentialKey, value: encrypted);
  }

  Future<void> signOut() async {
    await _storage.delete(key: _credentialKey);
    await _storage.delete(key: _encryptionKeyKey);
    _client?.close();
    _client = null;
  }
}
