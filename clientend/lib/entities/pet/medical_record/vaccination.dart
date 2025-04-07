import 'package:freezed_annotation/freezed_annotation.dart';

part 'vaccination.freezed.dart';

@freezed
abstract class Vaccination with _$Vaccination {
  const factory Vaccination({String? key, String? value}) = _Vaccination;
}
