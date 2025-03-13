import { configureStore } from '@reduxjs/toolkit';
import { TypedUseSelectorHook, useDispatch, useSelector } from 'react-redux';
import authReducer from './slices/authSlice';
import guardianReducer from './slices/guardianSlice';
import petReducer from './slices/petSlice';
import treatmentReducer from './slices/treatmentSlice';
import themeReducer from './slices/themeSlice';
import didReducer from './slices/didSlice';
import devModeReducer from './slices/devModeSlice';

export const store = configureStore({
  reducer: {
    auth: authReducer,
    guardian: guardianReducer,
    pet: petReducer,
    treatment: treatmentReducer,
    theme: themeReducer,
    did: didReducer,
    devMode: devModeReducer,
  },
});

export type RootState = ReturnType<typeof store.getState>;
export type AppDispatch = typeof store.dispatch;

export const useAppDispatch = () => useDispatch<AppDispatch>();
export const useAppSelector: TypedUseSelectorHook<RootState> = useSelector; 