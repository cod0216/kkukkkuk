import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/data/datasource/contracts/sharing_contract.dart';
import 'package:kkuk_kkuk/domain/repositories/sharing_contract_repository_interface.dart';
import 'package:web3dart/web3dart.dart';

class SharingContractRepository implements ISharingContractRepository {
  final SharingContract _sharingContract;

  SharingContractRepository(this._sharingContract);

  @override
  Future<String> createSharingRequest({
    required Credentials credentials,
    required String petAddress,
    required String recipientAddress,
    required String scope,
    required int sharingPeriod,
  }) async {
    try {
      // 공유 요청 생성
      final txHash = await _sharingContract.createSharingRequest(
        credentials: credentials,
        petAddress: petAddress,
        recipientAddress: recipientAddress,
        scope: scope,
        sharingPeriod: sharingPeriod,
      );

      print('공유 요청 생성 트랜잭션: $txHash');
      return txHash;
    } catch (e) {
      print('공유 요청 생성 오류: $e');
      throw Exception('공유 요청 생성에 실패했습니다: $e');
    }
  }

  @override
  Future<String> acceptSharingRequest({
    required Credentials credentials,
    required String requestId,
  }) async {
    try {
      // 공유 요청 수락
      final txHash = await _sharingContract.acceptSharingRequest(
        credentials: credentials,
        requestId: requestId,
      );

      print('공유 요청 수락 트랜잭션: $txHash');
      return txHash;
    } catch (e) {
      print('공유 요청 수락 오류: $e');
      throw Exception('공유 요청 수락에 실패했습니다: $e');
    }
  }

  @override
  Future<String> rejectSharingRequest({
    required Credentials credentials,
    required String requestId,
  }) async {
    try {
      // 공유 요청 거절
      final txHash = await _sharingContract.rejectSharingRequest(
        credentials: credentials,
        requestId: requestId,
      );

      print('공유 요청 거절 트랜잭션: $txHash');
      return txHash;
    } catch (e) {
      print('공유 요청 거절 오류: $e');
      throw Exception('공유 요청 거절에 실패했습니다: $e');
    }
  }

  @override
  Future<String> cancelSharingRequest({
    required Credentials credentials,
    required String requestId,
  }) async {
    try {
      // 공유 요청 취소
      final txHash = await _sharingContract.cancelSharingRequest(
        credentials: credentials,
        requestId: requestId,
      );

      print('공유 요청 취소 트랜잭션: $txHash');
      return txHash;
    } catch (e) {
      print('공유 요청 취소 오류: $e');
      throw Exception('공유 요청 취소에 실패했습니다: $e');
    }
  }

  @override
  Future<String> revokeSharingAccess({
    required Credentials credentials,
    required String petAddress,
    required String userAddress,
  }) async {
    try {
      // 공유 접근 권한 취소
      final txHash = await _sharingContract.revokeSharingAccess(
        credentials: credentials,
        petAddress: petAddress,
        userAddress: userAddress,
      );

      print('공유 접근 권한 취소 트랜잭션: $txHash');
      return txHash;
    } catch (e) {
      print('공유 접근 권한 취소 오류: $e');
      throw Exception('공유 접근 권한 취소에 실패했습니다: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getSharingRequests(
    String userAddress,
  ) async {
    try {
      // TODO: 사용자의 공유 요청 목록 조회 구현
      throw UnimplementedError('사용자의 공유 요청 목록 조회 기능이 구현되지 않았습니다.');
    } catch (e) {
      print('공유 요청 목록 조회 오류: $e');
      throw Exception('공유 요청 목록 조회에 실패했습니다: $e');
    }
  }

  @override
  Future<List<String>> getSharedPets(String userAddress) async {
    try {
      // TODO: 사용자와 공유된 반려동물 목록 조회 구현
      // 현재 PetSharingContract에 구현되어 있지 않은 경우 구현 필요
      throw UnimplementedError('사용자와 공유된 반려동물 목록 조회 기능이 구현되지 않았습니다.');
    } catch (e) {
      print('공유된 반려동물 목록 조회 오류: $e');
      throw Exception('공유된 반려동물 목록 조회에 실패했습니다: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getPetSharingStatus({
    required String petAddress,
    required String userAddress,
  }) async {
    try {
      // 공유 상태 조회
      return await _sharingContract.getPetSharingStatus(
        petAddress: petAddress,
        userAddress: userAddress,
      );
    } catch (e) {
      print('반려동물 공유 상태 조회 오류: $e');
      throw Exception('반려동물 공유 상태 조회에 실패했습니다: $e');
    }
  }

  @override
  Future<bool> checkSharingPermission({
    required String petAddress,
    required String userAddress,
  }) async {
    try {
      // 공유 권한 확인
      return await _sharingContract.checkSharingPermission(
        petAddress: petAddress,
        userAddress: userAddress,
      );
    } catch (e) {
      print('공유 권한 확인 오류: $e');
      throw Exception('공유 권한 확인에 실패했습니다: $e');
    }
  }

  @override
  Future<String> updateSharingScope({
    required Credentials credentials,
    required String petAddress,
    required String userAddress,
    required String newScope,
  }) async {
    try {
      // 공유 범위 업데이트
      return await _sharingContract.updateSharingScope(
        credentials: credentials,
        petAddress: petAddress,
        userAddress: userAddress,
        newScope: newScope,
      );
    } catch (e) {
      print('공유 범위 업데이트 오류: $e');
      throw Exception('공유 범위 업데이트에 실패했습니다: $e');
    }
  }

  @override
  Future<String> extendSharingPeriod({
    required Credentials credentials,
    required String petAddress,
    required String userAddress,
    required int additionalTime,
  }) async {
    try {
      // 공유 기간 연장
      return await _sharingContract.extendSharingPeriod(
        credentials: credentials,
        petAddress: petAddress,
        userAddress: userAddress,
        additionalPeriod: additionalTime,
      );
    } catch (e) {
      print('공유 기간 연장 오류: $e');
      throw Exception('공유 기간 연장에 실패했습니다: $e');
    }
  }
}

final sharingContractRepositoryProvider = Provider<ISharingContractRepository>((
  ref,
) {
  final sharingContract = ref.watch(sharingContractProvider);
  return SharingContractRepository(sharingContract);
});
