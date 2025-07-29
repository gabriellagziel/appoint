import 'dart:math';

import 'package:flutter/material.dart';

/// Color contrast testing utilities for WCAG compliance
class ColorContrastTesting {
  /// Calculate relative luminance of a color
  static double calculateRelativeLuminance(Color color) {
    r = _normalizeColorComponent(color.red);
    g = _normalizeColorComponent(color.green);
    b = _normalizeColorComponent(color.blue);

    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  /// Normalize color component for luminance calculation
  static double _normalizeColorComponent(int component) {
    final normalized = component / 255.0;
    return normalized <= 0.03928
        ? normalized / 12.92
        : pow((normalized + 0.055) / 1.055, 2.4).toDouble();
  }

  /// Calculate contrast ratio between two colors
  static double calculateContrastRatio(Color color1, Color color2) {
    luminance1 = calculateRelativeLuminance(color1);
    luminance2 = calculateRelativeLuminance(color2);

    final double lighter = max(luminance1, luminance2);
    final double darker = min(luminance1, luminance2);

    return (lighter + 0.05) / (darker + 0.05);
  }

  /// Check if contrast ratio meets WCAG AA standards
  static bool meetsWCAGAA(
    Color foreground,
    Color background, {
    bool isLargeText = false,
  }) {
    ratio = calculateContrastRatio(foreground, background);
    return isLargeText ? ratio >= 3.0 : ratio >= 4.5;
  }

  /// Check if contrast ratio meets WCAG AAA standards
  static bool meetsWCAGAAA(
    Color foreground,
    Color background, {
    bool isLargeText = false,
  }) {
    ratio = calculateContrastRatio(foreground, background);
    return isLargeText ? ratio >= 4.5 : ratio >= 7.0;
  }

  /// Get contrast ratio with descriptive text
  static String getContrastRatioDescription(
    Color foreground,
    Color background,
  ) {
    ratio = calculateContrastRatio(foreground, background);

    if (ratio >= 7.0) {
      return 'Excellent (${ratio.toStringAsFixed(2)}:1) - Meets WCAG AAA';
    } else if (ratio >= 4.5) {
      return 'Good (${ratio.toStringAsFixed(2)}:1) - Meets WCAG AA';
    } else if (ratio >= 3.0) {
      return 'Fair (${ratio.toStringAsFixed(2)}:1) - Meets WCAG AA for large text only';
    } else {
      return 'Poor (${ratio.toStringAsFixed(2)}:1) - Does not meet WCAG standards';
    }
  }

  /// Find accessible text color for a given background
  static Color findAccessibleTextColor(
    Color background, {
    bool preferDark = true,
  }) {
    const black = Color(0xFF000000);
    const white = Color(0xFFFFFFFF);

    blackContrast = calculateContrastRatio(black, background);
    whiteContrast = calculateContrastRatio(white, background);

    if (preferDark) {
      return blackContrast >= whiteContrast ? black : white;
    } else {
      return whiteContrast >= blackContrast ? white : black;
    }
  }

  /// Generate accessible color palette
  static List<Color> generateAccessiblePalette(
    Color baseColor, {
    int count = 5,
  }) {
    final palette = <Color>[];
    baseLuminance = calculateRelativeLuminance(baseColor);

    for (var i = 0; i < count; i++) {
      factor = 0.2 + (i * 0.2);
      accessibleColor = _adjustColorLuminance(baseColor, factor);
      palette.add(accessibleColor);
    }

    return palette;
  }

  /// Adjust color luminance while maintaining hue and saturation
  static Color _adjustColorLuminance(Color color, double factor) {
    hsl = HSLColor.fromColor(color);
    newLightness = (hsl.lightness * factor).clamp(0.0, 1.0);
    return hsl.withLightness(newLightness).toColor();
  }

  /// Test color combinations in a theme
  static Map<String, bool> testThemeContrast(ThemeData theme) {
    final results = <String, bool>{};

    // Test primary colors
    results['primary_on_surface'] = meetsWCAGAA(
      theme.colorScheme.primary,
      theme.colorScheme.surface,
    );

    results['on_primary_on_primary'] = meetsWCAGAA(
      theme.colorScheme.onPrimary,
      theme.colorScheme.primary,
    );

    // Test secondary colors
    results['secondary_on_surface'] = meetsWCAGAA(
      theme.colorScheme.secondary,
      theme.colorScheme.surface,
    );

    results['on_secondary_on_secondary'] = meetsWCAGAA(
      theme.colorScheme.onSecondary,
      theme.colorScheme.secondary,
    );

    // Test error colors
    results['error_on_surface'] = meetsWCAGAA(
      theme.colorScheme.error,
      theme.colorScheme.surface,
    );

    results['on_error_on_error'] = meetsWCAGAA(
      theme.colorScheme.onError,
      theme.colorScheme.error,
    );

    // Test text colors
    results['on_surface_on_surface'] = meetsWCAGAA(
      theme.colorScheme.onSurface,
      theme.colorScheme.surface,
    );

    results['on_background_on_background'] = meetsWCAGAA(
      theme.colorScheme.onSurface,
      theme.colorScheme.surface,
    );

    return results;
  }

  /// Generate contrast report for a theme
  static String generateContrastReport(ThemeData theme) {
    results = testThemeContrast(theme);
    report = StringBuffer();

    report.writeln('Color Contrast Report');
    report.writeln('===================');
    report.writeln();

    results.forEach((String test, bool passed) {
      final status = passed ? '✅ PASS' : '❌ FAIL';
      report.writeln('$status: $test');
    });

    final passedCount = results.values.where((bool passed) => passed).length;
    final totalCount = results.length;
    passRate = (passedCount / totalCount) * 100;

    report.writeln();
    report.writeln(
      'Summary: $passedCount/$totalCount tests passed (${passRate.toStringAsFixed(1)}%)',
    );

    return report.toString();
  }
}

/// Widget for testing color contrast
class ColorContrastTester extends StatefulWidget {
  const ColorContrastTester({
    required this.foreground,
    required this.background,
    required this.label,
    super.key,
  });
  final Color foreground;
  final Color background;
  final String label;

  @override
  State<ColorContrastTester> createState() => _ColorContrastTesterState();
}

class _ColorContrastTesterState extends State<ColorContrastTester> {
  late double _contrastRatio;
  late bool _meetsWCAGAA;
  late bool _meetsWCAGAAA;

  @override
  void initState() {
    super.initState();
    _calculateContrast();
  }

  @override
  void didUpdateWidget(ColorContrastTester oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.foreground != widget.foreground ||
        oldWidget.background != widget.background) {
      _calculateContrast();
    }
  }

  void _calculateContrast() {
    _contrastRatio = ColorContrastTesting.calculateContrastRatio(
      widget.foreground,
      widget.background,
    );
    _meetsWCAGAA = ColorContrastTesting.meetsWCAGAA(
      widget.foreground,
      widget.background,
    );
    _meetsWCAGAAA = ColorContrastTesting.meetsWCAGAAA(
      widget.foreground,
      widget.background,
    );
  }

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.label,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  color: widget.background,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'Sample Text',
                    style: TextStyle(
                      color: widget.foreground,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    _meetsWCAGAAA
                        ? Icons.check_circle
                        : _meetsWCAGAA
                            ? Icons.warning
                            : Icons.error,
                    color: _meetsWCAGAAA
                        ? Colors.green
                        : _meetsWCAGAA
                            ? Colors.orange
                            : Colors.red,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${_contrastRatio.toStringAsFixed(2)}:1',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _meetsWCAGAAA
                        ? 'WCAG AAA'
                        : _meetsWCAGAA
                            ? 'WCAG AA'
                            : 'Below AA',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}

/// Screen for testing color contrast
class ColorContrastTestScreen extends StatefulWidget {
  const ColorContrastTestScreen({super.key});

  @override
  State<ColorContrastTestScreen> createState() =>
      _ColorContrastTestScreenState();
}

class _ColorContrastTestScreenState extends State<ColorContrastTestScreen> {
  final List<Color> _testColors = [
    Colors.black,
    Colors.white,
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.grey,
    Colors.teal,
  ];

  final List<Color> _backgroundColors = [
    Colors.white,
    Colors.black,
    Colors.grey[100]!,
    Colors.grey[800]!,
    Colors.blue[50]!,
    Colors.blue[900]!,
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Color Contrast Testing'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Color Contrast Test Results',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              ..._testColors.expand(
                (foreground) => _backgroundColors.map(
                  (background) => ColorContrastTester(
                    foreground: foreground,
                    background: background,
                    label:
                        '${_getColorName(foreground)} on ${_getColorName(background)}',
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Theme Contrast Report',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    ColorContrastTesting.generateContrastReport(
                      Theme.of(context),
                    ),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  String _getColorName(Color color) {
    if (color == Colors.black) return 'Black';
    if (color == Colors.white) return 'White';
    if (color == Colors.red) return 'Red';
    if (color == Colors.green) return 'Green';
    if (color == Colors.blue) return 'Blue';
    if (color == Colors.yellow) return 'Yellow';
    if (color == Colors.orange) return 'Orange';
    if (color == Colors.purple) return 'Purple';
    if (color == Colors.grey) return 'Grey';
    if (color == Colors.teal) return 'Teal';
    return 'Custom';
  }
}

/// Mixin for adding contrast testing to widgets
mixin ContrastTestingMixin {
  /// Test contrast for a widget's colors
  bool testWidgetContrast(Color foreground, Color background) =>
      ColorContrastTesting.meetsWCAGAA(foreground, background);

  /// Get accessible text color for a background
  Color getAccessibleTextColor(Color background) =>
      ColorContrastTesting.findAccessibleTextColor(background);

  /// Generate accessible color palette
  List<Color> generateAccessiblePalette(Color baseColor) =>
      ColorContrastTesting.generateAccessiblePalette(baseColor);
}

/// Provider for color contrast testing
class ColorContrastProvider {
  factory ColorContrastProvider() => _instance;
  ColorContrastProvider._internal();
  static final ColorContrastProvider _instance =
      ColorContrastProvider._internal();

  /// Test a color combination
  bool testContrast(Color foreground, Color background) =>
      ColorContrastTesting.meetsWCAGAA(foreground, background);

  /// Get contrast ratio
  double getContrastRatio(Color foreground, Color background) =>
      ColorContrastTesting.calculateContrastRatio(foreground, background);

  /// Generate contrast report for current theme
  String generateThemeReport(ThemeData theme) =>
      ColorContrastTesting.generateContrastReport(theme);

  /// Test all color combinations in a list
  Map<String, bool> testColorCombinations(List<Color> colors) {
    final results = <String, bool>{};

    for (var i = 0; i < colors.length; i++) {
      for (var j = i + 1; j < colors.length; j++) {
        final key = 'Color $i vs Color $j';
        results[key] = ColorContrastTesting.meetsWCAGAA(colors[i], colors[j]);
      }
    }

    return results;
  }
}
