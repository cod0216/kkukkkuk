import { useEffect } from "react";
import { Routes, Route, useNavigate, useLocation } from "react-router-dom";
import MainLayout from "@/layouts/MainLayout";
import TreatmentMain from "@/pages/treatment/TreatmentMain";
import SignUp from "@/pages/signup/SignUp";
import Login from "@/pages/auth/Login";
import FindPw from "@/pages/auth/FindPw";
import FindId from "@/pages/auth/FindId";
import { getRefreshToken, removeRefreshToken } from "@/utils/iDBUtil";
import MyPage from "@/pages/mypage/MyPage"
import ViewProfile from "@/pages/mypage/ViewProfile"
import EditProfile from "@/pages/mypage/EditProfile"
import DoctorManagement from "@/pages/mypage/DoctorManagement"

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
 * 2025-03-27        eunchang         자동로그인 여부에 따른 로그인 상태 관리
 * 2025-03-30        sangmuk          마이페이지 라우트 추가
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
      const publicPaths = ["/login", "/sign-up", "/find-password", "/find-id"];
      const currentPath = location.pathname;
      const isPublic = publicPaths.some((path) => currentPath.startsWith(path));
      if (!token && !isPublic) {
        navigate("/login");
      }
    };
    checkRefreshToken();
  }, [navigate, location]);

  useEffect(() => {
    const openTabsKey = "openTabs";
    const tabId = Date.now() + "_" + Math.random().toString(36).substr(2, 9);

    const addTab = () => {
      const stored = localStorage.getItem(openTabsKey);
      const tabs: string[] = stored ? JSON.parse(stored) : [];
      tabs.push(tabId);
      localStorage.setItem(openTabsKey, JSON.stringify(tabs));
    };

    const removeTab = () => {
      const stored = localStorage.getItem(openTabsKey);
      let tabs: string[] = stored ? JSON.parse(stored) : [];
      tabs = tabs.filter((id) => id !== tabId);
      localStorage.setItem(openTabsKey, JSON.stringify(tabs));

      setTimeout(() => {
        const storedAfter = localStorage.getItem(openTabsKey);
        const updatedTabs: string[] = storedAfter
          ? JSON.parse(storedAfter)
          : [];
        if (
          updatedTabs.length === 0 &&
          localStorage.getItem("autoLogin") !== "true"
        ) {
          removeRefreshToken();
        }
      }, 300);
    };

    addTab();
    window.addEventListener("beforeunload", removeTab);
    return () => {
      window.removeEventListener("beforeunload", removeTab);
    };
  }, []);

  return (
    <Routes>
      <Route path="/login" element={<Login />} />
      <Route path="/find-password" element={<FindPw />} />
      <Route path="/find-id" element={<FindId />} />
      <Route path="/sign-up" element={<SignUp />} />

      <Route element={<MainLayout />}>
        <Route path="/" element={<TreatmentMain />} />
        <Route path="/treatment" element={<TreatmentMain />} />
        <Route path="/my-page" element={<MyPage />}>
          <Route index element={<ViewProfile />} />
          <Route path="edit-profile" element={<EditProfile />} />
          <Route path="doctor-management" element={<DoctorManagement />} />
        </Route>
      </Route>
    </Routes>
  );
}

export default App;
