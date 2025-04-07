import 'package:freezed_annotation/freezed_annotation.dart';

part 'examination.freezed.dart';

@freezed
abstract class Examination with _$Examination {
  const factory Examination({String? type, String? key, String? value}) =
      _Examination;
}
