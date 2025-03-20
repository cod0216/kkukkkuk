// -----------------로그인 Interface-------------------

export interface LoginRequest {
  account: string;
  password: string;
}

export interface LoginResponse {
  hospital: {
    id: number;
    did: string;
    account: string;
    name: string;
  };
  tokens: {
    access_token: string;
    refresh_token: string;
  };
}

// 토큰 재발급 요청 및 응답 인터페이스
export interface RefreshTokenRequest {
  refresh_token: string;
}

export interface TokensResponse {
  access_token: string;
  refresh_token: string;
}

export interface RefreshTokenResponse extends ApiResponse<TokensResponse> {
  data?: TokensResponse;
}

// -----------------회원가입 Interface-------------------

// 공통 API 응답 인터페이스
export interface ApiResponse<T = any> {
  status: "SUCCESS" | "FAILURE";
  message: string;
  data?: T;
}

// 계정 중복 확인 응답 인터페이스
export interface AccountCheckResponse extends ApiResponse<boolean> {}

// 라이센스 중복 확인 응답 인터페이스
export interface LicenseCheckResponse extends ApiResponse<boolean> {}
