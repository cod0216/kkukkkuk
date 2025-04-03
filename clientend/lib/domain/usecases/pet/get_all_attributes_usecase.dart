import 'dart:convert';

import 'package:kkuk_kkuk/domain/entities/pet/pet_medical_record.dart';
import 'package:kkuk_kkuk/domain/repositories/pet/pet_repository_interface.dart';

/// 블록체인 컨트랙트에서 반려동물 진료 기록을 조회하는 유스케이스
///
/// 반려동물 주소를 입력받아 블록체인에 저장된 진료 기록을 조회합니다.
class GetAllAtributesUseCase {
  final IPetRepository _repository;

  GetAllAtributesUseCase(this._repository);

  /// 블록체인에서 반려동물 진료 기록을 조회합니다.
  ///
  /// [petAddress] 반려동물 주소
  /// 반환값: 진료 기록 목록
  Future<List<PetMedicalRecord>> execute(String petAddress) async {
    try {
      // DID 형식(did:pet:0x...)에서 이더리움 주소 추출
      String cleanAddress = _extractEthereumAddress(petAddress);

      // 블록체인에서 반려동물 속성 조회
      final attributes = await _repository.getAllAttributes(cleanAddress);

      // 진료 기록 속성 필터링 및 변환
      final medicalRecords = _convertAttributesToMedicalRecords(attributes);

      return medicalRecords;
    } catch (e) {
      throw Exception('블록체인에서 진료 기록을 조회하는데 실패했습니다: $e');
    }
  }

  /// DID 형식의 주소에서 이더리움 주소 부분만 추출
  ///
  /// 예: "did:pet:0x184d1595e0943c5a6460c355613548b619b58ac5" -> "0x184d1595e0943c5a6460c355613548b619b58ac5"
  String _extractEthereumAddress(String address) {
    if (address.startsWith('did:pet:')) {
      return address.substring(8); // 'did:pet:' 제거 (8자)
    }
    return address; // 이미 이더리움 주소 형식이면 그대로 반환
  }

  /// 블록체인 속성을 진료 기록 객체로 변환하는 메서드
  ///
  /// [attributes] 블록체인에서 조회한 반려동물 속성
  /// 반환값: 변환된 진료 기록 목록
  List<PetMedicalRecord> _convertAttributesToMedicalRecords(
    Map<String, dynamic> attributes,
  ) {
    final List<PetMedicalRecord> records = [];

    print('attributes: $attributes');
    // 속성에서 진료 기록 데이터 추출 및 변환
    attributes.forEach((key, value) {
      if (key.startsWith('medical_')) {
        try {
          print('value: $value');
          // 블록체인에서 반환된 값은 Map 형태이므로 'value' 키에서 JSON 문자열을 추출
          final String jsonString = value['value'] as String;

          // JSON 문자열을 Map으로 변환
          final recordData = jsonDecode(jsonString);
          print(recordData);

          // 블록체인 데이터 형식을 PetMedicalRecord 형식으로 변환
          final record = _convertBlockchainRecordToPetMedicalRecord(
            recordData,
            key,
          );
          records.add(record);
        } catch (e) {
          print('진료 기록 변환 중 오류 발생: $e');
        }
      }
    });

    // 날짜 기준 내림차순 정렬
    records.sort((a, b) => b.treatmentDate.compareTo(a.treatmentDate));

    return records;
  }

  /// 블록체인 진료 기록 데이터를 PetMedicalRecord 객체로 변환
  PetMedicalRecord _convertBlockchainRecordToPetMedicalRecord(
    Map<String, dynamic> recordData,
    String recordKey,
  ) {
    // Extract timestamp from recordKey
    int timestamp = 0;
    try {
      final parts = recordKey.split('_');
      if (parts.length >= 3) {
        timestamp = int.parse(parts[2]);
      }
    } catch (e) {
      print('타임스탬프 추출 오류: $e');
    }

    final treatmentDate =
        timestamp > 0
            ? DateTime.fromMillisecondsSinceEpoch(timestamp * 1000)
            : DateTime.now();

    // Convert examinations
    final List<Examination> examinations = [];
    final List<Medication> medications = [];
    final List<Vaccination> vaccinations = [];

    if (recordData['treatments']?['examinations'] != null) {
      for (final exam in recordData['treatments']['examinations']) {
        examinations.add(
          Examination(
            type: exam['type'] ?? '',
            key: exam['key'] ?? '',
            value: exam['value'] ?? '',
          ),
        );
      }
    }

    if (recordData['treatments']?['medications'] != null) {
      for (final med in recordData['treatments']['medications']) {
        medications.add(
          Medication(key: med['key'] ?? '', value: med['value'] ?? ''),
        );
      }
    }

    if (recordData['treatments']?['vaccinations'] != null) {
      for (final vac in recordData['treatments']['vaccinations']) {
        vaccinations.add(
          Vaccination(key: vac['key'] ?? '', value: vac['value'] ?? ''),
        );
      }
    }

    return PetMedicalRecord(
      treatmentDate: treatmentDate,
      diagnosis: recordData['diagnosis'] ?? '',
      veterinarian: recordData['doctorName'] ?? '',
      hospitalName: recordData['hospitalName'] ?? '',
      hospitalAddress: recordData['hospitalAddress'] ?? '',
      examinations: examinations,
      medications: medications,
      vaccinations: vaccinations,
      memo: recordData['notes'],
      status: recordData['status'] ?? 'UNKNOWN',
      flagCertificated: recordData['flagCertificated'] ?? false,
      pictures: List<String>.from(recordData['pictures'] ?? []),
    );
  }
}
