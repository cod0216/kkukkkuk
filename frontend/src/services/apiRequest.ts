import apiClient from "@/services/apiClient";
import { ApiResponse, ResponseStatus, ErrorResponse } from "@/types";
import { AxiosError } from "axios";

/**
 * @module apiRequest
 * @file apiRequest.tsx
 * @author eunchang
 * @date 2025-03-26
 * @description Axios 기반의 API 요청 기능을 제공하는 모듈입니다.
 *
 * 이 모듈은 GET, POST, PUT, DELETE 요청을 수행합니다.
 *
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-26        eunchang         최초 생성
 * 2025-03-30        sangmuk          request patch method 추가
 */

/**
 * AxiosError 객체로부터 에러 메시지를 추출합니다.
 *
 * @param error - AxiosError 객체
 * @returns 에러 메시지 문자열
 */
export const extractErrorMessage = (error: AxiosError): string => {
  if (error.response?.data && (error.response.data as ErrorResponse).message) {
    return (error.response.data as ErrorResponse).message;
  }

  if (error.message) {
    return error.message;
  }
  return "알 수 없는 오류가 발생했습니다.";
};

/**
 * API 요청을 수행하는 객체입니다.
 */
export const request = {
  /**
   * GET Request
   */
  get: async <T>(url: string, params?: object): Promise<ApiResponse<T>> => {
    try {
      const response = await apiClient.get<ApiResponse<T>>(url, { params });
      return response.data;
    } catch (error) {
      const AxiosError = error as AxiosError;
      const errorMessage = extractErrorMessage(AxiosError);
      return {
        status: ResponseStatus.FAILURE,
        message: errorMessage,
        data: null,
      };
    }
  },

  /**
   * POST Request
   */
  post: async <T>(url: string, data?: object): Promise<ApiResponse<T>> => {
    try {
      const response = await apiClient.post<ApiResponse<T>>(url, data);
      return response.data;
    } catch (error) {
      const axiosError = error as AxiosError;
      const errorMessage = extractErrorMessage(axiosError);
      return {
        status: ResponseStatus.FAILURE,
        message: errorMessage,
        data: null,
      };
    }
  },

  /**
   * PUT Request
   */
  put: async <T>(url: string, data?: object): Promise<ApiResponse<T>> => {
    try {
      const response = await apiClient.put<ApiResponse<T>>(url, data);
      return response.data;
    } catch (error) {
      const axiosError = error as AxiosError;
      const errorMessage = extractErrorMessage(axiosError);
      return {
        status: ResponseStatus.FAILURE,
        message: errorMessage,
        data: null,
      };
    }
  },

  /**
   * DELETE Request
   */
  delete: async <T>(url: string): Promise<ApiResponse<T>> => {
    try {
      const response = await apiClient.post<ApiResponse<T>>(url);
      return response.data;
    } catch (error) {
      const axiosError = error as AxiosError;
      const errorMessage = extractErrorMessage(axiosError);
      return {
        status: ResponseStatus.FAILURE,
        message: errorMessage,
        data: null,
      };
    }
  },

  /**
   * PATCH Request
   */
  patch: async <T>(url: string, data?: object): Promise<ApiResponse<T>> => {
    try {
      const response = await apiClient.patch<ApiResponse<T>>(url, data)
      return response.data
    } catch (error) {
      const axiosError = error as AxiosError
      const errorMessage = extractErrorMessage(axiosError)
      return {
        status: ResponseStatus.FAILURE,
        message: errorMessage,
        data: null,
      }
    }
  },
};
