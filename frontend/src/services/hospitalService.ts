import api from "../api/interceptors";

// 인허가 번호로 병원 정보 조회하는 함수
export const fetchHospitalInfo = async (licenseNumber: string) => {
  try {
    // 실제 API 연동 시 아래 코드 사용
    // const response = await axios.get(`${API_URL}/hospitals/license/${licenseNumber}`);
    // return response.data;

    // 테스트용 모의 응답 (실제 구현 시 대체 필요)
    await new Promise((resolve) => setTimeout(resolve, 1500));

    if (!licenseNumber.trim()) {
      throw new Error("인허가 번호를 입력해주세요.");
    }

    // 예시 데이터 반환 (병원 id 포함)
    return {
      success: true,
      data: {
        id: 2,
        hospitalName: `${licenseNumber.slice(0, 3)}동물병원`,
        address: "서울시 강남구 테헤란로 123",
        phoneNumber: "02-123-4567",
        licenseNumber: licenseNumber,
      },
    };
  } catch (error) {
    console.error("병원 정보 조회 오류:", error);
    throw error;
  }
};

// HospitalSignupRequest DTO에 맞는 인터페이스
export interface HospitalSignupRequestPayload {
  account: string;
  password: string;
  id: number;
  did: string;
  license_number: string;
  doctor_name: string;
}

// 병원 회원가입 함수
export const registerHospital = async (
  hospitalData: HospitalSignupRequestPayload
) => {
  try {
    // 실제 API 연동 시 아래 코드 사용
    // const response = await axios.post(`${API_URL}/hospitals/register`, hospitalData);
    // return response.data;

    // 테스트용 모의 응답 (실제 구현 시 대체 필요)
    await new Promise((resolve) => setTimeout(resolve, 1500));

    // 필수 필드 검증
    const requiredFields: Array<keyof HospitalSignupRequestPayload> = [
      "account",
      "password",
      "id",
      "did",
      "license_number",
      "doctor_name",
    ];
    for (const field of requiredFields) {
      if (!hospitalData[field]) {
        throw new Error(`${field} 필드는 필수입니다.`);
      }
    }

    // DID는 실제 백엔드에서 처리하더라도 모의 응답에서는 그대로 사용합니다.
    return {
      success: true,
      message: "병원 계정이 성공적으로 등록되었습니다.",
      data: {
        id: hospitalData.id,
        hospitalName: hospitalData.account, // 실제 병원 이름 등으로 대체 가능
        did: hospitalData.did,
        createdAt: new Date().toISOString(),
      },
    };
  } catch (error) {
    console.error("병원 등록 오류:", error);
    throw error;
  }
};

// 의사 인증 함수
export const verifyDoctor = async (doctorInfo: {
  name: string;
  licenseNumber: string;
}) => {
  try {
    await new Promise((resolve) => setTimeout(resolve, 1000));

    if (!doctorInfo.name || !doctorInfo.licenseNumber) {
      throw new Error("의사 이름과 면허번호는 필수입니다.");
    }

    return {
      success: true,
      message: "의사 인증이 완료되었습니다.",
      data: {
        isVerified: true,
        name: doctorInfo.name,
        licenseNumber: doctorInfo.licenseNumber,
      },
    };
  } catch (error) {
    console.error("의사 인증 오류:", error);
    throw error;
  }
};
