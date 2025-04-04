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
 * 2025-04-02        seonghun         트랜잭션 가스비 한도 300,000,000으로 변경, 업로드전 데이터 크기 경고 및 최적화 기능 추가
 */

import { TreatmentResponse } from '@/interfaces/treatment';
import { BlockChainRecord, BlockChainRecordResponse, ExaminationTreatment, MedicationTreatment, VaccinationTreatment } from '@/interfaces/blockChain';
import { PetBasicInfo } from '@/interfaces/pet';
import { didRegistryABI } from '@/utils/constants';
import { 
  isRecordDeletedFromString, 
  hasTroublesomePattern, 
  extractValueFromJsonString, 
  sanitizeJsonString, 
  safeJsonParse, 
} from '@/utils/jsonParser';

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
      console.error('접근 권한이 없습니다.');
      return { 
        success: false, 
        error: '이 반려동물에 대한 접근 권한이 없습니다.',
        treatments: [] 
      };
    }
    
    // 진료 기록 조회를 위한 모든 속성 가져오기
    console.log('진료 기록 조회 중...');
    const [names, values, _expireDates] = await contract.getAllAttributes(petDID);
    
    // 진료 기록 목록
    const treatments: BlockChainRecord[] = [];
    
    // 진료 기록 간의 관계를 추적하기 위한 맵
    const recordMap: { [key: string]: BlockChainRecord } = {};
    const recordHistory: { [key: string]: string[] } = {};  // key: 원본 기록, value: 수정 기록 목록
    
    console.log(`총 ${names.length}개의 속성을 검색합니다.`);
    
    // 1단계: 모든 진료 기록을 파싱하고 맵에 저장
    for (let i = 0; i < names.length; i++) {
      const name = names[i];
      const value = values[i];
      
      // 의료 기록 필터링 (medical_로 시작하는 것만)
      if (name.startsWith('medical_record_') || name.startsWith('medical_')) {
        try {
          // 파싱 전에 삭제된 기록인지 확인 (문자열 패턴 기반)
          if (isRecordDeletedFromString(value)) {
            console.log('파싱 전 확인: 삭제된 기록 건너뜀:', name);
            continue;
          }
          
          // 처리하기 어려운 패턴인지 확인
          if (hasTroublesomePattern(value)) {
            console.log('처리하기 어려운 패턴 발견, 단순화된 처리 적용:', name);
            
            // 간단한 정보만 추출
            const diagnosis = extractValueFromJsonString(value, 'diagnosis', '기록 없음');
            const hospitalName = extractValueFromJsonString(value, 'hospitalName', '병원 정보 없음');
            const doctorName = extractValueFromJsonString(value, 'doctorName', '');
            const createdAt = extractValueFromJsonString(value, 'createdAt', '0');
            
            // 간단한 기록 생성
            const simplifiedRecord: BlockChainRecord = {
              id: name,
              diagnosis: diagnosis,
              hospitalName: hospitalName,
              doctorName: doctorName,
              notes: '이 기록은 복잡한 형식으로 인해 단순화되었습니다.',
              createdAt: String(parseInt(createdAt) || 0),
              timestamp: parseInt(createdAt) || 0,
            isDeleted: false,
              pictures: [],
              previousRecord: '',
              hospitalAddress: '',
            treatments: {
              examinations: [],
              medications: [],
              vaccinations: []
              }
            };
            
            recordMap[name] = simplifiedRecord;
            continue;
          }
          
          // 문자열 정제 및 안전한 JSON 파싱 사용
          const sanitizedValue = sanitizeJsonString(value);
          const recordData = safeJsonParse(sanitizedValue, {});
          
          if (!recordData || typeof recordData !== 'object') {
            console.warn('JSON 파싱 후 유효한 객체가 아님, 건너뜀:', name);
            continue;
          }
          
          // 삭제된 기록 확인
          if (recordData.isDeleted) {
            console.log('삭제된 진료 기록 건너뜀:', name);
            continue;
          }
          
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
          
          // 사진 데이터 처리
          let pictures: string[] = [];
          if (recordData.pictures && Array.isArray(recordData.pictures)) {
            pictures = recordData.pictures.map((pic: any) => 
              typeof pic === 'string' ? pic : (pic.url || '')
            );
          }
          
          // 처치 데이터 처리
          let treatments = {
            examinations: [],
            medications: [],
            vaccinations: []
          };
          
          if (recordData.treatments) {
            // examinations 처리
            if (recordData.treatments.examinations && Array.isArray(recordData.treatments.examinations)) {
              treatments.examinations = recordData.treatments.examinations.map((exam: any) => 
                typeof exam === 'string' ? { name: exam } : exam
              );
            }
            
            // medications 처리
            if (recordData.treatments.medications && Array.isArray(recordData.treatments.medications)) {
              treatments.medications = recordData.treatments.medications.map((med: any) => 
                typeof med === 'string' ? { name: med } : med
              );
            }
            
            // vaccinations 처리
            if (recordData.treatments.vaccinations && Array.isArray(recordData.treatments.vaccinations)) {
              treatments.vaccinations = recordData.treatments.vaccinations.map((vac: any) => 
                typeof vac === 'string' ? { name: vac } : vac
              );
            }
          }
          
          // 진료 기록 객체 생성
          const treatment: BlockChainRecord = {
            id: name,
            diagnosis: recordData.diagnosis || '정보 없음',
            hospitalName: recordData.hospitalName || '병원 정보 없음',
            doctorName: recordData.doctorName || '',
            notes: recordData.notes || '',
            createdAt: String(timestamp),
            timestamp: timestamp,
            isDeleted: false,
            hospitalAddress: recordData.hospitalAddress || '',
            pictures: pictures,
            previousRecord: recordData.previousRecord || '',
            treatments: treatments
          };
          
          // 기록 맵에 추가
          recordMap[name] = treatment;
          
          // 이전 기록 참조가 있으면 기록 히스토리에 추가
          if (recordData.previousRecord) {
            if (!recordHistory[recordData.previousRecord]) {
              recordHistory[recordData.previousRecord] = [];
            }
            recordHistory[recordData.previousRecord].push(name);
          }
        } catch (error) {
          console.error('의료 기록 파싱 오류:', error);
        }
      }
    }
    
    // 2단계: 수정 기록이 없는 최신 기록만 처리
    const processedKeys = new Set<string>();
    
    // 모든 키를 먼저 처리
    for (const key in recordMap) {
      if (processedKeys.has(key)) continue;
      
      const record = recordMap[key];
      processedKeys.add(key);
      
      // 이 기록에 대한 수정 기록 있는지 확인
      if (recordHistory[key] && recordHistory[key].length > 0) {
        // 수정 기록이 있으면 처리하지 않음 (나중에 최신 버전으로 처리됨)
        continue;
      }
      
      // 이 기록이 다른 기록의 수정본인지 확인
      if (record.previousRecord) {
        // 가장 최신 수정본 찾기
        let currentKey = key;
        let latestModification = record;
        
        // 이 기록의 최신 수정본 찾기
        while (recordHistory[currentKey] && recordHistory[currentKey].length > 0) {
          const nextKey = recordHistory[currentKey][0]; // 첫 번째 수정본 사용
          if (processedKeys.has(nextKey)) break;
          
          processedKeys.add(nextKey);
          latestModification = recordMap[nextKey];
          currentKey = nextKey;
        }
        
        // 최신 수정본 사용
        treatments.push(latestModification);
      } else {
        // 수정 기록이 없는 기록 추가
        treatments.push(record);
      }
    }
    
    // 정렬 (날짜 기준 내림차순)
    treatments.sort((a, b) => {
      const timeA = typeof a.timestamp === 'number' ? a.timestamp : parseInt(a.createdAt);
      const timeB = typeof b.timestamp === 'number' ? b.timestamp : parseInt(b.createdAt);
      return timeB - timeA;
    });
    
    console.log(`총 ${treatments.length}개의 진료 기록을 찾았습니다.`);
    
        return { 
          success: true, 
      treatments: treatments
    };
                } catch (error) {
    console.error('블록체인 진료 기록 조회 오류:', error);
      return {
        success: false,
      error: `블록체인 데이터 조회 중 오류가 발생했습니다: ${error instanceof Error ? error.message : '알 수 없는 오류'}`,
      treatments: []
    };
  }
};

/**
 * 날짜 포맷 함수
 * @param timestamp 타임스탬프
 * @returns 포맷된 날짜 문자열
 */
const formatDate = (timestamp: number | string): string => {
  try {
    // 문자열인 경우 숫자로 변환
    const numTimestamp = typeof timestamp === 'string' ? parseInt(timestamp) : timestamp;
    const date = new Date(numTimestamp);
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
 * 의료기록 항목을 포맷팅하는 함수
 * @param record 의료기록
 * @returns 포맷팅된 결과
 */
export const formatMedicalRecord = (record: BlockChainRecord): { 
  basic: string; 
  treatments: string; 
  preview: string;
} => {
  try {
    // 기본 정보
    let basic = `진단명: ${record.diagnosis || '기록 없음'}\n`;
    basic += `병원: ${record.hospitalName || '기록 없음'}\n`;
    basic += `수의사: ${record.doctorName || '기록 없음'}\n`;
    basic += `작성일: ${formatDate(record.createdAt)}\n\n`;
    basic += `${record.notes || ''}`;
    
    // 치료 정보
    let treatments = '';
    
    // 검사 항목
    if (record.treatments.examinations && record.treatments.examinations.length > 0) {
      treatments += '■ 검사 항목\n';
      record.treatments.examinations.forEach((exam: ExaminationTreatment | any) => {
        treatments += `• ${exam.type || exam.name || '이름 없음'}`;
        if (exam.value || exam.result) treatments += `: ${exam.value || exam.result}`;
        treatments += '\n';
      });
      treatments += '\n';
    }
    
    // 약물 처방
    if (record.treatments.medications && record.treatments.medications.length > 0) {
      treatments += '■ 처방 약물\n';
      record.treatments.medications.forEach((med: MedicationTreatment | any) => {
        treatments += `• ${med.type || med.name || '이름 없음'}`;
        if (med.value || med.dosage) treatments += ` (${med.value || med.dosage})`;
        if (med.instructions) treatments += `\n  ${med.instructions}`;
        treatments += '\n';
      });
      treatments += '\n';
    }
    
    // 예방접종
    if (record.treatments.vaccinations && record.treatments.vaccinations.length > 0) {
      treatments += '■ 예방접종\n';
      record.treatments.vaccinations.forEach((vac: VaccinationTreatment | any) => {
        treatments += `• ${vac.type || vac.name || '이름 없음'}`;
        if (vac.value || vac.date) treatments += ` (접종일: ${vac.value || vac.date})`;
        if (vac.nextDate) treatments += `\n  다음 접종 예정일: ${vac.nextDate}`;
        treatments += '\n';
      });
    }
    
    // 미리보기 요약
    let preview = record.diagnosis || '진단 기록 없음';
    preview = preview.length > 20 ? preview.substring(0, 20) + '...' : preview;
    
    return { 
      basic,
      treatments,
      preview
    };
  } catch (error) {
    console.error('의료기록 포맷팅 오류:', error);
    return { 
      basic: '기록 오류: 표시할 수 없는 형식입니다.',
      treatments: '',
      preview: '오류'
    };
  }
};

/**
 * 블록체인 데이터에서 접수일자와 만료일 사이에 진료기록 존재여부 확인
 * @param petDID 반려동물 DID 주소
 * @param createdAt 접수일자 (Unix 타임스탬프)
 * @param expireDate 만료일 (Unix 타임스탬프)
 * @returns 진료기록 존재 여부
 */
export const hasTreatmentRecords = async (
  petDID: string,
  createdAt: number,
  expireDate: number
): Promise<{ success: boolean; hasTreatment: boolean; error?: string }> => {
  try {
    // 필수 파라미터 확인
    if (!petDID) {
      return { 
        success: false, 
        hasTreatment: false,
        error: '필수 파라미터(petDID)가 누락되었습니다.'
      };
    }

    // 블록체인 인증 서비스를 통해 계정 연결 및 Provider, Registry 컨트랙트 가져오기
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
        error: '이 반려동물에 대한 접근 권한이 없습니다.'
      };
    }
    
    // 진료 기록 조회를 위한 모든 속성 가져오기
    const [names, values] = await contract.getAllAttributes(petDID);
    
    // 의료기록만 필터링하여 접수일자와 만료일 사이에 기록된 진료기록이 있는지 확인
    for (let i = 0; i < names.length; i++) {
      const name = names[i];
      const value = values[i];
      
      if (name.startsWith('medical_record_') || name.startsWith('medical_')) {
        try {
          // 파싱 전에 삭제된 기록인지 확인 (문자열 패턴 기반)
          if (isRecordDeletedFromString(value)) {
            console.log('파싱 전 확인: 삭제된 기록 건너뜀:', name);
            continue;
          }
          
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
  } catch (error) {
    console.error('블록체인 진료 기록 조회 오류:', error);
    return { 
      success: false, 
      hasTreatment: false,
      error: `진료 기록 확인 중 오류가 발생했습니다: ${error instanceof Error ? error.message : '알 수 없는 오류'}`
    };
  }
};

/**
 * 블록체인에서 반려동물 기본 정보를 조회하는 함수
 * @param petDID 반려동물 DID 주소
 * @returns 조회된 반려동물 기본 정보
 */
export const getPetBasicInfo = async (petDID: string): Promise<{
  success: boolean;
  petInfo?: PetBasicInfo;
  error?: string;
}> => {
  try {
    if (!petDID) {
      return {
        success: false,
        error: '반려동물 DID가 제공되지 않았습니다.'
      };
    }

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
      console.error('등록되지 않은 반려동물입니다.');
      return { 
        success: false, 
        error: '등록되지 않은 반려동물입니다.'
      };
    }
    
    // 접근 권한 확인
    const currentUserAddress = await signer.getAddress();
    const accessGranted = await contract.hasAccess(petDID, currentUserAddress);
    
    if (!accessGranted) {
      console.error('접근 권한이 없습니다.');
      return { 
        success: false, 
        error: '이 반려동물에 대한 접근 권한이 없습니다.'
      };
    }
    
    // 반려동물 기본 속성 가져오기
    const [names, values] = await contract.getAllAttributes(petDID);
    
    // PetBasicInfo 인터페이스를 활용한 정보 추출
    const petInfo: PetBasicInfo = {
      name: '',
      gender: '',
      breedName: '',
      birth: '',
      profileUrl: '',
      flagNeutering: false,
      speciesName: '',
      petDID: petDID // DID 정보도 포함
    };
    
    // 속성 매핑
    for (let i = 0; i < names.length; i++) {
      const name = names[i];
      const value = values[i];
      
      switch (name) {
        case 'name':
          petInfo.name = value;
          break;
        case 'gender':
          petInfo.gender = value;
          break;
        case 'breedName':
          petInfo.breedName = value;
          break;
        case 'birth':
          petInfo.birth = value;
          break;
        case 'profileUrl':
          petInfo.profileUrl = value;
          break;
        case 'flagNeutering':
          // PetBasicInfo 인터페이스는 string | boolean을 허용
          petInfo.flagNeutering = value === 'true' ? true : 
                                 value === 'false' ? false : 
                                 value;
          break;
        case 'speciesName':
          petInfo.speciesName = value;
          break;
      }
    }
    
    // 필수 정보 확인
    if (!petInfo.name) {
      return {
        success: false,
        error: '반려동물 이름을 찾을 수 없습니다.'
      };
    }
    
    return {
      success: true,
      petInfo
    };
  } catch (error: any) {
    console.error('반려동물 기본 정보 조회 오류:', error);
    return {
      success: false,
      error: `반려동물 정보 조회 중 오류가 발생했습니다: ${error.message || '알 수 없는 오류'}`
    };
  }
};

/**
 * 반려동물의 최신 진료 상태를 조회하는 함수
 * @param petDID 반려동물 DID 주소
 * @returns 최신 진료 상태 (IN_PROGRESS, COMPLETED, NONE)
 */
export const getLatestTreatmentStatus = async (
  petDID: string
): Promise<{ 
  success: boolean; 
  status: 'IN_PROGRESS' | 'COMPLETED' | 'NONE' | null;
  error?: string;
}> => {
  try {
    if (!petDID) {
      return {
        success: false,
        status: null,
        error: '반려동물 DID가 제공되지 않았습니다.'
      };
    }

    // 블록체인 인증 서비스를 통해 계정 연결 및 Registry 컨트랙트 가져오기
    const { getRegistryContract, getSigner } = await import('@/services/blockchainAuthService');
    const contract = await getRegistryContract();
    const signer = await getSigner();
    
    if (!contract || !signer) {
      return { 
        success: false, 
        status: null,
        error: 'MetaMask에 연결할 수 없습니다. 계정 연결 상태를 확인해주세요.'
      };
    }
    
    // 반려동물 존재 여부 확인
    const exists = await contract.petExists(petDID);
    if (!exists) {
      return { 
        success: false, 
        status: null,
        error: '등록되지 않은 반려동물입니다.'
      };
    }
    
    // 접근 권한 확인
    const currentUserAddress = await signer.getAddress();
    const accessGranted = await contract.hasAccess(petDID, currentUserAddress);
    
    if (!accessGranted) {
      return { 
        success: false, 
        status: null,
        error: '이 반려동물에 대한 접근 권한이 없습니다.'
      };
    }

    try {
      // 원본 의료기록 키 목록 가져오기
      const originalRecordKeys = await contract.getPetOriginalRecords(petDID);
      
      if (!originalRecordKeys || originalRecordKeys.length === 0) {
        return {
          success: true,
          status: 'NONE' // 의료기록이 없음
        };
      }
      
      // 최신 기록 키 (타임스탬프 내림차순 정렬 후)
      const sortedKeys = [...originalRecordKeys].sort((a, b) => {
        // medical_record_TIMESTAMP_ADDRESS 형식에서 타임스탬프 추출
        const timestampA = parseInt(a.split('_')[2]) || 0;
        const timestampB = parseInt(b.split('_')[2]) || 0;
        return timestampB - timestampA; // 내림차순 (최신순)
      });
      
      const latestOriginalKey = sortedKeys[0];
      
      // 원본 기록과 수정 기록들 가져오기
      const [originalRecord, updateRecords] = await contract.getMedicalRecordWithUpdates(petDID, latestOriginalKey);
      
      // 원본 기록 파싱
      const parsedOriginal = safeJsonParse(originalRecord, {});
      
      if (parsedOriginal.isDeleted) {
        // 원본이 삭제되었다면 다음 기록 확인
        if (sortedKeys.length > 1) {
          const nextOriginalKey = sortedKeys[1];
          const [nextOriginalRecord, nextUpdateRecords] = await contract.getMedicalRecordWithUpdates(petDID, nextOriginalKey);
          const parsedNextOriginal = safeJsonParse(nextOriginalRecord, {});
          
          if (parsedNextOriginal.isDeleted) {
            // 그 다음 기록도 삭제되었다면 'NONE'으로 처리
      return { 
        success: true, 
              status: 'NONE'
            };
          }
          
          // 최신 업데이트 기록 중 삭제되지 않은 것이 있는지 확인
          const validUpdates = nextUpdateRecords
            .map((record: string) => safeJsonParse(record, { isDeleted: true }))
            .filter((record: any) => !record.isDeleted);
          
          if (validUpdates.length > 0) {
            // 가장 최신 업데이트 기록 사용
            const latestUpdate = validUpdates.sort((a: any, b: any) => {
              const timeA = parseInt(a.timestamp || a.createdAt || '0');
              const timeB = parseInt(b.timestamp || b.createdAt || '0');
              return timeB - timeA; // 내림차순 (최신순)
            })[0];
            
      return {
        success: true,
              status: latestUpdate.status || 'IN_PROGRESS'
      };
          } else {
            // 유효한 업데이트가 없으면 원본 기록 상태 반환
      return {
        success: true,
              status: parsedNextOriginal.status || 'IN_PROGRESS'
      };
          }
    } else {
          // 다른 원본 기록이 없으면 'NONE'으로 처리
      return {
        success: true,
            status: 'NONE'
          };
        }
      }
      
      // 업데이트 기록 확인
      if (updateRecords && updateRecords.length > 0) {
        // 모든 업데이트 기록 파싱
        const parsedUpdates = updateRecords
          .map((record: string) => safeJsonParse(record, { isDeleted: true }))
          .filter((record: any) => !record.isDeleted);
        
        if (parsedUpdates.length > 0) {
          // 가장 최신 업데이트 기록 사용
          const latestUpdate = parsedUpdates.sort((a: any, b: any) => {
            const timeA = parseInt(a.timestamp || a.createdAt || '0');
            const timeB = parseInt(b.timestamp || b.createdAt || '0');
            return timeB - timeA; // 내림차순 (최신순)
          })[0];
          
          return {
            success: true,
            status: latestUpdate.status || 'IN_PROGRESS'
          };
        }
      }
      
      // 업데이트 기록이 없거나 모두 삭제된 경우 원본 기록 상태 반환
      return {
        success: true,
        status: parsedOriginal.status || 'IN_PROGRESS'
      };
  } catch (error: any) {
      console.error('진료 상태 조회 중 오류:', error);
    return {
      success: false,
      status: null,
        error: `진료 상태 조회 중 오류가 발생했습니다: ${error.message || '알 수 없는 오류'}`
      };
    }
  } catch (error: any) {
    console.error('진료 상태 조회 준비 중 오류:', error);
    return {
      success: false,
      status: null,
      error: `진료 상태 조회 준비 중 오류가 발생했습니다: ${error.message || '알 수 없는 오류'}`
    };
  }
};

// 다른 함수들은 이곳에 추가...

// treatmentRecordService 모든 함수 re-export
export {
  createBlockchainTreatment,
  updateBlockchainTreatment,
  softDeleteMedicalRecord,
  getHospitalPetsWithRecords,
  getRecordChanges,
  getLatestPetRecords
} from '@/services/treatmentRecordService';
