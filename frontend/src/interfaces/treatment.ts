import { Gender } from "@/interfaces/pet"; 

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
 */

/**
 * 치료 상태를 나타내는 Enum
 * @enum {string}
 */
export enum TreatmentState {
    WAITING = "대기중",
    IN_PROGRESS = "진료중",
    COMPLETED = "진료완료",
    NONE = "",
}

/**
 * 치료 정보 요청을 위한 인터페이스
 * @interface
 */
export interface GetTreatmentRequest {
  expired: boolean | "";
  petId: number | "";
  state: TreatmentState | "";
}

/**
 * 개별 치료 정보를 나타내는 인터페이스
 * @interface
 */
export interface Treatment {
  state: TreatmentState;
  id: number;
  expireDate: string;
  createdAt: string;
  petId: number;
  petDid: string;
  name: string;
  birth: string;
  age: number;
  gender: Gender;
  flagNeutering: boolean;
  breedName: string;
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
