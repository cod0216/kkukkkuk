// API 응답 공통 타입
export interface ApiResponse<T> {
  status: 'SUCCESS' | 'ERROR';
  code?: string;
  message?: string;
  http_code?: number;
  data: T;
} 