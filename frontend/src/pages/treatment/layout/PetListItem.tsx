import { FaPaw, FaCalendarAlt, FaDog, FaCat } from "react-icons/fa";
import { Treatment, Gender, TreatmentState } from "@/interfaces/index";
import { determinePetTypeSync } from "@/services/petTypeService";
/**
 * @module PetListItem
 * @file PetListItem.tsx
 * @author haelim
 * @date 2025-03-26
 * @author seonghun
 * @date 2025-03-28
 * @description 진단 페이지 좌측 동물 목록 조회의 각 아이템 UI 컴포넌트입니다. 
 * 
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-26        haelim           최초 생성
 * 2025-03-28        seonghun         상위 컴포넌트와 연동
 * 2025-03-31        seonghun         동물별 아이콘 표시, 블록체인 기반 공유계약 남을 일자 배지표시
 * 2025-04-01        assistant        품종 타입 판별 함수를 petTypeService로 이동
 */

/**
 * 진료 상태 타입
 */

/**
 * PetListItem 컴포넌트의 Props 타입 정의
 * @param treatment WAS 서버에서 조회한 진료 기록 메타데이터
 * @param isSelected 현재 메인으로 보여주고 있는 반려동물인지 여부
 * @param onSelect 메인으로 조회할 반려동물 선택하는 메서드
 * @param getStateColor 해당 반려동물의 STATE 에 따라 컴포넌트의 색상 결정
 * @param getStateBadgeColor 해당 반려동물의 STATE 에 따라 컴포넌트의 배지 색상 결정
 * @param isUnread 읽지 않은 상태인지 여부
 */
interface PetListItemProps {
  treatment: Treatment;
  isSelected: boolean;
  onSelect: () => void;
  getStateColor: (state: TreatmentState) => string;
  getStateBadgeColor: (state: TreatmentState) => string;
  isUnread?: boolean;
}

/**
 * 남은 계약 일수를 계산합니다.
 * @param expireDate 만료 시간 (유닉스 타임스탬프)
 * @returns 남은 일수
 */
const calculateRemainingDays = (expireDate?: number): number => {
  if (!expireDate) return 0;
  
  const now = Math.floor(Date.now() / 1000); // 현재 시간 (초 단위)
  const diffSeconds = expireDate - now;
  
  if (diffSeconds <= 0) return 0;
  
  return Math.ceil(diffSeconds / (60 * 60 * 24)); // 일 단위로 변환 (올림 처리)
};

/**
 * 진료 상태에 따른 스타일을 반환합니다.
 * @param state 진료 상태
 * @returns 상태에 따른 스타일 객체
 */
const getStatusStyle = (state: TreatmentState) => {
  switch (state) {
    case TreatmentState.COMPLETED:
      return {
        bgColor: 'bg-green-50',
        textColor: 'text-green-600',
        borderColor: 'border-green-200'
      };
    case TreatmentState.WAITING:
      return {
        bgColor: 'bg-yellow-50',
        textColor: 'text-yellow-600',
        borderColor: 'border-yellow-200'
      };
    case TreatmentState.CANCELLED:
      return {
        bgColor: 'bg-red-50',
        textColor: 'text-red-600',
        borderColor: 'border-red-200'
      };
    case TreatmentState.IN_PROGRESS:
      return {
        bgColor: 'bg-blue-50',
        textColor: 'text-blue-600',
        borderColor: 'border-blue-200'
      };
    case TreatmentState.SHARED:
    default:
      return {
        bgColor: 'bg-transparent',
        textColor: 'text-blue-600',
        borderColor: 'border-blue-200'
      };
  }
};

/**
 * 진단 페이지 좌측 동물 목록 조회의 각 아이템 UI 컴포넌트
 */
const PetListItem: React.FC<PetListItemProps> = ({
  treatment,
  isSelected,
  onSelect,
  getStateBadgeColor,
  isUnread = false,
}) => {
  // 공유 계약 정보 유무 확인
  const hasAgreementInfo = !!treatment.agreementInfo;
  
  // 남은 계약 일수 계산
  const remainingDays = hasAgreementInfo && treatment.agreementInfo
    ? calculateRemainingDays(treatment.agreementInfo.expireDate)
    : 0;
  
  // 공유 시작일 전체 포맷팅 (날짜와 시간 모두 포함)
  const formattedStartDate = hasAgreementInfo && treatment.agreementInfo?.formattedCreatedAt
    ? treatment.agreementInfo.formattedCreatedAt
    : '';
    
  // 반려동물 타입 판별
  const petType = determinePetTypeSync(treatment.breedName);
  
  
  // 진료 상태
  const calculatedState = treatment.calculatedState || 
    (hasAgreementInfo ? TreatmentState.SHARED : treatment.state);
  
  // 진료 상태 스타일
  const statusStyle = getStatusStyle(calculatedState);

  return (
    <div
      className={`relative flex flex-col gap-1 p-3 rounded-lg transition-all duration-200 cursor-pointer
        ${isSelected 
          ? "bg-blue-100 shadow-sm" 
          : "bg-transparent hover:bg-blue-50 border border-transparent"}
      `}
      onClick={onSelect}
    >
      <div className="flex gap-2">
        <div className="flex items-center flex-1 justify-between">
          <div className="flex items-baseline gap-2">
            {/* 반려동물 타입에 따른 아이콘 표시 */}
            {petType === 'dog' ? (
              <FaDog className="h-4 w-4 text-blue-500" title="강아지" />
            ) : petType === 'cat' ? (
              <FaCat className="h-4 w-4 text-orange-500" title="고양이" />
            ) : (
              <FaPaw className="h-4 w-4 text-gray-500" title="반려동물" />
            )}
            
            <div className="font-bold text-gray-900 text-nowrap">
              {treatment.name}
              {isUnread && (
                <span className="ml-1 inline-flex h-2 w-2 bg-red-500 rounded-full"></span>
              )}
            </div>
          </div>
          
          {/* 상태 또는 공유 계약 정보 표시 */}
          {hasAgreementInfo ? (
            <div className="flex items-center">
              <div className={`h-4 flex items-center text-[8pt] px-2 rounded-full text-nowrap ${statusStyle.bgColor} ${statusStyle.textColor} border ${statusStyle.borderColor} mr-1`}>
                {calculatedState}
              </div>
              <div className="h-4 flex items-center text-[8pt] px-2 rounded-full text-nowrap bg-gray-50 text-gray-600 border border-gray-200">
                {remainingDays}일
              </div>
            </div>
          ) : (
            <div
              className={`h-4 flex items-center text-[8pt] px-2 rounded-full text-nowrap ${getStateBadgeColor(
                treatment.state
              )}`}
            >
              {treatment.state}
            </div>
          )}
        </div>
      </div>
      
      {/* 기본 정보 */}
      <div className="text-xs text-gray-600">
      {treatment.breedName} | {treatment.age}세 | {treatment.gender === Gender.MALE ? "수컷" : "암컷"} | {
          // 문자열이나 불리언 값을 모두 처리할 수 있도록 변환
          (treatment.flagNeutering === true || treatment.flagNeutering === 'true') 
            ? "중성화 완료" 
            : "중성화 안함"
        }
      </div>
      
      {/* 공유 계약 정보 표시 */}
      {hasAgreementInfo && (
        <div className="mt-1 pt-1 border-t border-gray-100">
          <div className="flex flex-col text-xs text-gray-600">
            <div className="flex items-center">
              <FaCalendarAlt className="h-2.5 w-2.5 mr-1 text-blue-500" />
              <span className="text-[8pt]">
                <span className="font-semibold">접수일시: </span>{formattedStartDate}
              </span>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default PetListItem;
