/**
 * @module MedicalManagement
 * @file MedicalManagement.tsx
 * @author eunchang
 * @date 2025-04-09
 * @description 검사(진단)와 백신 접종 항목 관리 컴포넌트를 함께 보여주는 페이지입니다.
 *
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-04-09        eunchang         최초 생성
 */
import React from "react";
import DiagnosisManagement from "@/pages/mypage/DiagnosisManagement";
import VaccinationManagement from "@/pages/mypage/VaccinationManagement";

const MedicalManagement: React.FC = () => {
  return (
    <div className="flex">
      <div className="w-1/2">
        <DiagnosisManagement />
      </div>
      <div className="w-1/2">
        <VaccinationManagement />
      </div>
    </div>
  );
};

export default MedicalManagement;
