import { configureStore, createSlice, PayloadAction } from "@reduxjs/toolkit";
import { AuthState, HospitalDetail } from "@/interfaces/index";

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
