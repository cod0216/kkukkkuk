/**
 * @module treatmentService
 * @file treatmentService.ts
 * @author haelim
 * @date 2025-03-26
 * @author seonghun
 * @date 2025-03-28
 * @description Treatment 요청을 처리하는 서비스 모듈입니다.
 *
 * 이 모듈은 병원의 진료 정보를 가져오는 API 요청을 수행합니다.
 *
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-26        haelim           최초 생성
 * 2025-03-28        seonghun         블록체인 서비스 연동
 * 2025-03-31        seonghun         접수일, 만료일 사이 진료기록 존재 여부 반환 함수 생성
 */

import { TreatmentResponse } from '@/interfaces/treatment';
import { BlockChainRecord, BlockChainRecordResponse } from '@/interfaces/blockChain';
import { didRegistryABI } from '@/utils/constants';

// DID 레지스트리 컨트랙트 ABI 정의
export const DID_REGISTRY_ABI = didRegistryABI;

/**
 * API 응답 데이터를 TreatmentResponse 형식으로 변환하는 함수
 * @function
 * @param {any[]} data - 원본 API 응답 데이터
 * @returns {TreatmentResponse} 변환된 치료 응답 객체
 */
export const parseTreatmentResponse = (data: any[]): TreatmentResponse => {
  return {
    treatments: data.map(item => ({
      state: item.state || '',
      id: item.id || 0,
      expireDate: item.expire_date || '',
      createdAt: item.created_at || '',
      petId: item.pet_id || 0,
      petDid: item.pet_did || '',
      name: item.name || '',
      birth: item.birth || '',
      age: item.age || 0,
      gender: item.gender || '',
      flagNeutering: item.flag_neutering || false,
      breedName: item.breed_name || ''
    }))
  };
};

/**
 * JSON 문자열에서 잘못된 제어 문자를 제거하는 함수
 * @param jsonString JSON 문자열
 * @returns 정제된 JSON 문자열
 */
const sanitizeJsonString = (jsonString: string): string => {
  if (!jsonString) return jsonString;
  
  // JSON에서 허용되지 않는 제어 문자 제거 (U+0000에서 U+001F까지)
  let sanitized = jsonString.replace(/[\u0000-\u001F]/g, '');
  
  // 추가 JSON 구문 오류 처리: 문자열 내의 이스케이프되지 않은 인용 부호 처리
  sanitized = sanitized.replace(/([^\\])(")([^,}\]:"'])/g, '$1\\"$3');
  
  // 속성 값 뒤에 올바른 구분자가 오도록 수정
  sanitized = sanitized.replace(/([^,}\]:"'\s])(\s*})(\s*$)/g, '$1$2');
  sanitized = sanitized.replace(/([^,}\]:"'\s])(\s*])(\s*$)/g, '$1$2');
  
  // 중복 쉼표 제거
  sanitized = sanitized.replace(/,\s*,/g, ',');
  
  // 마지막 아이템 뒤의 쉼표 제거 (JSON에서는 허용되지 않음)
  sanitized = sanitized.replace(/,\s*}/g, '}');
  sanitized = sanitized.replace(/,\s*]/g, ']');
  
  // 키와 값 사이에 콜론이 있는지 확인
  sanitized = sanitized.replace(/"([^"]+)"\s*([^:\s])/g, '"$1": $2');
  
  return sanitized;
};

/**
 * JSON 문자열을 안전하게 파싱하는 함수
 * @param jsonString JSON 문자열
 * @returns 파싱된 객체 또는 기본값
 */
const safeJsonParse = (jsonString: string, defaultValue: any = {}): any => {
  try {
    // 문자열 내용으로 새로운 JSON 문자열 재생성
    // 이렇게 하면 원본 문자열에 있을 수 있는 특수 문자나 BOM이 제거됨
    if (jsonString && jsonString.startsWith('{')) {
      return JSON.parse(jsonString);
    }
    
    // 정상적인 JSON이 아니면 기본값 반환
    return defaultValue;
  } catch (error) {
    console.error('JSON 파싱 오류:', error, '원본 문자열:', jsonString);
    // 파싱에 실패하면 기본값 반환
    return defaultValue;
  }
};

/**
 * 객체의 모든 문자열 속성에서 제어 문자를 제거
 * @param obj 정제할 객체
 * @returns 정제된 객체
 */
const sanitizeObject = (obj: any): any => {
  if (!obj) return obj;
  
  if (typeof obj === 'string') {
    return sanitizeJsonString(obj);
  }
  
  if (Array.isArray(obj)) {
    return obj.map(item => sanitizeObject(item));
  }
  
  if (typeof obj === 'object') {
    const result: any = {};
    for (const key in obj) {
      if (Object.prototype.hasOwnProperty.call(obj, key)) {
        result[key] = sanitizeObject(obj[key]);
      }
    }
    return result;
  }
  
  return obj;
};

/**
 * 블록체인에서 진료 기록을 조회하는 서비스
 * @param petDID 반려동물 DID 주소
 * @param didRegistryAddress DID 레지스트리 컨트랙트 주소
 * @returns 조회된 진료 기록 데이터
 */
export const getBlockchainTreatments = async (petDID: string, didRegistryAddress: string): Promise<BlockChainRecordResponse> => {
  // 필수 파라미터 확인
  if (!petDID || !didRegistryAddress) {
    console.error('필수 파라미터가 누락되었습니다:', { petDID, didRegistryAddress });
    return { 
      success: false, 
      error: '필수 파라미터(petDID 또는 didRegistryAddress)가 누락되었습니다.',
      treatments: [] 
    };
  }

  try {
    // 블록체인 인증 서비스를 통해 계정 연결 및 Provider, Registry 컨트랙트 가져오기
    const { getRegistryContract, getSigner } = await import('@/services/blockchainAuthService');
    const contract = await getRegistryContract();
    const signer = await getSigner();
    
    if (!contract || !signer) {
      return { 
        success: false, 
        error: 'MetaMask에 연결할 수 없습니다. 계정 연결 상태를 확인해주세요.',
        treatments: [] 
      };
    }
    
    console.log('블록체인 연결 시도:', { petDID, didRegistryAddress });
    
    // 반려동물 존재 여부 확인
    const exists = await contract.petExists(petDID);
    if (!exists) {
      console.error('등록되지 않은 반려동물입니다.');
      return { 
        success: false, 
        error: '등록되지 않은 반려동물입니다.',
        treatments: [] 
      };
    }
    
    // 접근 권한 확인
    const currentUserAddress = await signer.getAddress();
    const accessGranted = await contract.hasAccess(petDID, currentUserAddress);
    
    if (!accessGranted) {
      console.error('이 반려동물 정보에 접근할 권한이 없습니다.');
      return { 
        success: false, 
        error: '이 반려동물 정보에 접근할 권한이 없습니다.',
        treatments: [] 
      };
    }
    
    // 모든 속성 조회
    const [names, values, expireDates] = await contract.getAllAttributes(petDID);
    console.log('블록체인 데이터 조회 성공:', { namesCount: names.length });
    
    // 의료기록만 필터링
    const treatments: BlockChainRecord[] = [];
    
    for (let i = 0; i < names.length; i++) {
      const name = names[i];
      const value = values[i];
      const expireDate = expireDates[i];
      
      if (name.startsWith('medical_record_') || name.startsWith('medical_')) {
        try {
          // 안전한 JSON 파싱 사용
          const recordData = safeJsonParse(value, {
            diagnosis: '진단 정보 없음',
            doctorName: '의사 정보 없음',
            hospitalName: '병원 정보 없음',
            hospitalAddress: '병원 주소 없음',
            isDeleted: false,
            treatments: {
              examinations: [],
              medications: [],
              vaccinations: []
            },
            notes: '',
            pictures: []
          });
          
          // timestamp 변환
          let timestamp = 0;
          if (recordData.createdAt) {
            timestamp = Number(recordData.createdAt);
          } else if (recordData.timestamp) {
            timestamp = Number(recordData.timestamp);
          } else if (name.startsWith('medical_record_')) {
            // medical_record_TIMESTAMP_ADDRESS 형식에서 타임스탬프 추출
            const parts = name.split('_');
            if (parts.length >= 3) {
              try {
                timestamp = Number(parts[2]);
              } catch (e) {
                timestamp = 0;
              }
            }
          }
          
          const treatment: BlockChainRecord = {
            id: name,
            timestamp: timestamp,
            diagnosis: recordData.diagnosis || '진단 정보 없음',
            doctorName: recordData.doctorName || '의사 정보 없음',
            hospitalName: recordData.hospitalName || '병원 정보 없음',
            hospitalAddress: recordData.hospitalAddress || '병원 주소 없음',
            isDeleted: recordData.isDeleted || false,
            expireDate: Number(expireDate),
            createdAt: formatDate(timestamp),
            treatments: recordData.treatments || {
              examinations: [],
              medications: [],
              vaccinations: []
            },
            notes: recordData.notes || '',
            pictures: recordData.pictures || []
          };
          
          treatments.push(treatment);
        } catch (error) {
          console.error('의료 기록 파싱 오류:', error);
        }
      }
    }
    
    return { success: true, treatments };
  } catch (error: any) {
    console.error('진료기록 조회 중 오류가 발생했습니다:', error.message || error);
    return { 
      success: false, 
      error: `진료기록 조회 중 오류가 발생했습니다: ${error.message || '알 수 없는 오류'}`,
      treatments: [] 
    };
  }
};

/**
 * 병원(현재 계정)이 접근 가능한 반려동물 목록을 가져오고 각 반려동물의 진료기록을 조회합니다.
 * @param didRegistryAddress DID 레지스트리 컨트랙트 주소
 * @returns 병원이 접근 가능한 반려동물 목록과 진료 기록 데이터
 */
export const getHospitalPetsWithRecords = async (didRegistryAddress: string): Promise<{
  success: boolean;
  error?: string;
  pets: {
    petDID: string;
    name: string;
    birth?: string;
    gender?: string;
    breed?: string;
    records: BlockChainRecord[];
  }[];
}> => {
  // 필수 파라미터 확인
  if (!didRegistryAddress) {
    console.error('필수 파라미터가 누락되었습니다:', { didRegistryAddress });
    return { 
      success: false, 
      error: 'DID 레지스트리 주소가 누락되었습니다.',
      pets: [] 
    };
  }

  try {
    // 블록체인 인증 서비스를 통해 계정 연결 및 Provider, Signer, 계약 가져오기
    const { getSigner, getProvider, getRegistryContract, getContractAddresses } = await import('@/services/blockchainAuthService');
    const provider = await getProvider();
    const signer = await getSigner();
    const registryContract = await getRegistryContract();
    const contractAddresses = getContractAddresses();
    
    if (!provider || !signer || !registryContract) {
      return {
        success: false,
        error: 'MetaMask에 연결할 수 없습니다. 계정 연결 상태를 확인해주세요.',
        pets: []
      };
    }
    
    console.log('블록체인 연결 시도:', { didRegistryAddress });
    const currentUserAddress = await signer.getAddress();
    
    try {
      // 레지스트리 컨트랙트 사용하여 병원이 권한을 가진 반려동물 목록 조회
      console.log('레지스트리 컨트랙트 인스턴스:', registryContract ? '존재함' : '없음');
      console.log('레지스트리 컨트랙트 주소:', contractAddresses.didRegistry);
      console.log('계정 주소:', currentUserAddress);
      
      // 레지스트리 컨트랙트에서 병원이 권한을 가진 반려동물 목록 조회
      console.log('레지스트리 컨트랙트에서 getHospitalPets 호출', { currentUserAddress });
      
      // 함수의 존재 여부를 자세히 확인
      try {
        const fnDesc = registryContract.interface.getFunction('getHospitalPets');
        console.log('레지스트리 함수 설명:', fnDesc);
      } catch (e) {
        console.error('레지스트리 함수 정보 조회 실패:', e);
        return {
          success: false,
          error: '컨트랙트 함수를 찾을 수 없습니다.',
          pets: []
        };
      }
      
      // 병원이 권한을 가진 반려동물 주소 목록 가져오기
      const petAddresses = await registryContract.getHospitalPets(currentUserAddress);
      
      if (!petAddresses || petAddresses.length === 0) {
        console.warn('접근 가능한 반려동물이 없습니다.');
        return { 
          success: true, 
          pets: [] 
        };
      }
      
      console.log('조회된 반려동물 주소:', petAddresses);
      
      // 각 반려동물의 진료 기록 조회
      const petsWithRecords = await Promise.all(
        petAddresses.map(async (petDID: string) => {
          try {
            // 각 반려동물의 속성 정보 조회
            const [names, values, expireDates] = await registryContract.getAllAttributes(petDID);
            
            // 반려동물 기본 정보 추출
            const petAttributes: {[key: string]: string} = {};
            for (let i = 0; i < names.length; i++) {
              if (["name", "gender", "breedName", "birth", "flagNeutering"].includes(names[i])) {
                petAttributes[names[i]] = values[i];
              }
            }
            
            // 각 반려동물의 진료 기록 필터링
            const records: BlockChainRecord[] = [];
            for (let i = 0; i < names.length; i++) {
              const name = names[i];
              const value = values[i];
              const expireDate = expireDates[i];
              
              if (name.startsWith('medical_record_') || name.startsWith('medical_')) {
                try {
                  // 안전한 JSON 파싱 사용
                  const recordData = safeJsonParse(value, {
                    diagnosis: '진단 정보 없음',
                    doctorName: '의사 정보 없음',
                    hospitalName: '병원 정보 없음',
                    hospitalAddress: '병원 주소 없음',
                    isDeleted: false,
                    treatments: {
                      examinations: [],
                      medications: [],
                      vaccinations: []
                    },
                    notes: '',
                    pictures: []
                  });
                  
                  // timestamp 변환
                  let timestamp = 0;
                  if (recordData.createdAt) {
                    timestamp = Number(recordData.createdAt);
                  } else if (recordData.timestamp) {
                    timestamp = Number(recordData.timestamp);
                  } else if (name.startsWith('medical_record_')) {
                    // medical_record_TIMESTAMP_ADDRESS 형식에서 타임스탬프 추출
                    const parts = name.split('_');
                    if (parts.length >= 3) {
                      try {
                        timestamp = Number(parts[2]);
                      } catch (e) {
                        timestamp = 0;
                      }
                    }
                  }
                  
                  const record: BlockChainRecord = {
                    id: name,
                    timestamp: timestamp,
                    diagnosis: recordData.diagnosis || '진단 정보 없음',
                    doctorName: recordData.doctorName || '의사 정보 없음',
                    hospitalName: recordData.hospitalName || '병원 정보 없음',
                    hospitalAddress: recordData.hospitalAddress || '병원 주소 없음',
                    isDeleted: recordData.isDeleted || false,
                    expireDate: Number(expireDate),
                    createdAt: formatDate(timestamp),
                    treatments: recordData.treatments || {
                      examinations: [],
                      medications: [],
                      vaccinations: []
                    },
                    notes: recordData.notes || '',
                    pictures: recordData.pictures || []
                  };
                  
                  records.push(record);
                } catch (error) {
                  console.error('의료 기록 파싱 오류:', error);
                }
              }
            }
            
            return {
              petDID,
              name: petAttributes.name || '이름 없음',
              birth: petAttributes.birth,
              gender: petAttributes.gender,
              breed: petAttributes.breedName,
              records
            };
          } catch (error) {
            console.error(`${petDID} 정보 조회 중 오류:`, error);
            return {
              petDID,
              name: '정보 조회 실패',
              records: []
            };
          }
        })
      );
      
      return { 
        success: true, 
        pets: petsWithRecords.filter(pet => pet !== null)
      };
    } catch (contractError: any) {
      console.error('컨트랙트 호출 오류:', contractError);
      return {
        success: false,
        error: `컨트랙트 호출 오류: ${contractError.message || '알 수 없는 오류'}`,
        pets: []
      };
    }
  } catch (error: any) {
    console.error('반려동물 목록 조회 중 오류가 발생했습니다:', error.message || error);
    return { 
      success: false, 
      error: `반려동물 목록 조회 중 오류가 발생했습니다: ${error.message || '알 수 없는 오류'}`,
      pets: [] 
    };
  }
};

/**
 * 날짜 포맷 함수
 * @param timestamp 타임스탬프
 * @returns 포맷된 날짜 문자열
 */
const formatDate = (timestamp: number): string => {
  try {
    const date = new Date(timestamp);
    return date.toLocaleString('ko-KR', {
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
      hour: '2-digit',
      minute: '2-digit'
    });
  } catch {
    return '날짜 정보 없음';
  }
};

/**
 * 블록체인에 진료 기록을 작성하는 서비스
 * @param petDID 반려동물 DID 주소
 * @param record 작성할 진료 기록 데이터
 * @returns 성공 여부와 에러 메시지
 */
export const createBlockchainTreatment = async (
  petDID: string,
  record: BlockChainRecord
): Promise<{ success: boolean; error?: string }> => {
  try {
    // 블록체인 인증 서비스를 통해 계정 연결 및 Provider, Registry 컨트랙트 가져오기
    const { getRegistryContract, getSigner } = await import('@/services/blockchainAuthService');
    const contract = await getRegistryContract();
    const signer = await getSigner();
    
    if (!contract || !signer) {
      return { 
        success: false, 
        error: 'MetaMask에 연결할 수 없습니다. 계정 연결 상태를 확인해주세요.' 
      };
    }

    // 반려동물 존재 여부 확인
    const exists = await contract.petExists(petDID);
    if (!exists) {
      return { 
        success: false, 
        error: '등록되지 않은 반려동물입니다.' 
      };
    }

    // 접근 권한 확인
    const currentUserAddress = await signer.getAddress();
    const accessGranted = await contract.hasAccess(petDID, currentUserAddress);
    
    if (!accessGranted) {
      return { 
        success: false, 
        error: '이 반려동물 정보에 접근할 권한이 없습니다.' 
      };
    }

    // 진료 기록 데이터 준비
    const recordData = {
      diagnosis: record.diagnosis,
      doctorName: record.doctorName,
      hospitalName: record.hospitalName,
      hospitalAddress: record.hospitalAddress,
      isDeleted: record.isDeleted,
      treatments: record.treatments,
      notes: record.notes,
      pictures: record.pictures
    };

    // 데이터 정제 후 블록체인에 기록 작성
    const sanitizedRecordData = sanitizeObject(recordData);
    const tx = await contract.setAttribute(
      petDID,
      record.id,
      JSON.stringify(sanitizedRecordData),
      record.expireDate,
      { gasLimit: 500000 }
    );

    // 트랜잭션 완료 대기
    await tx.wait();
    
    console.log('진료 기록 작성 성공:', tx.hash);
    return { success: true };
  } catch (error: any) {
    console.error('진료 기록 작성 중 오류 발생:', error);
    return { 
      success: false, 
      error: `진료 기록 작성 중 오류가 발생했습니다: ${error.message || '알 수 없는 오류'}` 
    };
  }
};

/**
 * 블록체인에서 반려동물의 기본 속성 정보를 조회합니다.
 * @param petDID 반려동물 DID 주소
 * @returns 반려동물의 기본 정보 (이름, 성별, 출생일, 중성화 여부, 품종)
 */
export const getPetBasicInfo = async (petDID: string): Promise<{
  success: boolean;
  error?: string;
  petInfo?: {
    name: string;
    gender: string;
    birth: string;
    flagNeutering: boolean | string;
    breedName: string;
  };
}> => {
  // 필수 파라미터 확인
  if (!petDID) {
    console.error('필수 파라미터가 누락되었습니다:', { petDID });
    return { 
      success: false, 
      error: '반려동물 DID 주소가 누락되었습니다.'
    };
  }

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
    
    // 반려동물 존재 여부 확인
    const exists = await contract.petExists(petDID);
    if (!exists) {
      return { 
        success: false, 
        error: '등록되지 않은 반려동물입니다.'
      };
    }
    
    // 접근 권한 확인
    const currentUserAddress = await signer.getAddress();
    const accessGranted = await contract.hasAccess(petDID, currentUserAddress);
    
    if (!accessGranted) {
      return { 
        success: false, 
        error: '이 반려동물 정보에 접근할 권한이 없습니다.'
      };
    }
    
    // 모든 속성 조회
    const [names, values, _expireDates] = await contract.getAllAttributes(petDID);
    // console.log('반려동물 기본 정보 조회 성공:', { namesCount: names.length });
    
    // 기본 속성 정보만 필터링
    const petAttributes: {[key: string]: any} = {
      name: '이름 없음',
      gender: '성별 정보 없음',
      birth: '출생일 정보 없음',
      flagNeutering: 'false',
      breedName: '품종 정보 없음'
    };
    
    for (let i = 0; i < names.length; i++) {
      const name = names[i];
      const value = values[i];
      
      if (name === 'name') {
        petAttributes.name = value;
      } else if (name === 'gender') {
        petAttributes.gender = value;
      } else if (name === 'birth') {
        petAttributes.birth = value;
      } else if (name === 'flagNeutering') {
        // PetMedicalRecord.tsx와 동일한 방식으로 중성화 정보 처리
        // 문자열 그대로 저장 (표시 시에 해석)
        petAttributes.flagNeutering = value;
      } else if (name === 'breedName') {
        petAttributes.breedName = value;
      }
    }
    
    return { 
      success: true, 
      petInfo: {
        name: petAttributes.name,
        gender: petAttributes.gender,
        birth: petAttributes.birth,
        flagNeutering: petAttributes.flagNeutering,
        breedName: petAttributes.breedName
      }
    };
  } catch (error: any) {
    console.error('반려동물 기본 정보 조회 중 오류가 발생했습니다:', error.message || error);
    return { 
      success: false, 
      error: `반려동물 기본 정보 조회 중 오류가 발생했습니다: ${error.message || '알 수 없는 오류'}`
    };
  }
};

/**
 * 접수일자와 만료일 사이에 기록된 진료기록이 있는지 확인합니다.
 * @param petDID 반려동물 DID 주소
 * @param createdAt 접수일자 (유닉스 타임스탬프)
 * @param expireDate 만료일자 (유닉스 타임스탬프)
 * @returns 진료기록 존재 여부
 */
export const hasTreatmentRecords = async (
  petDID: string,
  createdAt: number,
  expireDate: number
): Promise<{ success: boolean; hasTreatment: boolean; error?: string }> => {
  try {
    // 블록체인 인증 서비스를 통해 계정 연결 및 Registry 컨트랙트 가져오기
    const { getRegistryContract, getSigner } = await import('@/services/blockchainAuthService');
    const contract = await getRegistryContract();
    const signer = await getSigner();
    
    if (!contract || !signer) {
      return { 
        success: false, 
        hasTreatment: false,
        error: 'MetaMask에 연결할 수 없습니다. 계정 연결 상태를 확인해주세요.'
      };
    }
    
    // 반려동물 존재 여부 확인
    const exists = await contract.petExists(petDID);
    if (!exists) {
      return { 
        success: false, 
        hasTreatment: false,
        error: '등록되지 않은 반려동물입니다.'
      };
    }
    
    // 접근 권한 확인
    const currentUserAddress = await signer.getAddress();
    const accessGranted = await contract.hasAccess(petDID, currentUserAddress);
    
    if (!accessGranted) {
      return { 
        success: false, 
        hasTreatment: false,
        error: '이 반려동물 정보에 접근할 권한이 없습니다.'
      };
    }
    
    // 모든 속성 조회
    const [names, values, _expireDates] = await contract.getAllAttributes(petDID);
    
    // 의료기록만 필터링하여 접수일자와 만료일 사이에 기록된 진료기록이 있는지 확인
    for (let i = 0; i < names.length; i++) {
      const name = names[i];
      const value = values[i];
      
      if (name.startsWith('medical_record_') || name.startsWith('medical_')) {
        try {
          // 안전한 JSON 파싱 사용
          const recordData = safeJsonParse(value, {
            timestamp: 0,
            createdAt: '',
            isDeleted: false,
            notes: ''
          });
          
          // timestamp 변환
          let timestamp = 0;
          if (recordData.createdAt) {
            timestamp = Number(recordData.createdAt);
          } else if (recordData.timestamp) {
            timestamp = Number(recordData.timestamp);
          } else if (name.startsWith('medical_record_')) {
            // medical_record_TIMESTAMP_ADDRESS 형식에서 타임스탬프 추출
            const parts = name.split('_');
            if (parts.length >= 3) {
              try {
                timestamp = Number(parts[2]);
              } catch (e) {
                timestamp = 0;
              }
            }
          }
          
          // 접수일자와 만료일 사이에 기록된 진료기록인지 확인
          if (timestamp >= createdAt && timestamp <= expireDate) {
            // 삭제된 진료기록은 제외
            if (!recordData.isDeleted) {
              return { success: true, hasTreatment: true };
            }
          }
        } catch (error) {
          console.error('의료 기록 파싱 오류:', error);
        }
      }
    }
    
    // 진료기록이 없는 경우
    return { success: true, hasTreatment: false };
  } catch (error: any) {
    console.error('진료기록 확인 중 오류가 발생했습니다:', error.message || error);
    return { 
      success: false, 
      hasTreatment: false,
      error: `진료기록 확인 중 오류가 발생했습니다: ${error.message || '알 수 없는 오류'}`
    };
  }
};

/**
 * 가장 최근 진료 기록의 상태를 조회합니다.
 * @param petDid 반려동물 DID
 * @returns 최근 진료 상태 정보
 */
export const getLatestTreatmentStatus = async (petDid: string): Promise<{
  success: boolean;
  status: 'ongoing' | 'completed' | null;
  message?: string;
}> => {
  try {
    // 블록체인 인증 서비스를 통해 계정 연결 및 Registry 컨트랙트 가져오기
    const { getRegistryContract, getSigner } = await import('@/services/blockchainAuthService');
    const contract = await getRegistryContract();
    const signer = await getSigner();
    
    if (!contract || !signer) {
      return { 
        success: false, 
        status: null,
        message: 'MetaMask에 연결할 수 없습니다.'
      };
    }
    
    // 반려동물 존재 여부 확인
    const exists = await contract.petExists(petDid);
    if (!exists) {
      return { 
        success: false, 
        status: null,
        message: '등록되지 않은 반려동물입니다.'
      };
    }
    
    // 접근 권한 확인
    const currentUserAddress = await signer.getAddress();
    const accessGranted = await contract.hasAccess(petDid, currentUserAddress);
    
    if (!accessGranted) {
      return { 
        success: false, 
        status: null,
        message: '이 반려동물 정보에 접근할 권한이 없습니다.'
      };
    }
    
    // 모든 속성 조회
    const [names, values, _expireDates] = await contract.getAllAttributes(petDid);
    
    // 최신 진료 기록 찾기
    let latestRecord: any = null;
    let latestTimestamp = 0;
    
    for (let i = 0; i < names.length; i++) {
      const name = names[i];
      const value = values[i];
      
      if (name.startsWith('medical_record_') || name.startsWith('medical_')) {
        try {
          // 안전한 JSON 파싱 사용
          const recordData = safeJsonParse(value, {
            timestamp: 0,
            createdAt: '',
            isDeleted: false,
            notes: ''
          });
          
          // timestamp 변환
          let timestamp = 0;
          if (recordData.createdAt) {
            timestamp = Number(recordData.createdAt);
          } else if (recordData.timestamp) {
            timestamp = Number(recordData.timestamp);
          } else if (name.startsWith('medical_record_')) {
            // medical_record_TIMESTAMP_ADDRESS 형식에서 타임스탬프 추출
            const parts = name.split('_');
            if (parts.length >= 3) {
              try {
                timestamp = Number(parts[2]);
              } catch (e) {
                timestamp = 0;
              }
            }
          }
          
          // 최신 기록인지 확인
          if (timestamp > latestTimestamp && !recordData.isDeleted) {
            latestTimestamp = timestamp;
            latestRecord = recordData;
          }
        } catch (error) {
          console.error('의료 기록 파싱 오류:', error);
        }
      }
    }
    
    // 진료 기록이 없는 경우
    if (!latestRecord) {
      return { 
        success: true, 
        status: null,
        message: '진료 기록이 없습니다.'
      };
    }
    
    // notes 필드를 통해 최종 진료 여부 확인
    const notesLower = (latestRecord.notes || '').toLowerCase();
    const isCompleted = 
      notesLower.includes('[최종진료]') ||
      notesLower.includes('[final]') ||
      notesLower.includes('[완료]') ||
      notesLower.includes('[complete]') ||
      notesLower.includes('[치료완료]') ||
      notesLower.includes('[treatment completed]') ||
      notesLower.includes('최종 진료') ||
      notesLower.includes('마지막 진료');
    
    return {
      success: true,
      status: isCompleted ? 'completed' : 'ongoing',
      message: `최근 진료 상태: ${isCompleted ? '완료됨' : '진행 중'}`
    };
  } catch (error: any) {
    console.error('최근 진료 상태 조회 중 오류:', error);
    return {
      success: false,
      status: null,
      message: '진료 상태 조회 중 오류가 발생했습니다: ' + (error.message || '')
    };
  }
};

/**
 * 블록체인에 저장된 진료 기록의 변경 사항을 확인하는 함수
 * @param originalRecord 원본 진료 기록
 * @param updatedRecord 수정된 진료 기록
 * @returns 변경된 내용을 설명하는 문자열 배열
 */
export const getRecordChanges = (
  originalRecord: BlockChainRecord,
  updatedRecord: BlockChainRecord
): string[] => {
  const changes: string[] = [];
  
  // 진단명 변경 확인
  if (originalRecord.diagnosis !== updatedRecord.diagnosis) {
    changes.push(`진단명: "${originalRecord.diagnosis}" → "${updatedRecord.diagnosis}"`);
  }
  
  // 담당의 변경 확인
  if (originalRecord.doctorName !== updatedRecord.doctorName) {
    changes.push(`담당의: "${originalRecord.doctorName}" → "${updatedRecord.doctorName}"`);
  }
  
  // 최종 진료 상태 변경 확인
  const wasFinalized = originalRecord.notes?.includes('[최종진료]') || false;
  const isFinalized = updatedRecord.notes?.includes('[최종진료]') || false;
  if (wasFinalized !== isFinalized) {
    changes.push(isFinalized ? '최종 진료로 표시' : '최종 진료 표시 해제');
  }
  
  // 노트 내용 변경 확인 (최종 진료 표시 제외)
  const originalNotesContent = originalRecord.notes?.replace(/\[최종진료\]\s*/g, '') || '';
  const newNotesContent = updatedRecord.notes?.replace(/\[최종진료\]\s*/g, '') || '';
  if (originalNotesContent !== newNotesContent) {
    changes.push('진료 노트 수정');
  }
  
  // 처방 변경 확인
  const originalExams = JSON.stringify(originalRecord.treatments?.examinations || []);
  const newExams = JSON.stringify(updatedRecord.treatments?.examinations || []);
  if (originalExams !== newExams) {
    changes.push('검사 정보 수정');
  }
  
  const originalMeds = JSON.stringify(originalRecord.treatments?.medications || []);
  const newMeds = JSON.stringify(updatedRecord.treatments?.medications || []);
  if (originalMeds !== newMeds) {
    changes.push('약물 정보 수정');
  }
  
  const originalVacs = JSON.stringify(originalRecord.treatments?.vaccinations || []);
  const newVacs = JSON.stringify(updatedRecord.treatments?.vaccinations || []);
  if (originalVacs !== newVacs) {
    changes.push('접종 정보 수정');
  }
  
  // 사진 변경 확인
  const originalPics = JSON.stringify(originalRecord.pictures || []);
  const newPics = JSON.stringify(updatedRecord.pictures || []);
  if (originalPics !== newPics) {
    if ((originalRecord.pictures || []).length < (updatedRecord.pictures || []).length) {
      changes.push('사진 추가');
    } else if ((originalRecord.pictures || []).length > (updatedRecord.pictures || []).length) {
      changes.push('사진 삭제');
    } else {
      changes.push('사진 수정');
    }
  }
  
  return changes;
};

/**
 * 블록체인에 저장된 진료 기록을 수정하는 함수
 * @param petDID 반려동물 DID 주소
 * @param updatedRecord 수정된 진료 기록
 * @param changes 변경 내역 설명 배열 (비어있으면 자동으로 계산됨)
 * @returns 성공 여부와 오류 메시지, 성공 시 새 기록 ID
 */
export const updateBlockchainTreatment = async (
  petDID: string,
  updatedRecord: BlockChainRecord,
  changes: string[] = []
): Promise<{ success: boolean; error?: string; newRecordId?: string }> => {
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
    
    // 반려동물 존재 여부 확인
    const exists = await contract.petExists(petDID);
    if (!exists) {
      return { 
        success: false, 
        error: '등록되지 않은 반려동물입니다.'
      };
    }
    
    // 접근 권한 확인
    const currentUserAddress = await signer.getAddress();
    const accessGranted = await contract.hasAccess(petDID, currentUserAddress);
    
    if (!accessGranted) {
      return { 
        success: false, 
        error: '이 반려동물 정보에 접근할 권한이 없습니다.'
      };
    }
    
    // 원본 기록 ID 확인
    const previousRecordKey = updatedRecord.id;
    if (!previousRecordKey) {
      return {
        success: false,
        error: '원본 기록 ID가 없습니다.'
      };
    }
    
    // 원본 기록 가져오기
    const [originalValue, _expireDate] = await contract.getAttribute(petDID, previousRecordKey);
    if (!originalValue) {
      return {
        success: false,
        error: '해당 기록을 찾을 수 없습니다.'
      };
    }
    
    // 원본 기록 파싱
    let originalRecord;
    try {
      // 안전한 JSON 파싱 사용
      originalRecord = safeJsonParse(originalValue, {
        id: previousRecordKey,
        timestamp: updatedRecord.timestamp,
        diagnosis: '',
        doctorName: '',
        hospitalName: '',
        hospitalAddress: '',
        isDeleted: false,
        createdAt: '',
        treatments: {
          examinations: [],
          medications: [],
          vaccinations: []
        },
        notes: '',
        pictures: []
      });
      
      // BlockChainRecord 인터페이스에 맞게 형식 변환
      originalRecord = {
        id: previousRecordKey,
        timestamp: originalRecord.timestamp || updatedRecord.timestamp,
        diagnosis: originalRecord.diagnosis || '',
        doctorName: originalRecord.doctorName || '',
        hospitalName: originalRecord.hospitalName || '',
        hospitalAddress: originalRecord.hospitalAddress || '',
        isDeleted: originalRecord.isDeleted || false,
        createdAt: originalRecord.createdAt || '',
        treatments: originalRecord.treatments || {
          examinations: [],
          medications: [],
          vaccinations: []
        },
        notes: originalRecord.notes || '',
        pictures: originalRecord.pictures || []
      };
    } catch (error) {
      return {
        success: false,
        error: '기록 데이터 파싱 오류'
      };
    }
    
    // 변경 사항 자동 계산 (changes 파라미터가 비어있는 경우)
    if (changes.length === 0) {
      changes = getRecordChanges(originalRecord, updatedRecord);
      
      if (changes.length === 0) {
        return {
          success: false,
          error: '변경된 내용이 없습니다.'
        };
      }
    }
    
    // 현재 timestamp로 새 레코드의 ID 생성
    const timestamp = Math.floor(Date.now() / 1000);
    const newRecordKey = `medical_${timestamp}_${(updatedRecord.doctorName || '').replace(/\s+/g, '_')}`;
    
    // 노트에 수정 내역 추가
    const changeLog = `[수정내역] ${changes.join(', ')}`;
    const updatedNotes = updatedRecord.notes ? `${updatedRecord.notes}\n\n${changeLog}` : changeLog;
    
    // 정제된 노트 내용 생성
    const sanitizedNotes = sanitizeObject(updatedNotes);
    
    // JSON 형식으로 변환할 배열 생성 (약물, 검사, 접종)
    const sanitizedTreatments = sanitizeObject(updatedRecord.treatments || { examinations: [], medications: [], vaccinations: [] });
    const sanitizedPictures = sanitizeObject(updatedRecord.pictures || []);
    
    // 각 항목의 기본값 설정 및 엄격한 검증
    const examinationsJson = JSON.stringify(sanitizedTreatments.examinations || []);
    const medicationsJson = JSON.stringify(sanitizedTreatments.medications || []);
    const vaccinationsJson = JSON.stringify(sanitizedTreatments.vaccinations || []);
    const picturesJson = JSON.stringify(sanitizedPictures || []);
    
    console.log('새 진료 기록 ID:', newRecordKey);
    console.log('트랜잭션 데이터 검증:', {
      petDID,
      previousRecordKey,
      diagnosis: sanitizeObject(updatedRecord.diagnosis || ''),
      hospitalName: sanitizeObject(updatedRecord.hospitalName || ''),
      doctorName: sanitizeObject(updatedRecord.doctorName || ''),
      notesLength: sanitizedNotes ? sanitizedNotes.length : 0,
      examinationsLength: examinationsJson.length,
      medicationsLength: medicationsJson.length,
      vaccinationsLength: vaccinationsJson.length,
      picturesLength: picturesJson.length
    });
    
    try {
      // appendMedicalRecord 함수 호출하여 이전 기록을 참조하는 새 기록 생성
      const tx = await contract.appendMedicalRecord(
        petDID,
        previousRecordKey,
        sanitizeObject(updatedRecord.diagnosis || ''),
        sanitizeObject(updatedRecord.hospitalName || ''),
        sanitizeObject(updatedRecord.doctorName || ''),
        sanitizedNotes || '',
        examinationsJson || '[]',
        medicationsJson || '[]',
        vaccinationsJson || '[]',
        picturesJson || '[]',
        { gasLimit: 800000 }  // 가스 한도 증가
      );
      
      // 트랜잭션 완료 대기
      const receipt = await tx.wait();
      
      // 트랜잭션 상태 확인
      if (receipt.status === 0) {
        console.error('트랜잭션이 실패했습니다:', receipt);
        return {
          success: false,
          error: '블록체인 트랜잭션이 실패했습니다. 가스 한도나 네트워크 상태를 확인해주세요.'
        };
      }
      
      // 이벤트 로그에서 새 레코드 ID 찾기
      let actualRecordId = newRecordKey;
      try {
        // MedicalRecordAdded 이벤트 찾기
        const medicalRecordAddedEvent = receipt.events?.find(
          (event: any) => event.event === 'MedicalRecordAdded'
        );
        
        if (medicalRecordAddedEvent && medicalRecordAddedEvent.args) {
          // 이벤트의 두 번째 인자가 새 레코드 ID (recordKey)
          actualRecordId = medicalRecordAddedEvent.args[1];
          console.log('이벤트에서 찾은 레코드 ID:', actualRecordId);
        }
      } catch (error) {
        console.warn('새 레코드 ID를 이벤트에서 찾지 못했습니다:', error);
      }
      
      return {
        success: true,
        newRecordId: actualRecordId
      };
    } catch (error: any) {
      console.error('진료 기록 수정 중 오류:', error);
      
      // 오류 메시지 개선
      let errorMessage = error.message || '진료 기록 수정 중 오류가 발생했습니다.';
      
      // 가스 부족 오류
      if (errorMessage.includes('out of gas')) {
        errorMessage = '트랜잭션 가스가 부족합니다. 데이터가 너무 큽니다.';
      }
      // 트랜잭션 거부 오류
      else if (errorMessage.includes('reverted')) {
        errorMessage = '트랜잭션이 블록체인에서 거부되었습니다.';
      }
      
      return {
        success: false,
        error: errorMessage
      };
    }
  } catch (error: any) {
    console.error('진료 기록 수정 준비 중 오류:', error);
    return {
      success: false,
      error: error.message || '진료 기록 수정 준비 중 오류가 발생했습니다.'
    };
  }
};

export default {
  getBlockchainTreatments,
  getHospitalPetsWithRecords,
  createBlockchainTreatment,
  getPetBasicInfo,
  hasTreatmentRecords,
  getLatestTreatmentStatus,
  updateBlockchainTreatment
};
