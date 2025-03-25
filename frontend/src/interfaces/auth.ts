/**
 * Login Request Interface
 */
export interface LoginRequest {
  account: string;
  password: string;
}

/**
 * Login Response Interface
 */
export interface LoginResponse {
  hospital: {
    id: number;
    did: string;
    account: string;
    name: string;
  };
  tokens: TokensResponse;
}

/**
 * Token Response Interface
 */
export interface TokensResponse {
  access_token: string;
  refresh_token: string;
}

/**
 * Token Reissue Response Interface
 */
export interface RefreshTokenRequest {
  refresh_token: string;
}

/**
 * Auth State Interface
 */
export interface AuthState {
  access_token: string | null;
}
