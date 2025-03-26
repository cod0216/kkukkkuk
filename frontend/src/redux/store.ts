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
 * AccessToken Inital Status
 */
const initialAuthState: AuthState = {
  accessToken: null,
  hospital: null,
};

/**
 * Auth Slice Create
 */
const authSlice = createSlice({
  name: "auth",
  initialState: initialAuthState,
  reducers: {
    setAccessToken: (state, action: PayloadAction<string>) => {
      state.accessToken = action.payload;
    },

    clearAccessToken: (state) => {
      state.accessToken = null;
    },
    setHospital: (state, action: PayloadAction<HospitalDetail>) => {
      state.hospital = action.payload;
    },
  },
});

export const { setAccessToken, clearAccessToken, setHospital } =
  authSlice.actions;

/**
 * store create and auth reducer registering
 */
export const store = configureStore({
  reducer: {
    auth: authSlice.reducer,
  },
});

export type RootState = ReturnType<typeof store.getState>;
export type AppDispatch = typeof store.dispatch;
