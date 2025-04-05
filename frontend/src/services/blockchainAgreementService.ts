/**
 * @module blockchainAgreementService
 * @file blockchainAgreementService.ts
 * @author AI assistant
 * @date 2025-04-01
 * @description 블록체인에서 공유 계약 정보를 관리하고 가공하는 서비스
 * 
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-31        seonghun     최초 생성
 * 2025-04-02        seonghun     진료취소 기능 개선, 변경된 필드에 맞게 정보 조회 개선
 */

import { PetWithAgreement, SharingAgreement } from '@/interfaces/pet';
import { Treatment, TreatmentState, Gender } from '@/interfaces';
import { getPetBasicInfo } from '@/services/treatmentService';
import { 
  getSharingAgreementTimes,
  timestampToDate,
  formatDate
} from '@/services/blockchainAlarmService';

/**
 * 반려동물 DID 주소로 공유 계약 정보를 조회합니다.
 * @param petDID 반려동물 DID 주소
 * @param hospitalAddress 병원 주소
 * @returns 공유 계약 정보
 */
export const getAgreementInfo = async (
  petDID: string,
  hospitalAddress: string
): Promise<SharingAgreement | null> => {
  try {
    const agreement = await getSharingAgreementTimes(petDID, hospitalAddress);
    
    if (!agreement.exists) {
      console.log(`반려동물 ${petDID}에 대한 공유 계약이 없습니다.`);
      return null;
    }
    
    // 공유 계약 정보 포맷팅
    const formattedCreatedAt = formatDate(timestampToDate(agreement.createdAt));
    const formattedExpireDate = formatDate(timestampToDate(agreement.expireDate));
    const now = Date.now() / 1000; // 현재 시간 (초 단위)
    const daysUntilExpire = Math.floor((agreement.expireDate - now) / (60 * 60 * 24));
    const isExpiringSoon = daysUntilExpire <= 7; // 7일 이내 만료 예정
    
    return {
      createdAt: agreement.createdAt,
      expireDate: agreement.expireDate,
      formattedCreatedAt,
      formattedExpireDate,
      isExpiringSoon
    };
  } catch (error) {
    console.error(`공유 계약 정보 조회 중 오류(${petDID}):`, error);
    return null;
  }
};

/**
 * 반려동물 DID 주소로 기본 정보와 공유 계약 정보를 함께 조회합니다.
 * @param petDID 반려동물 DID 주소
 * @param hospitalAddress 병원 주소
 * @returns 기본 정보와 공유 계약 정보가 포함된 반려동물 정보
 */
export const getPetWithAgreementInfo = async (
  petDID: string,
  hospitalAddress: string
): Promise<PetWithAgreement | null> => {
  try {
    // 1. 기본 정보 조회
    const petInfoResult = await getPetBasicInfo(petDID);
    
    if (!petInfoResult.success || !petInfoResult.petInfo) {
      console.error(`반려동물 기본 정보 조회 실패: ${petInfoResult.error}`);
      return null;
    }
    
    // 2. 공유 계약 정보 조회
    const agreementInfo = await getAgreementInfo(petDID, hospitalAddress);
    
    if (!agreementInfo) {
      console.error(`반려동물 공유 계약 정보 조회 실패`);
      return null;
    }
    
    // 3. 나이 계산
    let age = 0;
    if (petInfoResult.petInfo.birth) {
      try {
        const today = new Date();
        const birth = new Date(petInfoResult.petInfo.birth);
        
        if (!isNaN(birth.getTime())) {
          let calculatedAge = today.getFullYear() - birth.getFullYear();
          const monthDiff = today.getMonth() - birth.getMonth();
          
          if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birth.getDate())) {
            calculatedAge--;
          }
          
          age = calculatedAge;
        }
      } catch (error) {
        console.warn('나이 계산 중 오류:', error);
      }
    }
    
    return {
      ...petInfoResult.petInfo,
      petDID,
      age,
      agreementInfo
    };
  } catch (error) {
    console.error(`반려동물 정보 조회 중 오류(${petDID}):`, error);
    return null;
  }
};

/**
 * 반려동물과 공유 계약 정보를 Treatment 형식으로 변환합니다.
 * @param pet 반려동물 정보
 * @param index 인덱스 (ID 생성용)
 * @returns Treatment 형식의 객체
 */
export const convertPetToTreatment = (
  pet: PetWithAgreement,
  index: number
): Treatment => {
  // 성별 처리
  let genderValue = Gender.FEMALE; // 기본값
  if (pet.gender) {
    const genderLower = pet.gender.toLowerCase();
    if (genderLower === 'male' || genderLower === '수컷') {
      genderValue = Gender.MALE;
    }
  }
  
  // 중성화 정보 처리 - 문자열로 통일
  let flagNeuteringValue: string | boolean = false;
  if (typeof pet.flagNeutering === 'boolean') {
    flagNeuteringValue = pet.flagNeutering;
  } else if (typeof pet.flagNeutering === 'string') {
    const lowerValue = pet.flagNeutering.toLowerCase();
    flagNeuteringValue = 
      lowerValue === 'true' || 
      lowerValue === '1' || 
      lowerValue === 'y' || 
      lowerValue === 'yes';
  }
  
  // Treatment 형식으로 변환
  return {
    id: index,
    petId: index,
    petDid: pet.petDID || '',
    state: TreatmentState.WAITING,
    name: pet.name || '이름 없음',
    age: pet.age || 0,
    gender: genderValue,
    breedName: pet.breedName || '품종 정보 없음',
    speciesName: pet.speciesName || '',
    profileUrl: pet.profileUrl || '',
    birth: pet.birth || '',
    flagNeutering: flagNeuteringValue,
    createdAt: new Date(pet.agreementInfo.createdAt * 1000).toISOString(),
    expireDate: new Date(pet.agreementInfo.expireDate * 1000).toISOString(),
    agreementInfo: pet.agreementInfo
  };
};

// 토큰에서 병원 정보 추출하는 함수
const getHospitalInfoFromToken = (token: string): { hospitalName: string; doctorName: string } => {
  try {
    const payloadBase64 = token.split(".")[1];
    const decoded = decodeURIComponent(
      atob(payloadBase64)
        .split("")
        .map((c) => "%" + ("00" + c.charCodeAt(0).toString(16)).slice(-2))
        .join("")
    );
    const payload = JSON.parse(decoded);
    return {
      hospitalName: payload.name || "진료 병원",
      doctorName: payload.doctorName || "담당 수의사"
    };
  } catch (error) {
    console.error("토큰 디코딩 실패", error);
    return {
      hospitalName: "진료 병원",
      doctorName: "담당 수의사"
    };
  }
};

/**
 * JSON 문자열에서 isDeleted가 true인지 빠르게 확인하는 함수 (파싱 없이)
 * @param jsonString JSON 문자열
 * @returns isDeleted가 true인지 여부
 */
const isRecordDeletedFromString = (jsonString: string): boolean => {
  if (!jsonString || typeof jsonString !== 'string') {
    return false;
  }
  
  // "isDeleted":true 패턴 검색 (공백이 있을 수 있음)
  const deletedPattern = /"isDeleted"\s*:\s*true/i;
  return deletedPattern.test(jsonString);
};

/**
 * JSON 문자열에서 특정 키의 값을 안전하게 추출하는 함수 (파싱 없이)
 * @param jsonString JSON 문자열
 * @param key 추출할 키 이름
 * @param defaultValue 기본값
 * @returns 추출된 값 또는 기본값
 */
const extractValueFromJsonString = (
  jsonString: string, 
  key: string, 
  defaultValue: string = ''
): string => {
  if (!jsonString || typeof jsonString !== 'string') {
    return defaultValue;
  }
  
  try {
    // "key":"value" 패턴 검색 (공백이 있을 수 있음)
    const regex = new RegExp(`"${key}"\\s*:\\s*"([^"]*)"`, 'i');
    const match = jsonString.match(regex);
    
    if (match && match[1]) {
      return match[1];
    }
    
    // 숫자 값인 경우를 위한 추가 패턴 (따옴표 없음)
    // "key":123 패턴
    const numRegex = new RegExp(`"${key}"\\s*:\\s*([0-9]+)`, 'i');
    const numMatch = jsonString.match(numRegex);
    
    if (numMatch && numMatch[1]) {
      return numMatch[1];
    }
    
    return defaultValue;
  } catch (error) {
    console.error(`JSON 문자열에서 ${key} 추출 중 오류:`, error);
    return defaultValue;
  }
};

// /**
//  * JSON 문자열을 안전하게 파싱하는 함수
//  * @param jsonString JSON 문자열
//  * @returns 파싱된 객체 또는 기본값
//  */
// const safeJsonParse = (jsonString: string, defaultValue: any = {}): any => {
//   if (!jsonString || typeof jsonString !== 'string') {
//     return defaultValue;
//   }
  
//   try {
//     // 문자열 내용으로 새로운 JSON 문자열 재생성
//     // 이렇게 하면 원본 문자열에 있을 수 있는 특수 문자나 BOM이 제거됨
//     if (jsonString && jsonString.startsWith('{')) {
//       return JSON.parse(jsonString);
//     }
    
//     // 정상적인 JSON이 아니면 기본값 반환
//     return defaultValue;
//   } catch (error) {
//     console.error('JSON 파싱 오류:', error, '원본 문자열:', jsonString);
    
//     // 특정 오류 패턴 처리 시도
//     try {
//       // 큰따옴표 닫기 누락 패턴 찾기
//       let fixedJson = jsonString;
      
//       // 1. "deletedAt":"숫자, 패턴 확인 (마지막 따옴표 누락)
//       const unclosedTimestampPattern = /"deletedAt":"(\d+),/g;
//       if (fixedJson.match(unclosedTimestampPattern)) {
//         fixedJson = fixedJson.replace(unclosedTimestampPattern, '"deletedAt":"$1",');
//       }
      
//       // 2. "deletedAt":"숫자 패턴 확인 (닫는 따옴표와 콤마 누락)
//       const missingQuoteTimestampPattern = /"deletedAt":"(\d+)(\s|,|\})/g;
//       if (fixedJson.match(missingQuoteTimestampPattern)) {
//         fixedJson = fixedJson.replace(missingQuoteTimestampPattern, '"deletedAt":"$1"$2');
//       }
      
//       // 3. "deletedBy":"0x... 패턴 확인 (이더리움 주소의 닫는 따옴표 누락)
//       const missingQuoteAddressPattern = /"deletedBy":"(0x[a-fA-F0-9]+)(\s|,|\})/g;
//       if (fixedJson.match(missingQuoteAddressPattern)) {
//         fixedJson = fixedJson.replace(missingQuoteAddressPattern, '"deletedBy":"$1"$2');
//       }
      
//       // 4. "[수정내역]"를 포함하는 경우 특별히 처리 (notes 필드의 수정 내역 관련 문제)
//       if (fixedJson.includes('[수정내역]')) {
//         // 수정 내역 문자열 패턴은 복잡하므로 문제가 될 수 있는 부분을 단순화
//         fixedJson = fixedJson.replace(/\[수정내역\][^"]*"[^"]*"[^,}]*/g, '수정 기록');
//       }
      
//       // 5. 일반적인 속성 뒤의 닫는 따옴표 누락 패턴
//       const generalMissingQuotePattern = /"([^"]+)":"([^",]*[^",\s])(\s*)(,|\})/g;
//       if (fixedJson.match(generalMissingQuotePattern)) {
//         fixedJson = fixedJson.replace(generalMissingQuotePattern, '"$1":"$2"$3$4');
//       }
      
//       // 6. 마지막 괄호 닫기 확인
//       if (!fixedJson.endsWith('}') && fixedJson.includes('{')) {
//         fixedJson = fixedJson + '}';
//       }
      
//       // 고친 문자열로 다시 시도
//       if (fixedJson !== jsonString) {
//         console.log('JSON 문자열 수정 시도:', fixedJson);
//         return JSON.parse(fixedJson);
//       }
//     } catch (fixError) {
//       console.error('JSON 수정 시도 실패:', fixError);
//     }
    
//     // 파싱에 실패하면 기본값 반환
//     return defaultValue;
//   }
// };

/**
 * JSON 문자열에 처리하기 어려운 패턴이 있는지 확인하는 함수
 * @param jsonString JSON 문자열
 * @returns 처리하기 어려운 패턴이 있으면 true, 없으면 false
 */
const hasTroublesomePattern = (jsonString: string): boolean => {
  if (!jsonString || typeof jsonString !== 'string') {
    return false;
  }
  
  // 수정내역 패턴 확인
  if (jsonString.includes('[수정내역]') && jsonString.includes('\"')) {
    return true;
  }
  // 트러블한 패턴이 없으면 false 반환
  return false;
};

/**
 * 병원에서 진료 취소 처리를 위한 특별 의료기록을 작성합니다.
 * 실제 공유 계약은 취소하지 않고, 특별 의료기록을 추가하여 UI에서 취소 상태를 표시합니다.
 * @param petDID 반려동물 DID 주소
 * @param hospitalAddress 병원 주소
 * @returns 성공 여부와 에러 메시지
 */
export const markAppointmentAsCancelled = async (
  petDID: string,
  hospitalAddress: string,
  cancelReason: string = "병원 측 진료 취소"
): Promise<{ success: boolean; error?: string }> => {
  try {
    // 블록체인 인증 서비스를 통해 계정 연결 및 Registry 컨트랙트 가져오기
    const { getRegistryContract, getSigner } = await import('@/services/blockchainAuthService');
    const contract = await getRegistryContract();
    const signer = await getSigner();
    
    if (!contract || !signer) {
      return { 
        success: false, 
        error: 'MetaMask에 연결할 수 없습니다. 계정 연결 상태를 확인해주세요.'
      };
    }
    
    // 병원 주소가 현재 연결된 계정과 일치하는지 확인
    const currentAddress = await signer.getAddress();
    const normalizedHospitalAddress = hospitalAddress.toLowerCase();
    const normalizedCurrentAddress = currentAddress.toLowerCase();
    
    if (normalizedHospitalAddress !== normalizedCurrentAddress) {
      return {
        success: false,
        error: '진료 취소 처리 권한이 없습니다. 현재 연결된 계정과 병원 주소가 일치하지 않습니다.'
      };
    }
    
    // 공유 계약이 존재하는지 확인
    const agreementInfo = await contract.getAgreementDetails(petDID, hospitalAddress);
    if (!agreementInfo || !agreementInfo.exists) {
      return {
        success: false,
        error: '공유 계약이 존재하지 않습니다.'
      };
    }
    
    // 토큰에서 병원 정보 가져오기
    const accessToken = localStorage.getItem('accessToken');
    const { hospitalName, doctorName } = accessToken 
      ? getHospitalInfoFromToken(accessToken)
      : { hospitalName: "진료 병원", doctorName: "담당 수의사" };
    
    // 특별 의료기록 추가 (진료 취소 표시)
    console.log('진료 취소 의료기록 작성 시도:', { petDID, hospitalAddress });
    
    // "CANCELED" 상태를 가진 특별 의료기록 추가
    const tx = await contract.addMedicalRecord(
      petDID,
      "CANCELED", // 진단명을 "CANCELED"로 설정하여 취소 표시
      hospitalName,
      doctorName,
      cancelReason, // 취소 사유
      "[]", // examinations (빈 배열)
      "[]", // medications (빈 배열)
      "[]", // vaccinations (빈 배열)
      "[]", // pictures (빈 배열)
      "CANCELLED", // status 추가 - 진료 상태를 CANCELLED로 설정
      true, // flagCertificated 추가 - 병원에서 인증된 기록
      { gasLimit: 500000 }
    );
    
    // 트랜잭션 완료 대기
    await tx.wait();
    
    console.log('진료 취소 의료기록 작성 성공:', tx.hash);
    
    return { success: true };
  } catch (error: any) {
    console.error('진료 취소 의료기록 작성 중 오류 발생:', error);
    return { 
      success: false, 
      error: `진료 취소 처리 중 오류가 발생했습니다: ${error.message || '알 수 없는 오류'}`
    };
  }
};

/**
 * 반려동물의 취소 상태를 확인합니다.
 * 가장 최근 의료기록이 취소 기록인지, 취소 이후 새 공유가 있는지 확인합니다.
 * @param petDID 반려동물 DID 주소
 * @param hospitalAddress 병원 주소
 * @returns 취소 상태 정보 (취소됨, 최근 취소 시간, 취소 이후 새 공유 있음)
 */
export const checkCancellationStatus = async (
  petDID: string,
  hospitalAddress: string
): Promise<{ 
  isCancelled: boolean; 
  cancellationTimestamp?: number;
  hasNewSharingAfterCancellation: boolean;
  error?: string;
}> => {
  try {
    // 블록체인 인증 서비스를 통해 계정 연결 및 Registry 컨트랙트 가져오기
    const { getRegistryContract } = await import('@/services/blockchainAuthService');
    const contract = await getRegistryContract();
    
    if (!contract) {
      return { 
        isCancelled: false,
        hasNewSharingAfterCancellation: false,
        error: 'MetaMask에 연결할 수 없습니다.'
      };
    }
    
    // 1. 모든 속성 조회 (의료기록 포함)
    const [names, values, _expireDates] = await contract.getAllAttributes(petDID);
    
    // 2. 의료기록만 필터링 (medical_record로 시작하는 키)
    let latestCancellation: { timestamp: number; recordKey: string } | null = null;
    
    for (let i = 0; i < names.length; i++) {
      const name = names[i];
      const value = values[i];
      
      // 의료기록 키인지 확인
      if (name.startsWith('medical_record_')) {
        try {
          // 삭제된 기록인지 먼저 확인 (파싱 전)
          if (isRecordDeletedFromString(value)) {
            console.log('파싱 전 확인: 삭제된 기록 건너뜀:', name);
            continue;
          }
          
          // 처리하기 어려운 패턴 확인
          if (hasTroublesomePattern(value)) {
            console.log('파싱 전 확인: 문제가 될 수 있는 패턴 감지, 건너뜀:', name);
            continue;
          }
          
          // JSON 파싱 대신 문자열 패턴 매칭으로 진단명과 병원 주소 추출
          const diagnosis = extractValueFromJsonString(value, 'diagnosis', '');
          const recordHospitalAddress = extractValueFromJsonString(value, 'hospitalAddress', '');
          
          // 진단명이 "CANCELED"인 취소 기록인지 확인
          if (diagnosis === "CANCELED" && recordHospitalAddress.toLowerCase() === hospitalAddress.toLowerCase()) {
            // 타임스탬프 추출 (키에서 추출 또는 createdAt 필드에서 추출)
            let timestamp = 0;
            const createdAt = extractValueFromJsonString(value, 'createdAt', '0');
            
            if (createdAt && createdAt !== '0') {
              timestamp = parseInt(createdAt, 10);
            } else {
              // 키에서 타임스탬프 추출 시도
              const parts = name.split('_');
              if (parts.length >= 3) {
                try {
                  timestamp = parseInt(parts[2], 10);
                } catch (e) {
                  timestamp = 0;
                }
              }
            }
            
            // 가장 최근 취소 기록 갱신
            if (!latestCancellation || timestamp > latestCancellation.timestamp) {
              latestCancellation = { timestamp, recordKey: name };
            }
          }
        } catch (e) {
          console.error('의료기록 파싱 오류:', e);
          // 파싱 오류는 무시하고 계속 진행
        }
      }
    }
    
    // 3. 공유 계약 정보 조회
    const [exists, _scope, createdAt, _expireDate] = await contract.getAgreementDetails(petDID, hospitalAddress);
    
    // 4. 취소 이후 새 공유 계약이 생성되었는지 확인
    let hasNewSharingAfterCancellation = false;
    
    if (exists && latestCancellation) {
      // 공유 계약 생성 시간이 취소 시간보다 나중이면 새 계약
      hasNewSharingAfterCancellation = createdAt > latestCancellation.timestamp;
    }
    
    return {
      isCancelled: !!latestCancellation && !hasNewSharingAfterCancellation,
      cancellationTimestamp: latestCancellation?.timestamp,
      hasNewSharingAfterCancellation
    };
    
  } catch (error: any) {
    console.error('취소 상태 확인 중 오류 발생:', error);
    return {
      isCancelled: false,
      hasNewSharingAfterCancellation: false,
      error: `취소 상태 확인 중 오류가 발생했습니다: ${error.message || '알 수 없는 오류'}`
    };
  }
};
