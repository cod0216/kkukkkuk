import axios, { AxiosError } from "axios";
import { getAccessToken } from "@/utils/tokenUtil";
import { convertKeysToCamelCase } from "@/utils/upper";

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
 */

const API_BASE_URL = import.meta.env.VITE_SERVER_URL;

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
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error: AxiosError) => Promise.reject(error)
);

/**
 * 재요청하는 함수()
 */

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
  (error: AxiosError) => Promise.reject(error)
);

export default apiClient;
