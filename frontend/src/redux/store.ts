import { configureStore, createSlice, PayloadAction } from "@reduxjs/toolkit";
import { AuthState } from "@/interfaces/index";

/**
 * AccessToken Inital Status
 */
const initialAuthState: AuthState = {
  access_token: null,
};

/**
 * Auth Slice Create
 */
const authSlice = createSlice({
  name: "auth",
  initialState: initialAuthState,
  reducers: {
    setAccessToken: (state, action: PayloadAction<string>) => {
      state.access_token = action.payload;
    },

    clearAccessToken: (state) => {
      state.access_token = null;
    },
  },
});

export const { setAccessToken, clearAccessToken } = authSlice.actions;

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
