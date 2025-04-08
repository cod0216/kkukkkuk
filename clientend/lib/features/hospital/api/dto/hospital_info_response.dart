import 'package:freezed_annotation/freezed_annotation.dart';

part 'hospital_info_response.freezed.dart';
part 'hospital_info_response.g.dart';

@freezed
abstract class HospitalInfoResponse with _$HospitalInfoResponse {
  const factory HospitalInfoResponse({
    required String status,
    required String message,
    required List<HospitalInfo> data,
  }) = _HospitalInfoResponse;

  factory HospitalInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$HospitalInfoResponseFromJson(json);
}

@freezed
abstract class HospitalInfo with _$HospitalInfo {
  const factory HospitalInfo({
    required int id,
    required String name,
    required String address,
    @JsonKey(name: 'phone_number') String? phoneNumber,
    @JsonKey(name: 'x_axis') required double xAxis,  // 경도 (longitude)
    @JsonKey(name: 'y_axis') required double yAxis,
  }) = _HospitalInfo;

  factory HospitalInfo.fromJson(Map<String, dynamic> json) => _$HospitalInfoFromJson(json);
}