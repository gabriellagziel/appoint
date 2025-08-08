  // MARK: - Web-Safe Auth Methods
  /// Get current user safely (web-compatible)
  static User? get currentUser {
    return AuthService.currentUser;
  }

  /// Get current user ID safely (web-compatible)
  static String? get currentUserId {
    return AuthService.currentUserId;
  }
