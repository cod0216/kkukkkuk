/**
 * @module ViewProfile
 * @file ViewProfile.tsx
 * @author sangmuk
 * @date 2025-03-30
 * @description 회원정보 조회 컴포넌트입니다.
 *
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-30        sangmuk         최초 생성
 */

import { useEffect, useState } from "react"
import { request } from "@/services/apiRequest"
import { ApiResponse, ResponseStatus } from "@/types"
// import { HospitalDetail } from "@/interfaces"

// interfaces/hospital.ts의 snakecase 문자열 처리 이슈 ?
interface LocalHospital {
  id: number;
  name?: string;
  address?: string;
  phoneNumber?: string;
  authorizationNumber?: string;
  xaxis?: number;
  yaxis?: number;
  did?: string;
  account?: string;
  password?: string;
  publicKey?: string;
  deleteDate?: string;
  email?: string;
  doctorName?: string;
}

function ViewProfile() {
  const [hospitalInfo, setHospitalInfo] = useState<LocalHospital | null>(null)
  const [loading, setLoading] = useState<boolean>(true)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    /**
     * 병원의 정보를 불러오는 함수입니다.
     */
    const fetchHospitalInfo = async () => {
      setLoading(true)
      setError(null)
      const response: ApiResponse<LocalHospital> = await request.get(
        "/api/hospitals/me"
      )

      if (response.status === ResponseStatus.SUCCESS && response.data) {
        setHospitalInfo(response.data)
      } else {
        setError(response.message || "병원 정보를 불러오는데 실패했습니다.")
      }
      setLoading(false)
    }

    fetchHospitalInfo()
  }, [])

  if (loading) {
    return <div>로딩 중...</div>
  }

  if (error) {
    return <div className="text-secondary-500">{error}</div>
  }

  if (!hospitalInfo) {
    return <div>병원 정보를 찾을 수 없습니다.</div>
  }

  return (
    <div>
      <h2 className="text-2xl font-bold mb-4">회원정보</h2>
      <div className="space-y-4 bg-white">
        <div>
          <label className="block text-sm font-medium text-neutral-600">
            병원 이름
          </label>
          <p className="mt-1 w-full px-3 py-2 border border-neutral-200 rounded text-neutral-600 min-h-[42px] flex items-center">
            {hospitalInfo.name ?? <span className="text-neutral-400">정보 없음</span>}
          </p>
        </div>
        <div>
          <label className="block text-sm font-medium text-neutral-600">
            계정
          </label>
          <p className="mt-1 w-full px-3 py-2 border border-neutral-200 rounded text-neutral-600 min-h-[42px] flex items-center">
            {hospitalInfo.account ?? <span className="text-neutral-400">정보 없음</span>}
          </p>
        </div>
        <div>
          <label className="block text-sm font-medium text-neutral-600">
            주소
          </label>
          <p className="mt-1 w-full px-3 py-2 border border-neutral-200 rounded text-neutral-600 min-h-[42px] flex items-center">
            {hospitalInfo.address ?? <span className="text-neutral-400">정보 없음</span>}
          </p>
        </div>
        <div>
          <label className="block text-sm font-medium text-neutral-600">
            전화번호
          </label>
          <p className="mt-1 w-full px-3 py-2 border border-neutral-200 rounded text-neutral-600 min-h-[42px] flex items-center">
            {hospitalInfo.phoneNumber ?? <span className="text-neutral-400">정보 없음</span>}
          </p>
        </div>
        <div>
          <label className="block text-sm font-medium text-neutral-600">
            병원 인허가 번호
          </label>
          <p className="mt-1 w-full px-3 py-2 border border-neutral-200 rounded text-neutral-600 min-h-[42px] flex items-center">
            {hospitalInfo.authorizationNumber ?? <span className="text-neutral-400">정보 없음</span>}
          </p>
        </div>
      </div>
    </div>
  )
}

export default ViewProfile
