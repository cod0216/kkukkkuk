import { LoginRequest, LoginResponse, RefreshTokenRequest } from "@/interfaces";
// import { clearAccessToken } from "@/redux/store";
// import { removeRefreshToken } from "@/utils/iDBUtil";
import { request } from "@/services/apiRequest";
import { ApiResponse } from "@/types";
import apiClient from "@/services/apiClient";

/**
 * @module authService
 * @file authService.tsx
 * @author eunchang
 * @date 2025-03-26
 * @description 인증 관련 API 요청을 처리하는 서비스 모듈입니다.
 *
 * 이 모듈은 로그인 관련 API 및 토큰 관련 API를 수행합니다.
 *
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-26        eunchang         최초 생성
 */

const DOMAIN_URL = "/api/auths";

/**
 * 로그인 API를 호출합니다.
 *
 * @param data - 로그인 요청 데이터 (아이디, 비밀번호)
 * @returns ApiResponse<LoginResponse> 타입의 응답 객체
 */
export const login = async (
  data: LoginRequest
): Promise<ApiResponse<LoginResponse>> => {
  const response = await request.post<LoginResponse>(
    `${DOMAIN_URL}/hospitals/login`,
    data
  );
  return response;
};

/**
 * 로그아웃 API를 호출합니다.
 *
 * @returns 로그아웃 처리 후 Promise<void>를 반환합니다.
 */
export const logout = async (): Promise<void> => {
  await request.post(`${DOMAIN_URL}/logout`);
};

/**
 * 토큰 재발급 API를 호출합니다.
 *
 * @param param0 - RefreshTokenRequest 타입의 객체 ({ refreshToken: string })
 * @returns 재발급된 accessToken과 refreshToken을 포함한 ApiResponse 객체
 */
export const refreshToken = async ({
  refreshToken,
}: RefreshTokenRequest): Promise<
  ApiResponse<{ accessToken: string; refreshToken: string }>
> => {
  const response = await apiClient.post<
    ApiResponse<{ accessToken: string; refreshToken: string }>
  >(
    `${DOMAIN_URL}/refresh`,
    {},
    {
      headers: {
        Authorization: `Bearer ${refreshToken}`,
      },
    }
  );
  return response.data;
};

/**
 * 비밀번호 재설정(임시 비밀번호 발급) API 호출을 수행합니다.
 *
 * @param data - 계정 및 이메일 정보를 담은 객체
 * @returns ApiResponse<null> 타입의 응답 객체
 */
export const findPassword = async (data: {
  account: string;
  email: string;
}): Promise<ApiResponse<null>> => {
  const response = await request.post<null>(
    `${DOMAIN_URL}/passwords/reset`,
    data
  );
  return response;
};
