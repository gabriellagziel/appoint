import 'package:flutter/material.dart';
import 'package:appoint/utils/admin_localizations.dart';

/// A utility class that automatically wraps admin routes with English-only localization
class AdminRouteWrapper {
  /// Private constructor to prevent instantiation
  AdminRouteWrapper._();

  /// Wraps a widget with English locale if it's an admin route
  static Widget wrapIfAdminRoute({
    required BuildContext context,
    required Widget child,
  }) {
    if (AdminLocalizations.isAdminRoute(context)) {
      return AdminLocalizations.enforceEnglish(child: child);
    }
    return child;
  }

  /// Wraps a widget with English locale if the route name matches admin patterns
  static Widget wrapIfAdminRouteName({
    required String? routeName,
    required Widget child,
  }) {
    if (AdminLocalizations.isAdminRouteByName(routeName)) {
      return AdminLocalizations.enforceEnglish(child: child);
    }
    return child;
  }

  /// Page route builder that applies English locale to admin routes
  static PageRoute<T> buildAdminRoute<T extends Object?>({
    required String routeName,
    required Widget child,
    RouteSettings? settings,
  }) {
    final isAdmin = AdminLocalizations.isAdminRouteByName(routeName);
    
    return MaterialPageRoute<T>(
      settings: settings ?? RouteSettings(name: routeName),
      builder: (context) => isAdmin 
          ? AdminLocalizations.enforceEnglish(child: child)
          : child,
    );
  }

  /// List of route patterns that should be considered admin routes
  static const List<String> adminRoutePatterns = [
    '/admin',
    '/admin/',
    '/admin-',
    'admin',
    'Admin',
    'ADMIN',
  ];

  /// Checks if a route is an admin route using multiple patterns
  static bool isAdminRoute(String? routeName) {
    if (routeName == null) return false;
    
    return adminRoutePatterns.any((pattern) => 
      routeName.contains(pattern) || 
      routeName.toLowerCase().contains(pattern.toLowerCase())
    );
  }
}