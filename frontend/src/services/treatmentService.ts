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
 */

import { GetTreatmentRequest, TreatmentResponse } from '@/interfaces/treatment';
import { BlockChainRecord, BlockChainRecordResponse } from '@/interfaces/blockChain';
import { request } from '@/services/apiRequest';
import { ApiResponse, ResponseStatus } from '@/types';
import { didRegistryABI } from '@/utils/constants';

// DID 레지스트리 컨트랙트 ABI 정의
export const DID_REGISTRY_ABI = didRegistryABI;

/**
 * 기존 API 호출 방식(백엔드)으로 진료 기록을 조회합니다.
 * @async
 * @function
 * @param {GetTreatmentRequest} data - 치료 정보 요청 객체, 
 * @returns {Promise<ApiResponse<TreatmentResponse>>} 치료 정보 응답 객체
 */
export const getTreatments = async (data: GetTreatmentRequest): Promise<ApiResponse<TreatmentResponse>> => {
  try {
    const response = await request.get<any[]>(
      `/api/hospitals/me/treatments?expired=${data.expired || ""}&state=${data.state || ""}&pet_id=${data.petId || ""}`
    );
    
    // 응답 확인용 로그
    console.log('치료 정보 응답:', response);
    
    // 백엔드 API 응답
    return {
      ...response,
      data: parseTreatmentResponse(response.data || [])
    };
  } catch (error: any) {
    console.error('진료 정보 조회 오류:', error);
    return {
      status: ResponseStatus.FAILURE,
      message: error.message || '진료 정보를 불러오는 중 오류가 발생했습니다.',
      data: { treatments: [] }
    };
  }
};

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
          const recordData = JSON.parse(value);
          
          // timestamp 변환
          let timestamp = 0;
          if (recordData.createdAt) {
            timestamp = Number(recordData.createdAt);
          } else if (recordData.timestamp) {
            timestamp = Number(recordData.timestamp);
          } else {
            timestamp = Date.now();
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
                  const recordData = JSON.parse(value);
                  
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
                        timestamp = Date.now();
                      }
                    } else {
                      timestamp = Date.now();
                    }
                  } else {
                    timestamp = Date.now();
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

    // 블록체인에 기록 작성
    const tx = await contract.setAttribute(
      petDID,
      record.id,
      JSON.stringify(recordData),
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
