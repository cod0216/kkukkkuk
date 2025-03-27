import { GetTreatmentRequest, TreatmentResponse, parseTreatmentResponse } from "@/interfaces";
import { request } from "@/services/apiRequest";
import { ApiResponse } from "@/types";

/**
 * @module treatmentService
 * @file treatmentService.ts
 * @author haelim
 * @date 2025-03-26
 * @description Treatment 요청을 처리하는 서비스 모듈입니다.
 *
 * 이 모듈은 병원의 진료 정보를 가져오는 API 요청을 수행합니다.
 *
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-26        haelim           최초 생성
 */


/**
 * 현재 로그인한 동물병원 회원 치료 이력을 조회합니다.
 *
 * @async
 * @function
 * @param {GetTreatmentRequest} data - 치료 정보 요청 객체, 
 * @returns {Promise<ApiResponse<TreatmentResponse>>} 치료 정보 응답 객체
 */
export const getTreatments = async (data: GetTreatmentRequest): Promise<ApiResponse<TreatmentResponse>> => {
  const response = await request.get<any[]>(
    `/api/hospitals/me/treatments?expired=${data.expired || ""}&state=${data.state || ""}&pet_id=${data.petId || ""}`
  );
  console.log(response)
  return {
    ...response,
    data: parseTreatmentResponse(response.data || [])
  };
};
