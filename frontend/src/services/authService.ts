import { LoginRequest, LoginResponse } from "@/interfaces";
import { clearAccessToken } from "@/redux/store";
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
 * logout API
 */
export const logout = async (): Promise<void> => {
  await request.post(`${DOMAIN_URL}/logout`);
  clearAccessToken();
  // ToDo 리프레쉬 토큰
};
