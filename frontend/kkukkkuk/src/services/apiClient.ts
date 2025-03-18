import axios, { AxiosInstance, AxiosError, AxiosResponse } from 'axios';
import { refreshToken } from './authService';

const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:8080';

// axios 인스턴스 생성
const apiClient: AxiosInstance = axios.create({
  baseURL: API_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

// 요청 인터셉터 - 토큰 추가
apiClient.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('access_token');
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
        const refreshTokenValue = localStorage.getItem('refresh_token');
        
        if (!refreshTokenValue) {
          // 리프레시 토큰이 없으면 로그아웃 상태로 처리
          localStorage.removeItem('access_token');
          localStorage.removeItem('refresh_token');
          localStorage.removeItem('hospital');
          window.location.href = '/login';
          return Promise.reject(error);
        }
        
        // 리프레시 토큰으로 새 액세스 토큰 요청
        const response = await refreshToken(refreshTokenValue);
        
        if (response.status === 'SUCCESS' && response.data) {
          // 새 토큰으로 원래 요청 재시도
          return apiClient(originalRequest);
        } else {
          // 토큰 갱신 실패 시 로그아웃 처리
          localStorage.removeItem('access_token');
          localStorage.removeItem('refresh_token');
          localStorage.removeItem('hospital');
          window.location.href = '/login';
          return Promise.reject(error);
        }
      } catch (refreshError) {
        // 갱신 과정에서 오류 발생 시 로그아웃 처리
        localStorage.removeItem('access_token');
        localStorage.removeItem('refresh_token');
        localStorage.removeItem('hospital');
        window.location.href = '/login';
        return Promise.reject(refreshError);
      }
    }
    
    return Promise.reject(error);
  }
);

export default apiClient; 