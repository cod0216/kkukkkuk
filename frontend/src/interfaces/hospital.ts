/**
 * @module hospital
 * @file hospital.ts
 * @author eunchang
 * @date 2025-03-26
 * @description 병원 도메인 전용 인터페이스 모듈입니다.
 *
 * 동물병원 서비스 구현시 필요한 인터페이스들을 정의합니다.
 *
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-26        eunchang         최초 생성
 */

/**
 * Hospital Base Info interface
 */
export interface HospitalBase {
  id: number;
  name?: string;
  address?: string;
  phone_number?: string;
  authorization_number?: string;
  x_axis?: number;
  y_axis?: number;
}

/**
 * Hospital Detail Info Interface
 */
export interface HospitalDetail extends HospitalBase {
  phone_number?: string;
  did?: string;
  account?: string;
  password?: string;
  public_key?: string;
  delete_date?: string;
  email?: string;
  doctor_name?: string;
}
