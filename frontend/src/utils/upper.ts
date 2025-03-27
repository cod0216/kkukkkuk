/**
 * @module upper
 * @file upper.tsx
 * @author eunchang
 * @date 2025-03-26
 * @description 스네이크 케이스를 카멜 케이스로 변환하는 유틸 모듈입니다.
 *
 * 이 모듈은 재귀적으로 모든 키를 카멜 케이스로 변환해줍니다.
 *
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-26        eunchang         최초 생성
 */

/**
 * 주어진 스네이크 케이스 문자열을 카멜 케이스로 변환합니다.
 *
 * @param str - 스네이크 케이스 문자열
 * @returns 카멜 케이스 문자열열
 */
export const convertSnakeCaseToCamelCase = (str: string): string => {
  const words = str.split("_");
  const camelCaseWord = words
    .map((word, index) => {
      if (index === 0) {
        return word;
      }
      const firstLetterCap = word.charAt(0).toUpperCase();
      const remainingLetters = word.slice(1);
      return firstLetterCap + remainingLetters;
    })
    .join("");

  return camelCaseWord;
};

/**
 * 객체나 배열 내의 모든 키를 스네이크 케이스에서 카멜 케이스로 변환
 *
 * @param data - 키 변환을 수행할 데이터
 * @returns 카멜 케이스로 변환된 새 데이터
 */
export const convertKeysToCamelCase = (data: any): any => {
  if (Array.isArray(data)) {
    return data.map((item) => convertKeysToCamelCase(item));
  } else if (data !== null && typeof data === "object") {
    const newObj: any = {};
    Object.keys(data).forEach((key) => {
      const newKey = convertSnakeCaseToCamelCase(key);
      newObj[newKey] = convertKeysToCamelCase(data[key]);
    });
    return newObj;
  }
  return data;
};
