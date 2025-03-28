import { Doctor } from "@/interfaces";
import { request } from "@/services/apiRequest";
import { ApiResponse } from "@/types";

/**
 * @module doctorService
 * @file doctorService.ts
 * @author haelim
 * @date 2025-03-26
 * @description Doctor 요청을 처리하는 서비스 모듈입니다.
 *
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-26        haelim           최초 생성
 */


/**
 * 현재 로그인한 동물병원 회원의 등록된 의사 정보를 불러옵니다.
 *
 * @async
 * @function
 * @returns {Promise<ApiResponse<Doctor[]>>} 의사 정보 응답 객체
 */
export const getDoctors = async (): Promise<ApiResponse<Doctor[]>> => {
   return await request.get<Doctor[]>(`/api/hospitals/me/doctors`);
};
