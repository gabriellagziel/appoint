import 'package:flutter/material.dart';

/// Service for showing UI notifications (snackbars, dialogs, etc.)
abstract class UINotificationService {
  /// Show an informational message to the user
  void showInfo(String message);

  /// Show a warning message to the user
  void showWarning(String message);

  /// Show an error message to the user
  void showError(String message);

  /// Show a success message to the user
  void showSuccess(String message);
}

/// Implementation using ScaffoldMessenger for showing snackbars
class ScaffoldNotificationService implements UINotificationService {
  ScaffoldNotificationService(this.messengerKey);
  final GlobalKey<ScaffoldMessengerState> messengerKey;

  @override
  void showInfo(String message) {
    _showSnack(message, Colors.blue, Icons.info);
  }

  @override
  void showWarning(String message) {
    _showSnack(message, Colors.orange, Icons.warning);
  }

  @override
  void showError(String message) {
    _showSnack(message, Colors.red, Icons.error);
  }

  @override
  void showSuccess(String message) {
    _showSnack(message, Colors.green, Icons.check_circle);
  }

  void _showSnack(String message, Color color, IconData icon) {
    messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: color,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            messengerKey.currentState?.hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}

/// Mock implementation for testing
class MockNotificationService implements UINotificationService {
  final List<String> _infoMessages = [];
  final List<String> _warningMessages = [];
  final List<String> _errorMessages = [];
  final List<String> _successMessages = [];

  List<String> get infoMessages => List.unmodifiable(_infoMessages);
  List<String> get warningMessages => List.unmodifiable(_warningMessages);
  List<String> get errorMessages => List.unmodifiable(_errorMessages);
  List<String> get successMessages => List.unmodifiable(_successMessages);

  void clear() {
    _infoMessages.clear();
    _warningMessages.clear();
    _errorMessages.clear();
    _successMessages.clear();
  }

  @override
  void showInfo(String message) {
    _infoMessages.add(message);
  }

  @override
  void showWarning(String message) {
    _warningMessages.add(message);
  }

  @override
  void showError(String message) {
    _errorMessages.add(message);
  }

  @override
  void showSuccess(String message) {
    _successMessages.add(message);
  }
}
