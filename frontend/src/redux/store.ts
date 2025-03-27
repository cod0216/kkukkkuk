import { configureStore, createSlice, PayloadAction } from "@reduxjs/toolkit";
import { AuthState, HospitalDetail } from "@/interfaces/index";

/**
 * @module store
 * @file store.tsx
 * @author eunchang
 * @date 2025-03-26
 * @description 상태 관리를 위한 Redux 스토어 모듈 입니다.
 *
 * 이 스토어는 상태를 관리합니다.
 *
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-26        eunchang         최초 생성
 */

/**
 * 초기 인증 상태를 정의 합니다.
 */
const initialAuthState: AuthState = {
  accessToken: null,
  hospital: null,
};

/**
 * 인증 관련 상태를 관리하는 auth slice를 생성합니다.
 */
const authSlice = createSlice({
  name: "auth",
  initialState: initialAuthState,
  reducers: {
    /**
     * 액세스 토큰을 설정합니다.
     *
     * @param state - 현재 상태
     * @param action - 새 액세스 토큰 문자열을 담은 PayloadAction
     */
    setAccessToken: (state, action: PayloadAction<string>) => {
      state.accessToken = action.payload;
    },
    /**
     * 액세스 토큰을 초기화합니다.
     *
     * @param state - 현재 상태
     */
    clearAccessToken: (state) => {
      state.accessToken = null;
    },

    /**
     * 병원 정보를 설정합니다.
     *
     * @param state - 현재 상태
     * @param action - HospitalDetail 타입의 병원 정보를 담은 PayloadAction
     */
    setHospital: (state, action: PayloadAction<HospitalDetail>) => {
      state.hospital = action.payload;
    },
  },
});

export const { setAccessToken, clearAccessToken, setHospital } =
  authSlice.actions;

/**
 * Redux 스토어를 생성하고 auth slice 리듀서를 등록합니다.
 */
export const store = configureStore({
  reducer: {
    auth: authSlice.reducer,
  },
});

export type RootState = ReturnType<typeof store.getState>;
export type AppDispatch = typeof store.dispatch;
