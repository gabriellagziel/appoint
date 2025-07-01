import 'package:json_annotation/json_annotation.dart';

part 'admin_user.g.dart';

@JsonSerializable()
class AdminUser {
  final String uid;
  final String email;
  final String displayName;
  final String role;

  AdminUser({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.role,
  });

  factory AdminUser.fromJson(final Map<String, dynamic> json) =>
      _$AdminUserFromJson(json);

  Map<String, dynamic> toJson() => _$AdminUserToJson(this);
}
