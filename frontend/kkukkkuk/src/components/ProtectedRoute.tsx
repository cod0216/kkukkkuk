import React from 'react';
import { Navigate } from 'react-router-dom';
import { useSelector } from 'react-redux';
import { RootState } from '../redux/store';
import { selectIsLoggedIn } from '../redux/slices/authSlice';

interface ProtectedRouteProps {
  children: React.ReactNode;
}

const ProtectedRoute: React.FC<ProtectedRouteProps> = ({ children }) => {
  const isLoggedIn = useSelector(selectIsLoggedIn);
  
  if (!isLoggedIn) {
    // 로그인이 되어있지 않으면 로그인 페이지로 리디렉션
    return <Navigate to="/login" replace />;
  }
  
  // 로그인 상태라면 자식 컴포넌트 렌더링
  return <>{children}</>;
};

export default ProtectedRoute; 