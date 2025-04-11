/**
 * @module doctor
 * @file doctor.ts
 * @author haelim
 * @date 2025-03-26
 * @description 의사 데이터 관련 타입과 인터페이스를 정의한 모듈입니다.
 *
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-26        haelim           최초 생성
 */

/**
 * 병원의 의사 정보를 나타내는 인터페이스입니다.
 * @interface
 */
export interface Doctor {
    id : number,
    name : string
}