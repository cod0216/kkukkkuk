import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/models/pet_medical_record.dart';

// 임시 진료 기록 데이터
final Map<int, List<PetMedicalRecord>> _dummyRecords = {
  1: [
    PetMedicalRecord(
      treatmentDate: DateTime(2024, 1, 15),
      recordType: '정기검진',
      veterinarian: '김수의',
      petName: '공이',
      petGender: 'MALE',
      guardianName: '홍길동',
      treatmentDetails: '구토시선 활영 (5~10kg)\n부방사선 활영 (5~10kg)',
      medication: '파나쿠어 250mg',
      xRayUrl: null,
      memo: '고양이 금식 염증 단백질 수치 (SAA)\n혈청화합검사 (17종)\n심장초음파 (5kg 이하)',
    ),
    PetMedicalRecord(
      treatmentDate: DateTime(2024, 1, 1),
      recordType: '치료',
      veterinarian: '이수의',
      petName: '공이',
      petGender: 'MALE',
      guardianName: '홍길동',
      treatmentDetails: '혈액 카테터 장착(catheter)\n전혈구검사(CBC, 나흐코딩)',
      medication: 'Cardopet, ProBNP - Feline',
      xRayUrl: null,
      memo: '기본내복약/1일, bid (<5kg)',
    ),
    PetMedicalRecord(
      treatmentDate: DateTime(2024, 1, 15),
      recordType: '정기검진',
      veterinarian: '김수의',
      petName: '공이',
      petGender: 'MALE',
      guardianName: '홍길동',
      treatmentDetails: '구토시선 활영 (5~10kg)\n부방사선 활영 (5~10kg)',
      medication: '파나쿠어 250mg',
      xRayUrl: null,
      memo: '고양이 금식 염증 단백질 수치 (SAA)\n혈청화합검사 (17종)\n심장초음파 (5kg 이하)',
    ),
    PetMedicalRecord(
      treatmentDate: DateTime(2024, 1, 1),
      recordType: '치료',
      veterinarian: '이수의',
      petName: '공이',
      petGender: 'MALE',
      guardianName: '홍길동',
      treatmentDetails: '혈액 카테터 장착(catheter)\n전혈구검사(CBC, 나흐코딩)',
      medication: 'Cardopet, ProBNP - Feline',
      xRayUrl: null,
      memo: '기본내복약/1일, bid (<5kg)',
    ),
    PetMedicalRecord(
      treatmentDate: DateTime(2024, 1, 15),
      recordType: '정기검진',
      veterinarian: '김수의',
      petName: '공이',
      petGender: 'MALE',
      guardianName: '홍길동',
      treatmentDetails: '구토시선 활영 (5~10kg)\n부방사선 활영 (5~10kg)',
      medication: '파나쿠어 250mg',
      xRayUrl: null,
      memo: '고양이 금식 염증 단백질 수치 (SAA)\n혈청화합검사 (17종)\n심장초음파 (5kg 이하)',
    ),
    PetMedicalRecord(
      treatmentDate: DateTime(2024, 1, 1),
      recordType: '치료',
      veterinarian: '이수의',
      petName: '공이',
      petGender: 'MALE',
      guardianName: '홍길동',
      treatmentDetails: '혈액 카테터 장착(catheter)\n전혈구검사(CBC, 나흐코딩)',
      medication: 'Cardopet, ProBNP - Feline',
      xRayUrl: null,
      memo: '기본내복약/1일, bid (<5kg)',
    ),
  ],
};

/// 반려동물 진료 기록 블록체인 서비스
class PetMedicalBlockChainService {
  /// 반려동물의 진료 기록 목록 조회
  Future<List<PetMedicalRecord>> getMedicalRecords(int petId) async {
    try {
      // TODO: 블록체인에서 진료 기록 데이터 가져오기
      // TODO: 블록체인 데이터를 PetMedicalRecord 객체로 변환
      await Future.delayed(const Duration(seconds: 1));
      return _dummyRecords[petId] ?? [];
    } catch (e) {
      throw Exception('진료 기록을 가져오는데 실패했습니다: $e');
    }
  }

  /// 새로운 진료 기록 추가
  Future<bool> addMedicalRecord(int petId, PetMedicalRecord record) async {
    try {
      // TODO: 블록체인에 새로운 진료 기록 추가
      // TODO: 트랜잭션 상태 확인
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      throw Exception('진료 기록 추가에 실패했습니다: $e');
    }
  }

  /// 특정 기간 동안의 진료 기록 조회
  Future<List<PetMedicalRecord>> getMedicalRecordsByDateRange(
    int petId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      // TODO: 블록체인에서 특정 기간의 진료 기록 조회
      // TODO: 날짜 범위에 따른 필터링 로직 구현
      await Future.delayed(const Duration(seconds: 1));
      final records = _dummyRecords[petId] ?? [];
      return records.where((record) {
        return record.treatmentDate.isAfter(startDate) &&
            record.treatmentDate.isBefore(endDate);
      }).toList();
    } catch (e) {
      throw Exception('기간별 진료 기록 조회에 실패했습니다: $e');
    }
  }

  /// 진료 기록 검증
  Future<bool> verifyMedicalRecord(int petId, String recordHash) async {
    try {
      // TODO: 블록체인에서 진료 기록 해시값 검증
      // TODO: 스마트 컨트랙트를 통한 진료 기록 무결성 검증
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      throw Exception('진료 기록 검증에 실패했습니다: $e');
    }
  }

  /// 진료 기록 접근 권한 확인
  Future<bool> checkAccessPermission(int petId, String userAddress) async {
    try {
      // TODO: 블록체인에서 사용자의 진료 기록 접근 권한 확인
      // TODO: 스마트 컨트랙트를 통한 권한 검증
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      throw Exception('접근 권한 확인에 실패했습니다: $e');
    }
  }

  /// 진료 기록 공유 권한 부여
  Future<bool> grantAccessPermission(
    int petId,
    String targetAddress,
    DateTime expiryDate,
  ) async {
    try {
      // TODO: 블록체인에 진료 기록 접근 권한 부여
      // TODO: 스마트 컨트랙트를 통한 권한 설정
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      throw Exception('권한 부여에 실패했습니다: $e');
    }
  }
}

final petMedicalRecordServiceProvider = Provider<PetMedicalBlockChainService>((
  ref,
) {
  return PetMedicalBlockChainService();
});
