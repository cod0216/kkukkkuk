/**
 * @module pet
 * @file pet.ts
 * @author haelim
 * @date 2025-03-26
 * @description 반려동물 데이터 관련 타입과 인터페이스를 정의한 모듈입니다.
 *
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-26        haelim           최초 생성
 * 2025-03-31        seonghun         PetWithAgreement 인터페이스 추가
 * 2025-04-02        seonghun         speciesName 필드 추가, profileUrl 필드 추가
 */

/**
 * 반려동물의 성별을 나타내는 enum
 * @enum
 */
export enum Gender {
  MALE = "수컷",
  FEMALE = "암컷",
}

/**
 * 반려동물 기본 정보 인터페이스
 * @interface
 */
export interface PetBasicInfo {
  name: string;         // 반려동물 이름
  gender: string;       // 성별
  birth: string;        // 생년월일
  flagNeutering: string | boolean;  // 중성화 여부
  breedName: string;    // 품종
  speciesName?: string; // 종류 (강아지, 고양이 등)
  profileUrl?: string;  // 프로필 이미지 URL
  petDID?: string;      // 반려동물 DID 주소
}

/**
 * 공유 계약 정보 인터페이스
 * @interface
 */
export interface SharingAgreement {
  createdAt: number;         // 계약 생성 시간 (유닉스 타임스탬프)
  expireDate: number;        // 계약 만료 시간 (유닉스 타임스탬프)
  formattedCreatedAt: string; // 형식화된 생성 시간
  formattedExpireDate: string; // 형식화된 만료 시간
  isExpiringSoon: boolean;    // 곧 만료 예정 여부
}

/**
 * 공유 계약 정보가 포함된 반려동물 정보 인터페이스
 * @interface
 */
export interface PetWithAgreement extends PetBasicInfo {
  agreementInfo: SharingAgreement;
  age?: number;               // 나이 (계산된 값)
}
