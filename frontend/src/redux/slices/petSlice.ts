import { createSlice, PayloadAction } from '@reduxjs/toolkit';
import { store } from '../store';
import { RootState } from '../store';
import { selectDevModeEnabled } from './devModeSlice';

export interface BlockchainInfo {
  transactionId: string;
  timestamp: string;
  blockNumber: number;
  dataHash: string;
}

export interface Pet {
  id: string;
  guardianId: string;
  name: string;
  species: string;
  breed: string;
  gender: string;
  birthDate: string;
  description: string;
  medicalRecords: string[]; // 진료기록 ID 목록
  blockchainData?: BlockchainInfo; // 블록체인 데이터 추가
}

export interface PetState {
  pets: Pet[];
  selectedPet: Pet | null;
  loading: boolean;
  error: string | null;
  blockchainLoading: boolean;
  blockchainError: string | null;
  blockchainData: { [key: string]: BlockchainInfo };
}

// 기본 초기 상태 정의
const initialState: PetState = {
  pets: [
    // 아래는 '호태'의 정보
    {
      id: 'pet-1',
      guardianId: 'owner-1',
      name: '호태',
      species: '개',
      breed: '시츄',
      gender: '수컷',
      birthDate: '2019-05-15',
      description: '활발하고 장난기 많은 시츄입니다.',
      medicalRecords: ['treatment-5'] // 진료기록 연결
    },
    // 아래는 '메리'의 정보
    {
      id: 'pet-2',
      guardianId: 'owner-1',
      name: '메리',
      species: '개',
      breed: '말티즈',
      gender: '암컷',
      birthDate: '2020-03-10',
      description: '온순하고 사람을 잘 따르는 말티즈입니다.',
      medicalRecords: ['treatment-1', 'treatment-3'] // 진료기록 연결
    },
    // 아래는 '초코'의 정보
    {
      id: 'pet-3',
      guardianId: 'owner-1',
      name: '초코',
      species: '고양이',
      breed: '러시안 블루',
      gender: '암컷',
      birthDate: '2021-01-20',
      description: '조용하고 독립적인 러시안 블루입니다.',
      medicalRecords: ['treatment-2'] // 진료기록 연결
    },
    // 아래는 '바둑이'의 정보
    {
      id: 'pet-4',
      guardianId: 'owner-2',
      name: '바둑이',
      species: '개',
      breed: '진돗개',
      gender: '수컷', 
      birthDate: '2018-09-05',
      description: '충성심이 강하고 활발한 진돗개입니다.',
      medicalRecords: ['treatment-4'] // 진료기록 연결
    }
  ],
  selectedPet: null, // 초기값은 null로 설정
  loading: false,
  error: null,
  blockchainLoading: false,
  blockchainError: null,
  blockchainData: {}
};

// localStorage에서 이전에 선택된 반려동물 ID 확인
const savedPetId = localStorage.getItem('selectedPetId');
if (savedPetId) {
  const foundPet = initialState.pets.find(pet => pet.id === savedPetId);
  if (foundPet) {
    initialState.selectedPet = foundPet;
  }
}

const petSlice = createSlice({
  name: 'pet',
  initialState,
  reducers: {
    fetchPetsStart: (state) => {
      state.loading = true;
      state.error = null;
    },
    fetchPetsSuccess: (state, action: PayloadAction<Pet[]>) => {
      state.pets = action.payload;
      state.loading = false;
    },
    fetchPetsFailure: (state, action: PayloadAction<string>) => {
      state.loading = false;
      state.error = action.payload;
    },
    selectPet: (state, action: PayloadAction<string>) => {
      const petId = action.payload;
      const pet = state.pets.find(p => p.id === petId);
      state.selectedPet = pet || null;
      
      // localStorage에 선택된 반려동물 ID 저장
      if (pet) {
        localStorage.setItem('selectedPetId', pet.id);
      }
    },
    clearSelectedPet: (state) => {
      state.selectedPet = null;
      localStorage.removeItem('selectedPetId');
    },
    fetchBlockchainDataStart: (state) => {
      state.blockchainLoading = true;
      state.blockchainError = null;
    },
    fetchBlockchainDataSuccess: (state, action: PayloadAction<{ petId: string, blockchainData: BlockchainInfo }>) => {
      state.blockchainLoading = false;
      const { petId, blockchainData } = action.payload;
      // 블록체인 데이터 저장
      state.blockchainData[petId] = blockchainData;
    },
    fetchBlockchainDataFailure: (state, action: PayloadAction<string>) => {
      state.blockchainLoading = false;
      state.blockchainError = action.payload;
    },
  },
});

export const {
  fetchPetsStart,
  fetchPetsSuccess,
  fetchPetsFailure,
  selectPet,
  clearSelectedPet,
  fetchBlockchainDataStart,
  fetchBlockchainDataSuccess,
  fetchBlockchainDataFailure,
} = petSlice.actions;

// 보호자 ID로 반려동물 목록을 필터링하는 함수
export const fetchPetsByGuardian = (guardianId: string) => (dispatch: any, getState: any) => {
  dispatch(fetchPetsStart());
  try {
    // 현재 상태
    const state = getState();
    const devModeEnabled = selectDevModeEnabled(state);
    
    // 개발 모드 여부에 관계없이 모든 반려동물 목록 가져오기
    const allPets = state.pet.pets;
    
    // 보호자 ID로 필터링
    const filteredPets = allPets.filter(pet => pet.guardianId === guardianId);
    
    // 필터링된 결과만 반영하고 기존 목록은 유지 (개발 모드에서도 상태가 초기화되지 않도록)
    if (filteredPets.length > 0) {
      dispatch(fetchPetsSuccess(filteredPets));
      
      // 현재 선택된 반려동물이 필터링된 목록에 없으면 첫 번째 반려동물 선택
      const currentSelectedPet = state.pet.selectedPet;
      if (!currentSelectedPet || !filteredPets.some(pet => pet.id === currentSelectedPet.id)) {
        dispatch(selectPet(filteredPets[0].id));
      }
    } else {
      // 필터링된 결과가 없을 경우 빈 배열로 설정하지만 오류는 발생시키지 않음
      dispatch(fetchPetsSuccess([]));
      dispatch(clearSelectedPet());
    }
  } catch (error) {
    dispatch(fetchPetsFailure(error instanceof Error ? error.message : '알 수 없는 오류가 발생했습니다.'));
  }
};

export const selectSelectedPet = (state: RootState) => {
  const selectedPetId = state.pet.selectedPet?.id || "";
  return state.pet.pets.find((pet: Pet) => pet.id === selectedPetId) || null;
};

export default petSlice.reducer; 