import { HospitalDetail } from "./hospital";

/**
 * @module auth
 * @file auth.tsx
 * @author eunchang
 * @date 2025-03-26
 * @description 계정에 관한 인터페이스를 정의하는 모듈입니다.
 *
 * 계정 관련 인터페이스들을 정의합니다.
 *
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-26        eunchang         최초 생성
 */

/**
 * Login 요청 Interface
 */
export interface LoginRequest {
  account: string;
  password: string;
}

/**
 * Login 응답답 Interface
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
 * Token 요청 Interface
 */
export interface TokensResponse {
  accessToken: string;
  refreshToken: string;
}

/**
 * Token 재발행 Interface
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
