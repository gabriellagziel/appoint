import 'dart:io';
import 'dart:convert';

/// Security scanner for package dependencies
///
/// Scans pubspec.yaml dependencies for known vulnerabilities,
/// license compliance, and outdated packages
class DependencyScanner {
  static const String _pubspecFile = 'pubspec.yaml';
  static const String _lockFile = 'pubspec.lock';

  /// Scans all dependencies for security issues
  static Future<SecurityReport> scanDependencies() async {
    final report = SecurityReport();

    try {
      // Parse pubspec.yaml
      final pubspecData = await _parsePubspecFile();
      if (pubspecData == null) {
        report.addError('Failed to parse pubspec.yaml');
        return report;
      }

      // Get dependencies
      final dependencies = _extractDependencies(pubspecData);

      // Scan for vulnerabilities
      final vulnerabilities = await _scanVulnerabilities(dependencies);
      report.addVulnerabilities(vulnerabilities);

      // Check license compliance
      final licenseIssues = await _checkLicenseCompliance(dependencies);
      report.addLicenseIssues(licenseIssues);

      // Check for outdated packages
      final outdatedPackages = await _checkOutdatedPackages(dependencies);
      report.addOutdatedPackages(outdatedPackages);

      // Check for discontinued packages
      final discontinuedPackages =
          await _checkDiscontinuedPackages(dependencies);
      report.addDiscontinuedPackages(discontinuedPackages);

      // Check for suspicious packages
      final suspiciousPackages = await _checkSuspiciousPackages(dependencies);
      report.addSuspiciousPackages(suspiciousPackages);
    } catch (e) {
      report.addError('Dependency scan failed: $e');
    }

    return report;
  }

  /// Parses the pubspec.yaml file
  static Future<Map<String, dynamic>?> _parsePubspecFile() async {
    try {
      final file = File(_pubspecFile);
      if (!await file.exists()) {
        return null;
      }

      final content = await file.readAsString();
      return json.decode(content) as Map<String, dynamic>;
    } catch (e) {
      print('Error parsing pubspec.yaml: $e');
      return null;
    }
  }

  /// Extracts dependencies from pubspec data
  static Map<String, String> _extractDependencies(
      Map<String, dynamic> pubspecData) {
    final dependencies = <String, String>{};

    // Extract direct dependencies
    final deps = pubspecData['dependencies'] as Map<String, dynamic>?;
    if (deps != null) {
      for (final entry in deps.entries) {
        final version = entry.value;
        if (version is String) {
          dependencies[entry.key] = version;
        } else if (version is Map<String, dynamic>) {
          final versionStr = version['version'] as String?;
          if (versionStr != null) {
            dependencies[entry.key] = versionStr;
          }
        }
      }
    }

    // Extract dev dependencies
    final devDeps = pubspecData['dev_dependencies'] as Map<String, dynamic>?;
    if (devDeps != null) {
      for (final entry in devDeps.entries) {
        final version = entry.value;
        if (version is String) {
          dependencies[entry.key] = version;
        } else if (version is Map<String, dynamic>) {
          final versionStr = version['version'] as String?;
          if (versionStr != null) {
            dependencies[entry.key] = versionStr;
          }
        }
      }
    }

    return dependencies;
  }

  /// Scans dependencies for known vulnerabilities
  static Future<List<SecurityVulnerability>> _scanVulnerabilities(
    Map<String, String> dependencies,
  ) async {
    final vulnerabilities = <SecurityVulnerability>[];

    // Known vulnerable packages (this would typically come from a vulnerability database)
    final knownVulnerabilities = {
      'http': {
        'versions': ['<0.13.0'],
        'severity': VulnerabilitySeverity.high,
        'description': 'HTTP request smuggling vulnerability',
        'cve': 'CVE-2023-1234',
      },
      'crypto': {
        'versions': ['<3.0.0'],
        'severity': VulnerabilitySeverity.critical,
        'description': 'Weak encryption algorithm',
        'cve': 'CVE-2023-5678',
      },
    };

    for (final entry in dependencies.entries) {
      final package = entry.key;
      final version = entry.value;

      if (knownVulnerabilities.containsKey(package)) {
        final vuln = knownVulnerabilities[package]!;
        final affectedVersions = vuln['versions'] as List<String>;

        if (_isVersionAffected(version, affectedVersions)) {
          vulnerabilities.add(SecurityVulnerability(
            package: package,
            version: version,
            severity: vuln['severity'] as VulnerabilitySeverity,
            description: vuln['description'] as String,
            cve: vuln['cve'] as String?,
            type: VulnerabilityType.dependency,
          ));
        }
      }
    }

    // Check for packages with known security issues
    final suspiciousPackages = await _checkPackageSecurity(dependencies);
    vulnerabilities.addAll(suspiciousPackages);

    return vulnerabilities;
  }

  /// Checks if a version is affected by vulnerabilities
  static bool _isVersionAffected(
      String version, List<String> affectedVersions) {
    // Simple version comparison (in production, use proper semver parsing)
    for (final affected in affectedVersions) {
      if (affected.startsWith('<')) {
        final threshold = affected.substring(1);
        if (_compareVersions(version, threshold) < 0) {
          return true;
        }
      } else if (affected.startsWith('<=')) {
        final threshold = affected.substring(2);
        if (_compareVersions(version, threshold) <= 0) {
          return true;
        }
      } else if (affected.startsWith('>')) {
        final threshold = affected.substring(1);
        if (_compareVersions(version, threshold) > 0) {
          return true;
        }
      } else if (affected.startsWith('>=')) {
        final threshold = affected.substring(2);
        if (_compareVersions(version, threshold) >= 0) {
          return true;
        }
      } else if (affected == version) {
        return true;
      }
    }
    return false;
  }

  /// Simple version comparison
  static int _compareVersions(String v1, String v2) {
    final parts1 = v1.split('.').map(int.parse).toList();
    final parts2 = v2.split('.').map(int.parse).toList();

    final maxLength =
        parts1.length > parts2.length ? parts1.length : parts2.length;

    for (int i = 0; i < maxLength; i++) {
      final p1 = i < parts1.length ? parts1[i] : 0;
      final p2 = i < parts2.length ? parts2[i] : 0;

      if (p1 < p2) return -1;
      if (p1 > p2) return 1;
    }

    return 0;
  }

  /// Checks package security using external APIs
  static Future<List<SecurityVulnerability>> _checkPackageSecurity(
    Map<String, String> dependencies,
  ) async {
    final vulnerabilities = <SecurityVulnerability>[];

    // This would typically call external security APIs
    // For now, we'll simulate some checks

    for (final entry in dependencies.entries) {
      final package = entry.key;
      final version = entry.value;

      // Check for packages with suspicious names
      if (_isSuspiciousPackageName(package)) {
        vulnerabilities.add(SecurityVulnerability(
          package: package,
          version: version,
          severity: VulnerabilitySeverity.medium,
          description: 'Package name may indicate security concerns',
          type: VulnerabilityType.suspicious,
        ));
      }

      // Check for packages with very recent versions (potential supply chain attack)
      if (_isVeryRecentVersion(version)) {
        vulnerabilities.add(SecurityVulnerability(
          package: package,
          version: version,
          severity: VulnerabilitySeverity.low,
          description: 'Very recent version may indicate supply chain attack',
          type: VulnerabilityType.supply_chain,
        ));
      }
    }

    return vulnerabilities;
  }

  /// Checks if a package name is suspicious
  static bool _isSuspiciousPackageName(String package) {
    final suspiciousPatterns = [
      'hack',
      'exploit',
      'backdoor',
      'malware',
      'virus',
      'trojan',
      'keylogger',
      'spyware',
    ];

    final lowerPackage = package.toLowerCase();
    return suspiciousPatterns.any((pattern) => lowerPackage.contains(pattern));
  }

  /// Checks if a version is very recent
  static bool _isVeryRecentVersion(String version) {
    // This would check against package registry data
    // For now, we'll assume any version with 'dev' or 'alpha' is recent
    return version.contains('dev') ||
        version.contains('alpha') ||
        version.contains('beta');
  }

  /// Checks license compliance
  static Future<List<LicenseIssue>> _checkLicenseCompliance(
    Map<String, String> dependencies,
  ) async {
    final issues = <LicenseIssue>[];

    // Known problematic licenses
    final problematicLicenses = {
      'GPL': 'Copyleft license may require source code disclosure',
      'AGPL': 'Strong copyleft license with network use clause',
      'LGPL': 'Lesser copyleft license with linking requirements',
    };

    // This would typically fetch license information from package registries
    // For now, we'll simulate some checks

    for (final entry in dependencies.entries) {
      final package = entry.key;

      // Check for packages with known problematic licenses
      if (_hasProblematicLicense(package)) {
        issues.add(LicenseIssue(
          package: package,
          license: 'GPL', // This would be fetched from registry
          severity: LicenseIssueSeverity.warning,
          description:
              'Package uses GPL license which may have compliance implications',
        ));
      }

      // Check for packages without clear license information
      if (_hasUnclearLicense(package)) {
        issues.add(LicenseIssue(
          package: package,
          license: 'Unknown',
          severity: LicenseIssueSeverity.error,
          description: 'Package license information is unclear or missing',
        ));
      }
    }

    return issues;
  }

  /// Checks if a package has a problematic license
  static bool _hasProblematicLicense(String package) {
    // This would check against package registry data
    // For now, we'll simulate some checks
    final problematicPackages = ['some_gpl_package', 'agpl_dependency'];
    return problematicPackages.contains(package);
  }

  /// Checks if a package has unclear license information
  static bool _hasUnclearLicense(String package) {
    // This would check against package registry data
    // For now, we'll simulate some checks
    final unclearPackages = ['unclear_license_package', 'no_license_package'];
    return unclearPackages.contains(package);
  }

  /// Checks for outdated packages
  static Future<List<OutdatedPackage>> _checkOutdatedPackages(
    Map<String, String> dependencies,
  ) async {
    final outdated = <OutdatedPackage>[];

    // This would typically check against package registry data
    // For now, we'll simulate some checks

    for (final entry in dependencies.entries) {
      final package = entry.key;
      final currentVersion = entry.value;

      // Simulate checking for newer versions
      final latestVersion = await _getLatestVersion(package);
      if (latestVersion != null &&
          _compareVersions(currentVersion, latestVersion) < 0) {
        outdated.add(OutdatedPackage(
          package: package,
          currentVersion: currentVersion,
          latestVersion: latestVersion,
          severity: _getOutdatedSeverity(currentVersion, latestVersion),
        ));
      }
    }

    return outdated;
  }

  /// Gets the latest version of a package
  static Future<String?> _getLatestVersion(String package) async {
    // This would typically call the pub.dev API
    // For now, we'll simulate some responses
    final mockLatestVersions = {
      'http': '1.1.0',
      'crypto': '3.0.2',
      'flutter_test': '0.0.0',
    };

    return mockLatestVersions[package];
  }

  /// Gets the severity of an outdated package
  static OutdatedSeverity _getOutdatedSeverity(String current, String latest) {
    // Simple severity calculation based on version difference
    final currentParts = current.split('.').map(int.parse).toList();
    final latestParts = latest.split('.').map(int.parse).toList();

    if (currentParts.length >= 1 && latestParts.length >= 1) {
      final majorDiff = latestParts[0] - currentParts[0];
      if (majorDiff > 0) return OutdatedSeverity.critical;
    }

    if (currentParts.length >= 2 && latestParts.length >= 2) {
      final minorDiff = latestParts[1] - currentParts[1];
      if (minorDiff > 2) return OutdatedSeverity.high;
    }

    return OutdatedSeverity.low;
  }

  /// Checks for discontinued packages
  static Future<List<DiscontinuedPackage>> _checkDiscontinuedPackages(
    Map<String, String> dependencies,
  ) async {
    final discontinued = <DiscontinuedPackage>[];

    // Known discontinued packages
    final discontinuedPackages = {
      'uni_links': 'Replaced by app_links package',
      'old_package': 'Package is no longer maintained',
    };

    for (final entry in dependencies.entries) {
      final package = entry.key;

      if (discontinuedPackages.containsKey(package)) {
        discontinued.add(DiscontinuedPackage(
          package: package,
          reason: discontinuedPackages[package]!,
          severity: DiscontinuedSeverity.warning,
        ));
      }
    }

    return discontinued;
  }

  /// Checks for suspicious packages
  static Future<List<SuspiciousPackage>> _checkSuspiciousPackages(
    Map<String, String> dependencies,
  ) async {
    final suspicious = <SuspiciousPackage>[];

    for (final entry in dependencies.entries) {
      final package = entry.key;

      // Check for packages with suspicious characteristics
      if (_isSuspiciousPackage(package)) {
        suspicious.add(SuspiciousPackage(
          package: package,
          reason: 'Package exhibits suspicious characteristics',
          severity: SuspiciousSeverity.medium,
        ));
      }
    }

    return suspicious;
  }

  /// Checks if a package is suspicious
  static bool _isSuspiciousPackage(String package) {
    // Check for packages with very few downloads
    // Check for packages with suspicious names
    // Check for packages with no documentation
    // This would typically use package registry data

    final suspiciousPackages = ['suspicious_package', 'unknown_package'];
    return suspiciousPackages.contains(package);
  }
}

/// Security vulnerability
class SecurityVulnerability {
  final String package;
  final String version;
  final VulnerabilitySeverity severity;
  final String description;
  final String? cve;
  final VulnerabilityType type;

  SecurityVulnerability({
    required this.package,
    required this.version,
    required this.severity,
    required this.description,
    this.cve,
    required this.type,
  });

  @override
  String toString() {
    return 'SecurityVulnerability('
        'package: $package, '
        'version: $version, '
        'severity: $severity, '
        'type: $type'
        ')';
  }
}

/// Vulnerability severity levels
enum VulnerabilitySeverity {
  low,
  medium,
  high,
  critical,
}

/// Vulnerability types
enum VulnerabilityType {
  dependency,
  suspicious,
  supply_chain,
  license,
}

/// License compliance issue
class LicenseIssue {
  final String package;
  final String license;
  final LicenseIssueSeverity severity;
  final String description;

  LicenseIssue({
    required this.package,
    required this.license,
    required this.severity,
    required this.description,
  });

  @override
  String toString() {
    return 'LicenseIssue('
        'package: $package, '
        'license: $license, '
        'severity: $severity'
        ')';
  }
}

/// License issue severity levels
enum LicenseIssueSeverity {
  info,
  warning,
  error,
}

/// Outdated package information
class OutdatedPackage {
  final String package;
  final String currentVersion;
  final String latestVersion;
  final OutdatedSeverity severity;

  OutdatedPackage({
    required this.package,
    required this.currentVersion,
    required this.latestVersion,
    required this.severity,
  });

  @override
  String toString() {
    return 'OutdatedPackage('
        'package: $package, '
        'current: $currentVersion, '
        'latest: $latestVersion, '
        'severity: $severity'
        ')';
  }
}

/// Outdated severity levels
enum OutdatedSeverity {
  low,
  medium,
  high,
  critical,
}

/// Discontinued package information
class DiscontinuedPackage {
  final String package;
  final String reason;
  final DiscontinuedSeverity severity;

  DiscontinuedPackage({
    required this.package,
    required this.reason,
    required this.severity,
  });

  @override
  String toString() {
    return 'DiscontinuedPackage('
        'package: $package, '
        'reason: $reason, '
        'severity: $severity'
        ')';
  }
}

/// Discontinued severity levels
enum DiscontinuedSeverity {
  info,
  warning,
  error,
}

/// Suspicious package information
class SuspiciousPackage {
  final String package;
  final String reason;
  final SuspiciousSeverity severity;

  SuspiciousPackage({
    required this.package,
    required this.reason,
    required this.severity,
  });

  @override
  String toString() {
    return 'SuspiciousPackage('
        'package: $package, '
        'reason: $reason, '
        'severity: $severity'
        ')';
  }
}

/// Suspicious severity levels
enum SuspiciousSeverity {
  low,
  medium,
  high,
}

/// Security report
class SecurityReport {
  final List<SecurityVulnerability> vulnerabilities = [];
  final List<LicenseIssue> licenseIssues = [];
  final List<OutdatedPackage> outdatedPackages = [];
  final List<DiscontinuedPackage> discontinuedPackages = [];
  final List<SuspiciousPackage> suspiciousPackages = [];
  final List<String> errors = [];

  void addVulnerabilities(List<SecurityVulnerability> vulns) {
    vulnerabilities.addAll(vulns);
  }

  void addLicenseIssues(List<LicenseIssue> issues) {
    licenseIssues.addAll(issues);
  }

  void addOutdatedPackages(List<OutdatedPackage> packages) {
    outdatedPackages.addAll(packages);
  }

  void addDiscontinuedPackages(List<DiscontinuedPackage> packages) {
    discontinuedPackages.addAll(packages);
  }

  void addSuspiciousPackages(List<SuspiciousPackage> packages) {
    suspiciousPackages.addAll(packages);
  }

  void addError(String error) {
    errors.add(error);
  }

  bool get hasCriticalIssues {
    return vulnerabilities
            .any((v) => v.severity == VulnerabilitySeverity.critical) ||
        licenseIssues.any((l) => l.severity == LicenseIssueSeverity.error);
  }

  bool get hasHighIssues {
    return vulnerabilities
            .any((v) => v.severity == VulnerabilitySeverity.high) ||
        outdatedPackages.any((o) => o.severity == OutdatedSeverity.critical);
  }

  @override
  String toString() {
    return 'SecurityReport('
        'vulnerabilities: ${vulnerabilities.length}, '
        'licenseIssues: ${licenseIssues.length}, '
        'outdatedPackages: ${outdatedPackages.length}, '
        'criticalIssues: $hasCriticalIssues'
        ')';
  }
}
