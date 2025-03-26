import { HospitalDetail } from "./hospital";

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
  accessToken: string;
  refreshToken: string;
}

/**
 * Token Reissue Response Interface
 */
export interface RefreshTokenRequest {
  refreshToken: string;
}

/**
 * Auth State Interface
 */
export interface AuthState {
  accessToken: string | null;
  hospital: HospitalDetail | null;
}
