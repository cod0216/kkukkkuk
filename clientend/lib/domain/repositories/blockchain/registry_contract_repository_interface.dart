import 'package:web3dart/web3dart.dart';

/// 반려동물 레지스트리 컨트랙트 레포지토리 인터페이스
///
/// 반려동물 DID 레지스트리 컨트랙트와 상호작용하기 위한 메서드를 정의합니다.
abstract class IRegistryContractRepository {
  /// 반려동물 존재 여부 확인
  Future<bool> petExists(String petAddress);

  /// 반려동물 속성 조회
  Future<Map<String, dynamic>> getAllAttributes(String petAddress);

  /// 병원 추가 (공유 계약 생성)
  Future<String> addHospitalWithSharing({
    required Credentials credentials,
    required String petAddress,
    required String hospitalAddress,
    required String scope,
    required int sharingPeriod,
  });

  /// 병원 제거
  Future<String> removeHospital({
    required Credentials credentials,
    required String petAddress,
    required String hospitalAddress,
  });

  /// 공유 계약 취소
  Future<String> revokeSharingAgreement({
    required Credentials credentials,
    required String petAddress,
    required String hospitalAddress,
  });

  /// 공유 계약 상세 정보 조회
  Future<Map<String, dynamic>> getAgreementDetails({
    required String petAddress,
    required String hospitalAddress,
  });

  /// 반려동물의 병원 목록 조회
  Future<List<String>> getPetHospitals(String petAddress);

  /// 병원의 반려동물 목록 조회
  Future<List<String>> getHospitalPets(String hospitalAddress);

  /// 공유 권한 확인
  Future<bool> checkSharingPermission({
    required String petAddress,
    required String userAddress,
  });
}
