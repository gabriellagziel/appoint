import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact.freezed.dart';
part 'contact.g.dart';

@freezed
class Contact with _$Contact {
  const factory Contact({
    required final String id,
    required final String displayName,
    final String? phoneNumber,
    final String? email,
    final String? location,
  }) = _Contact;
  const Contact._();

  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);

  // Getters for backward compatibility
  String? get phone => phoneNumber;
}
