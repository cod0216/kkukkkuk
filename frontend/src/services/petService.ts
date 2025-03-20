import axios from 'axios';
import { Pet, TreatmentStatus } from '../redux/slices/petSlice';

// API 응답 공통 타입
export interface ApiResponse<T> {
  status: 'SUCCESS' | 'ERROR';
  code?: string;
  message?: string;
  http_code?: number;
  data: T;
}

// API 응답의 반려동물 데이터 타입
interface ApiPet {
  state: 'IN_PROGRESS' | 'WAITING' | 'COMPLETED';
  id: number;
  did: string;
  name: string;
  gender: string;
  flag_neutering: boolean;
  breed_name: string;
  birth: string;
  age: string;
}

// API 반려동물 상태를 앱 내부 상태로 변환
const mapStateToTreatmentStatus = (state: string): TreatmentStatus => {
  switch (state) {
    case 'IN_PROGRESS': return 'inProgress';
    case 'WAITING': return 'waiting';
    case 'COMPLETED': return 'completed';
    default: return 'waiting';
  }
};

// API 응답을 내부 Pet 타입으로 변환
const mapApiPetToPet = (apiPet: ApiPet): Pet => {
  return {
    id: apiPet.id.toString(),
    name: apiPet.name,
    breed: apiPet.breed_name,
    guardianId: apiPet.did,
    guardianName: '보호자', // API 응답에 보호자 이름이 없어서 기본값 설정
    registeredDate: apiPet.birth, // 등록일 대신 생년월일 사용
    expiryDate: new Date(new Date().getTime() + 30 * 24 * 60 * 60 * 1000).toISOString(), // 임시로 현재 날짜 + 30일
    treatmentStatus: mapStateToTreatmentStatus(apiPet.state),
    gender: apiPet.gender,
    flagNeutering: apiPet.flag_neutering,
    age: apiPet.age,
    did: apiPet.did
  };
};

// 반려동물 목록 조회 API
export const fetchPets = async (): Promise<ApiResponse<Pet[]>> => {
  try {
    const response = await axios.get<{
      status: string;
      message: string;
      data: ApiPet[];
    }>('/api/hospitals/me/pets', {
      headers: {
        Authorization: `Bearer ${localStorage.getItem('accessToken')}`
      }
    });
    
    // API 응답이 성공인 경우
    if (response.data.status === 'success') {
      // ApiPet을 Pet으로 변환
      const pets = response.data.data.map(mapApiPetToPet);
      
      return {
        status: 'SUCCESS',
        message: response.data.message,
        data: pets
      };
    } else {
      // API 응답이 에러인 경우
      return {
        status: 'ERROR',
        code: 'API_ERROR',
        message: response.data.message || '반려동물 목록을 불러오는데 실패했습니다.',
        data: []
      };
    }
  } catch (error) {
    if (axios.isAxiosError(error)) {
      if (error.response) {
        return {
          status: 'ERROR',
          code: 'API_ERROR',
          message: error.response.data?.message || '반려동물 목록을 불러오는데 실패했습니다.',
          http_code: error.response.status,
          data: []
        };
      }
      return {
        status: 'ERROR',
        code: 'NETWORK_ERROR',
        message: '서버 연결에 실패했습니다.',
        http_code: 500,
        data: []
      };
    }
    return {
      status: 'ERROR',
      code: 'UNKNOWN_ERROR',
      message: '알 수 없는 오류가 발생했습니다.',
      http_code: 500,
      data: []
    };
  }
};

// 반려동물 상세 정보 조회 API
export const fetchPetDetail = async (petId: string): Promise<ApiResponse<Pet>> => {
  try {
    // 실제 API가 구현되면 아래 코드로 교체
    // const response = await axios.get<ApiResponse<ApiPet>>(`/api/pets/${petId}`);
    
    // 임시 구현: 전체 목록에서 해당 ID를 찾는 방식
    const allPetsResponse = await fetchPets();
    if (allPetsResponse.status === 'SUCCESS') {
      const pet = allPetsResponse.data.find((p: Pet) => p.id === petId);
      if (pet) {
        return {
          status: 'SUCCESS',
          message: '반려동물 정보를 불러왔습니다.',
          data: pet
        };
      }
    }
    
    return {
      status: 'ERROR',
      code: 'PET_NOT_FOUND',
      message: '해당 반려동물을 찾을 수 없습니다.',
      data: {} as Pet
    };
  } catch (error) {
    if (axios.isAxiosError(error)) {
      if (error.response) {
        return error.response.data as ApiResponse<Pet>;
      }
      return {
        status: 'ERROR',
        code: 'NETWORK_ERROR',
        message: '서버 연결에 실패했습니다.',
        http_code: 500,
        data: {} as Pet
      };
    }
    return {
      status: 'ERROR',
      code: 'UNKNOWN_ERROR',
      message: '알 수 없는 오류가 발생했습니다.',
      http_code: 500,
      data: {} as Pet
    };
  }
};

// 진료 상태 업데이트 API
export const updatePetTreatmentStatus = async (petId: string, status: TreatmentStatus): Promise<ApiResponse<Pet>> => {
  try {
    // 실제 API가 구현되면 아래 코드 사용
    // const apiStatus = status === 'waiting' ? 'WAITING' : 
    //                   status === 'inProgress' ? 'IN_PROGRESS' : 'COMPLETED';
    // const response = await axios.patch<ApiResponse<ApiPet>>(`/api/pets/${petId}/treatment-status`, { state: apiStatus });
    
    // 임시 구현: 상태만 업데이트된 것처럼 처리
    const petResponse = await fetchPetDetail(petId);
    if (petResponse.status === 'SUCCESS') {
      const updatedPet = {
        ...petResponse.data,
        treatmentStatus: status
      };
      
      return {
        status: 'SUCCESS',
        message: '진료 상태가 업데이트되었습니다.',
        data: updatedPet
      };
    }
    
    return petResponse;
  } catch (error) {
    if (axios.isAxiosError(error)) {
      if (error.response) {
        return error.response.data as ApiResponse<Pet>;
      }
      return {
        status: 'ERROR',
        code: 'NETWORK_ERROR',
        message: '서버 연결에 실패했습니다.',
        http_code: 500,
        data: {} as Pet
      };
    }
    return {
      status: 'ERROR',
      code: 'UNKNOWN_ERROR',
      message: '알 수 없는 오류가 발생했습니다.',
      http_code: 500,
      data: {} as Pet
    };
  }
};

// 개발용 더미 데이터 생성
export const generateDummyPets = (): Pet[] => {
  const currentDate = new Date();
  
  // 만료일 설정 (현재 날짜에서 30일 추가)
  const getExpiryDate = (days: number = 30) => {
    const date = new Date(currentDate);
    date.setDate(date.getDate() + days);
    return date.toISOString();
  };
  
  return [
    {
      id: 'pet1',
      name: '맥스',
      breed: '골든 리트리버',
      guardianId: 'guardian1',
      guardianName: '김철수',
      registeredDate: new Date(currentDate.getTime() - 15 * 24 * 60 * 60 * 1000).toISOString(),
      expiryDate: getExpiryDate(20),
      treatmentStatus: 'waiting' as TreatmentStatus,
      gender: 'male',
      flagNeutering: true,
      age: '3년 2개월',
      did: 'did:pet:max123'
    },
    {
      id: 'pet2',
      name: '루시',
      breed: '푸들',
      guardianId: 'guardian2',
      guardianName: '이영희',
      registeredDate: new Date(currentDate.getTime() - 10 * 24 * 60 * 60 * 1000).toISOString(),
      expiryDate: getExpiryDate(25),
      treatmentStatus: 'inProgress' as TreatmentStatus,
      gender: 'female',
      flagNeutering: false,
      age: '1년 8개월',
      did: 'did:pet:lucy456'
    },
    {
      id: 'pet3',
      name: '초코',
      breed: '닥스훈트',
      guardianId: 'guardian3',
      guardianName: '박지영',
      registeredDate: new Date(currentDate.getTime() - 20 * 24 * 60 * 60 * 1000).toISOString(),
      expiryDate: getExpiryDate(1), // 만료 임박
      treatmentStatus: 'completed' as TreatmentStatus,
      gender: 'male',
      flagNeutering: true,
      age: '5년 7개월',
      did: 'did:pet:choco789'
    }
  ];
}; 