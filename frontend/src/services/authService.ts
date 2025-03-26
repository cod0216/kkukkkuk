import { LoginRequest, LoginResponse } from "@/interfaces";
// import { clearAccessToken } from "@/redux/store";
// import { removeRefreshToken } from "@/utils/iDBUtil"
import { request } from "@/services/apiRequest";
import { ApiResponse } from "@/types";

const DOMAIN_URL = "/api/auths";

/**
 * login API
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
