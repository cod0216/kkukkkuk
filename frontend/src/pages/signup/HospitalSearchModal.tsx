/**
 * @module HospitalSearchModal
 * @file HospitalSearchModal.tsx
 * @author sangmuk
 * @date 2025-03-26
 * @description 병원 검색 모달 컴포넌트입니다.
 *
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-26        sangmuk         병원 검색 모달 컴포넌트 작성
 */

import { useState } from 'react'
import axios from 'axios'
import { HospitalBase } from '@/interfaces'

/**
 * 병원 검색 모달 컴포넌트 속성 타입
 * @interface
 */
interface HospitalSearchModalProps {
  isOpen: boolean
  onClose: () => void
  onSelect: (hospital: HospitalBase) => void
}

const BASE_URL = import.meta.env.VITE_BASE_URL
const SEARCH_HOSPITAL_ENDPOINT = '/api/hospitals/name/'

/**
 * 병원 검색 모달 컴포넌트
 * @param {object} props - 컴포넌트 프롭스
 * @param {boolean} props.isOpen - 모달 열림 상태
 * @param {Function} props.onClose - 모달 닫기 콜백
 * @param {Function} props.onSelect - 병원 선택 시 콜백
 * @returns {JSX.Element | null} 모달 컴포넌트 또는 null
 */
function HospitalSearchModal({ isOpen, onClose, onSelect }: HospitalSearchModalProps) {
  const [searchQuery, setSearchQuery] = useState('')
  const [hospitals, setHospitals] = useState<HospitalBase[]>([])
  const [isLoading, setIsLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)

  /**
   * 모달 배경 클릭 시 모달을 닫는 핸들러
   * @param {React.MouseEvent<HTMLDivElement>} e - 클릭 이벤트
   */
  const handleBackdropClick = (e: React.MouseEvent<HTMLDivElement>) => {
    if (e.target === e.currentTarget) {
      onClose();
    }
  };

  /**
   * 병원 검색을 실행하는 핸들러
   * @returns {Promise<void>}
   */
  const handleSearch = async () => {
    if (!searchQuery.trim()) {
      setError('병원 이름을 입력해주세요.')
      return
    }

    setIsLoading(true)
    setError(null)

    try {
      const response = await axios.get(`${BASE_URL}${SEARCH_HOSPITAL_ENDPOINT}${encodeURIComponent(searchQuery)}`)
      if (response.data.status === 'SUCCESS') {
        setHospitals(response.data.data)
      } else {
        setError('병원 검색에 실패했습니다.')
      }
    } catch (error) {
      console.error('병원 검색 실패', error)
      setError('병원 검색 중 오류가 발생했습니다.')
    } finally {
      setIsLoading(false)
    }
  }

  /**
   * 검색창에서 엔터키 입력 시 검색 실행
   * @param {React.KeyboardEvent<HTMLInputElement>} e - 키보드 이벤트
   */
  const handleKeyDown = (e: React.KeyboardEvent<HTMLInputElement>) => {
    if (e.key === 'Enter') {
      handleSearch();
    }
  };

  const handleSelectHospital = (hospital: HospitalBase) => {
    onSelect(hospital)
    onClose()
  }

  if (!isOpen) return null

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50" onClick={handleBackdropClick}>
      <div className="bg-white p-6 rounded w-full max-w-lg max-h-[80vh] overflow-y-auto">
        <h2 className="text-xl font-bold mb-4">동물병원 검색</h2>
        
        <div className="flex gap-2 mb-4">
          <input
            type="text"
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            onKeyDown={handleKeyDown}
            placeholder="병원 이름을 입력하세요"
            className="flex-1 p-2 border rounded"
          />
          <button
            onClick={handleSearch}
            className="px-4 py-2 bg-primary-400 text-white rounded"
            disabled={isLoading}
          >
            {isLoading ? '검색 중...' : '검색'}
          </button>
        </div>
        
        {error && <p className="text-secondary-500 mb-4">{error}</p>}
        
        {hospitals.length > 0 ? (
          <div className="border rounded divide-y">
            {hospitals.map((hospital) => (
              <div
                key={hospital.id}
                className="p-3 hover:bg-gray-100 cursor-pointer"
                onClick={() => handleSelectHospital(hospital)}
              >
                <p className="font-semibold">{hospital.name}</p>
                <p className="text-sm text-neutral-600">{hospital.address}</p>
                <p className="text-sm text-neutral-600">{hospital.phone_number}</p>
              </div>
            ))}
          </div>
        ) : (
          hospitals.length === 0 && !isLoading && !error && (
            <p className="text-center text-neutral-600">검색 결과가 없습니다.</p>
          )
        )}
        
        <div className="mt-4 flex justify-end">
          <button
            onClick={onClose}
            className="px-4 py-2 bg-neutral-300 text-neutral-600 rounded"
          >
            닫기
          </button>
        </div>
      </div>
    </div>
  )
}

export default HospitalSearchModal