import axios, { AxiosError } from "axios";
import { getAccessToken } from "@/utils/tokenUtil";

const API_BASE_URL = import.meta.env.VITE_SERVER_URL;

/**
 * API Client instance
 */
const apiClient = axios.create({
  baseURL: API_BASE_URL,
  headers: { "Content-Type": "application/json" },
  timeout: 10 * 1000,
});

/**
 * Request interceptor
 */
apiClient.interceptors.request.use(
  (config) => {
    const token = getAccessToken();
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error: AxiosError) => Promise.reject(error)
);

/**
 * Reseponse Interceptor
 */

// 토큰 재발급 로직 구현 -> IndexedDB 완료 후 구현

export default apiClient;
