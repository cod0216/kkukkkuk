import React from 'react';
import { FaPaw } from 'react-icons/fa';
import { Treatment , Gender, TreatmentState } from '@/interfaces';
/**
 * @module PetListItem
 * @file PetListItem.tsx
 * @author haelim
 * @date 2025-03-26
 * @description 진단 페이지 좌측 동물 목록 조회의 각 아이템 UI 컴포넌트입니다. 
 * 
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-26        haelim           최초 생성
 */


/**
 * PetListItem 컴포넌트의 Props 타입 정의 
 * @param treatment WAS 서버에서 조회한 진료 기록 메타데이터 
 * @param isSelected 현재 메인으로 보여주고 있는 반려동물인지 여부 
 * @param onSelect 메인으로 조회할 반려동물 선택하는 메서드 
 * @param getStateColor 해당 반려동물의 STATE 에 따라 컴포넌트의 색상 결정 
 * @param getStateBadgeColor 해당 반려동물의 STATE 에 따라 컴포넌트의 배지 색상 결정 
 */
interface PetListItemProps {
  treatment: Treatment;
  isSelected: boolean;
  onSelect: () => void;
  getStateColor: (state: TreatmentState) => string;
  getStateBadgeColor: (state: TreatmentState) => string;
}

/**
 * 진단 페이지 좌측 동물 목록 조회의 각 아이템 UI 컴포넌트
 */
const PetListItem: React.FC<PetListItemProps> = ({
  treatment, isSelected, onSelect, getStateColor, getStateBadgeColor }) => {
  return (
    <div
      className={`flex flex-col gap-1 p-3 rounded-lg transition-all duration-200 cursor-pointer
        ${isSelected ? 'outline-primary-500' : ''} 
        ${getStateColor(treatment.state)}`}
      onClick={onSelect}
    >
      <div className="flex gap-2">
        <div className="flex items-center flex-1 justify-between">
           <div className="flex items-baseline gap-2">
              <FaPaw className="h-3 w-3 text-gray-500" />
              <div className="font-bold text-gray-900 text-nowrap">{treatment.name}</div>
              <div className="text-[8pt] font-medium text-gray-600">{treatment.breedName}</div>
          </div>
          {/* <div className={`h-4 flex items-center text-[8pt] px-2 rounded-full text-nowrap ${getStateBadgeColor(treatment.state)}`}>
            {treatment.state}
          </div> */}
        </div>
      </div>
      <div className="text-xs text-gray-600">
        {treatment.age}, {treatment.gender === Gender.MALE ? '수컷' : '암컷'}
        {treatment.flagNeutering ? ', 중성화' : ''}
      </div>
    </div>
  );
};

export default PetListItem;