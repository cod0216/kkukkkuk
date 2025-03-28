import React from "react";
import { FaPaw, FaStethoscope } from "react-icons/fa";
import { Treatment, Gender, TreatmentState } from "@/interfaces/index";
/**
 * @module TreatmentHeader
 * @file TreatmentHeader.tsx
 * @author haelim
 * @date 2025-03-26
 * @description 진단 페이지 내부의 헤더 역할을 수행합니다.
 *              진단 페이지 상단 메인으로 조회할 반려동물를 출력하는 UI 컴포넌트입니다.
 *
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-26        haelim           최초 생성
 */

/**
 * TreatmentHeader 컴포넌트의 Props 타입 정의
 */
interface TreatmentHeaderProps {
  treatment?: Treatment;
  getStateBadgeColor: (state: TreatmentState) => string;
  onSelected: () => void;
  isFormVisible: boolean;
}

/**
 * 진단 페이지 내부의 헤더 역할을 수행합니다.
 * 진단 페이지 상단 메인으로 조회할 반려동물를 출력하는 UI 컴포넌트입니다.
 */
const TreatmentHeader: React.FC<TreatmentHeaderProps> = ({
  treatment,
  getStateBadgeColor,
  isFormVisible,
  onSelected,
}) => {
  return (
    <div className="bg-white p-4 rounded-lg border mb-3 flex items-center">
      {/* 왼쪽 아이콘 */}
      <div className="w-12 h-12 bg-gray-100 rounded-full flex items-center justify-center border border-gray-200">
        <FaPaw className="text-gray-400 text-2xl" />
      </div>

      {/* 중앙 정보 */}
      <div className="flex-1 px-4">
        <div className="flex items-center gap-3">
          <div className="text-md font-bold text-gray-800">
            {treatment?.name}
          </div>
          {treatment && (
            <div
              className={`text-[10px] px-2 py-0.5 rounded-full ${getStateBadgeColor(
                treatment.state
              )}`}
            >
              {treatment?.state}
            </div>
          )}
        </div>
        <div className="text-gray-600 text-sm font-medium mt-0.5">
          {treatment?.breedName}
        </div>
        <div className="text-gray-500 text-xs flex gap-1 mt-1">
          <span>{treatment?.gender === Gender.MALE ? "수컷" : "암컷"}</span>
          <span>·</span>
          <span>
            {treatment?.flagNeutering ? "중성화 완료" : "중성화 안함"}
          </span>
          <span>·</span>
          <span>{treatment?.age}세</span>
        </div>
      </div>

      {/* 오른쪽 버튼 */}
      {isFormVisible && (
        <button
          onClick={onSelected}
          className="bg-primary-500 hover:bg-primary-700 text-white text-xs font-medium px-3 py-1.5 rounded-md flex items-center gap-1 transition"
        >
          <FaStethoscope className="text-white text-xs" />
          <span>진료 시작</span>
        </button>
      )}
    </div>
  );
};

export default TreatmentHeader;
