import { request } from "@/services/apiRequest";
import { ApiResponse, ResponseStatus } from "@/types";

/**
 * @module petTypeService
 * @file petTypeService.ts
 * @author seonghun
 * @date 2025-04-01
 * @description 반려동물 타입 및 품종 관련 서비스를 제공하는 모듈입니다.
 * 백엔드 API를 통해 최상위 종 및 하위 품종 정보를 가져오고, 품종명을 기반으로 반려동물 타입을 판별합니다.
 */

// 타입 정의
export interface BreedType {
  id: number;
  name: string;
}

// 최상위 종과 하위 품종 데이터 캐싱
let topLevelBreeds: BreedType[] = [];
const subBreeds: Record<number, BreedType[]> = {};
let allBreeds: Record<string, 'dog' | 'cat' | 'unknown'> = {};
let isInitialized = false;

// 개와 고양이의 ID
let DOG_ID: number | null = null;
let CAT_ID: number | null = null;

/**
 * 모든 최상위 종(강아지, 고양이 등)을 가져옵니다.
 * @returns 최상위 종 목록
 */
export const getTopLevelBreeds = async (): Promise<BreedType[]> => {
  try {
    const response: ApiResponse<BreedType[]> = await request.get<BreedType[]>('/api/breeds');
    if (response && response.status === ResponseStatus.SUCCESS && response.data) {
      topLevelBreeds = response.data;
      
      // 강아지와 고양이 ID 저장
      topLevelBreeds.forEach(breed => {
        if (breed.name === '강아지') DOG_ID = breed.id;
        if (breed.name === '고양이') CAT_ID = breed.id;
      });
      
      console.log(`최상위 품종 ${topLevelBreeds.length}개 로드 완료: ${response.message}`);
      return topLevelBreeds;
    } else {
      console.warn('최상위 품종 조회 실패:', response?.message || '알 수 없는 오류');
      return [];
    }
  } catch (error) {
    console.error('최상위 종 조회 중 오류:', error);
    return [];
  }
};

/**
 * 특정 상위 종의 하위 품종을 가져옵니다.
 * @param parentId 상위 종 ID
 * @returns 하위 품종 목록
 */
export const getSubBreeds = async (parentId: number): Promise<BreedType[]> => {
  try {
    // 이미 캐싱된 데이터가 있으면 그것을 반환
    if (subBreeds[parentId]) {
      return subBreeds[parentId];
    }
    
    const response: ApiResponse<BreedType[]> = await request.get<BreedType[]>(`/api/breeds/${parentId}`);
    if (response && response.status === ResponseStatus.SUCCESS && response.data) {
      subBreeds[parentId] = response.data;
      console.log(`하위 품종 ${response.data.length}개 로드 완료 (parentId: ${parentId}): ${response.message}`);
      return response.data;
    } else {
      console.warn(`하위 품종 조회 실패 (parentId: ${parentId}):`, response?.message || '알 수 없는 오류');
      return [];
    }
  } catch (error) {
    console.error(`하위 품종 조회 중 오류(parentId: ${parentId}):`, error);
    return [];
  }
};

/**
 * 모든 품종 데이터를 초기화합니다.
 * @returns 초기화 성공 여부
 */
export const initializeBreedData = async (): Promise<boolean> => {
  if (isInitialized) return true;
  
  try {
    // 1. 최상위 종 가져오기
    console.log('반려동물 품종 데이터 초기화 시작...');
    const topBreeds = await getTopLevelBreeds();
    if (!topBreeds.length) {
      console.warn('최상위 품종 정보를 가져오는데 실패했습니다. 백업 데이터를 사용합니다.');
      return false;
    }
    
    // 2. 각 최상위 종의 하위 품종 가져오기
    let totalSubBreeds = 0;
    for (const breed of topBreeds) {
      const subs = await getSubBreeds(breed.id);
      totalSubBreeds += subs.length;
      
      // 3. 모든 계열/그룹명과 그 타입을 매핑
      // API 응답 확인 결과 1번이 고양이, 1001번이 강아지임
      if (breed.id === 1001) {
        // 강아지 계열/그룹 매핑
        subs.forEach(sub => {
          allBreeds[sub.name.toLowerCase()] = 'dog';
          
          // 그룹명에서 '그룹' 제거한 키워드도 매핑 (예: '스포팅 그룹' -> '스포팅')
          const keywordOnly = sub.name.replace(' 그룹', '').toLowerCase();
          allBreeds[keywordOnly] = 'dog';
        });
      } else if (breed.id === 1) {
        // 고양이 계열/그룹 매핑
        subs.forEach(sub => {
          allBreeds[sub.name.toLowerCase()] = 'cat';
          
          // 계열명에서 '계열' 제거한 키워드도 매핑 (예: '페르시안 계열' -> '페르시안')
          const keywordOnly = sub.name.replace(' 계열', '').toLowerCase();
          allBreeds[keywordOnly] = 'cat';
        });
      }
    }
    
    // 최상위 종도 매핑 ('강아지', '고양이')
    topBreeds.forEach(breed => {
      if (breed.id === 1001) {
        allBreeds['강아지'] = 'dog';
        allBreeds['개'] = 'dog';
        allBreeds['dog'] = 'dog';
      } else if (breed.id === 1) {
        allBreeds['고양이'] = 'cat';
        allBreeds['cat'] = 'cat';
      }
    });
    
    // 추가 일반적인 품종 키워드 매핑 (API에서 얻지 못한 구체적인 품종명)
    addCommonBreedKeywords();
    
    isInitialized = true;
    console.log(`반려동물 품종 데이터 초기화 완료: 최상위 품종 ${topBreeds.length}개, 하위 계열/그룹 ${totalSubBreeds}개 로드됨`);
    return true;
  } catch (error) {
    console.error('품종 데이터 초기화 중 오류:', error);
    return false;
  }
};

/**
 * 일반적으로 많이 사용되는 구체적인 품종명을 추가로 매핑
 */
const addCommonBreedKeywords = () => {
  // 강아지 구체적인 품종
  const dogBreeds = [
    '리트리버', '말티즈', '푸들', '시츄', '비숑', '치와와', '포메라니안', '진돗개',
    '보더콜리', '닥스훈트', '허스키', '골든', '래브라도', '코기', '웰시코기', '셰퍼드',
    '비글', '달마티안', '프렌치불독', '요크셔', '퍼그', '시바', '불테리어'
  ];
  
  // 고양이 구체적인 품종
  const catBreeds = [
    '페르시안', '샴', '먼치킨', '러시안블루', '스핑크스', '뱅갈', '브리티시', '스코티시',
    '메인쿤', '아비시니안', '버만', '시베리안', '노르웨이', '랙돌', '터키시앙고라', '봄베이',
    '엑조틱', '히말라얀', '코리안쇼트헤어'
  ];
  
  // 매핑 추가
  dogBreeds.forEach(breed => {
    allBreeds[breed.toLowerCase()] = 'dog';
  });
  
  catBreeds.forEach(breed => {
    allBreeds[breed.toLowerCase()] = 'cat';
  });
  
  // 추가 키워드 매핑 (모호한 이름 등 고려)
  allBreeds['쇼트헤어'] = 'cat';  // 대부분 고양이에 사용
  allBreeds['테리어'] = 'dog';    // 대부분 개에 사용
  allBreeds['불독'] = 'dog';
  allBreeds['스패니얼'] = 'dog';
};

/**
 * 품종명을 기반으로 반려동물 타입(강아지/고양이)을 판별합니다.
 * @param breedName 반려동물 품종명
 * @returns 'dog' | 'cat' | 'unknown'
 */
export const determinePetType = async (breedName: string): Promise<'dog' | 'cat' | 'unknown'> => {
  if (!breedName) return 'unknown';
  
  // 데이터가 초기화되지 않았으면 초기화
  if (!isInitialized) {
    const initialized = await initializeBreedData();
    if (!initialized) {
      console.warn('품종 데이터 초기화 실패, 백업 로직을 사용합니다.');
      return fallbackDeterminePetType(breedName);
    }
  }
  
  const lowerBreed = breedName.toLowerCase();
  
  // 정확한 품종명 매칭
  if (allBreeds[lowerBreed]) {
    return allBreeds[lowerBreed];
  }
  
  // 부분 문자열 매칭 시도
  for (const [breed, type] of Object.entries(allBreeds)) {
    if (lowerBreed.includes(breed)) {
      return type;
    }
  }
  
  // 판별 불가능한 경우
  return fallbackDeterminePetType(breedName);
};

// 프로미스를 사용하지 않는 동기 버전의 함수
// 이미 초기화된 데이터를 기반으로 판별하여 기존 코드와 호환성 유지
export const determinePetTypeSync = (breedName: string): 'dog' | 'cat' | 'unknown' => {
  if (!breedName) return 'unknown';
  
  // 데이터가 초기화되지 않았으면 대체 로직 사용
  if (!isInitialized) {
    console.warn('품종 데이터가 초기화되지 않았습니다. 백업 로직을 사용합니다.');
    return fallbackDeterminePetType(breedName);
  }
  
  const lowerBreed = breedName.toLowerCase();
  
  // 정확한 품종명 매칭
  if (allBreeds[lowerBreed]) {
    return allBreeds[lowerBreed];
  }
  
  // 부분 문자열 매칭 시도
  for (const [breed, type] of Object.entries(allBreeds)) {
    if (lowerBreed.includes(breed)) {
      return type;
    }
  }
  
  // 판별 불가능한 경우, 백업 로직 사용
  return fallbackDeterminePetType(breedName);
};

/**
 * API가 실패하거나 초기화되지 않았을 때 사용할 백업 판별 함수
 * 기존 하드코딩 방식 사용
 */
const fallbackDeterminePetType = (breedName: string): 'dog' | 'cat' | 'unknown' => {
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

// 앱 시작 시 데이터 미리 로드
initializeBreedData()
  .then(success => {
    if (success) {
      console.log('반려동물 품종 데이터가 성공적으로 초기화되었습니다.');
    } else {
      console.warn('반려동물 품종 데이터 초기화가 실패했습니다. 백업 데이터를 사용합니다.');
    }
  })
  .catch(error => {
    console.error('반려동물 품종 데이터 초기화 중 예외 발생:', error);
  });
