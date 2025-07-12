import 'package:flutter/material.dart';

extension SnackBarExtensions on BuildContext {
  void showSnackBar(String message, {final Color? backgroundColor}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }
}
