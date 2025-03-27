import { useEffect } from "react";
import { Routes, Route, useNavigate, useLocation } from "react-router-dom";
import MainLayout from "@/layouts/MainLayout";
import TreatmentMain from "@/pages/treatment/TreatmentMain";
import SignUp from "@/pages/signup/SignUp";
import Login from "@/pages/auth/Login";
import FindPw from "@/pages/auth/FindPw";
import FindId from "@/pages/auth/FindId";

import { getRefreshToken } from "@/utils/iDBUtil";
/**
 * @module App
 * @file App.tsx
 * @author eunchang
 * @date 2025-03-26
 * @description 애플리케이션의 라우팅을 구성하는 최상위 컴포넌트입니다.
 *
 * 이 모듈은 React Router를 활용하여 라우팅을 정의합니다.
 *
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-26        eunchang         최초 생성
 * 2025-03-27        eunchang         로그인 상태 관리
 */

function App() {
  const navigate = useNavigate();
  const location = useLocation();

  /**
   * refreshToken을 조회하고 허용된 사이트 외에는 로그인 페이지로 이동시킵니다.
   */
  useEffect(() => {
   const checkRefreshToken = async () => {
    const token = await getRefreshToken();
    const publicPaths = ["login", "/sing-up", "/find-password", "/find-id"]
    const currentPath = location.pathname;

    if(!token && !publicPaths.includes(currentPath)) {
      navigate("/login");
    }
   };
   checkRefreshToken();
  }, [navigate,location]);

  return (
    <Routes>
      <Route path="/login" element={<Login />} />
      <Route path="/find-password" element={<FindPw />} />
      <Route path="/find-id" element={<FindId />}  />
      <Route path="/sign-up" element={<SignUp />} />
      
      <Route element={<MainLayout />}>
        <Route path="/" element={<TreatmentMain />} />
        <Route path="/treatment" element={<TreatmentMain />} />
      </Route>
    </Routes>
  );
}

export default App;
