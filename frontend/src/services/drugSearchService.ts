import { ResponseStatus, ApiResponse } from '@/types';
import apiClient from '@/services/apiClient';

/**
 * 약품 인터페이스
 */
export interface Drug {
  id: number;
  name_kr: string;
  name_en: string;
  apply_animal: string;
}

/**
 * 약품 상세 정보 인터페이스
 */
export interface DrugDetail extends Drug {
  description?: string;
  usage?: string;
  caution?: string;
  sideEffect?: string;
  manufacturer?: string;
}

/**
 * 약품 응답 인터페이스
 */
export interface DrugsResponse extends ApiResponse<Drug[]> {}

/**
 * 약품 자동완성 응답 인터페이스
 */
export interface DrugAutoCompleteResponse extends ApiResponse<string[]> {}

/**
 * 약품 상세 응답 인터페이스
 */
export interface DrugDetailResponse extends ApiResponse<DrugDetail> {}

/**
 * 동물 약품 전체 목록을 조회합니다.
 * @returns 약품 목록 응답
 */
export const getAllDrugs = async (): Promise<DrugsResponse> => {
  try {
    console.log(`[API] 전체 약품 목록 조회 요청`);
    
    // API 요청 (apiClient 사용)
    const response = await apiClient.get('/api/drugs/');
    
    // 응답 확인
    if (response.status === 200) {
      console.log(`[API] 전체 약품 목록 응답 성공: ${response.data.data?.length || 0}개 결과`);
      return {
        status: ResponseStatus.SUCCESS,
        message: '약품 목록을 성공적으로 불러왔습니다.',
        data: response.data.data || []
      };
    }
    
    return {
      status: ResponseStatus.FAILURE,
      message: '약품 목록을 불러오는데 실패했습니다.',
      data: []
    };
  } catch (error: any) {
    console.error('[API] 약품 목록 조회 중 오류:', error);
    return {
      status: ResponseStatus.FAILURE,
      message: error.response?.data?.message || '약품 목록을 불러오는 중 오류가 발생했습니다.',
      data: []
    };
  }
};

/**
 * 특정 약품 이름으로 약품을 검색합니다.
 * @param search 검색할 약품 이름
 * @returns 검색 결과 약품 목록
 */
export const searchDrugs = async (search: string): Promise<DrugsResponse> => {
  try {
    console.log(`[API] 약품 검색 요청: "${search}"`);
    
    // 검색어가 없으면 빈 배열 반환
    if (!search.trim()) {
      return {
        status: ResponseStatus.SUCCESS,
        message: '검색어를 입력해주세요.',
        data: []
      };
    }
    
    // API 요청 (Path Variable 사용)
    const response = await apiClient.get(`/api/drugs/${encodeURIComponent(search)}`);
    
    // 응답 확인
    if (response.status === 200) {
      console.log(`[API] 약품 검색 응답 성공: ${response.data.data?.length || 0}개 결과`);
      return {
        status: ResponseStatus.SUCCESS,
        message: response.data.message || `'${search}' 검색 결과입니다.`,
        data: response.data.data || []
      };
    }
    
    return {
      status: ResponseStatus.FAILURE,
      message: '약품 검색에 실패했습니다.',
      data: []
    };
  } catch (error: any) {
    console.error('[API] 약품 검색 중 오류:', error);
    return {
      status: ResponseStatus.FAILURE,
      message: error.response?.data?.message || '약품 검색 중 오류가 발생했습니다.',
      data: []
    };
  }
};

/**
 * 약품 이름 자동완성 목록을 조회합니다.
 * @param search 검색어
 * @param petBreed 동물 종류 (선택적, 클라이언트측 필터링용)
 * @returns 자동완성 약품명 목록
 */
export const getDrugAutoComplete = async (search: string, petBreed?: string): Promise<DrugAutoCompleteResponse> => {
  try {
    console.log(`[API] 약품 자동완성 요청: "${search}"${petBreed ? ` (동물종류: ${petBreed})` : ''}`);
    
    // 검색어가 없으면 빈 배열 반환
    if (!search.trim()) {
      return {
        status: ResponseStatus.SUCCESS,
        message: '검색어를 입력해주세요.',
        data: []
      };
    }
    
    // API 요청 (Query Parameter 사용) - params 객체 사용하여 올바른 URL 구성
    console.log(`[API] 약품 자동완성 API 호출: /api/drugs/auto-correct?search=${encodeURIComponent(search)}`);
    const response = await apiClient.get('/api/drugs/auto-correct', {
      params: { search: search }
    });
    
    // 응답 확인
    if (response.status === 200) {
      console.log(`[API] 약품 자동완성 응답 성공: ${response.data.data?.length || 0}개 결과`);
      
      // 동물 종류 필터링이 필요한 경우
      if (petBreed && response.data.data && response.data.data.length > 0) {
        try {
          // 동물별 약품 정보 가져오기 (검색으로 부하가 크지 않은 경우에만 사용)
          console.log(`[API] '${petBreed}'에 적합한 약품 검색 중...`);
          const animalDrugs = await findDrugsForAnimal(petBreed);
          console.log(`[API] '${petBreed}'에 적합한 약품 ${animalDrugs.length}개 찾음`);
          
          // 자동완성 결과를 동물 종류에 맞게 정렬 (적합한 약품이 위로)
          const sortedResults = [...response.data.data].sort((a, b) => {
            const aMatch = animalDrugs.includes(a);
            const bMatch = animalDrugs.includes(b);
            if (aMatch && !bMatch) return -1;
            if (!aMatch && bMatch) return 1;
            return 0;
          });
          
          console.log(`[API] '${petBreed}' 동물 기준으로 정렬된 자동완성 결과:`, sortedResults.slice(0, 3), `외 ${sortedResults.length > 3 ? sortedResults.length - 3 : 0}개`);
          
          return {
            status: ResponseStatus.SUCCESS,
            message: `'${petBreed}'에 적합한 약품 우선 정렬 결과입니다.`,
            data: sortedResults
          };
        } catch (error) {
          console.error('[API] 동물 종류별 약품 필터링 중 오류:', error);
          // 오류 발생 시 원본 결과 반환
          return {
            status: ResponseStatus.SUCCESS,
            message: response.data.message || '자동완성 목록입니다.',
            data: response.data.data || []
          };
        }
      }
      
      // 동물 종류 필터링이 필요 없는 경우
      return {
        status: ResponseStatus.SUCCESS,
        message: response.data.message || '자동완성 목록입니다.',
        data: response.data.data || []
      };
    }
    
    return {
      status: ResponseStatus.FAILURE,
      message: '자동완성 목록을 불러오는데 실패했습니다.',
      data: []
    };
  } catch (error: any) {
    console.error('[API] 자동완성 목록 조회 중 오류:', error);
    return {
      status: ResponseStatus.FAILURE,
      message: error.response?.data?.message || '자동완성 목록을 불러오는 중 오류가 발생했습니다.',
      data: []
    };
  }
};

/**
 * 약품 상세 정보를 조회합니다.
 * @param drugId 약품 ID
 * @returns 약품 상세 정보
 */
export const getDrugDetail = async (drugId: number): Promise<DrugDetailResponse> => {
  try {
    console.log(`[API] 약품 상세 정보 조회 요청: ID ${drugId}`);
    
    // API 요청
    const response = await apiClient.get(`/api/drugs/${drugId}`);
    
    // 응답 확인
    if (response.status === 200) {
      console.log(`[API] 약품 상세 정보 응답 성공: ${response.data.data?.name_kr || 'N/A'}`);
      return {
        status: ResponseStatus.SUCCESS,
        message: '약품 상세 정보를 성공적으로 불러왔습니다.',
        data: response.data.data
      };
    }
    
    return {
      status: ResponseStatus.FAILURE,
      message: '약품 상세 정보를 불러오는데 실패했습니다.',
      data: null
    };
  } catch (error: any) {
    console.error('[API] 약품 상세 정보 조회 중 오류:', error);
    return {
      status: ResponseStatus.FAILURE,
      message: error.response?.data?.message || '약품 상세 정보를 불러오는 중 오류가 발생했습니다.',
      data: null
    };
  }
};

/**
 * 특정 동물에 적합한 약품 이름 목록을 가져옵니다.
 * 이 함수는 성능 최적화를 위해 결과를 캐시합니다.
 */
const animalDrugCache: Record<string, string[]> = {};

/**
 * 특정 동물에 적합한 약품 이름 목록을 찾습니다.
 * @param animalType 동물 종류 (예: '개', '고양이')
 * @returns 동물에 적합한 약품 이름 목록
 */
const findDrugsForAnimal = async (animalType: string): Promise<string[]> => {
  // 캐시에 이미 있으면 캐시된 결과 반환
  if (animalDrugCache[animalType]) {
    console.log(`[API] '${animalType}' 동물 약품 캐시 사용 (${animalDrugCache[animalType].length}개)`);
    return animalDrugCache[animalType];
  }
  
  try {
    console.log(`[API] '${animalType}' 동물에 적합한 약품 검색을 위해 전체 약품 목록 조회 중...`);
    // 전체 약품 목록 가져오기
    const response = await getAllDrugs();
    
    if (response.status === ResponseStatus.SUCCESS && response.data) {
      console.log(`[API] 전체 약품 ${response.data.length}개 조회 완료`);
      
      // 해당 동물에 적합한 약품만 필터링
      const matchingDrugs = response.data
        .filter(drug => 
          drug.apply_animal && 
          drug.apply_animal.toLowerCase().includes(animalType.toLowerCase())
        )
        .map(drug => drug.name_kr);
      
      console.log(`[API] '${animalType}' 동물에 적합한 약품 ${matchingDrugs.length}개 필터링 완료`);
      
      // 결과 캐시에 저장
      animalDrugCache[animalType] = matchingDrugs;
      
      return matchingDrugs;
    }
    
    console.log(`[API] 전체 약품 목록을 가져오지 못함`);
    return [];
  } catch (error) {
    console.error(`[API] '${animalType}'에 적합한 약품 찾기 오류:`, error);
    return [];
  }
};
