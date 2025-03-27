/**
 * @module types
 * @file types.tsx
 * @author eunchang
 * @date 2025-03-26
 * @description
 *
 *
 *
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-26        eunchang         최초 생성
 */

/**
 *
 */
export enum ResponseStatus {
  SUCCESS = "SUCCESS",
  FAILURE = "FAILURE",
}

/**
 *
 */
export enum ResponseCode {
  OK = 200,
  BAD_REQUEST = 400,
  UNAUTHORIZED = 401,
  FORBIDDEN = 403,
  NOT_FOUND = 404,
  INTERNAL_SERVER_ERROR = 500,
}

/**
 *
 */
export interface ApiResponse<T> {
  status: ResponseStatus;
  message: string;
  data: T | null;
}

/**
 *
 */
export interface ErrorResponse extends ApiResponse<null> {
  code?: string;
  http_code?: ResponseCode;
}

/**
 *
 */
export enum StorageKey {
  ACCESSTOKEN = "accesstoken",
  REFRESHTOKEN = "refreshtoken",
  USER = "user",
  HOSPITAL = "hospital",
}
