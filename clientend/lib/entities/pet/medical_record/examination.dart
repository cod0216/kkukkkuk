import 'package:freezed_annotation/freezed_annotation.dart';

part 'examination.freezed.dart';

@freezed
abstract class Examination with _$Examination {
  const factory Examination({
    required String type,
    required String key,
    required String value,
  }) = _Examination;
}
