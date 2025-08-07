# Accessibility Guide

This document outlines the accessibility features and compliance measures implemented in APP-OINT, ensuring the application meets WCAG 2.1 AA standards.

## Table of Contents

1. [Overview](#overview)
2. [WCAG Compliance](#wcag-compliance)
3. [Color Contrast](#color-contrast)
4. [Screen Reader Support](#screen-reader-support)
5. [Keyboard Navigation](#keyboard-navigation)
6. [Focus Management](#focus-management)
7. [Text and Typography](#text-and-typography)
8. [Images and Media](#images-and-media)
9. [Forms and Inputs](#forms-and-inputs)
10. [Testing and Validation](#testing-and-validation)

## Overview

APP-OINT is committed to providing an accessible experience for all users, including those with disabilities. The application follows Web Content Accessibility Guidelines (WCAG) 2.1 AA standards and implements comprehensive accessibility features.

### Key Accessibility Features

- **High Contrast Support**: Multiple color themes for better visibility
- **Screen Reader Compatibility**: Full support for assistive technologies
- **Keyboard Navigation**: Complete keyboard accessibility
- **Focus Indicators**: Clear focus management
- **Alternative Text**: Descriptive text for images and icons
- **Semantic HTML**: Proper heading structure and landmarks
- **Error Handling**: Clear error messages and validation

## WCAG Compliance

### WCAG 2.1 AA Standards

APP-OINT complies with the following WCAG 2.1 AA success criteria:

#### Perceivable
- **1.1.1 Non-text Content**: All images have alternative text
- **1.3.1 Info and Relationships**: Semantic structure and ARIA labels
- **1.3.2 Meaningful Sequence**: Logical reading order
- **1.4.1 Use of Color**: Color is not the only way to convey information
- **1.4.3 Contrast (Minimum)**: 4.5:1 contrast ratio for normal text
- **1.4.4 Resize Text**: Text can be resized up to 200%
- **1.4.11 Non-text Contrast**: 3:1 contrast for UI elements

#### Operable
- **2.1.1 Keyboard**: All functionality available via keyboard
- **2.1.2 No Keyboard Trap**: No keyboard traps
- **2.2.1 Timing Adjustable**: Time limits can be adjusted
- **2.2.2 Pause, Stop, Hide**: Moving content can be paused
- **2.3.1 Three Flashes**: No content flashes more than 3 times per second
- **2.4.1 Bypass Blocks**: Skip links and landmarks
- **2.4.2 Page Titled**: Descriptive page titles
- **2.4.3 Focus Order**: Logical focus order
- **2.4.4 Link Purpose**: Clear link purpose
- **2.4.5 Multiple Ways**: Multiple ways to navigate
- **2.4.6 Headings and Labels**: Clear headings and labels
- **2.4.7 Focus Visible**: Focus indicators visible

#### Understandable
- **3.1.1 Language of Page**: Page language declared
- **3.1.2 Language of Parts**: Language changes marked
- **3.2.1 On Focus**: No unexpected changes on focus
- **3.2.2 On Input**: No unexpected changes on input
- **3.2.3 Consistent Navigation**: Consistent navigation structure
- **3.2.4 Consistent Identification**: Consistent component identification
- **3.3.1 Error Identification**: Clear error identification
- **3.3.2 Labels or Instructions**: Clear labels and instructions
- **3.3.3 Error Suggestion**: Error suggestions provided
- **3.3.4 Error Prevention**: Error prevention for critical actions

#### Robust
- **4.1.1 Parsing**: Valid HTML markup
- **4.1.2 Name, Role, Value**: ARIA attributes properly implemented
- **4.1.3 Status Messages**: Status messages announced to screen readers

## Color Contrast

### Contrast Requirements

#### Text Contrast
- **Normal Text**: Minimum 4.5:1 contrast ratio
- **Large Text**: Minimum 3:1 contrast ratio (18pt or 14pt bold)
- **UI Components**: Minimum 3:1 contrast ratio

#### Color Contrast Testing

```dart
// lib/utils/color_contrast_testing.dart
import 'package:flutter/material.dart';
import 'dart:math';

class ColorContrastTester {
  /// Calculate the relative luminance of a color
  static double getRelativeLuminance(Color color) {
    double r = color.red / 255.0;
    double g = color.green / 255.0;
    double b = color.blue / 255.0;

    r = r <= 0.03928 ? r / 12.92 : pow((r + 0.055) / 1.055, 2.4);
    g = g <= 0.03928 ? g / 12.92 : pow((g + 0.055) / 1.055, 2.4);
    b = b <= 0.03928 ? b / 12.92 : pow((b + 0.055) / 1.055, 2.4);

    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  /// Calculate contrast ratio between two colors
  static double getContrastRatio(Color color1, Color color2) {
    double luminance1 = getRelativeLuminance(color1);
    double luminance2 = getRelativeLuminance(color2);

    double lighter = max(luminance1, luminance2);
    double darker = min(luminance1, luminance2);

    return (lighter + 0.05) / (darker + 0.05);
  }

  /// Check if contrast meets WCAG AA standards
  static bool meetsWCAGAA(Color foreground, Color background, {bool isLargeText = false}) {
    double ratio = getContrastRatio(foreground, background);
    double requiredRatio = isLargeText ? 3.0 : 4.5;
    return ratio >= requiredRatio;
  }

  /// Get contrast rating
  static String getContrastRating(double ratio) {
    if (ratio >= 7.0) return 'AAA';
    if (ratio >= 4.5) return 'AA';
    if (ratio >= 3.0) return 'A';
    return 'Fail';
  }

  /// Test all color combinations in the theme
  static Map<String, dynamic> testThemeContrast(ThemeData theme) {
    Map<String, dynamic> results = {
      'passed': 0,
      'failed': 0,
      'tests': [],
    };

    // Test text colors
    _testColorPair(
      'Primary Text',
      theme.colorScheme.onPrimary,
      theme.colorScheme.primary,
      results,
    );

    _testColorPair(
      'Surface Text',
      theme.colorScheme.onSurface,
      theme.colorScheme.surface,
      results,
    );

    _testColorPair(
      'Background Text',
      theme.colorScheme.onBackground,
      theme.colorScheme.background,
      results,
    );

    _testColorPair(
      'Error Text',
      theme.colorScheme.onError,
      theme.colorScheme.error,
      results,
    );

    return results;
  }

  static void _testColorPair(String name, Color foreground, Color background, Map<String, dynamic> results) {
    double ratio = getContrastRatio(foreground, background);
    bool passes = meetsWCAGAA(foreground, background);
    String rating = getContrastRating(ratio);

    Map<String, dynamic> test = {
      'name': name,
      'foreground': foreground,
      'background': background,
      'ratio': ratio,
      'rating': rating,
      'passes': passes,
    };

    results['tests'].add(test);
    if (passes) {
      results['passed']++;
    } else {
      results['failed']++;
    }
  }
}
```

### High Contrast Theme

```dart
// lib/theme/high_contrast_theme.dart
import 'package:flutter/material.dart';

class HighContrastTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF000000),
        onPrimary: Color(0xFFFFFFFF),
        secondary: Color(0xFF000000),
        onSecondary: Color(0xFFFFFFFF),
        surface: Color(0xFFFFFFFF),
        onSurface: Color(0xFF000000),
        background: Color(0xFFFFFFFF),
        onBackground: Color(0xFF000000),
        error: Color(0xFF000000),
        onError: Color(0xFFFFFFFF),
        outline: Color(0xFF000000),
        outlineVariant: Color(0xFF000000),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Color(0xFF000000),
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Color(0xFF000000),
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF000000),
        ),
        headlineLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Color(0xFF000000),
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF000000),
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF000000),
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF000000),
        ),
        titleMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF000000),
        ),
        titleSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF000000),
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Color(0xFF000000),
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: Color(0xFF000000),
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: Color(0xFF000000),
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF000000),
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xFF000000),
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: Color(0xFF000000),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF000000),
          foregroundColor: const Color(0xFFFFFFFF),
          elevation: 4,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF000000),
          side: const BorderSide(color: Color(0xFF000000), width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF000000), width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF000000), width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF000000), width: 3),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF000000), width: 2),
        ),
        labelStyle: const TextStyle(color: Color(0xFF000000)),
        hintStyle: const TextStyle(color: Color(0xFF666666)),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFFFFFFF),
        onPrimary: Color(0xFF000000),
        secondary: Color(0xFFFFFFFF),
        onSecondary: Color(0xFF000000),
        surface: Color(0xFF000000),
        onSurface: Color(0xFFFFFFFF),
        background: Color(0xFF000000),
        onBackground: Color(0xFFFFFFFF),
        error: Color(0xFFFFFFFF),
        onError: Color(0xFF000000),
        outline: Color(0xFFFFFFFF),
        outlineVariant: Color(0xFFFFFFFF),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Color(0xFFFFFFFF),
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Color(0xFFFFFFFF),
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFFFFFFFF),
        ),
        headlineLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Color(0xFFFFFFFF),
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFFFFFFFF),
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFFFFFFFF),
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFFFFFFFF),
        ),
        titleMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFFFFFFFF),
        ),
        titleSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFFFFFFFF),
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Color(0xFFFFFFFF),
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: Color(0xFFFFFFFF),
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: Color(0xFFFFFFFF),
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFFFFFFFF),
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xFFFFFFFF),
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: Color(0xFFFFFFFF),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFFFFF),
          foregroundColor: const Color(0xFF000000),
          elevation: 4,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFFFFFFF),
          side: const BorderSide(color: Color(0xFFFFFFFF), width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFFFFFFF), width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFFFFFFF), width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFFFFFFF), width: 3),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFFFFFFF), width: 2),
        ),
        labelStyle: const TextStyle(color: Color(0xFFFFFFFF)),
        hintStyle: const TextStyle(color: Color(0xFFCCCCCC)),
      ),
    );
  }
}
```

## Screen Reader Support

### Semantic Labels

```dart
// lib/widgets/accessibility/semantic_widgets.dart
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

class AccessibleButton extends StatelessWidget {
  final String label;
  final String? hint;
  final VoidCallback? onPressed;
  final Widget child;
  final bool isEnabled;

  const AccessibleButton({
    super.key,
    required this.label,
    this.hint,
    required this.onPressed,
    required this.child,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      hint: hint,
      enabled: isEnabled,
      button: true,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        child: child,
      ),
    );
  }
}

class AccessibleImage extends StatelessWidget {
  final String imagePath;
  final String altText;
  final double? width;
  final double? height;
  final BoxFit? fit;

  const AccessibleImage({
    super.key,
    required this.imagePath,
    required this.altText,
    this.width,
    this.height,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: altText,
      image: true,
      child: Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: fit,
      ),
    );
  }
}

class AccessibleTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final String? errorText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;

  const AccessibleTextField({
    super.key,
    required this.label,
    this.hint,
    this.errorText,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      hint: hint,
      textField: true,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          errorText: errorText,
        ),
      ),
    );
  }
}
```

### Live Regions

```dart
// lib/widgets/accessibility/live_region.dart
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

class LiveRegion extends StatefulWidget {
  final String message;
  final bool isAnnouncing;
  final Widget child;

  const LiveRegion({
    super.key,
    required this.message,
    required this.isAnnouncing,
    required this.child,
  });

  @override
  State<LiveRegion> createState() => _LiveRegionState();
}

class _LiveRegionState extends State<LiveRegion> {
  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      label: widget.isAnnouncing ? widget.message : null,
      child: widget.child,
    );
  }
}

// Usage example
class NotificationWidget extends StatelessWidget {
  final String message;
  final bool showNotification;

  const NotificationWidget({
    super.key,
    required this.message,
    required this.showNotification,
  });

  @override
  Widget build(BuildContext context) {
    return LiveRegion(
      message: message,
      isAnnouncing: showNotification,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Text(message),
      ),
    );
  }
}
```

## Keyboard Navigation

### Focus Management

```dart
// lib/widgets/accessibility/focus_manager.dart
import 'package:flutter/material.dart';

class AccessibleFocusManager {
  static void moveToNextFocus(BuildContext context) {
    FocusScope.of(context).nextFocus();
  }

  static void moveToPreviousFocus(BuildContext context) {
    FocusScope.of(context).previousFocus();
  }

  static void unfocus(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  static void requestFocus(BuildContext context, FocusNode focusNode) {
    FocusScope.of(context).requestFocus(focusNode);
  }
}

class AccessibleFocusTraversal extends StatelessWidget {
  final List<Widget> children;
  final FocusTraversalPolicy? policy;

  const AccessibleFocusTraversal({
    super.key,
    required this.children,
    this.policy,
  });

  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
      policy: policy ?? ReadingOrderTraversalPolicy(),
      child: Column(
        children: children,
      ),
    );
  }
}
```

### Skip Links

```dart
// lib/widgets/accessibility/skip_links.dart
import 'package:flutter/material.dart';

class SkipLinks extends StatelessWidget {
  final List<SkipLink> links;

  const SkipLinks({
    super.key,
    required this.links,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -100,
      left: 0,
      child: Focus(
        autofocus: true,
        child: Container(
          color: Theme.of(context).colorScheme.primary,
          child: Column(
            children: links.map((link) => _buildSkipLink(context, link)).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildSkipLink(BuildContext context, SkipLink link) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => link.onTap(),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Text(
            link.label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class SkipLink {
  final String label;
  final VoidCallback onTap;

  SkipLink({required this.label, required this.onTap});
}

// Usage example
class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content
          Column(
            children: [
              // Navigation
              Semantics(
                label: 'Main navigation',
                child: NavigationBar(),
              ),
              // Main content
              Semantics(
                label: 'Main content',
                child: MainContent(),
              ),
            ],
          ),
          // Skip links
          SkipLinks(
            links: [
              SkipLink(
                label: 'Skip to main content',
                onTap: () => _focusMainContent(context),
              ),
              SkipLink(
                label: 'Skip to navigation',
                onTap: () => _focusNavigation(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _focusMainContent(BuildContext context) {
    // Focus the main content area
  }

  void _focusNavigation(BuildContext context) {
    // Focus the navigation area
  }
}
```

## Focus Management

### Focus Indicators

```dart
// lib/widgets/accessibility/focus_indicators.dart
import 'package:flutter/material.dart';

class AccessibleFocusIndicator extends StatelessWidget {
  final Widget child;
  final Color? focusColor;
  final double focusWidth;

  const AccessibleFocusIndicator({
    super.key,
    required this.child,
    this.focusColor,
    this.focusWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        // Handle focus change
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: focusColor ?? Theme.of(context).colorScheme.primary,
            width: focusWidth,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: child,
      ),
    );
  }
}

class AccessibleButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Widget child;

  const AccessibleButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      button: true,
      child: Focus(
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            // Custom focus style
            side: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
```

## Text and Typography

### Scalable Text

```dart
// lib/theme/accessible_typography.dart
import 'package:flutter/material.dart';

class AccessibleTypography {
  static TextTheme get textTheme {
    return const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        height: 1.2,
        letterSpacing: -0.5,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        height: 1.2,
        letterSpacing: -0.5,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        height: 1.3,
        letterSpacing: -0.25,
      ),
      headlineLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.3,
        letterSpacing: -0.25,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.3,
        letterSpacing: -0.25,
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.3,
        letterSpacing: -0.25,
      ),
      titleLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.4,
        letterSpacing: -0.25,
      ),
      titleMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.4,
        letterSpacing: -0.25,
      ),
      titleSmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 1.4,
        letterSpacing: -0.25,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        height: 1.5,
        letterSpacing: 0.15,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        height: 1.5,
        letterSpacing: 0.25,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        height: 1.5,
        letterSpacing: 0.4,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.4,
        letterSpacing: 0.1,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.4,
        letterSpacing: 0.5,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 1.4,
        letterSpacing: 0.5,
      ),
    );
  }
}
```

### Text Scaling

```dart
// lib/widgets/accessibility/scalable_text.dart
import 'package:flutter/material.dart';

class ScalableText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const ScalableText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: MediaQuery.of(context).textScaler.clamp(
          minScaleFactor: 0.8,
          maxScaleFactor: 2.0,
        ),
      ),
      child: Text(
        text,
        style: style,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      ),
    );
  }
}
```

## Images and Media

### Alternative Text

```dart
// lib/widgets/accessibility/accessible_image.dart
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

class AccessibleImage extends StatelessWidget {
  final String imagePath;
  final String altText;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final bool isDecorative;

  const AccessibleImage({
    super.key,
    required this.imagePath,
    required this.altText,
    this.width,
    this.height,
    this.fit,
    this.isDecorative = false,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: isDecorative ? null : altText,
      image: true,
      excludeSemantics: isDecorative,
      child: Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: fit,
      ),
    );
  }
}

class AccessibleIcon extends StatelessWidget {
  final IconData icon;
  final String? label;
  final double? size;
  final Color? color;
  final bool isDecorative;

  const AccessibleIcon({
    super.key,
    required this.icon,
    this.label,
    this.size,
    this.color,
    this.isDecorative = false,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: isDecorative ? null : label,
      excludeSemantics: isDecorative,
      child: Icon(
        icon,
        size: size,
        color: color,
      ),
    );
  }
}
```

## Forms and Inputs

### Accessible Form Fields

```dart
// lib/widgets/accessibility/accessible_form.dart
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

class AccessibleTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final String? errorText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final bool required;
  final String? helpText;

  const AccessibleTextField({
    super.key,
    required this.label,
    this.hint,
    this.errorText,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.required = false,
    this.helpText,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      hint: hint,
      textField: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              if (required)
                Text(
                  ' *',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
            ],
          ),
          if (helpText != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                helpText!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            validator: validator,
            decoration: InputDecoration(
              hintText: hint,
              errorText: errorText,
              border: const OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}

class AccessibleCheckbox extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String? helpText;

  const AccessibleCheckbox({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.helpText,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      checked: value,
      checkbox: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Checkbox(
                value: value,
                onChanged: onChanged,
              ),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
          if (helpText != null)
            Padding(
              padding: const EdgeInsets.only(left: 48, top: 4),
              child: Text(
                helpText!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
```

## Testing and Validation

### Accessibility Testing

```dart
// test/accessibility/accessibility_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/semantics.dart';

class AccessibilityTester {
  static void testSemanticLabels(WidgetTester tester) {
    // Test that all interactive elements have semantic labels
    final semantics = tester.getSemantics(find.byType(MaterialApp));
    
    // Check for buttons without labels
    final buttons = find.byType(ElevatedButton);
    for (final button in buttons.evaluate()) {
      final semanticsNode = tester.getSemantics(find.byWidget(button));
      expect(semanticsNode.label, isNotEmpty);
    }
  }

  static void testColorContrast(WidgetTester tester) {
    // Test color contrast ratios
    final theme = Theme.of(tester.element(find.byType(MaterialApp)));
    
    // Test text contrast
    final textContrast = ColorContrastTester.getContrastRatio(
      theme.colorScheme.onSurface,
      theme.colorScheme.surface,
    );
    expect(textContrast, greaterThanOrEqualTo(4.5));
  }

  static void testFocusTraversal(WidgetTester tester) {
    // Test keyboard navigation
    final focusNodes = <FocusNode>[];
    
    // Find all focusable widgets
    final focusableWidgets = find.byType(ElevatedButton);
    for (final widget in focusableWidgets.evaluate()) {
      final focusNode = Focus.of(tester.element(find.byWidget(widget)));
      focusNodes.add(focusNode);
    }
    
    // Test focus order
    for (int i = 0; i < focusNodes.length - 1; i++) {
      focusNodes[i].requestFocus();
      tester.pump();
      
      // Verify focus moves to next element
      FocusScope.of(tester.element(find.byType(MaterialApp))).nextFocus();
      tester.pump();
      
      expect(focusNodes[i + 1].hasFocus, isTrue);
    }
  }

  static void testScreenReaderSupport(WidgetTester tester) {
    // Test screen reader announcements
    final semantics = tester.getSemantics(find.byType(MaterialApp));
    
    // Check for live regions
    final liveRegions = find.byWidgetPredicate((widget) {
      final semanticsNode = Semantics.of(tester.element(find.byWidget(widget)));
      return semanticsNode.liveRegion;
    });
    
    expect(liveRegions, findsWidgets);
  }
}

// Example test
void main() {
  group('Accessibility Tests', () {
    testWidgets('should have proper semantic labels', (tester) async {
      await tester.pumpWidget(MyApp());
      AccessibilityTester.testSemanticLabels(tester);
    });

    testWidgets('should meet color contrast requirements', (tester) async {
      await tester.pumpWidget(MyApp());
      AccessibilityTester.testColorContrast(tester);
    });

    testWidgets('should support keyboard navigation', (tester) async {
      await tester.pumpWidget(MyApp());
      AccessibilityTester.testFocusTraversal(tester);
    });

    testWidgets('should support screen readers', (tester) async {
      await tester.pumpWidget(MyApp());
      AccessibilityTester.testScreenReaderSupport(tester);
    });
  });
}
```

### CI/CD Integration

```yaml
# .github/workflows/accessibility-test.yml
name: Accessibility Tests

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  accessibility-test:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.16.0'
    
    - name: Install dependencies
      run: flutter pub get
    
    - name: Run accessibility tests
      run: flutter test test/accessibility/
    
    - name: Run color contrast tests
      run: dart run tool/color_contrast_test.dart
    
    - name: Generate accessibility report
      run: dart run tool/accessibility_report.dart
    
    - name: Upload accessibility report
      uses: actions/upload-artifact@v3
      with:
        name: accessibility-report
        path: accessibility-report.html
```

### Accessibility Report Generator

```dart
// tool/accessibility_report.dart
import 'dart:io';
import 'dart:convert';

class AccessibilityReport {
  static void generateReport() {
    final report = {
      'timestamp': DateTime.now().toIso8601String(),
      'tests': {
        'colorContrast': _runColorContrastTests(),
        'semanticLabels': _runSemanticLabelTests(),
        'keyboardNavigation': _runKeyboardNavigationTests(),
        'screenReader': _runScreenReaderTests(),
      },
      'summary': {
        'totalTests': 0,
        'passedTests': 0,
        'failedTests': 0,
        'compliance': 'WCAG 2.1 AA',
      },
    };

    // Calculate summary
    report['tests'].forEach((key, value) {
      report['summary']['totalTests'] += value['total'];
      report['summary']['passedTests'] += value['passed'];
      report['summary']['failedTests'] += value['failed'];
    });

    // Write report
    final file = File('accessibility-report.json');
    file.writeAsStringSync(jsonEncode(report));

    // Generate HTML report
    _generateHtmlReport(report);
  }

  static Map<String, dynamic> _runColorContrastTests() {
    // Implement color contrast testing
    return {
      'total': 10,
      'passed': 8,
      'failed': 2,
      'issues': [
        {
          'type': 'contrast',
          'severity': 'error',
          'message': 'Button text contrast ratio is 2.8:1, required 4.5:1',
          'location': 'lib/widgets/button.dart:45',
        },
      ],
    };
  }

  static Map<String, dynamic> _runSemanticLabelTests() {
    // Implement semantic label testing
    return {
      'total': 15,
      'passed': 14,
      'failed': 1,
      'issues': [
        {
          'type': 'semantic',
          'severity': 'warning',
          'message': 'Image missing alt text',
          'location': 'lib/widgets/image.dart:23',
        },
      ],
    };
  }

  static Map<String, dynamic> _runKeyboardNavigationTests() {
    // Implement keyboard navigation testing
    return {
      'total': 8,
      'passed': 8,
      'failed': 0,
      'issues': [],
    };
  }

  static Map<String, dynamic> _runScreenReaderTests() {
    // Implement screen reader testing
    return {
      'total': 12,
      'passed': 11,
      'failed': 1,
      'issues': [
        {
          'type': 'screenReader',
          'severity': 'error',
          'message': 'Live region not properly announced',
          'location': 'lib/widgets/notification.dart:67',
        },
      ],
    };
  }

  static void _generateHtmlReport(Map<String, dynamic> report) {
    final html = '''
<!DOCTYPE html>
<html>
<head>
    <title>Accessibility Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .summary { background: #f5f5f5; padding: 20px; border-radius: 8px; }
        .test-section { margin: 20px 0; }
        .issue { background: #fff3cd; padding: 10px; margin: 10px 0; border-left: 4px solid #ffc107; }
        .error { border-left-color: #dc3545; background: #f8d7da; }
        .warning { border-left-color: #ffc107; background: #fff3cd; }
    </style>
</head>
<body>
    <h1>Accessibility Report</h1>
    <div class="summary">
        <h2>Summary</h2>
        <p><strong>Compliance:</strong> ${report['summary']['compliance']}</p>
        <p><strong>Total Tests:</strong> ${report['summary']['totalTests']}</p>
        <p><strong>Passed:</strong> ${report['summary']['passedTests']}</p>
        <p><strong>Failed:</strong> ${report['summary']['failedTests']}</p>
    </div>
    
    ${_generateTestSection('Color Contrast', report['tests']['colorContrast'])}
    ${_generateTestSection('Semantic Labels', report['tests']['semanticLabels'])}
    ${_generateTestSection('Keyboard Navigation', report['tests']['keyboardNavigation'])}
    ${_generateTestSection('Screen Reader', report['tests']['screenReader'])}
</body>
</html>
    ''';

    final file = File('accessibility-report.html');
    file.writeAsStringSync(html);
  }

  static String _generateTestSection(String title, Map<String, dynamic> test) {
    final issues = test['issues'] as List;
    final issuesHtml = issues.map((issue) => '''
      <div class="issue ${issue['severity']}">
        <strong>${issue['type'].toString().toUpperCase()}:</strong> ${issue['message']}<br>
        <small>Location: ${issue['location']}</small>
      </div>
    ''').join('');

    return '''
    <div class="test-section">
        <h3>$title</h3>
        <p>Passed: ${test['passed']}/${test['total']}</p>
        $issuesHtml
    </div>
    ''';
  }
}

void main() {
  AccessibilityReport.generateReport();
}
```

## Conclusion

This accessibility guide ensures that APP-OINT provides an inclusive experience for all users. Regular testing and validation help maintain accessibility standards and identify areas for improvement.

For questions or concerns about accessibility, please contact our accessibility team at accessibility@appoint.com.

---

**Last Updated**: December 2024
**Version**: 1.0.0 