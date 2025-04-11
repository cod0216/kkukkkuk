import { ApiResponse } from "@/types";

/**
 * @module Diagnosis
 * @file Diagnosis.ts
 * @author eunchang
 * @date 2025-03-26
 * @description 검사 관련 이터페이스 모듈입니다.
 *
 * 검사 관련 인터페이스를 모아서 관리합니다.
 *
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-04-09        eunchang         Diagnosis 추가
 */

/**
 * 진단 데이터 인터페이스
 *
 * @interface
 */
export interface Diagnosis {
  id: number;
  name: string;
  hospitalId: string;
}

/**
 * 단일 진단 응답 인터페이스
 *
 * @interface
 */
export interface DiagnosisResponse extends ApiResponse<Diagnosis | null> {}

/**
 * 진단목록 응답 인터페이스
 *
 * @interface
 */
export interface DiagnosisListResponse extends ApiResponse<Diagnosis[]> {}

/**
 * 자동완성 응답 인터페이스
 *
 * @interface
 */
export interface AutoCorrectDiagnosisResponse extends ApiResponse<string[]> {}
/**
 * 검사 생성/수정 요청 인터페이스
 *
 * @interface
 */
export interface DiagnosisRequest {
  name: string;
}
