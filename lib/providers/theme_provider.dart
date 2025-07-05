import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appoint/theme/app_theme.dart';
import 'package:appoint/theme/sample_palettes.dart';
import 'package:appoint/theme/app_colors.dart';

/// Holds the currently selected palette and theme mode.
class ThemeState {
  final AppPalette palette;
  final ThemeMode mode;
  const ThemeState({required this.palette, required this.mode});

  ThemeState copyWith({final AppPalette? palette, final ThemeMode? mode}) =>
      ThemeState(
        palette: palette ?? this.palette,
        mode: mode ?? this.mode,
      );
}

class ThemeNotifier extends StateNotifier<ThemeState> {
  ThemeNotifier()
      : super(
            const ThemeState(palette: AppPalette.blue, mode: ThemeMode.system));

  void setPalette(final AppPalette palette) {
    state = state.copyWith(palette: palette);
  }

  void setMode(final ThemeMode mode) {
    state = state.copyWith(mode: mode);
  }
}

final themeNotifierProvider =
    StateNotifierProvider<ThemeNotifier, ThemeState>((final ref) {
  return ThemeNotifier();
});

/// Provides the light [ThemeData] based on the selected palette.
final lightThemeProvider = Provider<ThemeData>((final ref) {
  final state = ref.watch(themeNotifierProvider);
  final seed = paletteSeeds[state.palette] ?? AppColors.defaultSeed;
  return AppTheme.lightTheme(seed);
});

/// Provides the dark [ThemeData] based on the selected palette.
final darkThemeProvider = Provider<ThemeData>((final ref) {
  final state = ref.watch(themeNotifierProvider);
  final seed = paletteSeeds[state.palette] ?? AppColors.defaultSeed;
  return AppTheme.darkTheme(seed);
});

/// Exposes the current [ThemeMode].
final themeModeProvider = Provider<ThemeMode>((final ref) {
  return ref.watch(themeNotifierProvider).mode;
});
