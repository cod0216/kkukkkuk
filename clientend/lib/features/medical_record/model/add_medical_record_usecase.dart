import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kkuk_kkuk/entities/pet/medical_record/medical_record.dart';
import 'package:kkuk_kkuk/features/pet/api/repositories/pet_repository_interface.dart';
import 'package:web3dart/web3dart.dart';

class AddMedicalRecordUseCase {
  static const String _privateKeyKey = 'eth_private_key';
  final IPetRepository _repository;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  AddMedicalRecordUseCase(this._repository);

  /// 반려동물 진료 기록 추가
  ///
  /// [petDid] - 반려동물 DID (블록체인 주소)
  /// [record] - 추가할 진료 기록 객체
  Future<String> execute({
    required String petDid,
    required MedicalRecord record,
  }) async {
    try {
      // 개인 키 가져오기
      final privateKeyHex = await _secureStorage.read(key: _privateKeyKey);
      if (privateKeyHex == null || privateKeyHex.isEmpty) {
        throw Exception('개인 키를 찾을 수 없습니다. 다시 로그인해주세요.');
      }

      // DID에서 이더리움 주소 추출
      final petAddress = _extractAddressFromDid(petDid);

      // 자격 증명 생성
      final credentials = EthPrivateKey.fromHex(privateKeyHex);

      // 검사 결과를 JSON으로 변환
      final examinationsJson = jsonEncode(
        record.examinations
            .map((e) => {'type': e.type, 'key': e.key, 'value': e.value})
            .toList(),
      );

      // 약물 정보를 JSON으로 변환
      final medicationsJson = jsonEncode(
        record.medications
            .map((med) => {'key': med.key, 'value': med.value})
            .toList(),
      );

      // 예방 접종 정보를 JSON으로 변환
      final vaccinationsJson = jsonEncode(
        record.vaccinations
            .map((vac) => {'key': vac.key, 'value': vac.value})
            .toList(),
      );

      // 사진 URL을 JSON으로 변환
      final picturesJson = jsonEncode(record.pictures);

      // 레포지토리 메서드 호출
      return await _repository.addMedicalRecord(
        credentials: credentials,
        petAddress: petAddress,
        diagnosis: record.diagnosis,
        hospitalName: record.hospitalName,
        doctorName: record.veterinarian,
        notes: record.memo ?? '',
        examinationsJson: examinationsJson,
        medicationsJson: medicationsJson,
        vaccinationsJson: vaccinationsJson,
        picturesJson: picturesJson,
        status: record.status,
        flagCertificated: record.flagCertificated,
      );
    } catch (e) {
      throw Exception('진료 기록 추가에 실패했습니다: $e');
    }
  }

  /// DID 문자열에서 이더리움 주소 추출
  /// 예: "did:pet:0x123..." -> "0x123..."
  String _extractAddressFromDid(String did) {
    // DID가 이미 이더리움 주소 형식인지 확인
    if (did.startsWith('0x')) {
      return did;
    }

    // did:pet: 접두사 제거
    if (did.startsWith('did:pet:')) {
      return did.substring(8);
    }

    // 형식이 맞지 않으면 원래 값 반환
    return did;
  }
}
