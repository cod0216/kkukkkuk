import 'package:freezed_annotation/freezed_annotation.dart';

part 'ocr_response.freezed.dart';
part 'ocr_response.g.dart';

/// OCR 데이터 응답 DTO
@freezed
abstract class OcrResponse with _$OcrResponse {
  const factory OcrResponse({
    required String status,
    required String message,
    required OcrResponseData data,
  }) = _OcrResponse;

  factory OcrResponse.fromJson(Map<String, dynamic> json) =>
      _$OcrResponseFromJson(json);
}

@freezed
abstract class OcrResponseData with _$OcrResponseData {
  const factory OcrResponseData({
    required String date,
    required String diagnosis,
    required String notes,
    required String doctorName,
    required String hospitalName,
    required List<ExaminationDto> examinations,
    required List<MedicationDto> medications,
    required List<VaccinationDto> vaccinations,
  }) = _OcrResponseData;

  factory OcrResponseData.fromJson(Map<String, dynamic> json) =>
      _$OcrResponseDataFromJson(json);
}

@freezed
abstract class ExaminationDto with _$ExaminationDto {
  const factory ExaminationDto({
    required String type,
    required String key,
    required String value,
  }) = _ExaminationDto;

  factory ExaminationDto.fromJson(Map<String, dynamic> json) =>
      _$ExaminationDtoFromJson(json);
}

@freezed
abstract class MedicationDto with _$MedicationDto {
  const factory MedicationDto({required String key, required String value}) =
      _MedicationDto;

  factory MedicationDto.fromJson(Map<String, dynamic> json) =>
      _$MedicationDtoFromJson(json);
}

@freezed
abstract class VaccinationDto with _$VaccinationDto {
  const factory VaccinationDto({required String key, required String value}) =
      _VaccinationDto;

  factory VaccinationDto.fromJson(Map<String, dynamic> json) =>
      _$VaccinationDtoFromJson(json);
}
