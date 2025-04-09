import { store } from "@/redux/store";
/**
 * @module tokenUtil
 * @file tokenUtil.tsx
 * @author eunchang
 * @date 2025-03-26
 * @description 토큰 관련 유틸리티 함수를 제공하는 모듈입니다.
 *
 * 이 모듈은 Redux 스토어에서 액세스 토큰을 가져옵니다.
 *
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-26        eunchang         최초 생성
 * 2025-03-26        haelim           parseJwt 추가가
 */

/**
 * Redux 스토에서 현재 액세스 토큰을 반환합니다.
 *
 * @returns 액세스 토큰을 얻습니다.
 */
export const getAccessToken = (): string | null => {
  const state = store.getState();
  return state.auth.accessToken;
};


/**
 * JWT 토큰에서 payload를 파싱하여 반환하는 함수
 * @param token JWT 문자열
 * @returns payload 객체 or null
 */
export function parseJwt(token: string | null): any | null {
  try {
    if(!token) return;
    const base64Url = token.split('.')[1];
    const base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
    const jsonPayload = decodeURIComponent(
      atob(base64)
        .split('')
        .map((c) => `%${('00' + c.charCodeAt(0).toString(16)).slice(-2)}`)
        .join('')
    );
    return JSON.parse(jsonPayload);
  } catch (e) {
    console.error('JWT 파싱 실패:', e);
    return null;
  }
}
