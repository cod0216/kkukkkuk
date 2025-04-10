// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hospital.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Hospital _$HospitalFromJson(Map<String, dynamic> json) => _Hospital(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  address: json['address'] as String,
  phoneNumber: json['phone_number'] as String?,
  xAxis: (json['x_axis'] as num).toDouble(),
  yAxis: (json['y_axis'] as num).toDouble(),
);

Map<String, dynamic> _$HospitalToJson(_Hospital instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'address': instance.address,
  'phone_number': instance.phoneNumber,
  'x_axis': instance.xAxis,
  'y_axis': instance.yAxis,
};
