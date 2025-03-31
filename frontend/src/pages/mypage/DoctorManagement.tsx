/**
 * @module DoctorManagement
 * @file DoctorManagement.tsx
 * @author sangmuk
 * @date 2025-03-30
 * @description 의료진 관리 컴포넌트입니다.
 *
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-30        sangmuk         최초 생성
 */

import { useState, useEffect } from "react"
import { request } from "@/services/apiRequest"
import { ApiResponse, ResponseStatus } from "@/types"
import { Doctor } from "@/interfaces"

/**
 * 의료진을 관리하는 페이지의 컴포넌트입니다.
 * @returns 
 */
function DoctorManagement() {
  const [doctors, setDoctors] = useState<Doctor[]>([])
  const [loading, setLoading] = useState<boolean>(true)
  const [error, setError] = useState<string | null>(null)
  const [newDoctorName, setNewDoctorName] = useState<string>("")

  const [editingDoctorId, setEditingDoctorId] = useState<number | null>(null)
  const [editingDoctorName, setEditingDoctorName] = useState<string>("")

  /**
   * @function
   * 의료진 목록을 불러오는 함수입니다.
   */
  const fetchDoctors = async () => {
    setLoading(true)
    setError(null)
    const response: ApiResponse<Doctor[]> = await request.get(
      "/api/hospitals/me/doctors"
    )

    if (response.status === ResponseStatus.SUCCESS && response.data) {
      setDoctors(response.data)
    } else {
      setError(response.message || "의료진 목록을 불러오는데 실패했습니다.")
      setDoctors([])
    }
    setLoading(false)
  }

  useEffect(() => {
    fetchDoctors()
  }, [])

  /**
   * @function
   * 의사를 추가하는 함수입니다.
   */
  const handleAddDoctor = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault()
    if (!newDoctorName.trim()) {
      setError("의사 이름을 입력해주세요.")
      return
    }
    setError(null)

    const requestPayload: Omit<Doctor, 'id'> = { name: newDoctorName.trim() }
    const response: ApiResponse<Doctor> = await request.post(
      "/api/hospitals/me/doctors",
      requestPayload
    )

    if (response.status === ResponseStatus.SUCCESS && response.data) {
      fetchDoctors()
      setNewDoctorName("")
    } else {
      setError(response.message || "의사 등록에 실패했습니다.")
    }
  }

  /**
   * @function
   * 의사를 목록에서 삭제하는 함수입니다.
   */
  const handleDeleteDoctor = async (doctorId: number) => {
    if (!window.confirm("정말로 이 의사를 삭제하시겠습니까?")) {
      return
    }
    setError(null)

    const response: ApiResponse<null> = await request.delete(
      `/api/doctors/${doctorId}`
    )

    if (response.status === ResponseStatus.SUCCESS) {
      fetchDoctors()
    } else {
      setError(response.message || "의사 삭제에 실패했습니다.")
    }
  }

  /**
   * 의사 정보 수정을 시작하고 초기 데이터를 설정하는 함수입니다.
   * @param doctor 
   */
  const handleEditStart = (doctor: Doctor) => {
    setEditingDoctorId(doctor.id)
    setEditingDoctorName(doctor.name)
    setError(null)
  }

  /**
   * 의사 정보 수정을 취소
   */
  const handleEditCancel = () => {
    setEditingDoctorId(null)
    setEditingDoctorName("")
  }

  /**
   * 의사 이름 수정 입력 필드의 변경 이벤트를 처리하는 이벤트 핸들러 함수입니다.
   * @param e 
   */
  const handleNameChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setEditingDoctorName(e.target.value)
  }

  /**
   * @function
   * 의사 정보를 수정하는 함수입니다.
   */
  const handleUpdateDoctor = async (doctorId: number) => {
    if (!editingDoctorName.trim()) {
      setError("의사 이름을 입력해주세요.")
      return
    }
    setError(null)

    const payload = { name: editingDoctorName.trim() }
    const response: ApiResponse<Doctor> = await request.put(
      `/api/doctors/${doctorId}`,
      payload
    )

    if (response.status === ResponseStatus.SUCCESS && response.data) {
      fetchDoctors()
      handleEditCancel()
    } else {
      setError(response.message || "의사 정보 수정에 실패했습니다.")
    }
  }

  if (loading) return <div>로딩 중...</div>

  return (
    <div>
      <h2 className="text-2xl font-bold mb-4">의료진 관리</h2>

      {error && <div className="mb-4 text-secondary-500">{error}</div>}

      <form
        onSubmit={handleAddDoctor}
        className="mb-6 flex items-center space-x-2 w-fit min-w-[400px] min-h-[42px]"
      >
        <input
          type="text"
          value={newDoctorName}
          onChange={(e) => setNewDoctorName(e.target.value)}
          placeholder="의사의 이름을 입력해주세요"
          className="flex-grow px-3 py-2 border border-neutral-300 rounded"
          disabled={editingDoctorId !== null}
        />
        <button
          type="submit"
          className="px-4 py-2 bg-primary-500 text-white rounded hover:bg-primary-600"
          disabled={editingDoctorId !== null}
        >
          등록
        </button>
      </form>

      <h3 className="text-xl font-semibold mb-2">등록된 의료진</h3>
      {doctors.length > 0 ? (
        <ul className="space-y-2">
          {doctors.map((doctor) => (
            <li
              key={doctor.id}
              className="w-fit min-w-[400px] min-h-[42px] flex justify-between items-center p-3 border rounded bg-white"
            >
              {editingDoctorId === doctor.id ? (
                <>
                  <input
                    type="text"
                    value={editingDoctorName}
                    onChange={handleNameChange}
                    className="flex-grow px-2 py-1 mr-2 border rounded"
                    autoFocus
                  />
                  <div className="flex space-x-1">
                    <button
                      onClick={() => handleUpdateDoctor(doctor.id)}
                      className="px-3 py-1 bg-primary-500 text-white text-xs rounded hover:bg-primary-600 focus:outline-none"
                    >
                      저장
                    </button>
                    <button
                      onClick={handleEditCancel}
                      className="px-3 py-1 bg-neutral-500 text-white text-xs rounded hover:bg-neutral-600 focus:outline-none"
                    >
                      취소
                    </button>
                  </div>
                </>
              ) : (
                <>
                  <span className="text-neutral-600">
                    {doctor.name}
                  </span>
                  <div className="flex space-x-1">
                    <button
                      onClick={() => handleEditStart(doctor)}
                      className="px-3 py-1 bg-primary-500 text-white text-xs rounded hover:bg-primary-600 focus:outline-none"
                    >
                      수정
                    </button>
                    <button
                      onClick={() => handleDeleteDoctor(doctor.id)}
                      className="px-3 py-1 bg-secondary-500 text-white text-xs rounded hover:bg-secondary-600 focus:outline-none"
                    >
                      삭제
                    </button>
                  </div>
                </>
              )}
            </li>
          ))}
        </ul>
      ) : (
        <p className="text-neutral-500">등록된 의료진이 없습니다.</p>
      )}
    </div>
  )
}

export default DoctorManagement
