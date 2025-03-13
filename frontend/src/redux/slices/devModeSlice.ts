import { createSlice, PayloadAction } from '@reduxjs/toolkit';
import { BlockchainInfo, Pet } from './petSlice';
import { generateMockBlockchainData } from '../../utils/blockchainUtils';
import { store } from '../store';
import { Guardian } from './guardianSlice';
import { Treatment, TreatmentItem } from './treatmentSlice';
import { fetchGuardiansSuccess } from './guardianSlice';
import { fetchPetsSuccess, selectPet } from './petSlice';
import { fetchTreatmentsSuccess } from './treatmentSlice';

// 병원 정보 인터페이스
export interface Hospital {
  id: string;
  name: string;
  email: string;
  username: string;
  address: string;
  phone: string;
  did: string;
  licenseNumber: string;
  createdAt: string;
  doctors: Doctor[];
}

// 의사 정보 인터페이스
export interface Doctor {
  id: string;
  name: string;
  specialization: string;
  licenseNumber: string;
}

// 개발 모드 상태 인터페이스
interface DevModeState {
  // 개발 모드 활성화 여부
  enabled: boolean;
  // 가짜 블록체인 데이터 (petId를 키로 사용)
  mockBlockchainData: {
    [petId: string]: BlockchainInfo;
  };
  // 가짜 병원 데이터 (ssafy@example.com 더미 계정용)
  mockHospitalData: Hospital;
}

// 반려동물 ID 목록
const DEFAULT_PET_IDS = ['pet-1', 'pet-2', 'pet-3', 'pet-4', 'pet-5'];

// 초기 목업 데이터
const initialMockData: Record<string, BlockchainInfo> = {
  'pet-1': {
    transactionId: '0x7f9a12e4b1b5c7d8e9f0a1b2c3d4e5f6a7b8c9d0',
    timestamp: '2023-03-01T15:30:45Z',
    blockNumber: 12345678,
    dataHash: '0xabcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890'
  },
  'pet-2': {
    transactionId: '0x8a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b',
    timestamp: '2023-03-02T10:15:20Z',
    blockNumber: 12345800,
    dataHash: '0x123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0'
  },
  'pet-3': {
    transactionId: '0x9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c',
    timestamp: '2023-03-03T08:45:30Z',
    blockNumber: 12346000,
    dataHash: '0xfedcba9876543210fedcba9876543210fedcba9876543210fedcba9876543210'
  }
};

// 더미 병원 데이터
const initialHospitalData: Hospital = {
  id: 'hospital-1',
  name: '싸피 동물병원',
  email: 'ssafy@example.com',
  username: '병원 관리자',
  address: '서울특별시 강남구 테헤란로 212',
  phone: '02-1234-5678',
  did: 'did:kkuk:hospital:15c7a89b3d',
  licenseNumber: 'KVM-12345',
  createdAt: '2023-01-15T09:30:45Z',
  doctors: [
    {
      id: 'doctor-1',
      name: '김수의',
      specialization: '내과',
      licenseNumber: 'KVM-D-001'
    },
    {
      id: 'doctor-2',
      name: '이진료',
      specialization: '외과',
      licenseNumber: 'KVM-D-002'
    },
    {
      id: 'doctor-3',
      name: '박처방',
      specialization: '피부과',
      licenseNumber: 'KVM-D-003'
    }
  ]
};

// 시간에 따라 달라지는 랜덤한 데이터
const getRandomBlockchainData = (petId: string): BlockchainInfo => {
  // 현재 시간을 기반으로 데이터 생성
  const now = new Date();
  const timestamp = now.toISOString();
  
  return {
    transactionId: `0x${Math.random().toString(16).substring(2, 30)}${Math.random().toString(16).substring(2, 10)}`,
    timestamp: timestamp,
    blockNumber: Math.floor(12340000 + Math.random() * 10000),
    dataHash: `0x${Math.random().toString(16).substring(2, 30)}${Math.random().toString(16).substring(2, 30)}`
  };
};

// 초기 상태 - 모든 기본 펫에 대한 데이터를 미리 생성
const generateInitialMockData = (): Record<string, BlockchainInfo> => {
  const mockData = { ...initialMockData };
  
  // 기본 데이터에 없는 pet ID에 대해 랜덤 데이터 생성
  DEFAULT_PET_IDS.forEach(petId => {
    if (!mockData[petId]) {
      mockData[petId] = getRandomBlockchainData(petId);
    }
  });
  
  return mockData;
};

// localStorage에서 개발 모드 설정 불러오기
const getDevModeFromStorage = (): boolean => {
  const stored = localStorage.getItem('devModeEnabled');
  // stored가 null이면 기본값인 process.env.NODE_ENV === 'development' 반환
  return stored === null ? process.env.NODE_ENV === 'development' : stored === 'true';
};

// 초기 상태
const initialState: DevModeState = {
  // localStorage에서 개발 모드 설정 불러오기
  enabled: getDevModeFromStorage(),
  mockBlockchainData: generateInitialMockData(),
  mockHospitalData: initialHospitalData
};

// 개발 모드 슬라이스 생성
const devModeSlice = createSlice({
  name: 'devMode',
  initialState,
  reducers: {
    // 개발 모드 설정
    setDevModeEnabled: (state, action: PayloadAction<boolean>) => {
      console.log(`[DevMode] Setting enabled state to: ${action.payload}`);
      state.enabled = action.payload;
      // localStorage에 개발 모드 설정 저장
      localStorage.setItem('devModeEnabled', action.payload.toString());
    },
    
    // 특정 반려동물 ID에 대한 가짜 블록체인 데이터 생성/업데이트
    generateMockDataForPet: (state, action: PayloadAction<string>) => {
      const petId = action.payload;
      console.log(`[DevMode] Generating mock data for pet: ${petId}`);
      if (!state.mockBlockchainData[petId]) {
        console.log(`[DevMode] No existing data for pet ${petId}, creating new entry`);
        
        // 랜덤 데이터 생성 및 직접 할당
        const newData = getRandomBlockchainData(petId);
        state.mockBlockchainData[petId] = { ...newData };
        
        console.log(`[DevMode] Created new data:`, state.mockBlockchainData[petId]);
      } else {
        console.log(`[DevMode] Pet ${petId} already has data:`, state.mockBlockchainData[petId]);
      }
    },
    
    // 특정 반려동물 ID에 대한 가짜 블록체인 데이터 수동 설정
    setMockDataForPet: (state, action: PayloadAction<{petId: string, data: BlockchainInfo}>) => {
      const { petId, data } = action.payload;
      console.log(`[DevMode] Manually setting data for pet ${petId}:`, data);
      state.mockBlockchainData[petId] = data;
    },
    
    // 모든 가짜 블록체인 데이터 초기화
    resetMockData: (state) => {
      console.log(`[DevMode] Resetting all mock data to initial values`);
      state.mockBlockchainData = initialMockData;
    },
    
    // 병원 데이터 업데이트
    updateMockHospitalData: (state, action: PayloadAction<Partial<Hospital>>) => {
      console.log(`[DevMode] Updating mock hospital data:`, action.payload);
      state.mockHospitalData = { ...state.mockHospitalData, ...action.payload };
    },
    
    // 의사 추가
    addDoctorToMockHospital: (state, action: PayloadAction<Doctor>) => {
      console.log(`[DevMode] Adding doctor to mock hospital:`, action.payload);
      state.mockHospitalData.doctors.push(action.payload);
    },
    
    // 의사 삭제
    removeDoctorFromMockHospital: (state, action: PayloadAction<string>) => {
      const doctorId = action.payload;
      console.log(`[DevMode] Removing doctor ${doctorId} from mock hospital`);
      state.mockHospitalData.doctors = state.mockHospitalData.doctors.filter(
        doctor => doctor.id !== doctorId
      );
    }
  }
});

// 액션 생성자 내보내기
export const { 
  setDevModeEnabled, 
  generateMockDataForPet, 
  setMockDataForPet, 
  resetMockData,
  updateMockHospitalData,
  addDoctorToMockHospital,
  removeDoctorFromMockHospital
} = devModeSlice.actions;

// 셀렉터 함수 - 개발 모드 활성화 여부 확인
export const selectDevModeEnabled = (state: { devMode: DevModeState }) => {
  const enabled = state.devMode.enabled;
  console.log(`[DevMode] Current state: ${enabled}`);
  return enabled;
};

// 셀렉터 함수 - 특정 반려동물 ID에 대한 가짜 블록체인 데이터 가져오기
export const selectMockDataForPet = (state: { devMode: DevModeState }, petId: string) => {
  if (state.devMode.enabled) {
    // 데이터가 없으면 새로 생성
    if (!state.devMode.mockBlockchainData[petId]) {
      console.log(`[DevMode] No data found for pet ${petId}, generating new data`);
      const newData = generateMockBlockchainData(petId);
      // 주의: 이 방식은 리덕스의 불변성 원칙을 위반하지만 셀렉터에서는 괜찮음
      // 실제 상태에는 반영되지 않음
      return newData;
    }
    console.log(`[DevMode] Found data for pet ${petId}:`, state.devMode.mockBlockchainData[petId]);
    return state.devMode.mockBlockchainData[petId];
  }
  console.log(`[DevMode] Dev mode is disabled, returning null for pet ${petId}`);
  return null;
};

// 셀렉터 함수 - 모든 가짜 블록체인 데이터 가져오기
export const selectAllMockData = (state: { devMode: DevModeState }) => state.devMode.mockBlockchainData;

// 셀렉터 함수 - 더미 병원 데이터 가져오기
export const selectMockHospitalData = (state: { devMode: DevModeState }) => state.devMode.mockHospitalData;

// 유틸리티 함수 - 모든 반려동물에 대한 데이터 미리 저장
export const preloadMockDataForAllPets = () => (dispatch: any, getState: any) => {
  const state = getState();
  const enabled = state.devMode.enabled;
  
  if (enabled) {
    console.log('[DevMode] Preloading mock data for all pets');
    
    // 반려동물 목록 가져오기
    const allPets = state.pet.pets;
    allPets.forEach((pet: { id: string }) => {
      dispatch(generateMockDataForPet(pet.id));
    });
    
    console.log('[DevMode] Mock data preloaded successfully');
  }
};

// 개발 모드에서 사용할 기본 보호자 데이터
export const DEFAULT_GUARDIANS: Guardian[] = [
  {
    id: 'guardian-1',
    name: '김민지',
    email: 'minji.kim@example.com',
    address: '서울시 강남구 역삼동 123-45',
    registeredDate: '2023-01-15',
    expiryDate: '2024-01-15',
    treatmentStatus: 'waiting'
  },
  {
    id: 'guardian-2',
    name: '이준호',
    email: 'junho.lee@example.com',
    address: '서울시 마포구 홍대입구 456-78',
    registeredDate: '2023-02-20',
    expiryDate: '2024-02-20',
    treatmentStatus: 'inProgress'
  },
  {
    id: 'guardian-3',
    name: '박소연',
    email: 'soyeon.park@example.com',
    address: '서울시 서초구 반포동 789-12',
    registeredDate: '2023-03-10',
    expiryDate: '2024-03-10',
    treatmentStatus: 'completed'
  }
];

// 개발 모드에서 사용할 기본 반려동물 데이터
export const DEFAULT_PETS: Pet[] = [
  {
    id: 'pet-1',
    name: '몽실이',
    species: '강아지',
    breed: '말티즈',
    gender: '수컷',
    birthDate: '2020-05-15',
    guardianId: 'guardian-1',
    description: '활발하고 친근한 성격, 2022년 11월 중성화 수술',
    medicalRecords: ['treatment-1']
  },
  {
    id: 'pet-2',
    name: '까망이',
    species: '강아지',
    breed: '푸들',
    gender: '암컷',
    birthDate: '2018-08-23',
    guardianId: 'guardian-1',
    description: '유제품 알레르기 있음, 2021년 5월 치과 치료',
    medicalRecords: ['treatment-2']
  },
  {
    id: 'pet-3',
    name: '달미',
    species: '고양이',
    breed: '코리안 숏헤어',
    gender: '암컷',
    birthDate: '2021-12-10',
    guardianId: 'guardian-2',
    description: '닭고기 알레르기 있음, 2022년 8월 심장사상충 검사 음성',
    medicalRecords: ['treatment-3']
  },
  {
    id: 'pet-4',
    name: '초코',
    species: '강아지',
    breed: '웰시코기',
    gender: '수컷',
    birthDate: '2019-02-28',
    guardianId: 'guardian-3',
    description: '활동적이고 장난기 많음, 2022년 3월 중성화 수술',
    medicalRecords: ['treatment-4']
  },
  {
    id: 'pet-5',
    name: '구름이',
    species: '고양이',
    breed: '페르시안',
    gender: '수컷',
    birthDate: '2017-11-05',
    guardianId: 'guardian-3',
    description: '조용하고 온순한 성격, 2020년 10월 고관절 수술',
    medicalRecords: ['treatment-5']
  }
];

// 개발 모드에서 사용할 기본 진료 기록 데이터
export const DEFAULT_TREATMENTS: Treatment[] = [
  {
    id: 'treatment-1',
    petId: 'pet-1',
    hospitalName: '메이플 동물병원',
    hospitalId: 'hospital-001',
    veterinarianName: 'DR.MICHEL',
    veterinarianLicense: 'VET-001',
    treatmentDate: '2023-02-15',
    diagnosis: '정기 건강 검진',
    diseaseName: '없음',
    onsetDate: '2023-02-15',
    diagnosisDate: '2023-02-15',
    prognosis: '양호',
    nextAppointment: '2023-05-15',
    items: [
      { name: '종합 건강 검진', quantity: 1 },
      { name: '종합 영양제', quantity: 1, dosage: '1일 1회', frequency: '식후' }
    ],
    documentType: 'diagnosis',
    blockchainVerified: true,
    blockchainTxHash: '0x9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c',
    blockchainTimestamp: '2023-02-15T10:30:15Z'
  },
  {
    id: 'treatment-2',
    petId: 'pet-2',
    hospitalName: '메이플 동물병원',
    hospitalId: 'hospital-001',
    veterinarianName: 'DR.MICHEL',
    veterinarianLicense: 'VET-001',
    treatmentDate: '2023-03-10',
    diagnosis: '피부 알레르기',
    diseaseName: '접촉성 피부염',
    onsetDate: '2023-03-05',
    diagnosisDate: '2023-03-10',
    prognosis: '2주 내 호전 예상',
    nextAppointment: '2023-03-20',
    items: [
      { name: '피부 진찰', quantity: 1 },
      { name: '항히스타민제', quantity: 10, dosage: '1일 1정', frequency: '식후' }
    ],
    documentType: 'diagnosis',
    blockchainVerified: true,
    blockchainTxHash: '0x8a7b6c5d4e3f2a1b0c9d8e7f6a5b4c3d2e1f0a9b',
    blockchainTimestamp: '2023-03-10T14:22:45Z'
  },
  {
    id: 'treatment-3',
    petId: 'pet-3',
    hospitalName: '메이플 동물병원',
    hospitalId: 'hospital-001',
    veterinarianName: 'DR.MICHEL',
    veterinarianLicense: 'VET-001',
    treatmentDate: '2023-04-05',
    diagnosis: '치석 제거',
    diseaseName: '치주염',
    onsetDate: '2023-03-20',
    diagnosisDate: '2023-04-05',
    prognosis: '완치',
    nextAppointment: '2023-07-05',
    items: [
      { name: '치석 제거 수술', quantity: 1 },
      { name: '항생제', quantity: 5, dosage: '1일 1정', frequency: '식후' }
    ],
    documentType: 'diagnosis',
    blockchainVerified: true,
    blockchainTxHash: '0x7c6d5e4f3a2b1c0d9e8f7a6b5c4d3e2f1a0b9c8d',
    blockchainTimestamp: '2023-04-05T09:15:30Z'
  },
  {
    id: 'treatment-4',
    petId: 'pet-4',
    hospitalName: '메이플 동물병원',
    hospitalId: 'hospital-001',
    veterinarianName: 'DR.MICHEL',
    veterinarianLicense: 'VET-001',
    treatmentDate: '2023-04-20',
    diagnosis: '충치 치료',
    diseaseName: '치아 우식증',
    onsetDate: '2023-04-10',
    diagnosisDate: '2023-04-20',
    prognosis: '완치',
    nextAppointment: '2023-10-20',
    items: [
      { name: '충치 치료', quantity: 1 },
      { name: '소염제', quantity: 3, dosage: '1일 1정', frequency: '식후' }
    ],
    documentType: 'diagnosis',
    blockchainVerified: false
  },
  {
    id: 'treatment-5',
    petId: 'pet-5',
    hospitalName: '메이플 동물병원',
    hospitalId: 'hospital-001',
    veterinarianName: 'DR.MICHEL',
    veterinarianLicense: 'VET-001',
    treatmentDate: '2023-05-01',
    diagnosis: '정기 예방접종',
    diseaseName: '없음',
    onsetDate: '2023-05-01',
    diagnosisDate: '2023-05-01',
    prognosis: '양호',
    nextAppointment: '2024-05-01',
    items: [
      { name: '종합 예방접종', quantity: 1 }
    ],
    documentType: 'diagnosis',
    blockchainVerified: true,
    blockchainTxHash: '0x6d5e4f3a2b1c0d9e8f7a6b5c4d3e2f1a0b9c8d7e',
    blockchainTimestamp: '2023-05-01T11:45:20Z'
  }
];

// 개발 모드를 위한 모든 데이터 초기화 함수
export const initializeDevModeData = () => {
  console.log('[DevMode] Initializing development mode data');
  
  // 개발 모드가 활성화되어 있는지 확인
  const state = store.getState();
  const devModeEnabled = state.devMode.enabled;
  
  if (!devModeEnabled) {
    console.log('[DevMode] Development mode is not enabled, skipping data initialization');
    return;
  }

  // 데이터가 이미 로드되어 있는지 확인하고, 초기화가 필요한 경우에만 초기화를 수행
  
  // 보호자 데이터가 없는 경우에만 초기화
  if (state.guardian.guardians.length === 0) {
    store.dispatch(fetchGuardiansSuccess(DEFAULT_GUARDIANS));
    console.log('[DevMode] Guardian data initialized');
  } else {
    console.log('[DevMode] Guardian data already loaded, skipping initialization');
  }

  // 반려동물 데이터가 없는 경우에만 초기화
  if (state.pet.pets.length === 0) {
    store.dispatch(fetchPetsSuccess(DEFAULT_PETS));
    console.log('[DevMode] Pet data initialized');
    
    // 첫 번째 반려동물 선택 (선택된 반려동물이 없는 경우에만)
    if (!state.pet.selectedPet && DEFAULT_PETS.length > 0) {
      store.dispatch(selectPet(DEFAULT_PETS[0].id));
      console.log(`[DevMode] Selected first pet: ${DEFAULT_PETS[0].name}`);
    }
  } else {
    console.log('[DevMode] Pet data already loaded, skipping initialization');
  }

  // 진료 데이터가 없는 경우에만 초기화
  if (state.treatment.treatments.length === 0) {
    store.dispatch(fetchTreatmentsSuccess(DEFAULT_TREATMENTS));
    console.log('[DevMode] Treatment data initialized');
  } else {
    console.log('[DevMode] Treatment data already loaded, skipping initialization');
  }
  
  // 각 반려동물에 대한 블록체인 데이터 생성 - 이것도 선택적으로 처리
  const petsToProcess = state.pet.pets.length > 0 ? state.pet.pets : DEFAULT_PETS;
  petsToProcess.forEach(pet => {
    // 이미 블록체인 데이터가 있는지 확인
    if (!state.devMode.mockBlockchainData[pet.id]) {
      store.dispatch(generateMockDataForPet(pet.id));
    }
  });
  
  console.log('[DevMode] Dev mode data initialization complete');
};

export default devModeSlice.reducer; 