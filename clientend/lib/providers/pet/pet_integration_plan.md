# 펫 관련 코드 통합 계획

## 현재 상황 분석

현재 펫 관련 코드는 다음과 같이 여러 파일로 분산되어 있습니다:

1. **pet_provider.dart**

   - 반려동물 기본 정보 관리 (조회, 등록, 수정, 삭제)
   - FlutterSecureStorage 직접 사용 (TODO: SecureStorageProvider로 변경 필요)
   - 미구현된 기능: updatePet, deletePet

2. **pet_register_provider.dart**

   - 반려동물 등록 프로세스 관리 (단계별 등록)
   - 품종 및 종류 조회 기능
   - FlutterSecureStorage 직접 사용 (TODO: SecureStorageProvider로 변경 필요)

3. **pet_medical_record_provider.dart**
   - 진료 기록 조회 및 관리
   - 블록체인 기록 통합 기능
   - TODO 항목: 정렬, 필터링, 검색 기능

## 통합 방향

### 1. 모듈 구조 재설계

```
lib/providers/pet/
├── pet_provider.dart (통합된 메인 프로바이더)
├── pet_state.dart (상태 클래스 분리)
└── secure_storage_provider.dart (이미 구현된 것 활용)
```

### 2. 상태 관리 통합

- **PetState** 클래스를 확장하여 모든 펫 관련 상태를 포함
  - 기본 정보 (pets, currentPet)
  - 등록 관련 상태 (registerStep)
  - 진료 기록 관련 상태 (medicalRecords)

### 3. 기능 통합

- **PetNotifier** 클래스에 모든 기능 통합
  - 기본 CRUD 기능 (getPetList, registerPet, updatePet, deletePet)
  - 등록 프로세스 관리 (setBasicInfo, setImageUrl, moveToNextStep 등)
  - 진료 기록 관리 (getMedicalRecords, addBlockchainRecords 등)

### 4. 개선 사항

- **SecureStorageProvider 활용**

  - 직접 FlutterSecureStorage 사용 대신 이미 구현된 SecureStorageProvider 활용
  - 키 관리 일관성 유지

- **미구현 기능 구현**

  - updatePet, deletePet 기능 구현
  - 진료 기록 정렬, 필터링, 검색 기능 구현

- **코드 중복 제거**
  - 중복된 상태 관리 로직 통합
  - 에러 처리 패턴 일관화

## 구현 계획

### 1단계: 통합된 상태 클래스 구현

- PetState 클래스를 확장하여 모든 상태 포함
- 기존 상태 클래스의 기능을 유지하면서 통합

### 2단계: 통합된 프로바이더 구현

- PetNotifier 클래스에 모든 기능 통합
- SecureStorageProvider 활용하도록 변경
- 미구현 기능 구현

### 3단계: 기존 코드 마이그레이션

- 기존 코드에서 새로운 통합 프로바이더 사용하도록 변경
- 테스트 및 검증

### 4단계: 기존 파일 정리

- 통합 완료 후 기존 분리된 파일들 제거

## 예상 효과

1. **코드 중복 감소**: 유사한 상태 관리 및 에러 처리 로직 통합
2. **유지보수성 향상**: 관련 기능이 한 곳에 모여 있어 변경 용이
3. **일관성 증가**: 상태 관리 및 에러 처리 패턴 일관화
4. **확장성 개선**: 새로운 펫 관련 기능 추가 시 통합된 구조에 쉽게 추가 가능
