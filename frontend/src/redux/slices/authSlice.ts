import { createSlice, PayloadAction } from "@reduxjs/toolkit";
import { RootState } from "../store";

export interface Doctor {
  id: string;
  name: string;
  specialization: string;
  licenseNumber?: string;
}

export interface Hospital {
  id?: string | number;
  name: string;
  did: string;
  address?: string;
  phone?: string;
  phone_number?: string;
  email?: string;
  account?: string;
  license_number?: string;
  doctor_name?: string;
  authoriazation_number?: string;
  x_axis?: number;
  y_axis?: number;
  public_key?: string | null;
  doctors?: Doctor[];
}

export interface User {
  id: string;
  account: string;
  hospitalName: string;
  hospital?: Hospital;
}

export interface Tokens {
  access_token: string;
  refresh_token: string;
}

export interface AuthState {
  user: User | null;
  token: string | null;
  isLoggedIn: boolean;
  loading: boolean;
  error: string | null;
  hospital: Hospital | null;
}

const initialState: AuthState = {
  user: null,
  token: null,
  isLoggedIn: false,
  loading: false,
  error: null,
  hospital: null,
};

// 로컬 스토리지에서 기존 데이터 로드
const loadAuthStateFromStorage = (): AuthState => {
  try {
    const token = localStorage.getItem("access_token");
    const userStr = localStorage.getItem("user");
    const hospitalStr = localStorage.getItem("hospital");

    let user = null;
    let hospital = null;

    if (userStr) {
      user = JSON.parse(userStr);
    }

    if (hospitalStr) {
      hospital = JSON.parse(hospitalStr);
    }

    if (token) {
      return {
        user,
        token,
        hospital,
        isLoggedIn: true,
        loading: false,
        error: null,
      };
    }
  } catch (e) {
    console.error("로컬 스토리지에서 인증 상태 로드 중 오류:", e);
  }

  return initialState;
};

const preloadedState = loadAuthStateFromStorage();

export const authSlice = createSlice({
  name: "auth",
  initialState: preloadedState,
  reducers: {
    setCredentials: (
      state,
      action: PayloadAction<{ hospital: Hospital; tokens: Tokens }>
    ) => {
      state.hospital = action.payload.hospital;

      //id, 계정, 병원 이름
      state.user = {
        id: action.payload.hospital.id
          ? String(action.payload.hospital.id)
          : "",
        account: action.payload.hospital.account || "",
        hospitalName: action.payload.hospital.name,
        hospital: action.payload.hospital,
      };
      state.token = action.payload.tokens.access_token;
      state.isLoggedIn = true;

      // 로컬 스토리지 업데이트 에세스토큰 물어보기기
      localStorage.setItem("access_token", action.payload.tokens.access_token);
      localStorage.setItem("hospital", JSON.stringify(action.payload.hospital));
      localStorage.setItem("user", JSON.stringify(state.user));
    },
    logout: (state) => {
      state.user = null;
      state.token = null;
      state.isLoggedIn = false;
      state.hospital = null;

      // 로컬 스토리지에서 인증 데이터 제거
      localStorage.removeItem("access_token");
      localStorage.removeItem("refresh_token");
      localStorage.removeItem("user");
      localStorage.removeItem("hospital");
    },
    registerStart: (state) => {
      state.loading = true;
      state.error = null;
    },
    registerSuccess: (state, action: PayloadAction<any>) => {
      state.loading = false;
      state.error = null;
    },
    registerFailure: (state, action: PayloadAction<string>) => {
      state.loading = false;
      state.error = action.payload;
    },
    clearError: (state) => {
      state.error = null;
    },
    setHospitalInfo: (state, action: PayloadAction<Hospital>) => {
      state.hospital = action.payload;

      // 로컬 스토리지에 병원 정보 업데이트
      localStorage.setItem("hospital", JSON.stringify(action.payload));

      // 사용자 데이터에 병원 이름 업데이트
      if (state.user) {
        state.user.hospitalName = action.payload.name;
        localStorage.setItem("user", JSON.stringify(state.user));
      }
    },
    updateHospitalInfoAction: (state, action: PayloadAction<Hospital>) => {
      state.hospital = action.payload;

      // 로컬 스토리지에 병원 정보 업데이트
      localStorage.setItem("hospital", JSON.stringify(action.payload));

      // 사용자 데이터에 병원 이름 업데이트
      if (state.user) {
        state.user.hospitalName = action.payload.name;
        localStorage.setItem("user", JSON.stringify(state.user));
      }
    },
  },
});

export const {
  setCredentials,
  logout,
  registerStart,
  registerSuccess,
  registerFailure,
  clearError,
  updateHospitalInfoAction,
  setHospitalInfo,
} = authSlice.actions;

// 선택자(Selectors)
export const selectCurrentUser = (state: RootState) => state.auth.user;
export const selectCurrentToken = (state: RootState) => state.auth.token;
export const selectIsLoggedIn = (state: RootState) => state.auth.isLoggedIn;
export const selectLoading = (state: RootState) => state.auth.loading;
export const selectError = (state: RootState) => state.auth.error;
export const selectLoggedInHospital = (state: RootState) => state.auth.hospital;

export default authSlice.reducer;
