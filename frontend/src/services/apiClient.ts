import axios, { AxiosError } from "axios";
import { getAccessToken } from "@/utils/tokenUtil";
import { convertKeysToCamelCase } from "@/utils/upper";

const API_BASE_URL = import.meta.env.VITE_SERVER_URL;
// const API_BASE_URL = "http://localhost:8080";

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
apiClient.interceptors.response.use(
  (response) => {
    if (response.data) {
      response.data = convertKeysToCamelCase(response.data);
    }
    return response;
  },
  (error: AxiosError) => Promise.reject(error)
);

// TODO: 토큰 재발급 로직 구현 -> IndexedDB 완료 후 구현

export default apiClient;
