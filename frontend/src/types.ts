/**
 * API status code SUCCESS or FAILURE
 */
export enum ResponseStatus {
  SUCCESS = "SUCCESS",
  FAILURE = "FAILURE",
}

/**
 * API RESPONSE HTTP CODE ENUM
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
 * API DTO SUCCESS RESPONSE
 */
export interface ApiResponse<T> {
  status: ResponseStatus;
  message: string;
  data: T | null;
}

/**
 * API DTO FAILURE RESPONSE
 */
export interface ErrorResponse extends ApiResponse<null> {
  code?: string;
  http_code?: ResponseCode;
}

/**
 * Storage Key Eunm
 */
export enum StorageKey {
  ACCESS_TOKEN = "accesstoken",
  REFRESHTOKEN = "refreshtoken",
  USER = "user",
  HOSPITAL = "hospital",
}
