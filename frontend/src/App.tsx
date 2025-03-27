import { useEffect } from "react";
import { Routes, Route, useNavigate } from "react-router-dom";
import MainLayout from "@/layouts/MainLayout";
import TreatmentMain from "@/pages/treatment/TreatmentMain";
import SignUp from "@/pages/signup/SignUp";
import Login from "@/pages/auth/Login";
import FindPw from "@/pages/auth/FindPw";
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

  /**
   * refreshToken을 조회하여 로그인 상태를 관리합니다.
   */
  useEffect(() => {
    const checkRefreshToken = async () => {
      const token = await getRefreshToken();
      if (!token) {
        navigate("/login");
      }
    };
    checkRefreshToken();
  }, [navigate]);

  return (
    <Routes>
      <Route path="/login" element={<Login />} />
      <Route path="/find-password" element={<FindPw />} />
      <Route path="/sign-up" element={<SignUp />} />
      <Route element={<MainLayout />}>
        <Route path="/" element={<TreatmentMain />} />
        <Route path="/treatment" element={<TreatmentMain />} />
      </Route>
    </Routes>
  );
}

export default App;
