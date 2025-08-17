import 'package:flutter/material.dart';

// Simple theme extensions with sane defaults, so UI code can rely on tokens
@immutable
class AppSpace extends ThemeExtension<AppSpace> {
  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;

  const AppSpace({
    this.xs = 4,
    this.sm = 8,
    this.md = 12,
    this.lg = 16,
    this.xl = 24,
  });

  static const AppSpace defaults = AppSpace();

  @override
  AppSpace copyWith(
      {double? xs, double? sm, double? md, double? lg, double? xl}) {
    return AppSpace(
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
    );
  }

  @override
  AppSpace lerp(ThemeExtension<AppSpace>? other, double t) {
    if (other is! AppSpace) return this;
    return AppSpace(
      xs: xs + (other.xs - xs) * t,
      sm: sm + (other.sm - sm) * t,
      md: md + (other.md - md) * t,
      lg: lg + (other.lg - lg) * t,
      xl: xl + (other.xl - xl) * t,
    );
  }
}

@immutable
class AppCorners extends ThemeExtension<AppCorners> {
  final double sm;
  final double md;
  final double lg;
  final double xl;

  const AppCorners({
    this.sm = 8,
    this.md = 12,
    this.lg = 16,
    this.xl = 20,
  });

  static const AppCorners defaults = AppCorners();

  @override
  AppCorners copyWith({double? sm, double? md, double? lg, double? xl}) {
    return AppCorners(
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
    );
  }

  @override
  AppCorners lerp(ThemeExtension<AppCorners>? other, double t) {
    if (other is! AppCorners) return this;
    return AppCorners(
      sm: sm + (other.sm - sm) * t,
      md: md + (other.md - md) * t,
      lg: lg + (other.lg - lg) * t,
      xl: xl + (other.xl - xl) * t,
    );
  }
}

// Fallback minimal themes since generated tokens are not present in CI
ThemeData buildLightTheme() {
  final scheme = ColorScheme.fromSeed(seedColor: Colors.blue);
  return ThemeData(
    colorScheme: scheme,
    useMaterial3: true,
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(44),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        side: BorderSide(color: scheme.outline),
        foregroundColor: scheme.primary,
        overlayColor: scheme.primary.withOpacity(0.06),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(44),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        foregroundColor: scheme.onPrimaryContainer,
      ),
    ),
    extensions: const <ThemeExtension<dynamic>>[
      AppSpace.defaults,
      AppCorners.defaults,
    ],
  );
}

ThemeData buildDarkTheme() {
  final scheme =
      ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark);
  return ThemeData(
    colorScheme: scheme,
    useMaterial3: true,
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(44),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        side: BorderSide(color: scheme.outline),
        foregroundColor: scheme.primary,
        overlayColor: scheme.primary.withOpacity(0.10),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(44),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        foregroundColor: scheme.onPrimaryContainer,
      ),
    ),
    extensions: const <ThemeExtension<dynamic>>[
      AppSpace.defaults,
      AppCorners.defaults,
    ],
  );
}
