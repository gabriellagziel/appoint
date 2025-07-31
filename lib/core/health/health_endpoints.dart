import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class HealthEndpoints {
  static const String _baseUrl = 'https://api.appoint.com'; // Replace with your API URL
  
  /// Liveness check - indicates if the app is running
  static Future<bool> livenessCheck() async {
    try {
      // Check if app can perform basic operations
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('health_check', DateTime.now().toIso8601String());
      
      // Check connectivity
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return false;
      }
      
      return true;
    } catch (e) {
      print('Liveness check failed: $e');
      return false;
    }
  }
  
  /// Readiness check - indicates if the app is ready to serve requests
  static Future<bool> readinessCheck() async {
    try {
      // Check API connectivity
      final response = await http.get(
        Uri.parse('$_baseUrl/health/readiness'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 5));
      
      if (response.statusCode != 200) {
        return false;
      }
      
      // Check database connectivity
      final dbResponse = await http.get(
        Uri.parse('$_baseUrl/health/database'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 5));
      
      return dbResponse.statusCode == 200;
    } catch (e) {
      print('Readiness check failed: $e');
      return false;
    }
  }
  
  /// Collect performance metrics
  static Future<Map<String, dynamic>> collectMetrics() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/metrics'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        return {
          'timestamp': DateTime.now().toIso8601String(),
          'status': 'healthy',
          'response_time': response.headers['x-response-time'] ?? 'unknown',
          'error_rate': 0.0,
        };
      } else {
        return {
          'timestamp': DateTime.now().toIso8601String(),
          'status': 'unhealthy',
          'error_rate': 1.0,
        };
      }
    } catch (e) {
      return {
        'timestamp': DateTime.now().toIso8601String(),
        'status': 'error',
        'error': e.toString(),
        'error_rate': 1.0,
      };
    }
  }
} 