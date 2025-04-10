import 'package:freezed_annotation/freezed_annotation.dart';

part 'hospital.freezed.dart';
part 'hospital.g.dart';

@freezed
abstract class Hospital with _$Hospital {
  const factory Hospital({
    required int id,
    required String name,
    required String address,
    @JsonKey(name: 'phone_number') String? phoneNumber,
    @JsonKey(name: 'x_axis') required double xAxis,  // 경도 (longitude)
    @JsonKey(name: 'y_axis') required double yAxis,  // 위도 (latitude)
  }) = _Hospital;

  factory Hospital.fromJson(Map<String, dynamic> json) => _$HospitalFromJson(json);
}