/**
 * @module blockChain
 * @file blockChain.ts
 * @author haelim
 * @date 2025-03-26
 * @description 블록체인 데이터 관련 타입과 인터페이스를 정의한 모듈입니다.
 *
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-26        haelim           최초 생성
 */

/**
 * 블록체인 기반 치료 정보를 나타내는 인터페이스입니다.
 * @interface
 */
export interface BlockChainRecord {
  id?: string;  // 블록체인에 저장될 때의 식별자
  timestamp: number;  // Unix 타임스탬프 (초)
  diagnosis: string;  // 진단명
  treatments: BlockChainTreatment;  // 치료 정보
  doctorName: string;  // 담당 의사 이름
  notes: string;  // 진료 메모
  hospitalAddress: string;  // 병원 계정 주소
  hospitalName: string;  // 병원 이름
  createdAt: string;  // 생성 일시 (ISO 형식)
  isDeleted: boolean;  // 삭제 여부
  pictures?: string[];  // 첨부 이미지 (base64)
  expireDate?: number;  // 유효기간 만료일 (Unix 타임스탬프)
  petDid?: string;  // 반려동물 DID 주소
  previousRecord?: string; // 이전 기록 ID (수정 기능에서 사용)
}

/**
 * 블록체인 진료 기록 응답 객체
 * @interface
 */
export interface BlockChainRecordResponse {
  success: boolean;  // 성공 여부
  error?: string;  // 오류 메시지
  treatments: BlockChainRecord[];  // 진료 기록 목록
}

/**
 * 치료 정보를 포함하는 인터페이스입니다.
 * @interface
 * 
 */
export interface BlockChainTreatment {
  examinations: ExaminationTreatment[]; // 검사 목록
  medications: MedicationTreatment[]; // 약물 목록
  vaccinations: VaccinationTreatment[]; // 접종 목록
}

/**
 * 검사 종류 enum입니다.
 * @enum
 */
export enum TreatmentType {
  EXAMINATION = "검사",
  MEDICATION = "약물",
  VACCINATION = "접종",
}

/**
 * 검사 종류 정보를 포함하는 객체입니다.
 * @interface
 */
export interface TreatmentTypeInfo {
  enumName: TreatmentType; // TreatmentType enum 값
  camelCase: string; // JSON에서의 컬럼명 (카멜 케이스)
  displayName: string; // 화면에 보여줄 이름 (한글)
}

/**
 * TreatmentType에 대한 추가 정보를 담은 배열입니다.
 */
export const TreatmentTypes: TreatmentTypeInfo[] = [
  {
    enumName: TreatmentType.EXAMINATION,
    camelCase: "examinations",
    displayName: "검사",
  },
  {
    enumName: TreatmentType.MEDICATION,
    camelCase: "medications",
    displayName: "약물",
  },
  {
    enumName: TreatmentType.VACCINATION,
    camelCase: "vaccinations",
    displayName: "접종",
  },
];

/**
 * 검사 정보 인터페이스입니다.
 * @interface
 */
export interface ExaminationTreatment {
  type: string; // 검사 종류 
  key?: string; // 키 (내부 식별자)
  value: string; // 검사 내용
}

/**
 * 약물 정보 인터페이스입니다.
 * @interface
 */
export interface MedicationTreatment {
  type: string; // 약물 종류 
  key?: string; // 키 (내부 식별자)
  value: string; // 투여 횟수
}

/**
 * 접종 정보 인터페이스입니다.
 * @interface
 */
export interface VaccinationTreatment {
  type: string; // 접종 종류 
  key?: string; // 키 (내부 식별자)
  value: string; // 차수
}

/**
 * 진료 기록 수정 내역 항목
 * @interface
 */
export interface RecordHistoryItem {
  id: string;
  timestamp: number;
  userName: string;
  action: string;
  changes: string[];
}
