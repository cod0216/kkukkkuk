import { createSlice, PayloadAction } from '@reduxjs/toolkit';
import { selectDevModeEnabled, selectMockHospitalData } from './devModeSlice';

interface Doctor {
  id: string;
  name: string;
  specialization: string;
  licenseNumber?: string;
}

interface Hospital {
  name: string;
  did: string;
  address?: string;
  phone?: string;
  email?: string;
  doctors?: Doctor[];
}

interface AuthState {
  isAuthenticated: boolean;
  user: any;
  token: string | null;
  loading: boolean;
  error: string | null;
  hospital: any;
  currentDoctor: any;
}

const initialState: AuthState = {
  isAuthenticated: localStorage.getItem('token') ? true : false,
  user: JSON.parse(localStorage.getItem('user') || 'null'),
  token: localStorage.getItem('token'),
  loading: false,
  error: null,
  hospital: null,
  currentDoctor: null
};

const authSlice = createSlice({
  name: 'auth',
  initialState,
  reducers: {
    signupStart: (state) => {
      state.loading = true;
      state.error = null;
    },
    signupSuccess: (state, action: PayloadAction<any>) => {
      state.loading = false;
      state.error = null;
      state.user = action.payload;
      state.isAuthenticated = true;
    },
    signupFailure: (state, action: PayloadAction<string>) => {
      state.loading = false;
      state.error = action.payload;
    },
    registerStart: (state) => {
      state.loading = true;
      state.error = null;
    },
    registerSuccess: (state, action: PayloadAction<any>) => {
      state.loading = false;
      state.error = null;
      state.user = action.payload;
      state.isAuthenticated = true;
    },
    registerFailure: (state, action: PayloadAction<string>) => {
      state.loading = false;
      state.error = action.payload;
    },
    loginStart: (state) => {
      state.loading = true;
      state.error = null;
    },
    loginSuccess: (state, action: PayloadAction<{user: any, token: string, hospital?: any}>) => {
      state.isAuthenticated = true;
      state.user = action.payload.user;
      state.token = action.payload.token;
      state.loading = false;
      state.error = null;
      state.hospital = action.payload.hospital || null;
      
      localStorage.setItem('user', JSON.stringify(action.payload.user));
      localStorage.setItem('token', action.payload.token);
    },
    loginFailure: (state, action: PayloadAction<string>) => {
      state.loading = false;
      state.error = action.payload;
    },
    logout: (state) => {
      state.isAuthenticated = false;
      state.user = null;
      state.token = null;
      state.hospital = null;
      state.currentDoctor = null;
      
      localStorage.removeItem('user');
      localStorage.removeItem('token');
    },
    updateHospitalInfo: (state, action: PayloadAction<any>) => {
      state.hospital = { ...state.hospital, ...action.payload };
      if (state.user && state.hospital && state.user.id === state.hospital.id) {
        state.user = { ...state.user, ...action.payload };
        localStorage.setItem('user', JSON.stringify(state.user));
      }
    },
    setCurrentDoctor: (state, action: PayloadAction<any>) => {
      state.currentDoctor = action.payload;
    },
  },
});

export const {
  signupStart,
  signupSuccess,
  signupFailure,
  registerStart,
  registerSuccess,
  registerFailure,
  loginStart,
  loginSuccess,
  loginFailure,
  logout,
  updateHospitalInfo,
  setCurrentDoctor
} = authSlice.actions;

export const selectIsAuthenticated = (state: { auth: AuthState }) => state.auth.isAuthenticated;
export const selectUser = (state: { auth: AuthState }) => state.auth.user;
export const selectToken = (state: { auth: AuthState }) => state.auth.token;
export const selectLoggedInHospital = (state: any) => {
  const devModeEnabled = selectDevModeEnabled(state);
  if (devModeEnabled && state.auth.user?.email === 'ssafy@example.com') {
    return selectMockHospitalData(state);
  }
  return state.auth.hospital;
};
export const selectCurrentDoctor = (state: { auth: AuthState }) => state.auth.currentDoctor;

export default authSlice.reducer; 