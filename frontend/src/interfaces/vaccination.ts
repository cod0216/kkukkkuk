/**
 * @module Vaccination
 * @file vaccination.ts
 * @author eunchang
 * @date 2025-04-09
 * @description 백신 접종 관련 인터페이스 모듈입니다.
 *
 * 백신 접종 관련 인터페이스를 모아서 관리합니다.
 *
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-04-09        eunchang         최초 생성
 */
import { ApiResponse } from "@/types";

export interface Vaccination {
  id: number;
  name: string;
  hospitalId: string;
}

export interface VaccinationResponse extends ApiResponse<Vaccination | null> {}

export interface VaccinationListResponse extends ApiResponse<Vaccination[]> {}

export interface AutoCorrectVaccinationResponse extends ApiResponse<string[]> {}

export interface VaccinationRequest {
  name: string;
}
