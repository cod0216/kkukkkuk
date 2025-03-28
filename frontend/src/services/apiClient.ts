import axios, { AxiosError, AxiosRequestConfig } from "axios";
import { getAccessToken } from "@/utils/tokenUtil";
import { convertKeysToCamelCase } from "@/utils/upper";
import {
  getRefreshToken,
  removeRefreshToken,
  setRefreshtoken,
} from "@/utils/iDBUtil";
import { store } from "@/redux/store";
import { setAccessToken } from "@/redux/store";

import { ResponseCode } from "@/types";

/**
 * @module apiClient
 * @file apiClient.tsx
 * @author eunchang
 * @date 2025-03-26
 * @description Axios 인스턴스를 생성하여 API 요청 전/후 인터셉터를 구성하는 모듈입니다.
 *
 * 이 모듈은 API 기본 URL, 기본 헤더, 타임아웃 설정과 함께
 * 토큰 기반 인증 및 응답 데이터의 카멜 케이스 변환을 처리합니다.
 *
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-26        eunchang         최초 생성
 * 2025-03-27        eunchang         401 토큰 재발행 및 재요청
 */

const API_BASE_URL = import.meta.env.VITE_SERVER_URL;

/**
 * 무한 순회 방지용 인터페이스
 * @interface
 */
interface CustomAxiosRequestConfig extends AxiosRequestConfig {
  _retry?: boolean;
}

/**
 * refresh 요청이 진행 중일 때 그 결과를 공유할 promise
 */
let refreshPromise: Promise<string> | null = null;

/**
 * Axoios 인스턴스를 생성합니다.
 */
const apiClient = axios.create({
  baseURL: API_BASE_URL,
  headers: { "Content-Type": "application/json" },
  timeout: 10 * 1000,
});

/**
 * 요청 인터셉터를 추가합니다.
 * accessToken이 존재하면 헤더에 추가하며, 토큰 재발급 API 호출은 제외합니다.
 */
apiClient.interceptors.request.use(
  (config) => {
    if (config.url && config.url.includes("/api/auths/refresh")) {
      return config;
    }
    const token = getAccessToken();
    if (token) {
      config.headers = config.headers || {};
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error: AxiosError) => Promise.reject(error)
);

/**
 * refresh token을 이용하여 새로운 access token을 발급받습니다.
 * 동시에 여러 요청이 401 에러를 받으면 한 번만 refresh 요청을 진행하고,
 * 그 결과를 공유하여 모든 요청에 적용합니다.
 *
 * @returns 새로 발급된 access token
 */
async function performRefreshToken(): Promise<string> {
  const storedRefreshToken = await getRefreshToken();
  if (!storedRefreshToken) {
    return Promise.reject(new Error("RefreshToken을 찾을 수 없습니다."));
  }
  try {
    const response = await axios.post(
      `${API_BASE_URL}/api/auths/refresh`,
      {},
      {
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${storedRefreshToken}`,
        },
      }
    );
    const { accessToken, refreshToken: newRefreshToken } =
      convertKeysToCamelCase(response.data.data);
    if (!accessToken) {
      throw new Error("AccessToken을 발급받을 수 없습니다.");
    }
    store.dispatch(setAccessToken(accessToken));
    await setRefreshtoken(newRefreshToken);
    return accessToken;
  } catch (error) {
    await removeRefreshToken();
    return Promise.reject(error);
  }
}

/**
 * refresh token을 이용하여 새로운 access token을 발급받고, 원래의 요청을 재시도합니다.
 *
 * @param originalRequest - 재시도할 원래 요청 객체
 * @returns 재시도한 요청의 응답 또는 에러
 */
async function refreshAccessToken(
  originalRequest: CustomAxiosRequestConfig
): Promise<any> {
  if (!refreshPromise) {
    refreshPromise = performRefreshToken();
  }
  try {
    const newAccessToken = await refreshPromise;
    refreshPromise = null;
    originalRequest.headers = originalRequest.headers || {};
    originalRequest.headers.Authorization = `Bearer ${newAccessToken}`;
    return apiClient(originalRequest);
  } catch (error) {
    refreshPromise = null;
    return Promise.reject(error);
  }
}

/**
 * 응답 인터셉터를 추가합니다.
 * 응답 데이터를 카멜 케이스로 변환합니다.
 */
apiClient.interceptors.response.use(
  (response) => {
    if (response.data) {
      response.data = convertKeysToCamelCase(response.data);
    }
    return response;
  },
  async (error: AxiosError) => {
    const originalRequest = error.config as CustomAxiosRequestConfig;
    if (
      error.response &&
      error.response.status === ResponseCode.UNAUTHORIZED &&
      originalRequest &&
      !originalRequest._retry &&
      originalRequest.url &&
      !originalRequest.url.includes("/api/auths/refresh")
    ) {
      originalRequest._retry = true;
      try {
        return await refreshAccessToken(originalRequest);
      } catch (refreshError) {
        return Promise.reject(refreshError);
      }
    }
    return Promise.reject(error);
  }
);

export default apiClient;
