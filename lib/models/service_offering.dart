import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_offering.freezed.dart';
part 'service_offering.g.dart';

@freezed
@JsonSerializable(explicitToJson: true)
class ServiceOffering with _$ServiceOffering {
  const factory ServiceOffering({
    required final String id,
    required final String businessId,
    required final String name,
    required final String description,
    required final double price,
    required final Duration duration,
    final String? category,
    final List<String>? staffIds,
    @Default(true) final bool isActive,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _ServiceOffering;

  factory ServiceOffering.fromJson(Map<String, dynamic> json) =>
      _$ServiceOfferingFromJson(json);
}
