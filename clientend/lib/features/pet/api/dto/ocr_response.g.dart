// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ocr_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OcrResponse _$OcrResponseFromJson(Map<String, dynamic> json) => _OcrResponse(
  status: json['status'] as String,
  message: json['message'] as String,
  data: OcrResponseData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$OcrResponseToJson(_OcrResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

_OcrResponseData _$OcrResponseDataFromJson(Map<String, dynamic> json) =>
    _OcrResponseData(
      date: json['date'] as String,
      diagnosis: json['diagnosis'] as String,
      notes: json['notes'] as String,
      doctorName: json['doctorName'] as String,
      hospitalName: json['hospitalName'] as String,
      examinations:
          (json['examinations'] as List<dynamic>)
              .map((e) => ExaminationDto.fromJson(e as Map<String, dynamic>))
              .toList(),
      medications:
          (json['medications'] as List<dynamic>)
              .map((e) => MedicationDto.fromJson(e as Map<String, dynamic>))
              .toList(),
      vaccinations:
          (json['vaccinations'] as List<dynamic>)
              .map((e) => VaccinationDto.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$OcrResponseDataToJson(_OcrResponseData instance) =>
    <String, dynamic>{
      'date': instance.date,
      'diagnosis': instance.diagnosis,
      'notes': instance.notes,
      'doctorName': instance.doctorName,
      'hospitalName': instance.hospitalName,
      'examinations': instance.examinations,
      'medications': instance.medications,
      'vaccinations': instance.vaccinations,
    };

_ExaminationDto _$ExaminationDtoFromJson(Map<String, dynamic> json) =>
    _ExaminationDto(
      type: json['type'] as String,
      key: json['key'] as String,
      value: json['value'] as String,
    );

Map<String, dynamic> _$ExaminationDtoToJson(_ExaminationDto instance) =>
    <String, dynamic>{
      'type': instance.type,
      'key': instance.key,
      'value': instance.value,
    };

_MedicationDto _$MedicationDtoFromJson(Map<String, dynamic> json) =>
    _MedicationDto(key: json['key'] as String, value: json['value'] as String);

Map<String, dynamic> _$MedicationDtoToJson(_MedicationDto instance) =>
    <String, dynamic>{'key': instance.key, 'value': instance.value};

_VaccinationDto _$VaccinationDtoFromJson(Map<String, dynamic> json) =>
    _VaccinationDto(key: json['key'] as String, value: json['value'] as String);

Map<String, dynamic> _$VaccinationDtoToJson(_VaccinationDto instance) =>
    <String, dynamic>{'key': instance.key, 'value': instance.value};
