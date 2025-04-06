import 'package:freezed_annotation/freezed_annotation.dart';

part 'medication.freezed.dart';

@freezed
abstract class Medication with _$Medication {
  const factory Medication({required String key, required String value}) =
      _Medication;
}
