import 'package:appoint/theme/app_colors.dart';
import 'package:appoint/theme/app_theme.dart';
import 'package:appoint/theme/sample_palettes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Holds the currently selected palette and theme mode.
class ThemeState {
  const ThemeState({required this.palette, required this.mode});
  final AppPalette palette;
  final ThemeMode mode;

  ThemeState copyWith({AppPalette? palette, final ThemeMode? mode}) =>
      ThemeState(
        palette: palette ?? this.palette,
        mode: mode ?? this.mode,
      );
}

class ThemeNotifier extends StateNotifier<ThemeState> {
  ThemeNotifier()
      : super(
            const ThemeState(palette: AppPalette.blue, mode: ThemeMode.system),);

  void setPalette(AppPalette palette) {
    state = state.copyWith(palette: palette);
  }

  void setMode(ThemeMode mode) {
    state = state.copyWith(mode: mode);
  }
}

final themeNotifierProvider =
    StateNotifierProvider<ThemeNotifier, ThemeState>((ref) => ThemeNotifier());

/// Provides the light [ThemeData] based on the selected palette.
final lightThemeProvider = Provider<ThemeData>((ref) {
  final state = ref.watch(themeNotifierProvider);
  final seed = paletteSeeds[state.palette] ?? AppColors.defaultSeed;
  return AppTheme.lightTheme(seed);
});

/// Provides the dark [ThemeData] based on the selected palette.
final darkThemeProvider = Provider<ThemeData>((ref) {
  final state = ref.watch(themeNotifierProvider);
  final seed = paletteSeeds[state.palette] ?? AppColors.defaultSeed;
  return AppTheme.darkTheme(seed);
});

/// Exposes the current [ThemeMode].
final themeModeProvider = Provider<ThemeMode>((ref) => ref.watch(themeNotifierProvider).mode);
