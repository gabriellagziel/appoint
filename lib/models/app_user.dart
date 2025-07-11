/// Simplified user model built from Firebase custom claims.
class AppUser {

  const AppUser({
    required this.uid,
    required this.role, this.email,
    this.studioId,
    this.businessProfileId,
  });
  final String uid;
  final String? email;
  final String role;
  final String? studioId;
  final String? businessProfileId;
}
