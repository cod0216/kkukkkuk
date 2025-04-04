/**
 * JSON 문자열에서 isDeleted가 true인지 빠르게 확인하는 함수 (파싱 없이)
 * @param jsonString JSON 문자열
 * @returns isDeleted가 true인지 여부
 */
export const isRecordDeletedFromString = (jsonString: string): boolean => {
  if (!jsonString || typeof jsonString !== 'string') {
    return false;
  }
  
  // "isDeleted":true 패턴 검색 (공백이 있을 수 있음)
  const deletedPattern = /"isDeleted"\s*:\s*true/i;
  return deletedPattern.test(jsonString);
};

/**
 * JSON 문자열에 처리하기 어려운 패턴이 있는지 확인하는 함수
 * @param jsonString JSON 문자열
 * @returns 처리하기 어려운 패턴이 있으면 true, 없으면 false
 */
export const hasTroublesomePattern = (jsonString: string): boolean => {
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
 * JSON 문자열에서 특정 키의 값을 안전하게 추출하는 함수 (파싱 없이)
 * @param jsonString JSON 문자열
 * @param key 추출할 키 이름
 * @param defaultValue 기본값
 * @returns 추출된 값 또는 기본값
 */
export const extractValueFromJsonString = (
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

/**
 * JSON 문자열에서 잘못된 제어 문자를 제거하는 함수
 * @param jsonString JSON 문자열
 * @returns 정제된 JSON 문자열
 */
export const sanitizeJsonString = (jsonString: string): string => {
  if (!jsonString) return jsonString;
  
  // JSON 문자열인지 기본 검사
  if (typeof jsonString === 'string' && !jsonString.trim().startsWith('{') && !jsonString.trim().startsWith('[')) {
    // JSON이 아닌 일반 문자열은 그대로 반환
    return jsonString;
  }
  
  // JSON에서 허용되지 않는 제어 문자 제거 (U+0000에서 U+001F까지)
  let sanitized = jsonString.replace(/[\u0000-\u001F]/g, '');
  
  try {
    // 간단한 검증 - 유효한 JSON인지 확인
    JSON.parse(sanitized);
    return sanitized;
  } catch (e) {
    console.warn('JSON 파싱 오류, 추가 정제 시도:', e, '원본:', jsonString);
    
    // notes 필드 내용만 정확히 추출 시도 (이스케이프된 따옴표 처리 포함)
    try {
      const notesMatch = sanitized.match(/"notes":"((?:\\.|[^"\\])*)"/);
      if (notesMatch && notesMatch[1]) {
        let noteContent = notesMatch[1];
        
        // 이미 이스케이프된 백슬래시 복원
        noteContent = noteContent.replace(/\\\\/g, '\\');
        
        // 내부의 따옴표만 정확히 이스케이프
        noteContent = noteContent.replace(/(?<!\\)"/g, '\\"');
        
        // 정제된 notes 내용으로 교체
        sanitized = sanitized.replace(/"notes":"((?:\\.|[^"\\])*)"/, `"notes":"${noteContent}"`);
      }
    } catch (notesError) {
      console.warn('notes 필드 정제 중 오류:', notesError);
    }
    
    // 최종 JSON 구조 검증 및 반환
    try {
      JSON.parse(sanitized);
      return sanitized;
    } catch (finalError) {
      console.error('최종 JSON 정제 실패:', finalError, '정제 시도한 문자열:', sanitized);
      // JSON 파싱 실패 시 원본 반환 - 이 경우 상위에서 안전하게 처리해야 함
      return jsonString; 
    }
  }
};

/**
 * JSON 문자열을 안전하게 파싱하는 함수
 * @param jsonString JSON 문자열
 * @param defaultValue 파싱 실패시 반환할 기본값
 * @returns 파싱된 객체 또는 기본값
 */
export const safeJsonParse = (jsonString: string, defaultValue: any = null): any => {
  try {
    if (!jsonString || typeof jsonString !== 'string') {
      return defaultValue;
    }
    
    // 제어 문자 처리: 줄바꿈, 탭 등을 이스케이프 처리
    const sanitizedJson = jsonString
      .replace(/[\n\r]/g, '\\n') // 줄바꿈을 \n으로 치환
      .replace(/[\t]/g, '\\t')   // 탭을 \t로 치환
      .replace(/[\b\f]/g, '');   // 다른 제어 문자 제거
    
    return JSON.parse(sanitizedJson);
  } catch (error) {
    console.error('JSON 파싱 오류:', error, '원본 문자열:', jsonString);
    return defaultValue;
  }
};

/**
 * 객체의 모든 문자열 속성에서 제어 문자를 제거
 * @param obj 정제할 객체
 * @returns 정제된 객체
 */
export const sanitizeObject = (obj: any): any => {
  if (!obj) return obj;
  
  if (typeof obj === 'string') {
    // JSON 형식인 문자열만 파싱 시도, 아니면 그대로 반환
    if (obj.trim().startsWith('{') || obj.trim().startsWith('[')) {
      return sanitizeJsonString(obj);
    }
    return obj; // 일반 문자열은 그대로 반환
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
