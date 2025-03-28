import 'package:web3dart/web3dart.dart';

/// 반려동물 공유 컨트랙트 레포지토리 인터페이스
///
/// 반려동물 정보 공유 컨트랙트와 상호작용하기 위한 메서드를 정의합니다.
abstract class ISharingContractRepository {
  /// 공유 요청 생성
  Future<String> createSharingRequest({
    required Credentials credentials,
    required String petAddress,
    required String recipientAddress,
    required String scope,
    required int sharingPeriod,
  });

  /// 공유 요청 수락
  Future<String> acceptSharingRequest({
    required Credentials credentials,
    required String requestId,
  });

  /// 공유 요청 거절
  Future<String> rejectSharingRequest({
    required Credentials credentials,
    required String requestId,
  });

  /// 공유 요청 취소
  Future<String> cancelSharingRequest({
    required Credentials credentials,
    required String requestId,
  });

  /// 공유 접근 권한 취소
  Future<String> revokeSharingAccess({
    required Credentials credentials,
    required String petAddress,
    required String userAddress,
  });

  /// 사용자의 공유 요청 목록 조회
  Future<List<Map<String, dynamic>>> getSharingRequests(String userAddress);

  /// 사용자와 공유된 반려동물 목록 조회
  Future<List<String>> getSharedPets(String userAddress);

  /// 반려동물 공유 상태 조회
  Future<Map<String, dynamic>> getPetSharingStatus({
    required String petAddress,
    required String userAddress,
  });

  /// 공유 권한 확인
  Future<bool> checkSharingPermission({
    required String petAddress,
    required String userAddress,
  });

  /// 공유 범위 업데이트
  Future<String> updateSharingScope({
    required Credentials credentials,
    required String petAddress,
    required String userAddress,
    required String newScope,
  });

  /// 공유 기간 연장
  Future<String> extendSharingPeriod({
    required Credentials credentials,
    required String petAddress,
    required String userAddress,
    required int additionalTime,
  });
}
