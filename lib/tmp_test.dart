import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:appoint/utils/datetime_converter.dart';

part 'tmp_test.freezed.dart';
part 'tmp_test.g.dart';

@freezed
class Tmp with _$Tmp {
  factory Tmp({
    required String id,
    @DateTimeConverter() required DateTime time,
  }) = _Tmp;

  factory Tmp.fromJson(Map<String, dynamic> json) => _$TmpFromJson(json);
}
