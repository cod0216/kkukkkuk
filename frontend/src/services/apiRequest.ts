import apiClient from "@/services/apiClient";
import { ApiResponse, ResponseStatus, ErrorResponse } from "@/types";
import { AxiosError } from "axios";

/**
 * Extract Error Object
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
};
