/// Edge Case Generator for AI-Powered Test Data Generation
///
/// Generates edge cases and boundary conditions for comprehensive testing.
class EdgeCaseGenerator {
  /// Generates edge cases for different data types
  static List<EdgeCase> generateEdgeCases({
    required String dataType,
    required Map<String, dynamic> constraints,
  }) {
    switch (dataType.toLowerCase()) {
      case 'string':
        return _generateStringEdgeCases(constraints);
      case 'number':
        return _generateNumberEdgeCases(constraints);
      case 'date':
        return _generateDateEdgeCases(constraints);
      case 'email':
        return _generateEmailEdgeCases(constraints);
      case 'url':
        return _generateUrlEdgeCases(constraints);
      default:
        return _generateGenericEdgeCases(constraints);
    }
  }

  static List<EdgeCase> _generateStringEdgeCases(
      Map<String, dynamic> constraints) {
    final edgeCases = <EdgeCase>[];
    final minLength = constraints['minLength'] ?? 0;
    final maxLength = constraints['maxLength'] ?? 100;

    // Empty string
    edgeCases.add(EdgeCase(
      name: 'empty_string',
      value: '',
      description: 'Empty string boundary case',
      risk: RiskLevel.low,
    ));

    // Single character
    edgeCases.add(EdgeCase(
      name: 'single_character',
      value: 'a',
      description: 'Minimum length string',
      risk: RiskLevel.low,
    ));

    // Maximum length string
    final maxString = 'a' * maxLength;
    edgeCases.add(EdgeCase(
      name: 'maximum_length',
      value: maxString,
      description: 'Maximum length string',
      risk: RiskLevel.medium,
    ));

    // Special characters
    edgeCases.add(EdgeCase(
      name: 'special_characters',
      value: '!@#\$%^&*()_+-=[]{}|;:,.<>?',
      description: 'String with special characters',
      risk: RiskLevel.medium,
    ));

    // Unicode characters
    edgeCases.add(EdgeCase(
      name: 'unicode_characters',
      value: '🚀🌟🎉中文日本語한국어',
      description: 'String with Unicode characters',
      risk: RiskLevel.high,
    ));

    // SQL injection attempt
    edgeCases.add(EdgeCase(
      name: 'sql_injection',
      value: "'; DROP TABLE users; --",
      description: 'SQL injection attempt',
      risk: RiskLevel.critical,
    ));

    return edgeCases;
  }

  static List<EdgeCase> _generateNumberEdgeCases(
      Map<String, dynamic> constraints) {
    final edgeCases = <EdgeCase>[];
    final min = constraints['min'] ?? double.negativeInfinity;
    final max = constraints['max'] ?? double.infinity;

    // Zero
    edgeCases.add(EdgeCase(
      name: 'zero',
      value: 0,
      description: 'Zero value',
      risk: RiskLevel.low,
    ));

    // Negative numbers
    if (min < 0) {
      edgeCases.add(EdgeCase(
        name: 'negative_number',
        value: -1,
        description: 'Negative number',
        risk: RiskLevel.medium,
      ));

      edgeCases.add(EdgeCase(
        name: 'large_negative',
        value: -999999999,
        description: 'Large negative number',
        risk: RiskLevel.high,
      ));
    }

    // Maximum value
    if (max != double.infinity) {
      edgeCases.add(EdgeCase(
        name: 'maximum_value',
        value: max,
        description: 'Maximum allowed value',
        risk: RiskLevel.medium,
      ));
    }

    // Very large numbers
    edgeCases.add(EdgeCase(
      name: 'very_large',
      value: 999999999,
      description: 'Very large number',
      risk: RiskLevel.high,
    ));

    // Decimal numbers
    edgeCases.add(EdgeCase(
      name: 'decimal',
      value: 3.14159,
      description: 'Decimal number',
      risk: RiskLevel.low,
    ));

    return edgeCases;
  }

  static List<EdgeCase> _generateDateEdgeCases(
      Map<String, dynamic> constraints) {
    final edgeCases = <EdgeCase>[];
    final now = DateTime.now();

    // Current date
    edgeCases.add(EdgeCase(
      name: 'current_date',
      value: now,
      description: 'Current date and time',
      risk: RiskLevel.low,
    ));

    // Past date
    edgeCases.add(EdgeCase(
      name: 'past_date',
      value: now.subtract(const Duration(days: 365)),
      description: 'Date in the past',
      risk: RiskLevel.medium,
    ));

    // Future date
    edgeCases.add(EdgeCase(
      name: 'future_date',
      value: now.add(const Duration(days: 365)),
      description: 'Date in the future',
      risk: RiskLevel.medium,
    ));

    // Very old date
    edgeCases.add(EdgeCase(
      name: 'very_old_date',
      value: DateTime(1900),
      description: 'Very old date',
      risk: RiskLevel.high,
    ));

    // Leap year date
    edgeCases.add(EdgeCase(
      name: 'leap_year',
      value: DateTime(2024, 2, 29),
      description: 'Leap year date',
      risk: RiskLevel.medium,
    ));

    return edgeCases;
  }

  static List<EdgeCase> _generateEmailEdgeCases(
      Map<String, dynamic> constraints) {
    final edgeCases = <EdgeCase>[];

    // Valid email
    edgeCases.add(EdgeCase(
      name: 'valid_email',
      value: 'test@example.com',
      description: 'Valid email address',
      risk: RiskLevel.low,
    ));

    // Empty email
    edgeCases.add(EdgeCase(
      name: 'empty_email',
      value: '',
      description: 'Empty email address',
      risk: RiskLevel.medium,
    ));

    // Invalid format
    edgeCases.add(EdgeCase(
      name: 'invalid_format',
      value: 'invalid-email',
      description: 'Invalid email format',
      risk: RiskLevel.medium,
    ));

    // Very long email
    edgeCases.add(EdgeCase(
      name: 'long_email',
      value:
          'very.long.email.address.with.many.subdomains@very.long.domain.name.com',
      description: 'Very long email address',
      risk: RiskLevel.high,
    ));

    // Special characters
    edgeCases.add(EdgeCase(
      name: 'special_chars_email',
      value: 'test+tag@example.com',
      description: 'Email with special characters',
      risk: RiskLevel.medium,
    ));

    return edgeCases;
  }

  static List<EdgeCase> _generateUrlEdgeCases(
      Map<String, dynamic> constraints) {
    final edgeCases = <EdgeCase>[];

    // Valid URL
    edgeCases.add(EdgeCase(
      name: 'valid_url',
      value: 'https://example.com',
      description: 'Valid HTTPS URL',
      risk: RiskLevel.low,
    ));

    // HTTP URL
    edgeCases.add(EdgeCase(
      name: 'http_url',
      value: 'http://example.com',
      description: 'HTTP URL',
      risk: RiskLevel.medium,
    ));

    // Invalid URL
    edgeCases.add(EdgeCase(
      name: 'invalid_url',
      value: 'not-a-url',
      description: 'Invalid URL format',
      risk: RiskLevel.medium,
    ));

    // URL with query parameters
    edgeCases.add(EdgeCase(
      name: 'url_with_params',
      value: 'https://example.com?param1=value1&param2=value2',
      description: 'URL with query parameters',
      risk: RiskLevel.medium,
    ));

    // XSS attempt
    edgeCases.add(EdgeCase(
      name: 'xss_attempt',
      value: 'javascript:alert("xss")',
      description: 'XSS attempt in URL',
      risk: RiskLevel.critical,
    ));

    return edgeCases;
  }

  static List<EdgeCase> _generateGenericEdgeCases(
      Map<String, dynamic> constraints) {
    return [
      EdgeCase(
        name: 'null_value',
        value: null,
        description: 'Null value',
        risk: RiskLevel.medium,
      ),
      EdgeCase(
        name: 'empty_object',
        value: {},
        description: 'Empty object',
        risk: RiskLevel.low,
      ),
      EdgeCase(
        name: 'large_object',
        value: {'key': 'a' * 10000},
        description: 'Large object',
        risk: RiskLevel.high,
      ),
    ];
  }

  /// Generates edge cases for a specific field
  static List<EdgeCase> generateFieldEdgeCases({
    required String fieldName,
    required String fieldType,
    Map<String, dynamic>? fieldConstraints,
  }) {
    final constraints = fieldConstraints ?? {};

    // Add field-specific constraints
    constraints['fieldName'] = fieldName;
    constraints['fieldType'] = fieldType;

    final edgeCases = generateEdgeCases(
      dataType: fieldType,
      constraints: constraints,
    );

    // Add field-specific edge cases
    if (fieldName.toLowerCase().contains('password')) {
      edgeCases.addAll(_generatePasswordEdgeCases());
    } else if (fieldName.toLowerCase().contains('phone')) {
      edgeCases.addAll(_generatePhoneEdgeCases());
    } else if (fieldName.toLowerCase().contains('name')) {
      edgeCases.addAll(_generateNameEdgeCases());
    }

    return edgeCases;
  }

  static List<EdgeCase> _generatePasswordEdgeCases() {
    return [
      EdgeCase(
        name: 'weak_password',
        value: '123',
        description: 'Weak password',
        risk: RiskLevel.high,
      ),
      EdgeCase(
        name: 'strong_password',
        value: 'P@ssw0rd!2024',
        description: 'Strong password with special characters',
        risk: RiskLevel.low,
      ),
      EdgeCase(
        name: 'very_long_password',
        value: 'a' * 1000,
        description: 'Very long password',
        risk: RiskLevel.high,
      ),
    ];
  }

  static List<EdgeCase> _generatePhoneEdgeCases() {
    return [
      EdgeCase(
        name: 'valid_phone',
        value: '+1-555-123-4567',
        description: 'Valid phone number',
        risk: RiskLevel.low,
      ),
      EdgeCase(
        name: 'invalid_phone',
        value: 'not-a-phone',
        description: 'Invalid phone format',
        risk: RiskLevel.medium,
      ),
      EdgeCase(
        name: 'short_phone',
        value: '123',
        description: 'Too short phone number',
        risk: RiskLevel.medium,
      ),
    ];
  }

  static List<EdgeCase> _generateNameEdgeCases() {
    return [
      EdgeCase(
        name: 'single_character_name',
        value: 'A',
        description: 'Single character name',
        risk: RiskLevel.low,
      ),
      EdgeCase(
        name: 'very_long_name',
        value: 'A' * 1000,
        description: 'Very long name',
        risk: RiskLevel.high,
      ),
      EdgeCase(
        name: 'name_with_numbers',
        value: 'John123',
        description: 'Name with numbers',
        risk: RiskLevel.medium,
      ),
    ];
  }
}

class EdgeCase {
  final String name;
  final dynamic value;
  final String description;
  final RiskLevel risk;

  EdgeCase({
    required this.name,
    required this.value,
    required this.description,
    required this.risk,
  });

  @override
  String toString() {
    return 'EdgeCase(name: $name, value: $value, risk: $risk, description: $description)';
  }
}

enum RiskLevel {
  low,
  medium,
  high,
  critical,
}
