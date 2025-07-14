import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/services/api/api_client.dart';
import 'package:appoint/services/auth_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

/// FCM Token Provider that manages Firebase Cloud Messaging tokens
/// Handles token retrieval, storage, and backend synchronization
class FCMTokenProvider extends StateNotifier<FCMTokenState> {
  FCMTokenProvider(this._authService, this._apiClient) : super(FCMTokenState.initial()) {
    _initialize();
  }

  final AuthService _authService;
  final ApiClient _apiClient;

  /// Initialize FCM token management
  Future<void> _initialize() async {
    try {
      // Request notification permissions
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        // Get initial token
        await _getAndStoreToken();
        
        // Listen for token refresh
        FirebaseMessaging.instance.onTokenRefresh.listen(_onTokenRefresh);
        
        // Listen for user authentication changes
        _authService.authStateChanges.listen(_onAuthStateChanged);
      } else {
        state = FCMTokenState.error('Notification permissions denied');
      }
    } catch (e) {
      state = FCMTokenState.error('Failed to initialize FCM: $e');
    }
  }

  /// Get current FCM token and store it
  Future<void> _getAndStoreToken() async {
    try {
      state = FCMTokenState.loading();
      
      final token = await FirebaseMessaging.instance.getToken();
      
      if (token != null) {
        state = FCMTokenState.success(token);
        await _sendTokenToBackend(token);
      } else {
        state = FCMTokenState.error('Failed to get FCM token');
      }
    } catch (e) {
      state = FCMTokenState.error('Failed to get FCM token: $e');
    }
  }

  /// Handle token refresh
  Future<void> _onTokenRefresh(String newToken) async {
    try {
      state = FCMTokenState.success(newToken);
      await _sendTokenToBackend(newToken);
    } catch (e) {
      state = FCMTokenState.error('Failed to handle token refresh: $e');
    }
  }

  /// Handle authentication state changes
  Future<void> _onAuthStateChanged(dynamic authState) async {
    // Check if user is authenticated
    final currentUser = _authService.currentUser;
    if (currentUser != null) {
      // User logged in, send token to backend
      final currentToken = state.token;
      if (currentToken != null) {
        await _sendTokenToBackend(currentToken);
      }
    } else {
      // User logged out, clear token state
      state = FCMTokenState.initial();
    }
  }

  /// Send FCM token to backend
  Future<void> _sendTokenToBackend(String token) async {
    try {
      final currentUser = _authService.currentUser;
      if (currentUser != null) {
        await _apiClient.post('/users/fcm-token', data: {
          'token': token,
          'platform': _getPlatform(),
          'appVersion': _getAppVersion(),
        });
      }
    } catch (e) {
      // Log error but don't fail the token update
      // In a real app, you would log this to a service like Crashlytics
    }
  }

  /// Get current platform
  String _getPlatform() {
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    if (kIsWeb) return 'web';
    return 'unknown';
  }

  /// Get app version
  String _getAppVersion() {
    // TODO: Implement app version retrieval
    return '1.0.0';
  }

  /// Manually refresh token
  Future<void> refreshToken() async {
    await _getAndStoreToken();
  }

  /// Get current token
  String? get currentToken => state.token;

  /// Check if token is available
  bool get hasToken => state.token != null;

  /// Check if token is loading
  bool get isLoading => state.isLoading;

  /// Check if there's an error
  bool get hasError => state.error != null;
}

/// State class for FCM Token Provider
class FCMTokenState {
  final String? token;
  final bool isLoading;
  final String? error;

  const FCMTokenState._({
    this.token,
    this.isLoading = false,
    this.error,
  });

  factory FCMTokenState.initial() => const FCMTokenState._();

  factory FCMTokenState.loading() => const FCMTokenState._(isLoading: true);

  factory FCMTokenState.success(String token) => FCMTokenState._(token: token);

  factory FCMTokenState.error(String error) => FCMTokenState._(error: error);
}

/// Provider for FCM Token
final fcmTokenProvider = StateNotifierProvider<FCMTokenProvider, FCMTokenState>((ref) {
  final authService = ref.watch(authServiceProvider);
  final apiClient = ref.watch(apiClientProvider);
  return FCMTokenProvider(authService, apiClient);
});

/// Provider for API Client
final apiClientProvider = Provider<ApiClient>((ref) => ApiClient.instance);

/// Provider for Auth Service
final authServiceProvider = Provider<AuthService>((ref) => AuthService()); 