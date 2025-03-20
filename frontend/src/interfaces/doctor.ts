// 의사 정보 인터페이스
export interface Doctor {
  id: number;
  name: string;
}

export interface DoctorRegister {
  id: string;
  name: string;
  licenseNumber: string;
}

// 의사 목록 API 응답 인터페이스
export interface FetchDoctorsResponse {
  status: "SUCCESS" | "FAILURE";
  message: string;
  data: Doctor[] | null;
}

// 의사 추가 요청 인터페이스
export interface AddDoctorRequest {
  name: string;
}

// 의사 추가 API 응답 인터페이스
export interface AddDoctorResponse {
  status: "SUCCESS" | "FAILURE";
  message: string;
  data: Doctor | null;
}

// 의사 상세 정보 응답 인터페이스
export interface DoctorDetailResponse {
  status: "SUCCESS" | "FAILURE";
  message: string;
  data: Doctor | null;
}

// 의사 정보 수정 요청 인터페이스
export interface UpdateDoctorRequest {
  name: string;
}

// 의사 정보 수정 응답 인터페이스
export interface UpdateDoctorResponse {
  status: "SUCCESS" | "FAILURE";
  message: string;
  data: Doctor | null;
}

// 의사 삭제 응답 인터페이스
export interface DeleteDoctorResponse {
  status: "SUCCESS" | "FAILURE";
  message: string;
  data: null;
}
