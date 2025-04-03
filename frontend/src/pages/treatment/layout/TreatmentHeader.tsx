import React, { useState } from "react";
import { FaPaw, FaStethoscope, FaDog, FaCat, FaCalendarAlt, FaTimes } from "react-icons/fa";
import { Treatment, Gender, TreatmentState } from "@/interfaces/index";
import { markAppointmentAsCancelled } from "@/services/blockchainAgreementService";
/**
 * @module TreatmentHeader
 * @file TreatmentHeader.tsx
 * @author haelim
 * @date 2025-03-26
 * @author seonghun
 * @date 2025-03-28
 * @description 진단 페이지 내부의 헤더 역할을 수행합니다. 
 *              진단 페이지 상단 메인으로 조회할 반려동물를 출력하는 UI 컴포넌트입니다.   
 *              
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-26        haelim           최초 생성
 * 2025-03-28        seonghun         선택한 동물 정보 표시 추가
 * 2025-03-31        seonghun         진료취소 버튼 추가, 공유계약 상세정보 추가, 동물별 아이콘 추가
 * 2025-04-01        seonghun         품종 타입 판별 함수를 petTypeService로 이동
 * 2025-04-02        seonghun         speciesName 및 profileUrl 지원 추가
 * 2025-04-03        seonghun         진료취소 버튼 필드에 맞게 개선, 취소 핸들러 추가
 */

/**
 * TreatmentHeader 컴포넌트의 Props 타입 정의
 */
interface TreatmentHeaderProps {
  treatment?: Treatment;
  getStateBadgeColor: (state: TreatmentState) => string;
  onSelected: () => void;
  isFormVisible: boolean;
  onCancelled?: () => void; // 취소 처리 후 콜백
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
        textColor: 'text-green-700',
        borderColor: 'border-green-200'
      };
    case TreatmentState.WAITING:
      return {
        bgColor: 'bg-yellow-50',
        textColor: 'text-yellow-700',
        borderColor: 'border-yellow-200'
      };
    case TreatmentState.CANCELLED:
      return {
        bgColor: 'bg-red-50',
        textColor: 'text-red-700',
        borderColor: 'border-red-200'
      };
    case TreatmentState.IN_PROGRESS:
      return {
        bgColor: 'bg-blue-50',
        textColor: 'text-blue-700',
        borderColor: 'border-blue-200'
      };
    case TreatmentState.SHARED:
    default:
      return {
        bgColor: 'bg-blue-50',
        textColor: 'text-blue-700',
        borderColor: 'border-blue-200'
      };
  }
};

/**
 * 진단 페이지 내부의 헤더 역할을 수행합니다.
 * 진단 페이지 상단 메인으로 조회할 반려동물를 출력하는 UI 컴포넌트입니다.
 */
const TreatmentHeader: React.FC<TreatmentHeaderProps> = ({
  treatment,
  getStateBadgeColor,
  isFormVisible,
  onSelected,
  onCancelled,
}) => {
  // 반려동물 타입 직접 확인 (speciesName 우선 사용)
  const speciesLower = treatment?.speciesName?.toLowerCase() || '';
  let petType: '강아지' | '고양이' | 'unknown' = 'unknown';
  
  if (speciesLower.includes('강아지') || speciesLower.includes('개') || speciesLower === 'dog') {
    petType = '강아지';
  } else if (speciesLower.includes('고양이') || speciesLower === 'cat') {
    petType = '고양이';
  }
  
  // 프로필 이미지 존재 여부
  const hasProfileImage = treatment?.profileUrl && treatment.profileUrl.length > 0;
  
  // 공유 계약 정보 확인
  const hasAgreementInfo = treatment && !!treatment.agreementInfo;
  
  // 공유 시작일과 만료일 포맷팅
  const formattedStartDate = hasAgreementInfo && treatment?.agreementInfo?.formattedCreatedAt
    ? treatment.agreementInfo.formattedCreatedAt.split(' ')[0]
    : '';
    
  const formattedExpireDate = hasAgreementInfo && treatment?.agreementInfo?.formattedExpireDate
    ? treatment.agreementInfo.formattedExpireDate.split(' ')[0]
    : '';
  
  // 만료 임박 여부
  const isExpiringSoon = hasAgreementInfo && treatment?.agreementInfo?.isExpiringSoon;
  
  // 로딩 상태
  const [isRevoking, setIsRevoking] = useState(false);
  
  // 에러 메시지
  const [errorMessage, setErrorMessage] = useState<string | null>(null);
  
  // 계산된 상태 확인 (상위 컴포넌트에서 제공한 값 사용)
  const isCancelled = treatment?.isCancelled || false;
  
  // 진료 상태
  const calculatedState = treatment?.calculatedState || 
    (hasAgreementInfo ? TreatmentState.SHARED : (treatment?.state || TreatmentState.NONE));
  
  // 진료 상태 스타일
  const statusStyle = getStatusStyle(calculatedState);

  // 취소 버튼 클릭 핸들러
  const handleRevokeClick = async () => {
    if (!treatment?.petDid) {
      setErrorMessage('반려동물 정보가 없습니다.');
      return;
    }
    
    setIsRevoking(true);
    setErrorMessage(null);
    
    try {
      // 현재 연결된 계정 주소를 사용
      const { getAccountAddress } = await import('@/services/blockchainAuthService');
      const currentAddress = await getAccountAddress();
      
      if (!currentAddress) {
        throw new Error('연결된 계정 정보를 가져올 수 없습니다.');
      }
      
      // 현재 병원 주소로 진료 취소 기록 작성
      const result = await markAppointmentAsCancelled(
        treatment.petDid,
        currentAddress,
        "병원 측 진료 취소 요청"
      );
      
      if (result.success) {
        // 부모 컴포넌트에 취소 완료 알림
        if (onCancelled) {
          onCancelled();
        }
      } else {
        setErrorMessage(result.error || '진료 취소 처리 중 오류가 발생했습니다.');
      }
    } catch (error: any) {
      setErrorMessage(error.message || '진료 취소 처리 중 오류가 발생했습니다.');
    } finally {
      setIsRevoking(false);
    }
  };

  return (
    <>
      <div className="bg-white p-4 rounded-lg border mb-3 flex items-center">
        {/* 왼쪽 아이콘 - 프로필 이미지 또는 동물 아이콘 */}
        <div className="w-16 h-16 rounded-full overflow-hidden flex items-center justify-center border border-gray-200">
          {hasProfileImage ? (
            <img 
              src={treatment!.profileUrl!} 
              alt={`${treatment!.name} 프로필`}
              className="w-full h-full object-cover"
              onError={(e) => {
                // 이미지 로드 실패 시 아이콘 표시
                e.currentTarget.style.display = 'none';
                if (e.currentTarget.parentElement) {
                  e.currentTarget.parentElement.classList.add('bg-gray-100');
                  
                  // 동물 아이콘 렌더링
                  const iconElement = document.createElement('div');
                  iconElement.className = 'flex items-center justify-center h-full';
                  
                  if (petType === '강아지') {
                    iconElement.innerHTML = '<svg class="text-blue-500 text-4xl" viewBox="0 0 512 512"><path fill="currentColor" d="M496 96h-64l-7.16-14.31A32 32 0 0 0 396.22 64H342.6l-27.28-27.28C305.23 26.64 288 33.78 288 48.03v149.84l128 45.71V208h32c35.35 0 64-28.65 64-64v-32c0-8.84-7.16-16-16-16zm-112 48c-8.84 0-16-7.16-16-16s7.16-16 16-16 16 7.16 16 16-7.16 16-16 16zM96 224c-17.64 0-32-14.36-32-32 0-17.67-14.33-32-32-32S0 174.33 0 192c0 41.66 26.83 76.85 64 90.1V496c0 8.84 7.16 16 16 16h64c8.84 0 16-7.16 16-16V384h160v112c0 8.84 7.16 16 16 16h64c8.84 0 16-7.16 16-16V277.55L266.05 224H96z"/></svg>';
                  } else if (petType === '고양이') {
                    iconElement.innerHTML = '<svg class="text-orange-500 text-4xl" viewBox="0 0 512 512"><path fill="currentColor" d="M290.59 192c-20.18 0-106.82 1.98-162.59 85.95V192c0-52.94-43.06-96-96-96-17.67 0-32 14.33-32 32s14.33 32 32 32c17.64 0 32 14.36 32 32v256c0 35.3 28.7 64 64 64h176c8.84 0 16-7.16 16-16v-16c0-17.67-14.33-32-32-32h-32l128-96v144c0 8.84 7.16 16 16 16h32c8.84 0 16-7.16 16-16V289.86c-10.29 2.67-20.89 4.54-32 4.54-61.81 0-113.52-44.05-125.41-102.4zM448 96h-64l-64-64v134.4c0 53.02 42.98 96 96 96s96-42.98 96-96V32l-64 64zm-72 80c-8.84 0-16-7.16-16-16s7.16-16 16-16 16 7.16 16 16-7.16 16-16 16z"/></svg>';
                  } else {
                    iconElement.innerHTML = '<svg class="text-gray-400 text-4xl" viewBox="0 0 512 512"><path fill="currentColor" d="M256 224c-79.41 0-192 122.76-192 200.25 0 34.9 26.81 55.75 71.74 55.75 48.84 0 81.09-25.08 120.26-25.08 39.51 0 71.85 25.08 120.26 25.08 44.93 0 71.74-20.85 71.74-55.75C448 346.76 335.41 224 256 224zm-147.28-12.61c-10.4-34.65-42.44-57.09-71.56-50.13-29.12 6.96-44.29 40.69-33.89 75.34 10.4 34.65 42.44 57.09 71.56 50.13 29.12-6.96 44.29-40.69 33.89-75.34zm84.72-20.78c30.94-8.14 46.42-49.94 34.58-93.36s-46.52-72.01-77.46-63.87-46.42 49.94-34.58 93.36c11.84 43.42 46.53 72.02 77.46 63.87zm281.39-29.34c-29.12-6.96-61.15 15.48-71.56 50.13-10.4 34.65 4.77 68.38 33.89 75.34 29.12 6.96 61.15-15.48 71.56-50.13 10.4-34.65-4.77-68.38-33.89-75.34zm-156.27 29.34c30.94 8.14 65.62-20.45 77.46-63.87 11.84-43.42-3.64-85.21-34.58-93.36s-65.62 20.45-77.46 63.87c-11.84 43.42 3.64 85.22 34.58 93.36z"/></svg>';
                  }
                  
                  e.currentTarget.parentElement.appendChild(iconElement);
                }
              }}
            />
          ) : (
            <div className="bg-gray-100 w-full h-full flex items-center justify-center">
              {petType === '강아지' ? (
                <FaDog className="text-blue-500 text-4xl" title="강아지" />
              ) : petType === '고양이' ? (
                <FaCat className="text-orange-500 text-4xl" title="고양이" />
              ) : (
                <FaPaw className="text-gray-400 text-4xl" title="반려동물" />
              )}
            </div>
          )}
        </div>

        {/* 중앙 정보 */}
        <div className="flex-1 px-4">
          {treatment ? (
            <>
              <div className="flex items-center gap-3">
                <div className="text-md font-bold text-gray-800">
                  {treatment.name}
                </div>
                
                {/* 계약 정보 또는 상태 표시 */}
                {hasAgreementInfo ? (
                  <div className="flex items-center">
                    <div className={`text-[10px] px-2 py-0.5 rounded-full ${statusStyle.bgColor} ${statusStyle.textColor} ${statusStyle.borderColor} mr-1 flex items-center`}>
                      <span>{calculatedState}</span>
                    </div>
                    <div className="text-[10px] px-2 py-0.5 rounded-full bg-gray-50 text-gray-600 border border-gray-200 mr-1 flex items-center">
                      <span>{formattedStartDate} ~ {formattedExpireDate}</span>
                    </div>
                    <div className={`text-[10px] px-2 py-0.5 rounded-full flex items-center ${
                      isExpiringSoon ? 'bg-red-50 text-red-600 border border-red-200' : 'bg-blue-50 text-blue-600 border border-blue-200'
                    }`}>
                      <FaCalendarAlt className="h-2 w-2 mr-1" />
                      <span>{treatment?.agreementInfo ? calculateRemainingDays(treatment.agreementInfo.expireDate) : 0}일</span>
                    </div>
                  </div>
                ) : (
                  <div className={`text-[10px] px-2 py-0.5 rounded-full ${getStateBadgeColor(
                    treatment.state
                  )}`}>
                    {treatment.state}
                  </div>
                )}
              </div>
              
              <div className="text-gray-600 text-sm font-medium mt-0.5">
                {treatment.breedName}
              </div>
              
              <div className="text-gray-500 text-xs flex gap-1 mt-1">
                <span>{treatment.age}세</span>
                <span>·</span>
                <span>{treatment.gender === Gender.MALE ? "수컷" : "암컷"}</span>
                <span>·</span>
                <span>
                  {(treatment.flagNeutering === true || treatment.flagNeutering === 'true') 
                    ? "중성화 완료" 
                    : "중성화 안함"}
                </span>
              </div>
            </>
          ) : (
            <div className="text-gray-500 text-sm">반려동물을 선택해주세요</div>
          )}
        </div>

        {/* 오른쪽 버튼 */}
        {isFormVisible && treatment && hasAgreementInfo && (
          <div className="flex flex-col gap-2">
            {!isCancelled && calculatedState !== TreatmentState.COMPLETED && (
              <button 
                onClick={onSelected}
                className="bg-primary-500 hover:bg-primary-700 text-white text-xs font-medium px-3 py-1.5 rounded-md flex items-center gap-1 transition"
              >
                <FaStethoscope className="text-white text-xs" />
                <span>{calculatedState === TreatmentState.IN_PROGRESS ? '추가 진료' : '진료 시작'}</span>
              </button>
            )}
            
            {!isCancelled && calculatedState !== TreatmentState.COMPLETED && (
              <button 
                onClick={handleRevokeClick}
                disabled={isRevoking}
                className="bg-red-500 hover:bg-red-700 text-white text-xs font-medium px-3 py-1.5 rounded-md flex items-center gap-1 transition"
              >
                <FaTimes className="text-white text-xs" />
                <span>{isRevoking ? '처리 중...' : '진료 취소'}</span>
              </button>
            )}
          </div>
        )}
        
        {/* 에러 메시지 */}
        {errorMessage && (
          <div className="absolute top-0 right-0 m-4 p-3 bg-red-50 text-red-600 border border-red-200 rounded-md shadow-md text-sm">
            {errorMessage}
            <button 
              onClick={() => setErrorMessage(null)}
              className="ml-2 text-red-600 font-bold hover:text-red-800"
            >
              ×
            </button>
          </div>
        )}
      </div>
    </>
  );
};

export default TreatmentHeader;
