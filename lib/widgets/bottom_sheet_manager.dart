import 'package:flutter/material.dart';

/// Utility for displaying consistent modal bottom sheets across the app.
class BottomSheetManager {
  /// Shows a modal bottom sheet with the given [child] widget.
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    bool isDismissible = true,
    bool useSafeArea = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      useSafeArea: useSafeArea,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: child,
      ),
    );
  }
}

