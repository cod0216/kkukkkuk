import { Gender } from "@/interfaces/pet"; 
import { BlockChainRecord, BlockChainRecordResponse } from "@/interfaces/blockChain";

/**
 * @module treatmentInterfaces
 * @file treatmentInterfaces.ts
 * @author haelim
 * @date 2025-03-26
 * @description 치료(Treatment) 관련 타입과 인터페이스를 정의한 모듈입니다.
 *
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-26        haelim           최초 생성
 * 2025-03-31        seonghun         Treatment 상태 타입 확장 
 */

/**
 * 치료 상태를 나타내는 Enum
 * @enum {string}
 */
export enum TreatmentState {
    WAITING = "진료전",
    IN_PROGRESS = "진료중",
    COMPLETED = "진료완료",
    CANCELLED = "진료취소",
    SHARED = "공유중",
    NONE = "",
}



/**
 * 개별 치료 정보를 나타내는 인터페이스
 * @interface
 */
export interface Treatment {
  id: number;
  petId: number;
  petDid?: string;
  state: TreatmentState;
  name: string;
  age: number;
  gender: Gender;
  breedName: string;
  birth?: string;
  flagNeutering: boolean | string;
  createdAt?: string;
  expireDate?: string;
  agreementInfo?: any;
  calculatedState?: TreatmentState; // 블록체인 기반으로 계산된 진료 상태
  isCancelled?: boolean; // 취소 여부
}

/**
 * 치료 목록 응답 객체
 * @interface
 */
export interface TreatmentResponse {
  treatments: Treatment[];
}


/**
 * API 응답 데이터를 TreatmentResponse 형식으로 변환하는 함수
 * 
 * @function
 * @param {any[]} data - 원본 API 응답 데이터
 * @returns {TreatmentResponse} 변환된 치료 응답 객체
 */
export const parseTreatmentResponse = (data: any[]): TreatmentResponse => {
  return {
    treatments: data.map(item => ({
      state: TreatmentState[item.state as keyof typeof TreatmentState] || TreatmentState.NONE,
      id: item.id,
      expireDate: item.expire_date,
      createdAt: item.created_at,
      petId: item.pet_id,
      petDid: item.pet_did,
      name: item.name,
      birth: item.birth,
      age: item.age,
      gender: item.gender,
      flagNeutering: item.flag_neutering,
      breedName: item.breed_name,
    }))
  };
};

// BlockChainRecord와 BlockChainRecordResponse 인터페이스는 
// blockChain.ts로 이동되었으므로 여기서는 export만 합니다.
export type { BlockChainRecord, BlockChainRecordResponse };


