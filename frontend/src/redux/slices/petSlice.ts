import { createSlice, PayloadAction } from '@reduxjs/toolkit';
import { RootState } from '../store';

// 반려동물 데이터 인터페이스
export interface Pet {
  id: string;
  name: string;
  breed: string;
  guardianId: string;
  guardianName: string;
  registeredDate: string;
  expiryDate: string;
  treatmentStatus: TreatmentStatus;
  gender?: string;
  flagNeutering?: boolean;
  age?: string;
  did?: string;
  blockchainData?: {
    hash: string;
    timestamp: string;
  };
}

// 진료 상태 타입
export type TreatmentStatus = 'waiting' | 'inProgress' | 'completed';

// 정렬 필드 타입
export type SortField = 'name' | 'registeredDate' | 'expiryDate' | 'treatmentStatus' | 'custom';
export type SortOrder = 'asc' | 'desc';

// 슬라이스 상태 인터페이스
interface PetState {
  pets: Pet[];
  selectedPet: Pet | null;
  loading: boolean;
  error: string | null;
  sortField: SortField;
  sortOrder: SortOrder;
  hideCompleted: boolean;
  customOrder: string[];
}

// 초기 상태
const initialState: PetState = {
  pets: [],
  selectedPet: null,
  loading: false,
  error: null,
  sortField: 'treatmentStatus',
  sortOrder: 'asc',
  hideCompleted: false,
  customOrder: []
};

// 더미 데이터 생성 함수 (개발용)
export const createDummyPets = (): Pet[] => {
  const currentDate = new Date();
  const tomorrow = new Date(currentDate);
  tomorrow.setDate(currentDate.getDate() + 1);
  
  const nextWeek = new Date(currentDate);
  nextWeek.setDate(currentDate.getDate() + 7);
  
  const nextMonth = new Date(currentDate);
  nextMonth.setMonth(currentDate.getMonth() + 1);
  
  return [
    {
      id: '1',
      name: '멍멍이',
      breed: '리트리버',
      guardianId: '1',
      guardianName: '김철수',
      registeredDate: currentDate.toISOString(),
      expiryDate: nextMonth.toISOString(),
      treatmentStatus: 'waiting',
      blockchainData: {
        hash: '0x123456789abcdef',
        timestamp: currentDate.toISOString()
      }
    },
    {
      id: '2',
      name: '야옹이',
      breed: '코리안 숏헤어',
      guardianId: '2',
      guardianName: '이영희',
      registeredDate: new Date(currentDate.getTime() - 86400000 * 2).toISOString(),
      expiryDate: tomorrow.toISOString(),
      treatmentStatus: 'inProgress'
    },
    {
      id: '3',
      name: '토토',
      breed: '말티즈',
      guardianId: '3',
      guardianName: '박지민',
      registeredDate: new Date(currentDate.getTime() - 86400000 * 5).toISOString(),
      expiryDate: nextWeek.toISOString(),
      treatmentStatus: 'completed',
      blockchainData: {
        hash: '0xabcdef123456789',
        timestamp: new Date(currentDate.getTime() - 86400000).toISOString()
      }
    }
  ];
};

// 슬라이스 생성
const petSlice = createSlice({
  name: 'pet',
  initialState,
  reducers: {
    // 반려동물 목록 페치 시작
    fetchPetsStart: (state) => {
      state.loading = true;
      state.error = null;
    },
    // 반려동물 목록 페치 성공
    fetchPetsSuccess: (state, action: PayloadAction<Pet[]>) => {
      state.pets = action.payload;
      state.loading = false;
      state.error = null;
    },
    // 반려동물 목록 페치 실패
    fetchPetsFailure: (state, action: PayloadAction<string>) => {
      state.loading = false;
      state.error = action.payload;
    },
    // 반려동물 선택
    selectPet: (state, action: PayloadAction<string>) => {
      const pet = state.pets.find(p => p.id === action.payload);
      if (pet) {
        state.selectedPet = pet;
      }
    },
    // 반려동물 선택 해제
    clearSelectedPet: (state) => {
      state.selectedPet = null;
    },
    // 진료 상태 업데이트
    updateTreatmentStatus: (state, action: PayloadAction<{ petId: string, status: TreatmentStatus }>) => {
      const { petId, status } = action.payload;
      const petIndex = state.pets.findIndex(p => p.id === petId);
      
      if (petIndex !== -1) {
        state.pets[petIndex].treatmentStatus = status;
        
        // 선택된 반려동물의 상태도 업데이트
        if (state.selectedPet && state.selectedPet.id === petId) {
          state.selectedPet.treatmentStatus = status;
        }
      }
    },
    // 정렬 필드 설정
    setSortField: (state, action: PayloadAction<SortField>) => {
      if (state.sortField === action.payload) {
        // 같은 필드를 다시 클릭하면 정렬 순서 변경
        state.sortOrder = state.sortOrder === 'asc' ? 'desc' : 'asc';
      } else {
        state.sortField = action.payload;
        // 기본 정렬 순서 설정 (대부분의 경우 오름차순)
        state.sortOrder = 'asc';
      }
    },
    // 정렬 순서 설정
    setSortOrder: (state, action: PayloadAction<SortOrder>) => {
      state.sortOrder = action.payload;
    },
    // 완료된 진료 숨김 토글
    toggleHideCompleted: (state) => {
      state.hideCompleted = !state.hideCompleted;
    },
    // 커스텀 정렬 순서 설정
    setCustomOrder: (state, action: PayloadAction<string[]>) => {
      state.customOrder = action.payload;
      state.sortField = 'custom';
    },
    // 특정 보호자의 반려동물 목록 로드 (해당 API가 준비되어 있을 때 사용)
    fetchPetsByGuardian: (state, action: PayloadAction<string>) => {
      // 해당 액션은 페이로드만 처리하고, API 호출은 별도의 미들웨어에서 처리
      // 현재는 로딩 상태로 변경만 수행
      state.loading = true;
    }
  }
});

// 액션 생성자 내보내기
export const {
  fetchPetsStart,
  fetchPetsSuccess,
  fetchPetsFailure,
  selectPet,
  clearSelectedPet,
  updateTreatmentStatus,
  setSortField,
  setSortOrder,
  toggleHideCompleted,
  setCustomOrder,
  fetchPetsByGuardian
} = petSlice.actions;

// 선택자 내보내기
export const selectPets = (state: RootState) => state.pet.pets;
export const selectSelectedPet = (state: RootState) => state.pet.selectedPet;
export const selectPetLoading = (state: RootState) => state.pet.loading;
export const selectPetError = (state: RootState) => state.pet.error;
export const selectPetSortField = (state: RootState) => state.pet.sortField;
export const selectPetSortOrder = (state: RootState) => state.pet.sortOrder;
export const selectHideCompleted = (state: RootState) => state.pet.hideCompleted;
export const selectCustomOrder = (state: RootState) => state.pet.customOrder;

// 리듀서 내보내기
export default petSlice.reducer; 