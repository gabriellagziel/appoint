
/// Simplified user model built from Firebase custom claims.
class AppUser {
  final String uid;
  final String? email;
  final String role;
  final String? studioId;
  final String? businessProfileId;

  const AppUser({
    required this.uid,
    this.email,
    required this.role,
    this.studioId,
    this.businessProfileId,
  });
}

