import { LoginRequest, LoginResponse, RefreshTokenRequest } from "@/interfaces";
// import { clearAccessToken } from "@/redux/store";
// import { removeRefreshToken } from "@/utils/iDBUtil";
import { request } from "@/services/apiRequest";
import { ApiResponse } from "@/types";
import apiClient from "@/services/apiClient";

const DOMAIN_URL = "/api/auths";

/**
 * 로그인을 요청하는 API입니다.
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
 * 로그아웃을 요청하는 API입니다.
 */
export const logout = async (): Promise<void> => {
  await request.post(`${DOMAIN_URL}/logout`);
};

/**
 * 토큰 재발행 요청 API 입니다.
 */
export const refreshToken = async (
  refreshToken: RefreshTokenRequest
): Promise<ApiResponse<LoginResponse>> => {
  const response = await apiClient.post<ApiResponse<LoginResponse>>(
    "/refresh",
    {},
    {
      headers: {
        Authorization: `Bearer ${refreshToken}`,
      },
    }
  );
  return response.data;
};
