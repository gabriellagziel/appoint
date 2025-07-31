import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:appoint_sdk/models/user.dart';
import 'package:appoint_sdk/models/business.dart';
import 'package:appoint_sdk/models/booking.dart';
import 'package:appoint_sdk/models/auth_response.dart';
import 'package:appoint_sdk/exceptions/appoint_exception.dart';

/// AppointSDK - Official Dart/Flutter client SDK for App-Oint API
/// 
/// This SDK provides a simple and intuitive interface for interacting with
/// the App-Oint appointment booking system. It handles authentication,
/// user management, business search, and booking operations.
/// 
/// Example usage:
/// ```dart
/// final sdk = AppointSDK();
/// sdk.initialize(baseUrl: 'https://api.appoint.com/v1');
/// 
/// final authResponse = await sdk.authenticate(
///   email: 'user@example.com',
///   password: 'password123',
/// );
/// sdk.setAuthToken(authResponse.token);
/// 
/// final user = await sdk.getCurrentUser();
/// final bookings = await sdk.getUserBookings();
/// ```
class AppointSDK {
  String? _baseUrl;
  String? _authToken;
  final http.Client _httpClient = http.Client();

  /// Initialize the SDK with the API base URL
  /// 
  /// [baseUrl] - The base URL for the App-Oint API
  /// Example: 'https://api.appoint.com/v1'
  void initialize({required String baseUrl}) {
    _baseUrl = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';
  }

  /// Set the authentication token for API requests
  /// 
  /// [token] - JWT authentication token received from login
  void setAuthToken(String token) {
    _authToken = token;
  }

  /// Clear the current authentication token
  void clearAuthToken() {
    _authToken = null;
  }

  /// Authenticate user with email and password
  /// 
  /// [email] - User's email address
  /// [password] - User's password (minimum 8 characters)
  /// 
  /// Returns [AuthResponse] containing the JWT token and user information
  /// 
  /// Throws [AppointException] if authentication fails
  Future<AuthResponse> authenticate({
    required String email,
    required String password,
  }) async {
    _validateInitialized();
    
    if (password.length < 8) {
      throw AppointException('Password must be at least 8 characters long');
    }

    try {
      final response = await _httpClient.post(
        Uri.parse('${_baseUrl}auth/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return AuthResponse.fromJson(data);
      } else if (response.statusCode == 401) {
        final data = jsonDecode(response.body);
        throw AppointException(data['error'] ?? 'Authentication failed');
      } else {
        throw AppointException('Authentication failed: ${response.statusCode}');
      }
    } catch (e) {
      if (e is AppointException) rethrow;
      throw AppointException('Network error: $e');
    }
  }

  /// Get the current user's profile information
  /// 
  /// Returns [User] object with profile details
  /// 
  /// Throws [AppointException] if not authenticated or user not found
  Future<User> getCurrentUser() async {
    _validateInitialized();
    _validateAuthenticated();

    try {
      final response = await _httpClient.get(
        Uri.parse('${_baseUrl}api/users/profile'),
        headers: _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data);
      } else if (response.statusCode == 401) {
        throw AppointException('Authentication required');
      } else if (response.statusCode == 404) {
        throw AppointException('User not found');
      } else {
        throw AppointException('Failed to get user profile: ${response.statusCode}');
      }
    } catch (e) {
      if (e is AppointException) rethrow;
      throw AppointException('Network error: $e');
    }
  }

  /// Search for businesses by query
  /// 
  /// [query] - Search query string
  /// 
  /// Returns list of [Business] objects matching the search
  /// 
  /// Throws [AppointException] if search fails
  Future<List<Business>> searchBusinesses({required String query}) async {
    _validateInitialized();

    try {
      final response = await _httpClient.get(
        Uri.parse('${_baseUrl}api/businesses/search?q=${Uri.encodeComponent(query)}'),
        headers: _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data as List).map((json) => Business.fromJson(json)).toList();
      } else {
        throw AppointException('Search failed: ${response.statusCode}');
      }
    } catch (e) {
      if (e is AppointException) rethrow;
      throw AppointException('Network error: $e');
    }
  }

  /// Get detailed information about a specific business
  /// 
  /// [businessId] - Unique identifier for the business
  /// 
  /// Returns [Business] object with complete details
  /// 
  /// Throws [AppointException] if business not found
  Future<Business> getBusiness({required String businessId}) async {
    _validateInitialized();

    try {
      final response = await _httpClient.get(
        Uri.parse('${_baseUrl}api/businesses/$businessId'),
        headers: _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Business.fromJson(data);
      } else if (response.statusCode == 404) {
        throw AppointException('Business not found');
      } else {
        throw AppointException('Failed to get business: ${response.statusCode}');
      }
    } catch (e) {
      if (e is AppointException) rethrow;
      throw AppointException('Network error: $e');
    }
  }

  /// Get all bookings for the current user
  /// 
  /// Returns list of [Booking] objects
  /// 
  /// Throws [AppointException] if not authenticated
  Future<List<Booking>> getUserBookings() async {
    _validateInitialized();
    _validateAuthenticated();

    try {
      final response = await _httpClient.get(
        Uri.parse('${_baseUrl}api/bookings'),
        headers: _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data as List).map((json) => Booking.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw AppointException('Authentication required');
      } else {
        throw AppointException('Failed to get bookings: ${response.statusCode}');
      }
    } catch (e) {
      if (e is AppointException) rethrow;
      throw AppointException('Network error: $e');
    }
  }

  /// Create a new booking
  /// 
  /// [businessId] - ID of the business to book with
  /// [scheduledAt] - Date and time for the appointment
  /// [serviceType] - Type of service to book
  /// [notes] - Optional notes for the booking
  /// [location] - Optional location for the appointment
  /// [openCall] - Whether this is an open call (default: false)
  /// 
  /// Returns [Booking] object for the created appointment
  /// 
  /// Throws [AppointException] if booking creation fails
  Future<Booking> createBooking({
    required String businessId,
    required DateTime scheduledAt,
    required String serviceType,
    String? notes,
    String? location,
    bool openCall = false,
  }) async {
    _validateInitialized();
    _validateAuthenticated();

    try {
      final response = await _httpClient.post(
        Uri.parse('${_baseUrl}api/bookings'),
        headers: _getAuthHeaders(),
        body: jsonEncode({
          'businessId': businessId,
          'scheduledAt': scheduledAt.toIso8601String(),
          'serviceType': serviceType,
          if (notes != null) 'notes': notes,
          if (location != null) 'location': location,
          'openCall': openCall,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return Booking.fromJson(data);
      } else if (response.statusCode == 400) {
        throw AppointException('Invalid booking data');
      } else if (response.statusCode == 409) {
        throw AppointException('Booking conflict - time slot unavailable');
      } else {
        throw AppointException('Failed to create booking: ${response.statusCode}');
      }
    } catch (e) {
      if (e is AppointException) rethrow;
      throw AppointException('Network error: $e');
    }
  }

  /// Check if the service is alive (health check)
  /// 
  /// Returns true if service is healthy
  Future<bool> checkLiveness() async {
    _validateInitialized();

    try {
      final response = await _httpClient.get(
        Uri.parse('${_baseUrl}health/liveness'),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Check if the service is ready to handle requests
  /// 
  /// Returns true if service is ready
  Future<bool> checkReadiness() async {
    _validateInitialized();

    try {
      final response = await _httpClient.get(
        Uri.parse('${_baseUrl}health/readiness'),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Clean up resources
  void dispose() {
    _httpClient.close();
  }

  void _validateInitialized() {
    if (_baseUrl == null) {
      throw AppointException('SDK not initialized. Call initialize() first.');
    }
  }

  void _validateAuthenticated() {
    if (_authToken == null) {
      throw AppointException('Authentication required. Call setAuthToken() first.');
    }
  }

  Map<String, String> _getAuthHeaders() {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    
    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    
    return headers;
  }
} 