/**
 * @module blockChain
 * @file blockChain.ts
 * @author haelim
 * @date 2025-03-26
 * @description 블록체인 데이터터 관련 타입과 인터페이스를 정의한 모듈입니다.
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
  tests: TestTreatment[]; // 검사 목록
  medications: MedicationTreatment[]; // 약물 목록
  vaccinations: VaccinationTreatment[]; // 접종 목록
}

/**
 * 검사 정보 인터페이스입니다.
 * @interface
 */
export interface TestTreatment {
  type: string; // 검사 종류
  description: string; // 검사 내용
}

/**
 * 약물 정보 인터페이스입니다.
 * @interface
 */
export interface MedicationTreatment {
  type: string; // 약물 종류
  dosage: number; // 투여 횟수
}

/**
 * 접종 정보 인터페이스입니다.
 * @interface
 */
export interface VaccinationTreatment {
  type: string; // 접종 종류
  doseNumber: number; // 차수
}


