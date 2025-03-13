import axios from 'axios';

// 기본 URL 설정
const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:8080/api';

// 인허가 번호로 병원 정보 조회하는 함수
export const fetchHospitalInfo = async (licenseNumber: string) => {
  try {
    // 실제 API 연동 시 아래 코드 사용
    // const response = await axios.get(`${API_URL}/hospitals/license/${licenseNumber}`);
    // return response.data;
    
    // 테스트용 모의 응답 (실제 구현 시 대체 필요)
    await new Promise(resolve => setTimeout(resolve, 1500));
    
    // 라이센스 번호가 비어있으면 오류 발생
    if (!licenseNumber.trim()) {
      throw new Error('인허가 번호를 입력해주세요.');
    }
    
    // 예시 데이터 반환
    return {
      success: true,
      data: {
        hospitalName: `${licenseNumber.slice(0, 3)}동물병원`,
        address: '서울시 강남구 테헤란로 123',
        phoneNumber: '02-123-4567',
        licenseNumber: licenseNumber,
      }
    };
  } catch (error) {
    console.error('병원 정보 조회 오류:', error);
    throw error;
  }
};

interface HospitalRegistrationData {
  hospitalName: string;
  address: string;
  phoneNumber: string;
  licenseNumber: string;
  username: string;
  password: string;
  email: string;
  doctors: Array<{
    name: string;
    licenseNumber: string;
  }>;
}

// 병원 회원가입 함수
export const registerHospital = async (hospitalData: HospitalRegistrationData) => {
  try {
    // 실제 API 연동 시 아래 코드 사용
    // const response = await axios.post(`${API_URL}/hospitals/register`, hospitalData);
    // return response.data;
    
    // 테스트용 모의 응답 (실제 구현 시 대체 필요)
    await new Promise(resolve => setTimeout(resolve, 1500));
    
    // 필수 필드 검증
    const requiredFields = ['hospitalName', 'address', 'phoneNumber', 'licenseNumber', 'username', 'password', 'email'];
    for (const field of requiredFields) {
      if (!hospitalData[field as keyof HospitalRegistrationData]) {
        throw new Error(`${field} 필드는 필수입니다.`);
      }
    }
    
    // 의사 정보 검증
    if (!hospitalData.doctors || hospitalData.doctors.length === 0) {
      throw new Error('최소 1명 이상의 의사 정보가 필요합니다.');
    }
    
    // DID 생성 (실제로는 백엔드에서 처리)
    const did = `did:kkuk:hospital:${Date.now().toString(36)}`;
    
    // 성공 응답 반환
    return {
      success: true,
      message: '병원 계정이 성공적으로 등록되었습니다.',
      data: {
        id: Math.floor(Math.random() * 10000),
        hospitalName: hospitalData.hospitalName,
        email: hospitalData.email,
        did,
        createdAt: new Date().toISOString()
      }
    };
  } catch (error) {
    console.error('병원 등록 오류:', error);
    throw error;
  }
};

// 의사 인증 함수
export const verifyDoctor = async (doctorInfo: { name: string, licenseNumber: string }) => {
  try {
    // 실제 API 연동 시 아래 코드 사용
    // const response = await axios.post(`${API_URL}/doctors/verify`, doctorInfo);
    // return response.data;
    
    // 테스트용 모의 응답 (실제 구현 시 대체 필요)
    await new Promise(resolve => setTimeout(resolve, 1000));
    
    // 필수 필드 검증
    if (!doctorInfo.name || !doctorInfo.licenseNumber) {
      throw new Error('의사 이름과 면허번호는 필수입니다.');
    }
    
    // 성공 응답 반환 (실제로는 API에서 검증 후 결과 반환)
    return {
      success: true,
      message: '의사 인증이 완료되었습니다.',
      data: {
        isVerified: true,
        name: doctorInfo.name,
        licenseNumber: doctorInfo.licenseNumber
      }
    };
  } catch (error) {
    console.error('의사 인증 오류:', error);
    throw error;
  }
}; 