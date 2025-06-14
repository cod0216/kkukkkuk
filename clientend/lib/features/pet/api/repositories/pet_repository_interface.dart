import 'package:kkuk_kkuk/entities/pet/pet.dart';
import 'package:kkuk_kkuk/entities/pet/breed.dart';
import 'package:web3dart/web3dart.dart';

/// 반려동물 레포지토리 인터페이스
///
/// 반려동물 관련 데이터 액세스를 위한 메서드를 정의합니다.
abstract class IPetRepository {
  /// 품종 목록 조회
  Future<List<Breed>> getBreeds(int speciesId);

  /// 품종 목록 조회
  Future<List<Breed>> getSpecies();

  /// 반려동물 목록 조회
  Future<List<Pet>> getPetList(String address);

  /// 반려동물 등록
  Future<Pet> registerPet(EthPrivateKey credentials, Pet pet);

  /// 반려동물 정보 수정
  Future<Pet> updatePet(EthPrivateKey credentials, Pet pet);

  /// 반려동물 삭제
  Future<bool> deletePet(EthPrivateKey credentials, String petAddress);

  /// 반려동물 속성 조회
  Future<Map<String, dynamic>> getAllAttributes(String petAddress);

  /// 반려동물 속성 설정
  Future<String> setAttribute({
    required Credentials credentials,
    required String petAddress,
    required String key,
    required String value,
  });

  /// 병원 추가 (공유 계약 생성)
  Future<String> addHospitalWithSharing({
    required Credentials credentials,
    required String petAddress,
    required String hospitalAddress,
    required String scope,
    required int sharingPeriod,
  });

  /// 진료 기록 추가 (공유 계약 생성)
  Future<String> addMedicalRecord({
    required Credentials credentials,
    required String petAddress,
    required String diagnosis,
    required String hospitalName,
    required String doctorName,
    required String notes,
    required String examinationsJson,
    required String medicationsJson,
    required String vaccinationsJson,
    required String picturesJson,
    required String status,
    required bool flagCertificated,
  });

  Future<Map<String, dynamic>> processMedicalRecordImage(
    Map<String, dynamic> ocrData,
  );

  Future<Map<String, dynamic>> getMedicalRecordWithUpdates(
    String petAddress, 
    String originalRecordKey
  );

  Future<List<String>> getPetOriginalRecords(String petAddress);
}
