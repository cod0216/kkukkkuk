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

// 병원 정보 수정 요청 인터페이스
export interface UpdateHospitalRequest {
  did?: string;
  name?: string;
  phone_number?: string;
  password?: string;
}

// 병원 정보 수정 응답 인터페이스
export interface UpdateHospitalResponse {
  status: "SUCCESS" | "FAILURE";
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

// 병원 정보 응답 인터페이스
export interface HospitalInfoResponse {
  status: "SUCCESS" | "FAILURE";
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

// 병원 회원 탈퇴 응답 인터페이스
export interface DeleteHospitalResponse {
  status: "SUCCESS" | "FAILURE";
  message: string;
  data: null;
}

// 의사 정보 인터페이스
export interface Doctor {
  id: number;
  name: string;
}

// 의사 목록 API 응답 인터페이스
export interface FetchDoctorsResponse {
  status: "SUCCESS" | "FAILURE";
  message: string;
  data: Doctor[] | null;
}
