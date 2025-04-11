import { AxiosError } from "axios";
import { ResponseStatus, ApiResponse } from "@/types";
import apiClient from "@/services/apiClient";
import {
  VaccinationListResponse,
  VaccinationRequest,
  VaccinationResponse,
  AutoCorrectVaccinationResponse,
} from "@/interfaces/vaccination";
import { extractErrorMessage } from "@/services/apiRequest";

/**
 * 백신 접종 전체 조회 서비스
 */
export const getVaccinations = async (): Promise<VaccinationListResponse> => {
  try {
    const response = await apiClient.get<
      ApiResponse<VaccinationListResponse["data"]>
    >("/api/vaccinations");
    return {
      status: ResponseStatus.SUCCESS,
      message:
        response.data.message ||
        "전체 백신 접종 항목을 성공적으로 조회했습니다.",
      data: response.data.data || [],
    };
  } catch (error: any) {
    const errorMessage = extractErrorMessage(error as AxiosError);
    return {
      status: ResponseStatus.FAILURE,
      message: errorMessage || "백신 접종 항목 조회 중 오류가 발생했습니다.",
      data: [],
    };
  }
};

/**
 * 백신 접종 생성 서비스
 */
export const createVaccination = async (
  request: VaccinationRequest
): Promise<VaccinationResponse> => {
  try {
    const response = await apiClient.post<
      ApiResponse<VaccinationResponse["data"]>
    >("/api/vaccinations", request);
    return {
      status: ResponseStatus.SUCCESS,
      message:
        response.data.message || "백신 접종 항목이 성공적으로 생성되었습니다.",
      data: response.data.data,
    };
  } catch (error: any) {
    const errorMessage = extractErrorMessage(error as AxiosError);
    return {
      status: ResponseStatus.FAILURE,
      message: errorMessage || "백신 접종 항목 생성 중 오류가 발생했습니다.",
      data: null,
    };
  }
};

/**
 * 백신 접종 수정 서비스
 */
export const updateVaccination = async (
  vaccinationId: number,
  request: VaccinationRequest
): Promise<VaccinationResponse> => {
  try {
    const response = await apiClient.put<
      ApiResponse<VaccinationResponse["data"]>
    >(`/api/vaccinations/${vaccinationId}`, request);
    return {
      status: ResponseStatus.SUCCESS,
      message:
        response.data.message || "백신 접종 항목이 성공적으로 수정되었습니다.",
      data: response.data.data,
    };
  } catch (error: any) {
    const errorMessage = extractErrorMessage(error as AxiosError);
    return {
      status: ResponseStatus.FAILURE,
      message: errorMessage || "백신 접종 항목 수정 중 오류가 발생했습니다.",
      data: null,
    };
  }
};

/**
 * 백신 접종 삭제 서비스
 */
export const deleteVaccination = async (
  vaccinationId: number
): Promise<ApiResponse<null>> => {
  try {
    const response = await apiClient.delete<ApiResponse<null>>(
      `/api/vaccinations/${vaccinationId}`
    );
    return {
      status: ResponseStatus.SUCCESS,
      message:
        response.data.message || "백신 접종 항목이 성공적으로 삭제되었습니다.",
      data: null,
    };
  } catch (error: any) {
    const errorMessage = extractErrorMessage(error as AxiosError);
    return {
      status: ResponseStatus.FAILURE,
      message: errorMessage || "백신 접종 항목 삭제 중 오류가 발생했습니다.",
      data: null,
    };
  }
};

/**
 * 백신 접종 항목 검색 서비스
 */
export const searchVaccination = async (
  search: string
): Promise<VaccinationListResponse> => {
  if (!search.trim()) {
    return {
      status: ResponseStatus.SUCCESS,
      message: "검색어를 입력해주세요.",
      data: [],
    };
  }

  try {
    const response = await apiClient.get<
      ApiResponse<VaccinationListResponse["data"]>
    >(`/api/vaccinations/${encodeURIComponent(search)}`);
    return {
      status: ResponseStatus.SUCCESS,
      message: response.data.message || `'${search}' 검색 결과입니다.`,
      data: response.data.data || [],
    };
  } catch (error: any) {
    const errorMessage = extractErrorMessage(error as AxiosError);
    return {
      status: ResponseStatus.FAILURE,
      message: errorMessage || "백신 접종 항목 검색 중 오류가 발생했습니다.",
      data: [],
    };
  }
};

/**
 * 백신 접종 자동완성 서비스
 */
export const autoCorrectVaccination = async (
  search: string
): Promise<AutoCorrectVaccinationResponse> => {
  if (!search.trim()) {
    return {
      status: ResponseStatus.SUCCESS,
      message: "검색어를 입력해주세요.",
      data: [],
    };
  }

  try {
    const response = await apiClient.get<
      ApiResponse<AutoCorrectVaccinationResponse["data"]>
    >(`/api/vaccinations/auto-correct?search=${encodeURIComponent(search)}`);
    return {
      status: ResponseStatus.SUCCESS,
      message:
        response.data.message || "자동완성 결과를 성공적으로 불러왔습니다.",
      data: response.data.data || [],
    };
  } catch (error: any) {
    const errorMessage = extractErrorMessage(error as AxiosError);
    return {
      status: ResponseStatus.FAILURE,
      message: errorMessage || "자동완성 결과 불러오는 중 오류가 발생했습니다.",
      data: [],
    };
  }
};
