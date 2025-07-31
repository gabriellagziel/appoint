/// Exception thrown by the AppointSDK
/// 
/// Used for all SDK-related errors including network issues, authentication failures,
/// and API errors
class AppointException implements Exception {
  /// Error message describing what went wrong
  final String message;
  
  /// Optional error code for programmatic handling
  final String? code;
  
  /// Optional HTTP status code if this was an API error
  final int? statusCode;

  const AppointException(
    this.message, {
    this.code,
    this.statusCode,
  });

  @override
  String toString() {
    final parts = <String>['AppointException: $message'];
    
    if (code != null) {
      parts.add('Code: $code');
    }
    
    if (statusCode != null) {
      parts.add('Status: $statusCode');
    }
    
    return parts.join(', ');
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppointException &&
        other.message == message &&
        other.code == code &&
        other.statusCode == statusCode;
  }

  @override
  int get hashCode => Object.hash(message, code, statusCode);
} 