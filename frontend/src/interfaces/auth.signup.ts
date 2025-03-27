/**
 * @module SignUpRequest
 * @file auth.signup.ts
 * @author sangmuk
 * @date 2025-03-26
 * @description 회원가입 요청 객체 구조입니다.
 *
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-26        sangmuk         최초 생성
 */

/**
 * signup request interface
 * @interface
 */
export interface SignUpRequest {
  account: string
  password: string
  email: string
  id: number | string
  doctorName: string
}
