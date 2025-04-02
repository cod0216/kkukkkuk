import 'dart:convert';

import 'package:kkuk_kkuk/domain/entities/pet/pet_medical_record.dart';
import 'package:kkuk_kkuk/domain/repositories/blockchain/registry_contract_repository_interface.dart';

/// 블록체인 컨트랙트에서 반려동물 진료 기록을 조회하는 유스케이스
///
/// 반려동물 주소를 입력받아 블록체인에 저장된 진료 기록을 조회합니다.
class GetMedicalRecordsFromBlockchainUseCase {
  final IRegistryContractRepository _repository;

  GetMedicalRecordsFromBlockchainUseCase(this._repository);

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
      if (key.startsWith('medical_record_')) {
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
    // 타임스탬프 추출 (recordKey에서 medical_record_TIMESTAMP_ 형식)
    int timestamp = 0;
    try {
      final parts = recordKey.split('_');
      if (parts.length >= 3) {
        timestamp = int.parse(parts[2]);
      }
    } catch (e) {
      print('타임스탬프 추출 오류: $e');
    }

    // 타임스탬프로부터 날짜 생성 (초 단위)
    final treatmentDate =
        timestamp > 0
            ? DateTime.fromMillisecondsSinceEpoch(timestamp * 1000)
            : DateTime.now();

    // 약물 정보 추출
    List<String> medications = [];
    if (recordData['treatments'] != null &&
        recordData['treatments']['medications'] != null) {
      medications = List<String>.from(recordData['treatments']['medications']);
    }

    // 예방접종 정보 추출
    List<String> vaccinations = [];
    if (recordData['treatments'] != null &&
        recordData['treatments']['vaccinations'] != null) {
      vaccinations = List<String>.from(
        recordData['treatments']['vaccinations'],
      );
    }

    return PetMedicalRecord(
      treatmentDate: treatmentDate,
      recordType: '진료', // 기본값
      medication: medications.isNotEmpty ? medications.join(', ') : null,
      vaccination: vaccinations.isNotEmpty ? vaccinations.join(', ') : null,
      xRayUrl: null, // 블록체인 데이터에 X-ray URL이 없음
      veterinarian: recordData['doctorName'] ?? '',
      petName: '', // 블록체인 데이터에 펫 이름이 없음
      petGender: '', // 블록체인 데이터에 펫 성별이 없음
      guardianName: '', // 블록체인 데이터에 보호자 이름이 없음
      treatmentDetails: recordData['diagnosis'] ?? '',
      memo: recordData['notes'],
    );
  }
}
