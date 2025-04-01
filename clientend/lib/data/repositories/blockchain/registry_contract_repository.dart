import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/data/datasource/contracts/registry_contract.dart';
import 'package:kkuk_kkuk/domain/repositories/blockchain/registry_contract_repository_interface.dart';
import 'package:web3dart/web3dart.dart';

class RegistryContractRepository implements IRegistryContractRepository {
  final RegistryContract _registryContract;

  RegistryContractRepository(this._registryContract);

  @override
  Future<String> addHospitalWithSharing({
    required Credentials credentials,
    required String petAddress,
    required String hospitalAddress,
    required String scope,
    required int sharingPeriod,
  }) async {
    try {
      return await _registryContract.addHospitalWithSharing(
        credentials: credentials,
        petAddress: petAddress,
        hospitalAddress: hospitalAddress,
        scope: scope,
        sharingPeriod: sharingPeriod,
      );
    } catch (e) {
      print('병원 추가 및 공유 계약 생성 오류: $e');
      throw Exception('병원 추가 및 공유 계약 생성에 실패했습니다: $e');
    }
  }

  @override
  Future<bool> checkSharingPermission({
    required String petAddress,
    required String userAddress,
  }) async {
    try {
      return await _registryContract.checkSharingPermission(
        petAddress: petAddress,
        userAddress: userAddress,
      );
    } catch (e) {
      print('공유 권한 확인 오류: $e');
      throw Exception('공유 권한 확인에 실패했습니다: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getAgreementDetails({
    required String petAddress,
    required String hospitalAddress,
  }) async {
    try {
      return await _registryContract.getAgreementDetails(
        petAddress: petAddress,
        hospitalAddress: hospitalAddress,
      );
    } catch (e) {
      print('공유 계약 상세 정보 조회 오류: $e');
      throw Exception('공유 계약 상세 정보 조회에 실패했습니다: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getAllAttributes(String petAddress) async {
    try {
      return await _registryContract.getAllAttributes(petAddress);
    } catch (e) {
      print('반려동물 속성 조회 오류: $e');
      throw Exception('반려동물 속성 조회에 실패했습니다: $e');
    }
  }

  @override
  Future<List<String>> getHospitalPets(String hospitalAddress) async {
    try {
      return await _registryContract.getHospitalPets(hospitalAddress);
    } catch (e) {
      print('병원의 반려동물 목록 조회 오류: $e');
      throw Exception('병원의 반려동물 목록 조회에 실패했습니다: $e');
    }
  }

  @override
  Future<List<String>> getPetHospitals(String petAddress) async {
    try {
      return await _registryContract.getPetHospitals(petAddress);
    } catch (e) {
      print('반려동물의 병원 목록 조회 오류: $e');
      throw Exception('반려동물의 병원 목록 조회에 실패했습니다: $e');
    }
  }

  @override
  Future<bool> petExists(String petAddress) async {
    try {
      return await _registryContract.petExists(petAddress);
    } catch (e) {
      print('반려동물 존재 여부 확인 오류: $e');
      throw Exception('반려동물 존재 여부 확인에 실패했습니다: $e');
    }
  }

  @override
  Future<String> removeHospital({
    required Credentials credentials,
    required String petAddress,
    required String hospitalAddress,
  }) async {
    try {
      return await _registryContract.removeHospital(
        credentials: credentials,
        petAddress: petAddress,
        hospitalAddress: hospitalAddress,
      );
    } catch (e) {
      print('병원 제거 오류: $e');
      throw Exception('병원 제거에 실패했습니다: $e');
    }
  }

  @override
  Future<String> revokeSharingAgreement({
    required Credentials credentials,
    required String petAddress,
    required String hospitalAddress,
  }) async {
    try {
      return await _registryContract.revokeSharingAgreement(
        credentials: credentials,
        petAddress: petAddress,
        hospitalAddress: hospitalAddress,
      );
    } catch (e) {
      print('공유 계약 취소 오류: $e');
      throw Exception('공유 계약 취소에 실패했습니다: $e');
    }
  }
}

final registryContractRepositoryProvider =
    Provider<IRegistryContractRepository>((ref) {
      final registryContract = ref.watch(petRegistryContractProvider);
      return RegistryContractRepository(registryContract);
    });
