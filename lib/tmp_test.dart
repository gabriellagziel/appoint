import 'package:freezed_annotation/freezed_annotation.dart';

part 'tmp_test.freezed.dart';
part 'tmp_test.g.dart';

@freezed
class Tmp with _$Tmp {
  const factory Tmp({
    required String id,
    required DateTime time,
  }) = _Tmp;

  factory Tmp.fromJson(Map<String, dynamic> json) => _$TmpFromJson(json);
}
