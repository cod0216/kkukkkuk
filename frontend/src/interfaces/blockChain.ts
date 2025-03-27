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
  diagnosis: string;
  treatments: BlockChainTreatment;
  doctorName: string;
  notes: string;
  hospitalAddress: string;
  hospitalName: string;
  createdAt: string;
  isDeleted: boolean;
  pictures: string[];
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
 * 치료 정보를 포함하는 인터페이스입니다.
 * @interface
 */
export interface BlockChainTreatment {
  examinations: ExaminationTreatment[]; // 검사 목록
  medications: MedicationTreatment[]; // 약물 목록
  vaccinations: VaccinationTreatment[]; // 접종 목록
}

/**
 * 검사 정보 인터페이스입니다.
 * @interface
 */
export interface ExaminationTreatment {
  key: string; // 검사 종류 
  value: string; // 검사 내용
}

/**
 * 약물 정보 인터페이스입니다.
 * @interface
 */
export interface MedicationTreatment {
  key: string; // 약물 종류 
  value: string; // 투여 횟수
}

/**
 * 접종 정보 인터페이스입니다.
 * @interface
 */
export interface VaccinationTreatment {
  key: string; // 접종 종류 
  value: string; // 차수
}
