import 'package:flutter/material.dart';

/// Predefined color palettes that can be selected at runtime.
enum AppPalette { blue, green, orange }

/// Mapping of palettes to their seed colors.
const Map<AppPalette, Color> paletteSeeds = {
  AppPalette.blue: Colors.blue,
  AppPalette.green: Colors.green,
  AppPalette.orange: Colors.deepOrange,
};
