import axios from 'axios';
import apiClient from './apiClient';
import { ApiResponse } from './hospitalService';

const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:8080';

export interface LoginRequest {
  account: string;
  password: string;
}

export interface LoginResponse {
  hospital: {
    id: number;
    did: string;
    account: string;
    name: string;
  };
  tokens: {
    access_token: string;
    refresh_token: string;
  };
}

// 계정명 유효성 검사 함수 (5~10자의 영문 소문자, 숫자, 밑줄(_)만 허용)
export const validateAccount = (account: string): boolean => {
  const accountRegex = /^[a-z0-9_]{5,10}$/;
  return accountRegex.test(account);
};

// 비밀번호 유효성 검사 함수 (6~20자의 영문 대소문자, 숫자, 특수문자(!@#$%^&) 조합)
export const validatePassword = (password: string): boolean => {
  const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&])[A-Za-z\d!@#$%^&]{6,20}$/;
  return passwordRegex.test(password);
};

// 로그인 API
export const login = async (data: LoginRequest): Promise<ApiResponse<LoginResponse>> => {
  try {
    // 유효성 검사
    if (!validateAccount(data.account)) {
      return {
        status: 'FAILURE',
        name: 'INVALID_ACCOUNT_FORMAT',
        code: 'AUTH-001',
        message: '계정명은 5~10자의 영문 소문자, 숫자, 밑줄(_)만 허용됩니다.',
        http_code: 400
      };
    }

    if (!validatePassword(data.password)) {
      return {
        status: 'FAILURE',
        name: 'INVALID_PASSWORD_FORMAT',
        code: 'AUTH-001',
        message: '비밀번호는 6~20자의 영문 대소문자, 숫자, 특수문자(!@#$%^&) 조합이어야 합니다.',
        http_code: 400
      };
    }

    const response = await apiClient.post(`/api/auths/hospitals/login`, data);
    return response.data;
  } catch (error) {
    console.error('로그인 오류:', error);
    
    // 에러 객체가 AxiosError이고 응답이 있을 경우 API 오류 응답 반환
    if (axios.isAxiosError(error) && error.response) {
      return error.response.data as ApiResponse;
    }
    
    // 기타 오류
    return {
      name: 'UNKNOWN_ERROR',
      code: 'AUTH-999',
      message: '알 수 없는 오류가 발생했습니다.',
      status: 'FAILURE',
      http_code: 500
    };
  }
};

// 로그아웃 응답 인터페이스
export interface LogoutResponse {
  status: string;
  message: string;
  data: null;
}

// 로그아웃 API
export const logout = async (): Promise<LogoutResponse> => {
  try {
    // API 요청 (apiClient에서 토큰 자동으로 추가)
    const response = await apiClient.post<LogoutResponse>(`/api/auths/logout`, {});
    
    // 로컬 스토리지에서 인증 데이터 제거
    localStorage.removeItem('access_token');
    localStorage.removeItem('refresh_token');
    localStorage.removeItem('hospital');
    
    return response.data;
  } catch (error) {
    console.error('로그아웃 오류:', error);
    
    // 로컬 스토리지에서 인증 데이터 제거 (에러가 발생하더라도 클라이언트 측에서는 로그아웃 처리)
    localStorage.removeItem('access_token');
    localStorage.removeItem('refresh_token');
    localStorage.removeItem('hospital');
    
    // 에러 응답 반환
    if (axios.isAxiosError(error) && error.response?.data) {
      return error.response.data as LogoutResponse;
    }
    
    return {
      status: 'error',
      message: '로그아웃 중 오류가 발생했습니다.',
      data: null
    };
  }
};

// 토큰 재발급 요청 및 응답 인터페이스
export interface RefreshTokenRequest {
  refresh_token: string;
}

export interface TokensResponse {
  access_token: string;
  refresh_token: string;
}

export interface RefreshTokenResponse extends ApiResponse<TokensResponse> {
  data?: TokensResponse;
}

// 토큰 재발급 API
export const refreshToken = async (refreshTokenValue: string): Promise<RefreshTokenResponse> => {
  try {
    const data: RefreshTokenRequest = {
      refresh_token: refreshTokenValue
    };
    
    const response = await axios.post(`${API_URL}/api/auths/refresh`, data);
    
    // 성공 시 새 토큰을 로컬 스토리지에 저장
    if (response.data.status === 'SUCCESS' && response.data.data) {
      localStorage.setItem('access_token', response.data.data.access_token);
      localStorage.setItem('refresh_token', response.data.data.refresh_token);
    }
    
    return response.data;
  } catch (error) {
    console.error('토큰 재발급 오류:', error);
    
    // 에러 객체가 AxiosError이고 응답이 있을 경우 API 오류 응답 반환
    if (axios.isAxiosError(error) && error.response) {
      return error.response.data as RefreshTokenResponse;
    }
    
    // 기타 오류
    return {
      name: 'UNKNOWN_ERROR',
      code: 'AUTH-999',
      message: '알 수 없는 오류가 발생했습니다.',
      status: 'FAILURE',
      http_code: 500
    };
  }
}; 