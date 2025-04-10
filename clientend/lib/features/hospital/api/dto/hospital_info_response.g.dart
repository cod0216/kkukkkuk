// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hospital_info_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HospitalInfoResponse _$HospitalInfoResponseFromJson(
  Map<String, dynamic> json,
) => _HospitalInfoResponse(
  status: json['status'] as String,
  message: json['message'] as String,
  data:
      (json['data'] as List<dynamic>)
          .map((e) => HospitalInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$HospitalInfoResponseToJson(
  _HospitalInfoResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};

_HospitalInfo _$HospitalInfoFromJson(Map<String, dynamic> json) =>
    _HospitalInfo(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      address: json['address'] as String,
      phoneNumber: json['phone_number'] as String?,
      xAxis: (json['x_axis'] as num).toDouble(),
      yAxis: (json['y_axis'] as num).toDouble(),
      flagCertified: json['flag_certified'] as bool,
    );

Map<String, dynamic> _$HospitalInfoToJson(_HospitalInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'phone_number': instance.phoneNumber,
      'x_axis': instance.xAxis,
      'y_axis': instance.yAxis,
      'flag_certified': instance.flagCertified,
    };
