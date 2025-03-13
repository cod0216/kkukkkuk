import { createSlice, PayloadAction } from '@reduxjs/toolkit';
import { RootState } from '../store';

// 진료 상태 유형 정의
export type TreatmentStatus = 'waiting' | 'inProgress' | 'completed';

export interface Guardian {
  id: string;
  name: string;
  email: string;
  address?: string;
  registeredDate: string;  // 등록시간(=스마트컨트랙트체결시간)
  expiryDate: string;      // 만료시간(=스마트컨트랙트권한만료시간)
  treatmentStatus: TreatmentStatus; // 진료 상태
}

export type SortField = 'name' | 'registeredDate' | 'expiryDate' | 'treatmentStatus' | 'custom';
export type SortOrder = 'asc' | 'desc';

interface GuardianState {
  guardians: Guardian[];
  selectedGuardian: Guardian | null;
  loading: boolean;
  error: string | null;
  sortField: SortField;
  sortOrder: SortOrder;
  hideCompleted: boolean;
  customOrder: string[]; // 사용자 정의 순서 (guardian ID 배열)
}

const initialState: GuardianState = {
  guardians: [
    {
      id: 'owner-1',
      name: '김철수',
      email: 'kim@example.com',
      registeredDate: '2025-01-15',
      expiryDate: '2026-01-15',
      treatmentStatus: 'waiting'
    },
    {
      id: 'owner-2',
      name: '이영희',
      email: 'lee@example.com',
      registeredDate: '2025-02-20',
      expiryDate: '2026-02-20',
      treatmentStatus: 'completed'
    },
    {
      id: 'owner-3',
      name: '박민수',
      email: 'park@example.com',
      registeredDate: '2025-03-10',
      expiryDate: '2026-03-10',
      treatmentStatus: 'inProgress'
    },
    {
      id: 'hospital-1',
      name: '싸피 병원',
      email: 'ssafy@example.com',
      registeredDate: '2025-01-01',
      expiryDate: '2026-01-01',
      treatmentStatus: 'waiting'
    }
  ],
  selectedGuardian: null,
  loading: false,
  error: null,
  sortField: 'treatmentStatus',
  sortOrder: 'asc',
  hideCompleted: false,
  customOrder: []
};

const guardianSlice = createSlice({
  name: 'guardian',
  initialState,
  reducers: {
    fetchGuardiansStart: (state) => {
      state.loading = true;
      state.error = null;
    },
    fetchGuardiansSuccess: (state, action: PayloadAction<Guardian[]>) => {
      state.guardians = action.payload;
      state.loading = false;
    },
    fetchGuardiansFailure: (state, action: PayloadAction<string>) => {
      state.loading = false;
      state.error = action.payload;
    },
    selectGuardian: (state, action: PayloadAction<string>) => {
      state.selectedGuardian = state.guardians.find(guardian => guardian.id === action.payload) || null;
    },
    clearSelectedGuardian: (state) => {
      state.selectedGuardian = null;
    },
    addGuardian: (state, action: PayloadAction<Guardian>) => {
      state.guardians.push(action.payload);
    },
    updateGuardian: (state, action: PayloadAction<Guardian>) => {
      const index = state.guardians.findIndex(guardian => guardian.id === action.payload.id);
      if (index !== -1) {
        state.guardians[index] = action.payload;
        
        // 선택된 보호자인 경우 업데이트
        if (state.selectedGuardian?.id === action.payload.id) {
          state.selectedGuardian = action.payload;
        }
      }
    },
    removeGuardian: (state, action: PayloadAction<string>) => {
      state.guardians = state.guardians.filter(guardian => guardian.id !== action.payload);
      
      // 선택된 보호자인 경우 선택 해제
      if (state.selectedGuardian?.id === action.payload) {
        state.selectedGuardian = null;
      }
    },
    // 보호자 진료 상태 변경
    updateTreatmentStatus: (state, action: PayloadAction<{guardianId: string, status: TreatmentStatus}>) => {
      const { guardianId, status } = action.payload;
      const index = state.guardians.findIndex(guardian => guardian.id === guardianId);
      if (index !== -1) {
        state.guardians[index].treatmentStatus = status;
        
        // 선택된 보호자인 경우 업데이트
        if (state.selectedGuardian?.id === guardianId) {
          state.selectedGuardian = state.guardians[index];
        }
      }
    },
    // 사용자 정의 순서 설정
    setCustomOrder: (state, action: PayloadAction<string[]>) => {
      state.customOrder = action.payload;
      state.sortField = 'custom';
    },
    // 정렬 필드 변경
    setSortField: (state, action: PayloadAction<SortField>) => {
      // 같은 필드를 다시 선택하면 정렬 순서 토글
      if (state.sortField === action.payload) {
        state.sortOrder = state.sortOrder === 'asc' ? 'desc' : 'asc';
      } else {
        state.sortField = action.payload;
        state.sortOrder = 'asc'; // 새 필드 선택 시 오름차순으로 시작
      }
    },
    // 정렬 순서 직접 설정
    setSortOrder: (state, action: PayloadAction<SortOrder>) => {
      state.sortOrder = action.payload;
    },
    // 진료 완료된 보호자 숨김 토글
    toggleHideCompleted: (state) => {
      state.hideCompleted = !state.hideCompleted;
    },
  },
});

export const {
  fetchGuardiansStart,
  fetchGuardiansSuccess,
  fetchGuardiansFailure,
  selectGuardian,
  clearSelectedGuardian,
  addGuardian,
  updateGuardian,
  removeGuardian,
  updateTreatmentStatus,
  setCustomOrder,
  setSortField,
  setSortOrder,
  toggleHideCompleted,
} = guardianSlice.actions;

export default guardianSlice.reducer;

export const selectSelectedGuardian = (state: RootState) => {
  const selectedGuardianId = state.guardian.selectedGuardian?.id || "";
  return state.guardian.guardians.find((guardian: Guardian) => guardian.id === selectedGuardianId) || null;
}; 