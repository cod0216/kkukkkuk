import { createSlice, PayloadAction } from '@reduxjs/toolkit';
import { v4 as uuidv4 } from 'uuid';

export interface DIDInfo {
  did: string;
  hospitalName: string;
  createdAt: string;
  qrCodeValue: string;
}

interface DIDState {
  hospitalDID: string;
  didInfo: DIDInfo | null;
  sharedDID: DIDInfo | null;
  didList: DIDInfo[];
  showQRCode: boolean;
  loading: boolean;
  error: string | null;
}

// DID 식별자 생성 함수
const generateDID = (name: string): string => {
  const uuid = uuidv4();
  return `did:kkuk:${uuid}`;
};

// QR 코드에 포함될 정보 생성
const generateQRCodeValue = (did: string, hospitalName: string): string => {
  const data = {
    did,
    hospitalName,
    timestamp: new Date().toISOString(),
    type: 'hospital'
  };
  return JSON.stringify(data);
};

const initialState: DIDState = {
  hospitalDID: '',
  didInfo: null,
  sharedDID: null,
  didList: [],
  showQRCode: false,
  loading: false,
  error: null
};

const didSlice = createSlice({
  name: 'did',
  initialState,
  reducers: {
    generateHospitalDID: (state, action: PayloadAction<{ hospitalName: string }>) => {
      const did = generateDID(action.payload.hospitalName);
      const qrCodeValue = generateQRCodeValue(did, action.payload.hospitalName);
      
      const didInfo: DIDInfo = {
        did,
        hospitalName: action.payload.hospitalName,
        createdAt: new Date().toISOString(),
        qrCodeValue
      };
      
      state.hospitalDID = did;
      state.didInfo = didInfo;
      state.didList.push(didInfo);
    },
    setSharedDID: (state, action: PayloadAction<DIDInfo>) => {
      state.sharedDID = action.payload;
    },
    clearSharedDID: (state) => {
      state.sharedDID = null;
    },
    toggleQRCodeVisibility: (state) => {
      state.showQRCode = !state.showQRCode;
    },
    setShowQRCode: (state, action: PayloadAction<boolean>) => {
      state.showQRCode = action.payload;
    }
  }
});

export const {
  generateHospitalDID,
  setSharedDID,
  clearSharedDID,
  toggleQRCodeVisibility,
  setShowQRCode
} = didSlice.actions;

export default didSlice.reducer; 