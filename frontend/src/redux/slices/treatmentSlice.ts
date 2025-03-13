import { createSlice, PayloadAction } from '@reduxjs/toolkit';

export interface TreatmentItem {
  name: string;
  quantity: number;
  dosage?: string;
  frequency?: string;
  description?: string;
}

export interface DocumentType {
  type: 'receipt' | 'diagnosis' | 'none';
}

export interface Treatment {
  id: string;
  petId: string;
  hospitalName: string;
  hospitalId: string;
  veterinarianName: string;
  veterinarianLicense?: string;
  treatmentDate: string;
  diagnosis: string;
  diseaseName?: string;
  onsetDate?: string;
  diagnosisDate?: string;
  prognosis?: string;
  petColor?: string;
  nextAppointment?: string;
  items: TreatmentItem[];
  documentType: DocumentType['type'];
  blockchainVerified: boolean;
  blockchainTxHash?: string;
  blockchainTimestamp?: string;
  previousVersionId?: string;
  editHistory?: {
    date: string;
    hospitalId: string;
    action: string;
    veterinarianName: string;
  }[];
}

interface TreatmentState {
  treatments: Treatment[];
  currentTreatment: {
    petId: string;
    diagnosis: string;
    diseaseName?: string;
    onsetDate?: string;
    diagnosisDate?: string;
    prognosis?: string;
    petColor?: string;
    items: TreatmentItem[];
    nextAppointment?: string;
    documentType: DocumentType['type'];
    veterinarianName?: string;
    veterinarianLicense?: string;
  } | null;
  loading: boolean;
  error: string | null;
  importedPdfData: any | null;
  savingToBlockchain: boolean;
  blockchainLoading: boolean;
  blockchainError: string | null;
  tempSaved: boolean;
  editMode: {
    isEditing: boolean;
    treatmentId: string | null;
  };
}

const initialState: TreatmentState = {
  treatments: [
    {
      id: 'treatment-1',
      petId: 'pet-2',
      hospitalName: '수타르동물병원',
      hospitalId: 'hospital-1',
      veterinarianName: '김수의',
      veterinarianLicense: '제1234호',
      treatmentDate: '2023-01-31T03:10:00Z',
      diagnosis: '심장 기능 검사 필요, 초음파 검사 진행함',
      items: [
        { name: '재진료', quantity: 1, dosage: '', frequency: '', description: '' },
        { name: '일반신체검사', quantity: 1, dosage: '', frequency: '', description: '' },
        { name: '혈액검사-종합검사(화학검사BS-240)-화학검사 종합', quantity: 1, dosage: '', frequency: '', description: '' },
        { name: '혈액검사-(아이덱스,IDEXX)- CBCV', quantity: 1, dosage: '', frequency: '', description: '' },
        { name: '혈액검사- 전해질-아이센스 (ISMART30)', quantity: 1, dosage: '', frequency: '', description: '' },
        { name: 'vcheck F-Troponin I-TnI(바이오라인)', quantity: 1, dosage: '', frequency: '', description: '심장 효소 수치가 약간 높게 나옴' },
        { name: '혈액검사vcheck Feline-pro-BNP(바이오라인)', quantity: 1, dosage: '', frequency: '', description: '' },
        { name: '노검사 스트립과 마이크로 (복수 검사 등) (아이덱스 IDEXX-UA)', quantity: 1, dosage: '', frequency: '', description: '' },
        { name: '방사선-흉복부 (기립)', quantity: 1, dosage: '', frequency: '', description: '' },
        { name: '초음파-심장', quantity: 1, dosage: '', frequency: '', description: '' }
      ],
      nextAppointment: '2023-02-28',
      documentType: 'receipt',
      blockchainVerified: true,
      blockchainTxHash: '0x123456789abcdef',
      blockchainTimestamp: '2023-01-31T03:30:00Z'
    },
    {
      id: 'treatment-2',
      petId: 'pet-2',
      hospitalName: '싸피 병원',
      hospitalId: 'hospital-1',
      veterinarianName: '박수의',
      veterinarianLicense: '제5678호',
      treatmentDate: '2023-02-28T09:00:00Z',
      diagnosis: '심장 기능 추적 관찰 중, 약물 처방 시작',
      diseaseName: '고양이 심근병증 의심',
      onsetDate: '2023-01-15',
      diagnosisDate: '2023-01-31',
      prognosis: '약물 치료로 증상 관리 가능, 정기적인 검사 필요',
      items: [
        { name: '재진료', quantity: 1, dosage: '', frequency: '', description: '' },
        { name: '베나코 정', quantity: 30, dosage: '2.5mg', frequency: '1일 1회', description: '아침 식사 후 복용' },
        { name: 'Furosemide', quantity: 60, dosage: '12.5mg', frequency: '1일 2회', description: '아침, 저녁 식후 복용' }
      ],
      documentType: 'diagnosis',
      blockchainVerified: true,
      blockchainTxHash: '0x987654321fedcba',
      blockchainTimestamp: '2023-02-28T09:30:00Z'
    },
    {
      id: 'treatment-3',
      petId: 'pet-3',
      hospitalName: '강남동물병원',
      hospitalId: 'hospital-2',
      veterinarianName: '이수의',
      veterinarianLicense: '제9012호',
      treatmentDate: '2023-03-15T14:00:00Z',
      diagnosis: '피부 알레르기 증상 발견, 약물 치료 필요',
      items: [
        { name: '초진료', quantity: 1, dosage: '', frequency: '', description: '' },
        { name: '피부 검사', quantity: 1, dosage: '', frequency: '', description: '알레르기 검사' },
        { name: '약물 처방', quantity: 1, dosage: '10mg', frequency: '1일 1회', description: '항히스타민제' }
      ],
      documentType: 'receipt',
      blockchainVerified: true,
      blockchainTxHash: '0xabc123def456',
      blockchainTimestamp: '2023-03-15T14:30:00Z'
    },
    {
      id: 'treatment-4',
      petId: 'pet-5',
      hospitalName: '싸피 병원',
      hospitalId: 'hospital-1',
      veterinarianName: '박수의',
      veterinarianLicense: '제5678호',
      treatmentDate: '2023-04-10T10:30:00Z',
      diagnosis: '정기 검진 및 종합 백신 접종',
      items: [
        { name: '초진료', quantity: 1, dosage: '', frequency: '', description: '' },
        { name: '종합백신(DHPPL)', quantity: 1, dosage: '1ml', frequency: '연 1회', description: '기초 예방접종' },
        { name: '코로나 백신', quantity: 1, dosage: '1ml', frequency: '연 1회', description: '코로나 바이러스 예방' },
        { name: '심장사상충 검사', quantity: 1, dosage: '', frequency: '', description: '음성 결과' }
      ],
      documentType: 'receipt',
      blockchainVerified: true,
      blockchainTxHash: '0xdef456ghi789',
      blockchainTimestamp: '2023-04-10T11:00:00Z',
      editHistory: [
        {
          date: '2023-04-10T11:00:00Z',
          hospitalId: 'hospital-1',
          action: '블록체인 저장',
          veterinarianName: '박수의'
        }
      ]
    },
    {
      id: 'treatment-5',
      petId: 'pet-1',
      hospitalName: '싸피 병원',
      hospitalId: 'hospital-1',
      veterinarianName: '박수의',
      veterinarianLicense: '제5678호',
      treatmentDate: '2023-05-15T11:00:00Z',
      diagnosis: '건강 검진 및 예방접종',
      items: [
        { name: '일반 건강검진', quantity: 1, dosage: '', frequency: '', description: '기본 검진' },
        { name: '혈액검사', quantity: 1, dosage: '', frequency: '', description: '기본 혈액검사' },
        { name: '종합백신', quantity: 1, dosage: '1ml', frequency: '연 1회', description: '예방접종' }
      ],
      documentType: 'receipt',
      blockchainVerified: true,
      blockchainTxHash: '0x123abc456def789',
      blockchainTimestamp: '2023-05-15T11:30:00Z'
    }
  ],
  currentTreatment: null,
  loading: false,
  error: null,
  importedPdfData: null,
  savingToBlockchain: false,
  blockchainLoading: false,
  blockchainError: null,
  tempSaved: false,
  editMode: {
    isEditing: false,
    treatmentId: null
  }
};

const treatmentSlice = createSlice({
  name: 'treatment',
  initialState,
  reducers: {
    fetchTreatmentsStart: (state) => {
      state.loading = true;
      state.error = null;
    },
    fetchTreatmentsSuccess: (state, action: PayloadAction<Treatment[]>) => {
      state.treatments = action.payload;
      state.loading = false;
    },
    fetchTreatmentsFailure: (state, action: PayloadAction<string>) => {
      state.loading = false;
      state.error = action.payload;
    },
    setCurrentTreatment: (state, action: PayloadAction<TreatmentState['currentTreatment']>) => {
      state.currentTreatment = action.payload;
    },
    updateCurrentTreatmentDiagnosis: (state, action: PayloadAction<string>) => {
      if (state.currentTreatment) {
        state.currentTreatment.diagnosis = action.payload;
      }
    },
    updateCurrentTreatmentFields: (state, action: PayloadAction<{
      field: string;
      value: string;
    }>) => {
      if (state.currentTreatment) {
        const { field, value } = action.payload;
        (state.currentTreatment as any)[field] = value;
      }
    },
    addTreatmentItem: (state, action: PayloadAction<TreatmentItem>) => {
      if (state.currentTreatment) {
        state.currentTreatment.items.push(action.payload);
      }
    },
    removeTreatmentItem: (state, action: PayloadAction<number>) => {
      if (state.currentTreatment) {
        state.currentTreatment.items.splice(action.payload, 1);
      }
    },
    updateTreatmentItem: (state, action: PayloadAction<{ index: number; item: TreatmentItem }>) => {
      if (state.currentTreatment) {
        state.currentTreatment.items[action.payload.index] = action.payload.item;
      }
    },
    setImportedPdfData: (state, action: PayloadAction<any>) => {
      state.importedPdfData = action.payload;
      // 문서 타입 설정
      if (state.currentTreatment && action.payload.documentType) {
        state.currentTreatment.documentType = action.payload.documentType;
      }
    },
    clearImportedPdfData: (state) => {
      state.importedPdfData = null;
    },
    setDocumentType: (state, action: PayloadAction<DocumentType['type']>) => {
      if (state.currentTreatment) {
        state.currentTreatment.documentType = action.payload;
      }
    },
    saveTreatmentStart: (state) => {
      state.loading = true;
      state.error = null;
    },
    saveTreatmentSuccess: (state, action: PayloadAction<Treatment>) => {
      state.treatments.push(action.payload);
      state.currentTreatment = null;
      state.loading = false;
      state.tempSaved = false;
    },
    saveTreatmentFailure: (state, action: PayloadAction<string>) => {
      state.loading = false;
      state.error = action.payload;
    },
    saveToBlockchainStart: (state) => {
      state.savingToBlockchain = true;
      state.blockchainError = null;
    },
    saveToBlockchainSuccess: (state, action: PayloadAction<{ treatmentId: string; txHash: string; timestamp: string }>) => {
      state.savingToBlockchain = false;
      state.blockchainError = null;
      
      const index = state.treatments.findIndex(t => t.id === action.payload.treatmentId);
      if (index !== -1) {
        state.treatments[index].blockchainVerified = true;
        state.treatments[index].blockchainTxHash = action.payload.txHash;
        state.treatments[index].blockchainTimestamp = action.payload.timestamp;
        
        // 편집 히스토리 추가
        if (!state.treatments[index].editHistory) {
          state.treatments[index].editHistory = [];
        }
        
        state.treatments[index].editHistory?.push({
          date: new Date().toISOString(),
          hospitalId: state.treatments[index].hospitalId,
          action: '블록체인 저장',
          veterinarianName: state.treatments[index].veterinarianName
        });
        
        // 편집 중이었다면 이전 버전 참조 추가
        if (state.editMode.isEditing && state.editMode.treatmentId) {
          state.treatments[index].previousVersionId = state.editMode.treatmentId;
        }
      }
      state.tempSaved = false;
      // 편집 모드 종료
      state.editMode = {
        isEditing: false,
        treatmentId: null
      };
    },
    saveToBlockchainFailure: (state, action: PayloadAction<string>) => {
      state.savingToBlockchain = false;
      state.blockchainError = action.payload;
    },
    saveTreatmentTemp: (state) => {
      state.tempSaved = true;
    },
    updateExistingTreatment: (state, action: PayloadAction<{
      treatmentId: string;
      updatedFields: Partial<Treatment>;
    }>) => {
      const { treatmentId, updatedFields } = action.payload;
      const index = state.treatments.findIndex(t => t.id === treatmentId);
      
      if (index !== -1) {
        // 기존 데이터와 업데이트 필드 병합
        state.treatments[index] = {
          ...state.treatments[index],
          ...updatedFields
        };
        
        // 편집 히스토리 추가
        if (!state.treatments[index].editHistory) {
          state.treatments[index].editHistory = [];
        }
        
        state.treatments[index].editHistory?.push({
          date: new Date().toISOString(),
          hospitalId: state.treatments[index].hospitalId,
          action: '진료 내역 수정',
          veterinarianName: state.treatments[index].veterinarianName
        });
      }
    },
    setEditMode: (state, action: PayloadAction<{ isEditing: boolean; treatmentId: string | null }>) => {
      state.editMode = action.payload;
    },
  },
});

export const {
  fetchTreatmentsStart,
  fetchTreatmentsSuccess,
  fetchTreatmentsFailure,
  setCurrentTreatment,
  updateCurrentTreatmentDiagnosis,
  updateCurrentTreatmentFields,
  addTreatmentItem,
  removeTreatmentItem,
  updateTreatmentItem,
  setImportedPdfData,
  clearImportedPdfData,
  setDocumentType,
  saveTreatmentStart,
  saveTreatmentSuccess,
  saveTreatmentFailure,
  saveToBlockchainStart,
  saveToBlockchainSuccess,
  saveToBlockchainFailure,
  saveTreatmentTemp,
  updateExistingTreatment,
  setEditMode
} = treatmentSlice.actions;

export default treatmentSlice.reducer; 