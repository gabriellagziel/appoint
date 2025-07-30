import 'package:appoint/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// Utility class to enforce English-only localization for admin interfaces.
/// This ensures that admin dashboards and tools remain in English regardless
/// of the user's language preference.
class AdminLocalizations {
  /// Private constructor to prevent instantiation
  AdminLocalizations._();

  /// Returns AppLocalizations with English locale forced for admin interfaces.
  /// This method should be used in all admin-related screens and widgets.
  ///
  /// Usage:
  /// ```dart
  /// final l10n = AdminLocalizations.of(context);
  /// ```
  static AppLocalizations of(BuildContext context) {
    // Always return English localizations for admin interfaces
    return lookupAppLocalizations(const Locale('en'));
  }

  /// Check if the current route is an admin route
  static bool isAdminRoute(BuildContext context) {
    final routeName = ModalRoute.of(context)?.settings.name ?? '';
    return routeName.contains('admin') ||
        routeName.contains('Admin') ||
        routeName.contains('/admin/');
  }

  /// Wrapper widget that forces English locale for admin interfaces
  static Widget wrap({
    required Widget child,
    required bool isAdmin,
  }) {
    if (!isAdmin) {
      return child;
    }

    return enforceEnglish(child: child);
  }

  /// Creates a widget that enforces English locale for admin interfaces
  static Widget enforceEnglish({
    required Widget child,
  }) =>
      Localizations(
        locale: const Locale('en'),
        delegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        child: child,
      );

  /// Gets the admin route pattern
  static RegExp get adminRoutePattern => RegExp('/(admin|Admin)');

  /// Checks if a route name matches admin patterns
  static bool isAdminRouteByName(String? routeName) {
    if (routeName == null) return false;
    return adminRoutePattern.hasMatch(routeName);
  }
}
