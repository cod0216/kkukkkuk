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
