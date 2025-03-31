/**
 * @module EditProfile
 * @file EditProfile.tsx
 * @author sangmuk
 * @date 2025-03-30
 * @description 회원정보 수정 컴포넌트입니다.
 *
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-30        sangmuk         최초 생성
 * 2025-03-31        sangmuk         회원정보 수정 시 헤더의 병원 이름이 같이 변경되도록 수정
 */

import { useState, useEffect } from 'react'
import { request } from "@/services/apiRequest"
import { ApiResponse, ResponseStatus } from "@/types"
import { HospitalDetail } from "@/interfaces"
import { useDispatch } from "react-redux"
import { setHospital } from "@/redux/store"

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

interface EditProfilePayload {
  name?: string
  phoneNumber?: string
  password?: string
}

/**
 * 회원정보 수정을 처리하는 컴포넌트입니다.
 * @returns 
 */
function EditProfile() {
  const [formData, setFormData] = useState<EditProfilePayload>({})
  const [initialData, setInitialData] = useState<LocalHospital | null>(null)
  const [loading, setLoading] = useState<boolean>(true)
  const [error, setError] = useState<string | null>(null)
  const [successMessage, setSuccessMessage] = useState<string | null>(null)

  const dispatch = useDispatch()

  useEffect(() => {
    const fetchInitialData = async () => {
      setLoading(true)
      setError(null)
      const response: ApiResponse<LocalHospital> = await request.get("/api/hospitals/me")

      if (response.status === ResponseStatus.SUCCESS && response.data) {
        setInitialData(response.data)
        setFormData({
          name: response.data.name,
          phoneNumber: response.data.phoneNumber,
        })
      } else {
        setError(response.message || "정보를 불러오는데 실패했습니다.")
      }
      setLoading(false)
    }
    fetchInitialData()
  }, [])

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target
    setFormData(prev => ({ ...prev, [name]: value }))
  }

  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
     e.preventDefault()
     setError(null)
     setSuccessMessage(null)

     const payload: EditProfilePayload = {}
     if (formData.name !== initialData?.name) payload.name = formData.name
     if (formData.phoneNumber !== initialData?.phoneNumber) payload.phoneNumber = formData.phoneNumber
     if (formData.password && formData.password.length > 0) payload.password = formData.password

     if (Object.keys(payload).length === 0) {
       setError("변경된 내용이 없습니다.")
       return
     }


     const response: ApiResponse<LocalHospital> = await request.patch("/api/hospitals/me", payload)

     if (response.status === ResponseStatus.SUCCESS) {
        setSuccessMessage(response.message || "정보가 성공적으로 수정되었습니다.")
        if(response.data) {
          setInitialData(response.data)
          setFormData({
             name: response.data.name,
             phoneNumber: response.data.phoneNumber,
             password: ""
          })

          const hospitalForDispatch: HospitalDetail = {
            id: response.data.id,
            email: response.data.email,
            name: response.data.name,
            phone_number: response.data.phoneNumber,
            account: response.data.account,
            address: response.data.address,
            public_key: response.data.publicKey,
            authorization_number: response.data.authorizationNumber,
            doctor_name: response.data.doctorName,
            x_axis: response.data.xaxis,
            y_axis: response.data.yaxis,
          }
          dispatch(setHospital(hospitalForDispatch))
        }
     } else {
       setError(response.message || "정보 수정에 실패했습니다.")
     }
  }


  if (loading) return <div>로딩 중...</div>
  if (error && !initialData) return <div className="text-secondary-500">{error}</div>


  return (
    <div>
      <h2 className="text-2xl font-bold mb-4">회원정보 수정</h2>
      {error && <div className="mb-4 text-secondary-500">{error}</div>}
      {successMessage && <div className="mb-4 text-primary-500">{successMessage}</div>}

      <form onSubmit={handleSubmit} className="space-y-4">
        <div>
          <label htmlFor="name" className="block text-sm font-medium text-neutral-600">병원 이름</label>
          <input
             type="text"
             id="name"
             name="name"
             value={formData.name || ''}
             onChange={handleChange}
             className="mt-1 block w-fit min-w-[400px] px-3 py-2 border border-neutral-200 rounded"
          />
        </div>
        <div>
          <label htmlFor="phoneNumber" className="block text-sm font-medium text-neutral-600">전화번호</label>
          <input
             type="text"
             id="phoneNumber"
             name="phoneNumber"
             value={formData.phoneNumber || ''}
             onChange={handleChange}
             className="mt-1 block w-fit min-w-[400px] px-3 py-2 border border-neutral-200 rounded"
          />
        </div>
        <div>
          <label htmlFor="password" className="block text-sm font-medium text-neutral-600">비밀번호 확인</label>
          <input
            type="password"
            id="password"
            name="password"
            value={formData.password || ''}
            onChange={handleChange}
            className="mt-1 block w-fit min-w-[400px] px-3 py-2 border border-neutral-200 rounded"
          />
        </div>
        <div className="flex justify-start pt-2">
          <button
            type="submit"
            className=" px-4 py-2 bg-primary-500 text-white rounded hover:bg-primary-600"
          >
            수정하기
          </button>
        </div>
      </form>
    </div>
  )
}

export default EditProfile