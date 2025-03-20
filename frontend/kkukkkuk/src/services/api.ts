import axios, {
  AxiosInstance,
  AxiosError,
  AxiosResponse,
  AxiosStatic,
} from "axios";
import { refreshToken } from "./authService";

// axios 인스턴스 생성
const apiClient: AxiosInstance = axios.create({
  baseURL: import.meta.env.VITE_SERVER_URL,
  headers: {
    "Content-Type": "application/json",
  },
});

// 요청 인터셉터 - 토큰 추가
apiClient.interceptors.request.use(
  (config) => {
    const token = sessionStorage.getItem("access_token");
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// 응답 인터셉터 - 토큰 갱신 처리
apiClient.interceptors.response.use(
  (response) => {
    return response;
  },
  async (error: AxiosError) => {
    const originalRequest = error.config;

    // 토큰이 만료된 경우 (401 에러이고 originalRequest가 있고, _retry가 false인 경우)
    if (
      error.response?.status === 401 &&
      originalRequest &&
      !originalRequest.headers._retry
    ) {
      originalRequest.headers._retry = true;

      try {
        const refreshTokenValue = localStorage.getItem("refresh_token");

        if (!refreshTokenValue) {
          // 리프레시 토큰이 없으면 로그아웃 상태로 처리
          sessionStorage.removeItem("access_token");
          document.cookie =
            "refresh_token=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
          localStorage.removeItem("hospital");
          window.location.href = "/login";
          return Promise.reject(error);
        }

        // 리프레시 토큰으로 새 액세스 토큰 요청
        const response = await refreshToken(refreshTokenValue);

        if (response.status === "SUCCESS" && response.data) {
          // 새 토큰으로 원래 요청 재시도
          return apiClient(originalRequest);
        } else {
          // 토큰 갱신 실패 시 로그아웃 처리
          sessionStorage.removeItem("access_token");
          document.cookie =
            "refresh_token=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
          localStorage.removeItem("hospital");
          window.location.href = "/login";
          return Promise.reject(error);
        }
      } catch (refreshError) {
        // 갱신 과정에서 오류 발생 시 로그아웃 처리
        sessionStorage.removeItem("access_token");
        document.cookie =
          "refresh_token=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
        localStorage.removeItem("hospital");
        window.location.href = "/login";
        return Promise.reject(refreshError);
      }
    }

    return Promise.reject(error);
  }
);

export default apiClient;
