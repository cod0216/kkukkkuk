import { Routes, Route } from "react-router-dom";
import MainLayout from "@/layouts/MainLayout";
import TreatmentMain from "@/pages/treatment/TreatmentMain";
import Login from "@/pages/auth/Login";
import FindPw from "@/pages/auth/FindPw";
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
 */

function App() {
  return (
    <Routes>
      <Route path="/" element={<Login />} />
      <Route path="/find-password" element={<FindPw />} />
      <Route element={<MainLayout />}>
        <Route path="/TreatmentMain" element={<TreatmentMain />} />
        <Route path="/treatment" element={<TreatmentMain />} />
      </Route>
    </Routes>
  );
}

export default App;
