import 'package:freezed_annotation/freezed_annotation.dart';

part 'vaccination.freezed.dart';

@freezed
abstract class Vaccination with _$Vaccination {
  const factory Vaccination({required String key, required String value}) =
      _Vaccination;
}
