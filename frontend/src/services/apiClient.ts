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
 * 요청 인터셉터
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
 * 응답 인터셉터
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
