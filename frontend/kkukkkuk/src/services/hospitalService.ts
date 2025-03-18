import axios from 'axios';
import apiClient from './apiClient';

const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:8080/api';

// 병원 정보 API 응답 인터페이스
export interface ApiResponse<T = any> {
  name?: string;
  code?: string;
  message: string;
  status: 'SUCCESS' | 'FAILURE' | 'error';
  http_code?: number;
  data?: T;
}

// 인허가번호로 조회한 병원 정보 인터페이스
export interface HospitalAuthorizationResponse {
  id: number;
  name: string;
  address: string;
  phone_number: string;
}

// 병원 회원가입 요청 데이터 인터페이스
export interface HospitalSignupRequest {
  account: string;
  password: string;
  id: number;
  did: string;
  license_number: string;
  doctor_name: string;
}

// 병원 정보 조회
export const fetchHospitalInfo = async (authorizationNumber: string): Promise<ApiResponse<HospitalAuthorizationResponse>> => {
  try {
    // 실제 API 호출
    const response = await apiClient.get(`/api/hospitals/authorization-number/${authorizationNumber}`);
    return response.data;
    
    /* 목업 데이터는 삭제 또는 주석 처리
    await new Promise(resolve => setTimeout(resolve, 1000)); // 네트워크 지연 시뮬레이션
    
    // 테스트용 하드코딩된 라이센스 번호
    if (licenseNumber === '123456789') {
      return {
        success: true,
        data: {
          hospitalName: '행복동물병원',
          address: '서울시 강남구 역삼동 123-45',
          phoneNumber: '02-1234-5678',
          id: 1
        }
      };
    } else if (licenseNumber === '987654321') {
      return {
        success: true,
        data: {
          hospitalName: '사랑동물병원',
          address: '서울시 서초구 서초동 987-65',
          phoneNumber: '02-9876-5432',
          id: 2
        }
      };
    } else {
      return {
        success: false,
        message: '병원 정보를 찾을 수 없습니다.'
      };
    }
    */
  } catch (error) {
    console.error('병원 정보 조회 오류:', error);
    
    // 에러 객체가 AxiosError이고 응답이 있을 경우 API 오류 응답 반환
    if (axios.isAxiosError(error) && error.response) {
      return error.response.data as ApiResponse<HospitalAuthorizationResponse>;
    }
    
    // 기타 오류
    return {
      status: 'error',
      message: '서버 내부 오류가 발생했습니다.',
      data: undefined
    };
  }
};

// 병원 등록
export const registerHospital = async (data: HospitalSignupRequest): Promise<ApiResponse> => {
  try {
    // 실제 API 연동 시 사용할 코드
    // const response = await apiClient.post(`/auth/hospitals/signup`, data);
    // return response.data;
    
    // 목업 데이터 (실제 API 연동 전까지 사용)
    await new Promise(resolve => setTimeout(resolve, 1500)); // 네트워크 지연 시뮬레이션
    
    // 테스트용 성공 응답
    if (data.account && data.password && data.license_number) {
      return {
        status: 'SUCCESS',
        message: '병원 계정이 성공적으로 생성되었습니다.',
        data: {
          id: data.id,
          account: data.account,
          did: data.did || `did:example:hospital:${Math.random().toString(36).substring(2, 10)}`
        }
      };
    } 
    // 테스트용 실패 응답
    else {
      return {
        name: 'HOSPITAL_NOT_FOUND',
        code: 'AUTH-004',
        message: '병원 정보를 찾을 수 없습니다.',
        status: 'FAILURE',
        http_code: 400
      };
    }
  } catch (error) {
    console.error('병원 등록 오류:', error);
    
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

// 병원 정보 수정 요청 인터페이스
export interface UpdateHospitalRequest {
  did?: string;
  name?: string;
  phone_number?: string;
  password?: string;
}

// 병원 정보 수정 응답 인터페이스
export interface UpdateHospitalResponse {
  status: string;
  message: string;
  data: {
    id: number;
    did: string;
    account: string;
    name: string;
    address: string;
    phone_number: string;
  } | null;
}

// 병원 정보 수정
export const updateHospitalInfo = async (updateData: UpdateHospitalRequest): Promise<UpdateHospitalResponse> => {
  try {
    // API 호출하여 병원 정보 업데이트
    const response = await apiClient.put('/api/hospitals/me', updateData);
    return response.data;
  } catch (error) {
    console.error('병원 정보 수정 오류:', error);
    
    // 에러 객체가 AxiosError이고 응답이 있을 경우 API 오류 응답 반환
    if (axios.isAxiosError(error) && error.response) {
      return error.response.data as UpdateHospitalResponse;
    }
    
    // 기타 오류
    return {
      status: 'error',
      message: '서버 내부 오류가 발생했습니다.',
      data: null
    };
  }
};

// 계정 중복 확인 응답 인터페이스
export interface AccountCheckResponse extends ApiResponse<boolean | null> {
  data?: boolean | null;
}

// 계정 중복 확인
export const checkAccountAvailability = async (account: string): Promise<AccountCheckResponse> => {
  try {
    if (!account || account.trim() === '') {
      return {
        status: 'error',
        message: '이메일은 필수 입력사항입니다.',
        data: null
      };
    }

    // 실제 API 연동 시 사용할 코드
    // const response = await apiClient.get(`/api/hospitals/account/${account}`);
    // return response.data;
    
    // 목업 데이터 (실제 API 연동 전까지 사용)
    await new Promise(resolve => setTimeout(resolve, 800)); // 네트워크 지연 시뮬레이션
    
    // 테스트용 응답 (간단한 이메일 형식 체크)
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(account)) {
      return {
        status: 'error',
        message: '유효한 이메일 형식이 아닙니다.',
        data: null
      };
    }
    
    // 특정 이메일은 이미 사용 중으로 간주
    if (account === 'test@example.com' || account === 'admin@example.com') {
      return {
        status: 'SUCCESS',
        message: '사용할 수 없는 계정입니다.',
        data: false
      };
    }
    
    // 그 외에는 사용 가능한 계정으로 간주
    return {
      status: 'SUCCESS',
      message: '사용 가능한 계정입니다.',
      data: true
    };
  } catch (error) {
    console.error('계정 중복 확인 오류:', error);
    
    // 에러 객체가 AxiosError이고 응답이 있을 경우 API 오류 응답 반환
    if (axios.isAxiosError(error) && error.response) {
      return error.response.data as AccountCheckResponse;
    }
    
    // 기타 오류
    return {
      status: 'error',
      message: '서버 내부 오류가 발생했습니다.',
      data: null
    };
  }
};

// 라이센스 중복 확인 응답 인터페이스
export interface LicenseCheckResponse extends ApiResponse<boolean> {
  data?: boolean;
}

// 라이센스 중복 확인
export const checkLicenseAvailability = async (licenseNumber: string): Promise<LicenseCheckResponse> => {
  try {
    if (!licenseNumber || licenseNumber.trim() === '') {
      return {
        status: 'error',
        message: '라이센스 번호는 필수 입력사항입니다.',
        data: false
      };
    }

    // 실제 API 연동 시 사용할 코드
    // const response = await apiClient.get(`/api/hospitals/license/${licenseNumber}`);
    // return response.data;
    
    // 목업 데이터 (실제 API 연동 전까지 사용)
    await new Promise(resolve => setTimeout(resolve, 800)); // 네트워크 지연 시뮬레이션
    
    // 테스트용 응답
    if (licenseNumber === '123456') {
      return {
        status: 'SUCCESS',
        message: '사용할 수 없는 라이센스입니다.',
        data: false
      };
    }
    
    // 그 외에는 사용 가능한 라이센스로 간주
    return {
      status: 'SUCCESS',
      message: '사용 가능한 라이센스입니다.',
      data: true
    };
  } catch (error) {
    console.error('라이센스 중복 확인 오류:', error);
    
    // 에러 객체가 AxiosError이고 응답이 있을 경우 API 오류 응답 반환
    if (axios.isAxiosError(error) && error.response) {
      return error.response.data as LicenseCheckResponse;
    }
    
    // 기타 오류
    return {
      status: 'error',
      message: '서버 내부 오류가 발생했습니다.',
      data: false
    };
  }
};

// 병원 정보 응답 인터페이스
export interface HospitalInfoResponse {
  status: string;
  message: string;
  data: {
    id: number;
    name: string;
    did: string;
    account: string;
    password: string;
    address: string;
    phone_number: string;
    public_key: string | null;
    authoriazation_number: string;
    x_axis: number;
    y_axis: number;
    license_number: string;
    doctor_name: string;
  } | null;
}

// 병원 정보 조회
export const fetchHospitalMe = async (): Promise<HospitalInfoResponse> => {
  try {
    // API 호출하여 병원 정보 조회
    const response = await apiClient.get('/api/hospitals/me');
    return response.data;
  } catch (error) {
    console.error('병원 정보 조회 오류:', error);
    
    // 에러 객체가 AxiosError이고 응답이 있을 경우 API 오류 응답 반환
    if (axios.isAxiosError(error) && error.response) {
      return error.response.data as HospitalInfoResponse;
    }
    
    // 기타 오류
    return {
      status: 'error',
      message: '서버 내부 오류가 발생했습니다.',
      data: null
    };
  }
};

// 병원 회원 탈퇴 응답 인터페이스
export interface DeleteHospitalResponse {
  status: string;
  message: string;
  data: null;
}

// 병원 회원 탈퇴
export const deleteHospitalAccount = async (): Promise<DeleteHospitalResponse> => {
  try {
    const response = await apiClient.delete('/api/hospitals/me');
    return response.data;
  } catch (error) {
    console.error('병원 회원 탈퇴 오류:', error);
    
    // 에러 객체가 AxiosError이고 응답이 있을 경우 API 오류 응답 반환
    if (axios.isAxiosError(error) && error.response) {
      return error.response.data as DeleteHospitalResponse;
    }
    
    // 기타 오류
    return {
      status: 'error',
      message: '서버 내부 오류가 발생했습니다.',
      data: null
    };
  }
};

// 의사 목록 API 응답 인터페이스
export interface Doctor {
  id: number;
  name: string;
  // licenseNumber?: string; // 향후 추가될 예정
}

export interface FetchDoctorsResponse {
  status: string;
  message: string;
  data: Doctor[] | null;
}

// 병원 소속 의사 목록 조회
export const fetchDoctors = async (): Promise<FetchDoctorsResponse> => {
  try {
    const response = await apiClient.get('/api/hospitals/me/doctors');
    return response.data;
  } catch (error) {
    console.error('의사 목록 조회 오류:', error);
    
    // 에러 객체가 AxiosError이고 응답이 있을 경우 API 오류 응답 반환
    if (axios.isAxiosError(error) && error.response) {
      return error.response.data as FetchDoctorsResponse;
    }
    
    // 기타 오류
    return {
      status: 'error',
      message: '서버 내부 오류가 발생했습니다.',
      data: null
    };
  }
};

// 의사 추가 API 요청 인터페이스
export interface AddDoctorRequest {
  name: string;
}

// 의사 추가 API 응답 인터페이스
export interface AddDoctorResponse {
  status: string;
  message: string;
  data: Doctor | null;
}

// 의사 추가
export const addDoctor = async (doctorName: string, hospitalId: string | number): Promise<AddDoctorResponse> => {
  try {
    const response = await apiClient.post('/api/hospitals/me/doctors', 
      { name: doctorName },
      { 
        headers: {
          'hospitalId': hospitalId.toString()
        }
      }
    );
    return response.data;
  } catch (error) {
    console.error('의사 추가 오류:', error);
    
    // 에러 객체가 AxiosError이고 응답이 있을 경우 API 오류 응답 반환
    if (axios.isAxiosError(error) && error.response) {
      return error.response.data as AddDoctorResponse;
    }
    
    // 기타 오류
    return {
      status: 'error',
      message: '서버 내부 오류가 발생했습니다.',
      data: null
    };
  }
};

// 의사 상세 정보 응답 인터페이스
export interface DoctorDetailResponse {
  status: string;
  message: string;
  data: Doctor | null;
}

// 특정 의사 정보 조회
export const fetchDoctorDetail = async (doctorId: string | number): Promise<DoctorDetailResponse> => {
  try {
    const response = await apiClient.get(`/api/doctors/${doctorId}`);
    return response.data;
  } catch (error) {
    console.error('의사 상세 정보 조회 오류:', error);
    
    // 에러 객체가 AxiosError이고 응답이 있을 경우 API 오류 응답 반환
    if (axios.isAxiosError(error) && error.response) {
      return error.response.data as DoctorDetailResponse;
    }
    
    // 기타 오류
    return {
      status: 'error',
      message: '서버 내부 오류가 발생했습니다.',
      data: null
    };
  }
};

// 의사 정보 수정 요청 인터페이스
export interface UpdateDoctorRequest {
  name: string;
}

// 의사 정보 수정 응답 인터페이스
export interface UpdateDoctorResponse {
  status: string;
  message: string;
  data: Doctor | null;
}

// 의사 정보 수정
export const updateDoctor = async (doctorId: string | number, name: string): Promise<UpdateDoctorResponse> => {
  try {
    const response = await apiClient.put(`/api/doctors/${doctorId}`, { name });
    return response.data;
  } catch (error) {
    console.error('의사 정보 수정 오류:', error);
    
    // 에러 객체가 AxiosError이고 응답이 있을 경우 API 오류 응답 반환
    if (axios.isAxiosError(error) && error.response) {
      return error.response.data as UpdateDoctorResponse;
    }
    
    // 기타 오류
    return {
      status: 'error',
      message: '서버 내부 오류가 발생했습니다.',
      data: null
    };
  }
};

// 의사 삭제 응답 인터페이스
export interface DeleteDoctorResponse {
  status: string;
  message: string;
  data: null;
}

// 의사 삭제
export const deleteDoctor = async (doctorId: string | number): Promise<DeleteDoctorResponse> => {
  try {
    const response = await apiClient.delete(`/api/doctors/${doctorId}`);
    return response.data;
  } catch (error) {
    console.error('의사 삭제 오류:', error);
    
    // 에러 객체가 AxiosError이고 응답이 있을 경우 API 오류 응답 반환
    if (axios.isAxiosError(error) && error.response) {
      return error.response.data as DeleteDoctorResponse;
    }
    
    // 기타 오류
    return {
      status: 'error',
      message: '서버 내부 오류가 발생했습니다.',
      data: null
    };
  }
}; 