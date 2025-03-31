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
 * 품종명을 기반으로 반려동물 타입(강아지/고양이)을 판별합니다.
 * @param breedName 반려동물 품종명
 * @returns 'dog' | 'cat' | 'unknown'
 */
const determinePetType = (breedName: string): 'dog' | 'cat' | 'unknown' => {
  if (!breedName) return 'unknown';
  
  const lowerBreed = breedName.toLowerCase();
  
  // 강아지 품종 키워드
  const dogKeywords = [
    '테리어', '리트리버', '셰퍼드', '푸들', '불독', '시츄', '말티즈', '치와와', '포메라니안', 
    '진돗개', '보더콜리', '비숑', '닥스훈트', '허스키', '리트리버', '골든', '래브라도', '코기', 
    '웰시', '저먼', '셰퍼드', '비글', '달마티안', '그레이하운드', '프렌치불독', '요크셔', '퍼그',
    'terrier', 'retriever', 'shepherd', 'poodle', 'bulldog', 'shih tzu', 'maltese', 'chihuahua',
    'pomeranian', 'collie', 'bichon', 'dachshund', 'husky', 'golden', 'labrador', 'corgi',
    'welsh', 'german', 'beagle', 'dalmatian', 'greyhound', 'french', 'yorkshire', 'pug'
  ];
  
  // 고양이 품종 키워드
  const catKeywords = [
    '페르시안', '샴', '먼치킨', '러시안블루', '스핑크스', '뱅갈', '브리티시', '스코티시', 
    '메인쿤', '아비시니안', '버만', '시베리안', '노르웨이', '랙돌', '터키시앙고라', '봄베이',
    'persian', 'siamese', 'munchkin', 'russian blue', 'sphynx', 'bengal', 'british',
    'scottish', 'maine coon', 'abyssinian', 'birman', 'siberian', 'norwegian', 'ragdoll',
    'turkish angora', 'bombay', 'shorthair', '쇼트헤어', 'longhair', '롱헤어'
  ];
  
  // 특정 동물 종류 이름이 포함된 경우 직접 판별
  if (lowerBreed.includes('강아지') || lowerBreed.includes('개') || lowerBreed.includes('dog')) {
    return 'dog';
  }
  
  if (lowerBreed.includes('고양이') || lowerBreed.includes('cat')) {
    return 'cat';
  }
  
  // 품종 키워드로 판별
  for (const keyword of dogKeywords) {
    if (lowerBreed.includes(keyword.toLowerCase())) {
      return 'dog';
    }
  }
  
  for (const keyword of catKeywords) {
    if (lowerBreed.includes(keyword.toLowerCase())) {
      return 'cat';
    }
  }
  
  // 판별 불가능한 경우
  return 'unknown';
};

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
  // 반려동물 타입 판별
  const petType = treatment ? determinePetType(treatment.breedName) : 'unknown';
  
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
        {/* 왼쪽 아이콘 */}
        <div className="w-12 h-12 bg-gray-100 rounded-full flex items-center justify-center border border-gray-200">
          {petType === 'dog' ? (
            <FaDog className="text-blue-500 text-4xl" title="강아지" />
          ) : petType === 'cat' ? (
            <FaCat className="text-orange-500 text-4xl" title="고양이" />
          ) : (
            <FaPaw className="text-gray-400 text-4xl" title="반려동물" />
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
            {!isCancelled && (
              <button 
                onClick={onSelected}
                className="bg-primary-500 hover:bg-primary-700 text-white text-xs font-medium px-3 py-1.5 rounded-md flex items-center gap-1 transition"
              >
                <FaStethoscope className="text-white text-xs" />
                <span>진료 시작</span>
              </button>
            )}
            
            {!isCancelled && (
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
