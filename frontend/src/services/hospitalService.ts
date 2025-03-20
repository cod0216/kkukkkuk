import axios from "axios";
import apiClient from "./api";
import {
  ApiResponse,
  HospitalAuthorizationResponse,
  HospitalSignupRequest,
  UpdateHospitalRequest,
  UpdateHospitalResponse,
  AccountCheckResponse,
  LicenseCheckResponse,
  HospitalInfoResponse,
  DeleteHospitalResponse,
  Doctor,
  FetchDoctorsResponse,
} from "@/interfaces/index";

import {
  AddDoctorResponse,
  DoctorDetailResponse,
  UpdateDoctorResponse,
  DeleteDoctorResponse,
} from "@/interfaces/doctor";

// 병원 정보 조회
export const fetchHospitalInfo = async (
  authorizationNumber: string
): Promise<ApiResponse<HospitalAuthorizationResponse>> => {
  try {
    const response = await apiClient.get(
      `/api/hospitals/authorization-number/${authorizationNumber}`
    );
    return response.data;
  } catch (error) {
    console.error(error);

    if (axios.isAxiosError(error) && error.response) {
      return error.response.data as ApiResponse<HospitalAuthorizationResponse>;
    }

    return {
      status: "FAILURE",
      message: "서버 내부 오류가 발생했습니다.",
    };
  }
};

// 병원 등록
export const registerHospital = async (
  data: HospitalSignupRequest
): Promise<ApiResponse> => {
  try {
    const response = await apiClient.post(`/auth/hospitals/signup`, data);
    return response.data;
  } catch (error) {
    console.error(error);

    if (axios.isAxiosError(error) && error.response) {
      return error.response.data as ApiResponse;
    }

    return {
      status: "FAILURE",
      message: "알 수 없는 오류가 발생했습니다.",
    };
  }
};

// 병원 정보 수정
export const updateHospitalInfo = async (
  updateData: UpdateHospitalRequest
): Promise<UpdateHospitalResponse> => {
  try {
    const response = await apiClient.put("/api/hospitals/me", updateData);
    return response.data;
  } catch (error) {
    console.error(error);

    if (axios.isAxiosError(error) && error.response) {
      return error.response.data as UpdateHospitalResponse;
    }

    return {
      status: "FAILURE",
      message: "서버 내부 오류가 발생했습니다.",
      data: null,
    };
  }
};

// 계정 중복 확인
export const checkAccountAvailability = async (
  account: string
): Promise<AccountCheckResponse> => {
  try {
    if (!account || account.trim() === "") {
      return {
        status: "FAILURE",
        message: "이메일은 필수 입력사항입니다.",
        data: null,
      };
    }

    const response = await apiClient.get(`/api/hospitals/account/${account}`);
    return response.data;
  } catch (error) {
    console.error(error);

    if (axios.isAxiosError(error) && error.response) {
      return error.response.data as AccountCheckResponse;
    }

    return {
      status: "FAILURE",
      message: "서버 내부 오류가 발생했습니다.",
      data: null,
    };
  }
};

// 라이센스 중복 확인
export const checkLicenseAvailability = async (
  licenseNumber: string
): Promise<LicenseCheckResponse> => {
  try {
    if (!licenseNumber || licenseNumber.trim() === "") {
      return {
        status: "FAILURE",
        message: "라이센스 번호는 필수 입력사항입니다.",
        data: false,
      };
    }

    const response = await apiClient.get(
      `/api/hospitals/license/${licenseNumber}`
    );
    return response.data;
  } catch (error) {
    console.error(error);

    if (axios.isAxiosError(error) && error.response) {
      return error.response.data as LicenseCheckResponse;
    }

    return {
      status: "FAILURE",
      message: "서버 내부 오류가 발생했습니다.",
      data: false,
    };
  }
};

// 병원 정보 조회 (내 정보)
export const fetchHospitalMe = async (): Promise<HospitalInfoResponse> => {
  try {
    const response = await apiClient.get("/api/hospitals/me");
    return response.data;
  } catch (error) {
    console.error(error);

    if (axios.isAxiosError(error) && error.response) {
      return error.response.data as HospitalInfoResponse;
    }

    return {
      status: "FAILURE",
      message: "서버 내부 오류가 발생했습니다.",
      data: null,
    };
  }
};

// 병원 회원 탈퇴
export const deleteHospitalAccount =
  async (): Promise<DeleteHospitalResponse> => {
    try {
      const response = await apiClient.delete("/api/hospitals/me");
      return response.data;
    } catch (error) {
      console.error(error);

      if (axios.isAxiosError(error) && error.response) {
        return error.response.data as DeleteHospitalResponse;
      }

      return {
        status: "FAILURE",
        message: "서버 내부 오류가 발생했습니다.",
        data: null,
      };
    }
  };

// 병원 소속 의사 목록 조회
export const fetchDoctors = async (): Promise<FetchDoctorsResponse> => {
  try {
    const response = await apiClient.get("/api/hospitals/me/doctors");
    return response.data;
  } catch (error) {
    console.error(error);

    if (axios.isAxiosError(error) && error.response) {
      return error.response.data as FetchDoctorsResponse;
    }

    return {
      status: "FAILURE",
      message: "서버 내부 오류가 발생했습니다.",
      data: null,
    };
  }
};

// 의사 추가
export const addDoctor = async (
  doctorName: string,
  hospitalId: string | number
): Promise<AddDoctorResponse> => {
  try {
    const response = await apiClient.post(
      "/api/hospitals/me/doctors",
      { name: doctorName },
      {
        headers: {
          hospitalId: hospitalId.toString(),
        },
      }
    );
    return response.data;
  } catch (error) {
    console.error(error);

    if (axios.isAxiosError(error) && error.response) {
      return error.response.data as AddDoctorResponse;
    }

    return {
      status: "FAILURE",
      message: "서버 내부 오류가 발생했습니다.",
      data: null,
    };
  }
};

// 특정 의사 정보 조회
export const fetchDoctorDetail = async (
  doctorId: string | number
): Promise<DoctorDetailResponse> => {
  try {
    const response = await apiClient.get(`/api/doctors/${doctorId}`);
    return response.data;
  } catch (error) {
    console.error(error);

    if (axios.isAxiosError(error) && error.response) {
      return error.response.data as DoctorDetailResponse;
    }

    return {
      status: "FAILURE",
      message: "서버 내부 오류가 발생했습니다.",
      data: null,
    };
  }
};

// 의사 정보 수정
export const updateDoctor = async (
  doctorId: string | number,
  name: string
): Promise<UpdateDoctorResponse> => {
  try {
    const response = await apiClient.put(`/api/doctors/${doctorId}`, { name });
    return response.data;
  } catch (error) {
    console.error(error);

    if (axios.isAxiosError(error) && error.response) {
      return error.response.data as UpdateDoctorResponse;
    }

    return {
      status: "FAILURE",
      message: "서버 내부 오류가 발생했습니다.",
      data: null,
    };
  }
};

// 의사 삭제
export const deleteDoctor = async (
  doctorId: string | number
): Promise<DeleteDoctorResponse> => {
  try {
    const response = await apiClient.delete(`/api/doctors/${doctorId}`);
    return response.data;
  } catch (error) {
    console.error(error);

    if (axios.isAxiosError(error) && error.response) {
      return error.response.data as DeleteDoctorResponse;
    }

    return {
      status: "FAILURE",
      message: "서버 내부 오류가 발생했습니다.",
      data: null,
    };
  }
};
