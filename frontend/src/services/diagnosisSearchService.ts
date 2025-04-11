import { ResponseStatus, ApiResponse } from "@/types";
import apiClient from "@/services/apiClient";
import {
  DiagnosisListResponse,
  DiagnosisRequest,
  DiagnosisResponse,
  AutoCorrectDiagnosisResponse,
} from "@/interfaces/index";

/**
 * @module diagnosisSearchService
 * @file diagnosisSearchService.ts
 * @author eunchang
 * @date 2025-04-09
 * @description 검사 조회 서비스입니다.
 *
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-04-09        eunchang         최초 생성
 */

/**
 * 검사 전체 조회 서비스
 */
export const getDiagnoses = async (): Promise<DiagnosisListResponse> => {
  try {
    const response = await apiClient.get("/api/diagnoses");

    if (response.status === 200) {
      return {
        status: ResponseStatus.SUCCESS,
        message:
          response.data.message || "전체 검사 항목을 성공적으로 조회했습니다.",
        data: response.data.data || [],
      };
    }

    return {
      status: ResponseStatus.FAILURE,
      message: "검사 항목 조회에 실패했습니다.",
      data: [],
    };
  } catch (error: any) {
    return {
      status: ResponseStatus.FAILURE,
      message:
        error.response?.data?.message ||
        "검사 항목 조회 중 오류가 발생했습니다.",
      data: [],
    };
  }
};

/**
 * 검사 생성 서비스
 */
export const createDiagnosis = async (
  request: DiagnosisRequest
): Promise<DiagnosisResponse> => {
  try {
    const response = await apiClient.post("/api/diagnoses", request);

    if (response.status === 200) {
      return {
        status: ResponseStatus.SUCCESS,
        message:
          response.data.message || "검사 항목이 성공적으로 생성되었습니다.",
        data: response.data.data,
      };
    }

    return {
      status: ResponseStatus.FAILURE,
      message: "검사 항목 생성에 실패했습니다.",
      data: null,
    };
  } catch (error: any) {
    return {
      status: ResponseStatus.FAILURE,
      message:
        error.response?.data?.message ||
        "검사 항목 생성 중 오류가 발생했습니다.",
      data: null,
    };
  }
};

/**
 * 검사 수정 서비스
 */
export const updateDiagnosis = async (
  diagnosisId: number,
  request: DiagnosisRequest
): Promise<DiagnosisResponse> => {
  try {
    const response = await apiClient.put(
      `/api/diagnoses/${diagnosisId}`,
      request
    );

    if (response.status === 200) {
      return {
        status: ResponseStatus.SUCCESS,
        message:
          response.data.message || "검사 항목이 성공적으로 수정되었습니다.",
        data: response.data.data,
      };
    }

    return {
      status: ResponseStatus.FAILURE,
      message: "검사 항목 수정에 실패했습니다.",
      data: null,
    };
  } catch (error: any) {
    return {
      status: ResponseStatus.FAILURE,
      message:
        error.response?.data?.message ||
        "검사 항목 수정 중 오류가 발생했습니다.",
      data: null,
    };
  }
};

/**
 * 검사 삭제 서비스
 */
export const deleteDiagnosis = async (
  diagnosisId: number
): Promise<ApiResponse<null>> => {
  try {
    const response = await apiClient.delete(`/api/diagnoses/${diagnosisId}`);

    if (response.status === 200) {
      return {
        status: ResponseStatus.SUCCESS,
        message:
          response.data.message || "검사 항목이 성공적으로 삭제되었습니다.",
        data: null,
      };
    }

    return {
      status: ResponseStatus.FAILURE,
      message: "검사 항목 삭제에 실패했습니다.",
      data: null,
    };
  } catch (error: any) {
    return {
      status: ResponseStatus.FAILURE,
      message:
        error.response?.data?.message ||
        "검사 항목 삭제 중 오류가 발생했습니다.",
      data: null,
    };
  }
};

/**
 * 검사 단일 검색
 *
 */
export const searchDiagnosis = async (
  search: string
): Promise<DiagnosisListResponse> => {
  try {
    if (!search.trim()) {
      return {
        status: ResponseStatus.SUCCESS,
        message: "검색어를 입력해주세요.",
        data: [],
      };
    }

    const response = await apiClient.get(
      `/api/diagnoses/${encodeURIComponent(search)}`
    );

    if (response.status === 200) {
      return {
        status: ResponseStatus.SUCCESS,
        message: response.data.message || `'${search}' 검색 결과입니다.`,
        data: response.data.data || [],
      };
    }

    return {
      status: ResponseStatus.FAILURE,
      message: "검사 항목 검색에 실패했습니다.",
      data: [],
    };
  } catch (error: any) {
    return {
      status: ResponseStatus.FAILURE,
      message:
        error.response?.data?.message ||
        "검사 항목 검색 중 오류가 발생했습니다.",
      data: [],
    };
  }
};

/**
 * 검색 자동완성
 *
 */
export const autoCorrectDiagnosis = async (
  search: string
): Promise<AutoCorrectDiagnosisResponse> => {
  try {
    if (!search.trim()) {
      return {
        status: ResponseStatus.SUCCESS,
        message: "검색어를 입력해주세요.",
        data: [],
      };
    }

    const response = await apiClient.get(
      `/api/diagnoses/auto-correct?search=${encodeURIComponent(search)}`
    );

    if (response.status === 200) {
      return {
        status: ResponseStatus.SUCCESS,
        message:
          response.data.message || "자동완성 결과를 성공적으로 불러왔습니다.",
        data: response.data.data || [],
      };
    }

    return {
      status: ResponseStatus.FAILURE,
      message: "자동완성 결과를 불러오는데 실패했습니다.",
      data: [],
    };
  } catch (error: any) {
    return {
      status: ResponseStatus.FAILURE,
      message:
        error.response?.data?.message ||
        "자동완성 결과 불러오는 중 오류가 발생했습니다.",
      data: [],
    };
  }
};
