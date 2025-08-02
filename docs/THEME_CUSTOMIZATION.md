# Theme Customization Guide

This guide provides comprehensive instructions for customizing the APP-OINT application theme, including colors, typography, and dark/light mode support.

## Table of Contents

1. [Overview](#overview)
2. [Theme Structure](#theme-structure)
3. [Color System](#color-system)
4. [Typography](#typography)
5. [Dark/Light Mode](#darklight-mode)
6. [Custom Components](#custom-components)
7. [Best Practices](#best-practices)
8. [Examples](#examples)

## Overview

APP-OINT uses a comprehensive theming system built on Material Design 3 principles. The theme is centralized in the `lib/theme/` directory and provides consistent styling across the entire application.

### Key Features

- **Material Design 3**: Modern design system with dynamic color support
- **Dark/Light Mode**: Automatic theme switching based on system preferences
- **Customizable Colors**: Easy color scheme customization
- **Typography Scale**: Consistent text styling across the app
- **Component Themes**: Individual component theming support

## Theme Structure

### Directory Structure

```
lib/theme/
├── app_theme.dart          # Main theme configuration
├── app_colors.dart         # Color definitions
├── app_text_styles.dart    # Typography styles
├── app_dimensions.dart     # Spacing and sizing
├── app_shadows.dart        # Shadow definitions
├── app_animations.dart     # Animation configurations
└── themes/
    ├── light_theme.dart    # Light theme configuration
    ├── dark_theme.dart     # Dark theme configuration
    └── custom_theme.dart   # Custom theme examples
```

### Main Theme File

```dart
// lib/theme/app_theme.dart
class AppTheme {
  static ThemeData get lightTheme => _buildLightTheme();
  static ThemeData get darkTheme => _buildDarkTheme();
  
  static ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: AppColors.lightColorScheme,
      textTheme: AppTextStyles.textTheme,
      // ... other theme configurations
    );
  }
  
  static ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: AppColors.darkColorScheme,
      textTheme: AppTextStyles.textTheme,
      // ... other theme configurations
    );
  }
}
```

## Color System

### Color Definitions

```dart
// lib/theme/app_colors.dart
class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF6750A4);
  static const Color primaryContainer = Color(0xFFEADDFF);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFF21005D);
  
  // Secondary Colors
  static const Color secondary = Color(0xFF625B71);
  static const Color secondaryContainer = Color(0xFFE8DEF8);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSecondaryContainer = Color(0xFF1D192B);
  
  // Tertiary Colors
  static const Color tertiary = Color(0xFF7D5260);
  static const Color tertiaryContainer = Color(0xFFFFD8E4);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color onTertiaryContainer = Color(0xFF31111D);
  
  // Error Colors
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color onErrorContainer = Color(0xFF410002);
  
  // Neutral Colors
  static const Color surface = Color(0xFFFFFBFE);
  static const Color surfaceVariant = Color(0xFFE7E0EC);
  static const Color onSurface = Color(0xFF1C1B1F);
  static const Color onSurfaceVariant = Color(0xFF49454F);
  static const Color outline = Color(0xFF79747E);
  static const Color outlineVariant = Color(0xFFCAC4D0);
  
  // Background Colors
  static const Color background = Color(0xFFFFFBFE);
  static const Color onBackground = Color(0xFF1C1B1F);
  
  // Custom Brand Colors
  static const Color brandPrimary = Color(0xFF6750A4);
  static const Color brandSecondary = Color(0xFF625B71);
  static const Color brandAccent = Color(0xFF7D5260);
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, brandAccent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, tertiary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
```

### Color Schemes

```dart
// lib/theme/app_colors.dart (continued)
class AppColors {
  // Light Color Scheme
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primary,
    onPrimary: onPrimary,
    primaryContainer: primaryContainer,
    onPrimaryContainer: onPrimaryContainer,
    secondary: secondary,
    onSecondary: onSecondary,
    secondaryContainer: secondaryContainer,
    onSecondaryContainer: onSecondaryContainer,
    tertiary: tertiary,
    onTertiary: onTertiary,
    tertiaryContainer: tertiaryContainer,
    onTertiaryContainer: onTertiaryContainer,
    error: error,
    onError: onError,
    errorContainer: errorContainer,
    onErrorContainer: onErrorContainer,
    surface: surface,
    onSurface: onSurface,
    surfaceVariant: surfaceVariant,
    onSurfaceVariant: onSurfaceVariant,
    outline: outline,
    outlineVariant: outlineVariant,
    background: background,
    onBackground: onBackground,
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFF313033),
    onInverseSurface: Color(0xFFF4EFF4),
    inversePrimary: Color(0xFFD0BCFF),
    surfaceTint: primary,
  );
  
  // Dark Color Scheme
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFD0BCFF),
    onPrimary: Color(0xFF381E72),
    primaryContainer: Color(0xFF4F378B),
    onPrimaryContainer: Color(0xFFEADDFF),
    secondary: Color(0xFFCCC2DC),
    onSecondary: Color(0xFF332D41),
    secondaryContainer: Color(0xFF4A4458),
    onSecondaryContainer: Color(0xFFE8DEF8),
    tertiary: Color(0xFFEFB8C8),
    onTertiary: Color(0xFF492532),
    tertiaryContainer: Color(0xFF633B48),
    onTertiaryContainer: Color(0xFFFFD8E4),
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    surface: Color(0xFF1C1B1F),
    onSurface: Color(0xFFE6E1E5),
    surfaceVariant: Color(0xFF49454F),
    onSurfaceVariant: Color(0xFFCAC4D0),
    outline: Color(0xFF938F99),
    outlineVariant: Color(0xFF49454F),
    background: Color(0xFF1C1B1F),
    onBackground: Color(0xFFE6E1E5),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFFE6E1E5),
    onInverseSurface: Color(0xFF313033),
    inversePrimary: Color(0xFF6750A4),
    surfaceTint: Color(0xFFD0BCFF),
  );
}
```

### Custom Color Usage

```dart
// Using custom colors in widgets
class CustomWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Custom Styled Text',
        style: theme.textTheme.headlineMedium?.copyWith(
          color: AppColors.onPrimary,
        ),
      ),
    );
  }
}
```

## Typography

### Text Style Definitions

```dart
// lib/theme/app_text_styles.dart
class AppTextStyles {
  // Font Family
  static const String fontFamily = 'Roboto';
  
  // Display Styles
  static const TextStyle displayLarge = TextStyle(
    fontSize: 57,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
    height: 1.12,
  );
  
  static const TextStyle displayMedium = TextStyle(
    fontSize: 45,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.16,
  );
  
  static const TextStyle displaySmall = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.22,
  );
  
  // Headline Styles
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.25,
  );
  
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.29,
  );
  
  static const TextStyle headlineSmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.33,
  );
  
  // Title Styles
  static const TextStyle titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.27,
  );
  
  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    height: 1.5,
  );
  
  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
  );
  
  // Body Styles
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.5,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.43,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
  );
  
  // Label Styles
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
  );
  
  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.33,
  );
  
  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.45,
  );
  
  // Complete Text Theme
  static const TextTheme textTheme = TextTheme(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    displaySmall: displaySmall,
    headlineLarge: headlineLarge,
    headlineMedium: headlineMedium,
    headlineSmall: headlineSmall,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    titleSmall: titleSmall,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
    labelSmall: labelSmall,
  );
}
```

### Typography Usage

```dart
// Using typography in widgets
class TypographyExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Display Large',
          style: theme.textTheme.displayLarge,
        ),
        Text(
          'Headline Medium',
          style: theme.textTheme.headlineMedium,
        ),
        Text(
          'Body Large',
          style: theme.textTheme.bodyLarge,
        ),
        Text(
          'Label Medium',
          style: theme.textTheme.labelMedium,
        ),
      ],
    );
  }
}
```

## Dark/Light Mode

### Theme Provider

```dart
// lib/providers/theme_provider.dart
class ThemeProvider extends StateNotifier<ThemeMode> {
  ThemeProvider() : super(ThemeMode.system);
  
  void setThemeMode(ThemeMode mode) {
    state = mode;
  }
  
  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
  
  bool get isDarkMode => state == ThemeMode.dark;
  bool get isLightMode => state == ThemeMode.light;
  bool get isSystemMode => state == ThemeMode.system;
}

final themeProvider = StateNotifierProvider<ThemeProvider, ThemeMode>((ref) {
  return ThemeProvider();
});
```

### Theme Configuration

```dart
// lib/main.dart
class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    
    return MaterialApp(
      title: 'APP-OINT',
      themeMode: themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: HomeScreen(),
    );
  }
}
```

### Theme Toggle Widget

```dart
// lib/widgets/theme_toggle.dart
class ThemeToggle extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final themeProvider = ref.read(themeProvider.notifier);
    
    return IconButton(
      icon: Icon(
        themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
      ),
      onPressed: () => themeProvider.toggleTheme(),
    );
  }
}
```

### System Theme Detection

```dart
// lib/widgets/system_theme_detector.dart
class SystemThemeDetector extends ConsumerStatefulWidget {
  final Widget child;
  
  const SystemThemeDetector({required this.child});
  
  @override
  ConsumerState<SystemThemeDetector> createState() => _SystemThemeDetectorState();
}

class _SystemThemeDetectorState extends ConsumerState<SystemThemeDetector>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }
  
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  
  @override
  void didChangePlatformBrightness() {
    // Handle system theme changes
    final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    // Update theme if in system mode
  }
  
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
```

## Custom Components

### Custom Button Styles

```dart
// lib/widgets/custom_button.dart
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonStyle? style;
  final bool isLoading;
  
  const CustomButton({
    required this.text,
    this.onPressed,
    this.style,
    this.isLoading = false,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: style ?? _getDefaultStyle(theme),
      child: isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.colorScheme.onPrimary,
                ),
              ),
            )
          : Text(text),
    );
  }
  
  ButtonStyle _getDefaultStyle(ThemeData theme) {
    return ElevatedButton.styleFrom(
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.onPrimary,
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 2,
    );
  }
}
```

### Custom Card Styles

```dart
// lib/widgets/custom_card.dart
class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? elevation;
  final BorderRadius? borderRadius;
  
  const CustomCard({
    required this.child,
    this.padding,
    this.elevation,
    this.borderRadius,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: elevation ?? 2,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(12),
      ),
      child: Padding(
        padding: padding ?? EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}
```

## Best Practices

### 1. Use Theme Colors

Always use theme colors instead of hardcoded colors:

```dart
// ✅ Good
Container(
  color: theme.colorScheme.primary,
  child: Text(
    'Text',
    style: TextStyle(color: theme.colorScheme.onPrimary),
  ),
)

// ❌ Bad
Container(
  color: Colors.purple,
  child: Text(
    'Text',
    style: TextStyle(color: Colors.white),
  ),
)
```

### 2. Responsive Typography

Use theme text styles for consistent typography:

```dart
// ✅ Good
Text(
  'Title',
  style: theme.textTheme.headlineMedium,
)

// ❌ Bad
Text(
  'Title',
  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
)
```

### 3. Dark Mode Support

Ensure all custom colors work in both light and dark modes:

```dart
// ✅ Good
Container(
  color: theme.colorScheme.surface,
  child: Text(
    'Text',
    style: TextStyle(color: theme.colorScheme.onSurface),
  ),
)

// ❌ Bad
Container(
  color: Colors.white,
  child: Text(
    'Text',
    style: TextStyle(color: Colors.black),
  ),
)
```

### 4. Consistent Spacing

Use theme spacing values for consistent layout:

```dart
// ✅ Good
Padding(
  padding: EdgeInsets.all(theme.spacing.medium),
  child: child,
)

// ❌ Bad
Padding(
  padding: EdgeInsets.all(16),
  child: child,
)
```

## Examples

### Complete Theme Example

```dart
// lib/theme/custom_theme.dart
class CustomTheme {
  static ThemeData get customLightTheme {
    return AppTheme.lightTheme.copyWith(
      colorScheme: AppColors.lightColorScheme.copyWith(
        primary: Color(0xFF1976D2),
        secondary: Color(0xFF424242),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFF1976D2),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF1976D2),
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
  
  static ThemeData get customDarkTheme {
    return AppTheme.darkTheme.copyWith(
      colorScheme: AppColors.darkColorScheme.copyWith(
        primary: Color(0xFF90CAF9),
        secondary: Color(0xFFBDBDBD),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFF121212),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
    );
  }
}
```

### Theme Extension

```dart
// lib/theme/theme_extension.dart
extension ThemeExtension on ThemeData {
  // Custom getters for commonly used values
  ColorScheme get colors => colorScheme;
  TextTheme get text => textTheme;
  
  // Custom spacing
  EdgeInsets get defaultPadding => EdgeInsets.all(16);
  EdgeInsets get smallPadding => EdgeInsets.all(8);
  EdgeInsets get largePadding => EdgeInsets.all(24);
  
  // Custom border radius
  BorderRadius get defaultBorderRadius => BorderRadius.circular(8);
  BorderRadius get largeBorderRadius => BorderRadius.circular(16);
  
  // Custom shadows
  List<BoxShadow> get defaultShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];
}
```

### Usage in Widgets

```dart
// Example widget using theme
class ThemedWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: theme.defaultPadding,
      decoration: BoxDecoration(
        color: theme.colors.surface,
        borderRadius: theme.defaultBorderRadius,
        boxShadow: theme.defaultShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Title',
            style: theme.text.headlineMedium?.copyWith(
              color: theme.colors.onSurface,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Description',
            style: theme.text.bodyMedium?.copyWith(
              color: theme.colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
```

## Conclusion

This theme customization guide provides a comprehensive approach to styling the APP-OINT application. By following these guidelines, you can create a consistent, accessible, and visually appealing user interface that works seamlessly across different devices and user preferences.

For additional customization options or questions, please refer to the Material Design 3 documentation or create an issue in the repository. 