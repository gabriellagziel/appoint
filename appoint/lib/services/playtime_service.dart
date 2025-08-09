  // MARK: - Web-Safe Auth Methods
  /// Get current user safely (web-compatible)
  User? get currentUser {
    return AuthService.currentUser;
  }

  /// Get current user ID safely (web-compatible)
  String? get currentUserId {
    return AuthService.currentUserId;
  }
