import axios from "axios";

export const API_BASE_URL = "http://localhost:8080";

const api = axios.create({
  baseURL: API_BASE_URL,
  withCredentials: false,
  headers: {
    Accept: "application/json",
    "Content-Type": "application/json",
  },
});

// request
api.interceptors.request.use(
  (config) => {
    const accessToken = localStorage.getItem("accessToken");
    if (accessToken) {
      config.headers.Authorization = `Bearer ${accessToken}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// response
api.interceptors.response.use(
  (response) => {
    return response;
  },
  async (error) => {
    const originalRequest = error.config;

    // access token 만료로 인한 401 에러이고, 아직 재시도하지 않은 요청일 경우
    // 토글임
    if (error.response.status === 401 && !originalRequest._retry) {
      originalRequest._retry = true; // 재시도 표시

      try {
        const refreshToken = document.cookie
          .split("; ")
          .find((row) => row.startsWith("refresh_token="))
          ?.split("=")[1];

        // refresh 토큰으로 새로운 access 토큰 발급 요청
        const response = await axios.post(
          `${API_BASE_URL}/refresh`,
          {},
          {
            headers: {
              Authorization: `Bearer ${refreshToken}`,
            },
          }
        );

        // 새로운 access 토큰 저장
        const newAccessToken = response.data.data.tokens.access_token;
        localStorage.setItem("accessToken", newAccessToken);
        // console.log("access 재발급 성공");

        // 실패했던 요청 재시도
        originalRequest.headers.Authorization = `Bearer ${newAccessToken}`;
        console.log("실패했던 요청 재시도");

        return api(originalRequest);
      } catch (refreshError) {
        // refresh 토큰도 만료되었거나 유효하지 않은 경우 다시 로그인 ㄱㄱㄱ
        localStorage.removeItem("accessToken");
        window.location.href = `/login?redirect=${window.location.pathname}`;
        return Promise.reject(refreshError);
      }
    }
    return Promise.reject(error);
  }
);

export default api;
