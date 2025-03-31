/**
 * @module DeleteAccount
 * @file DeleteAccount.tsx
 * @author sangmuk
 * @date 2025-03-31
 * @description 회원탈퇴 기능을 작성한 컴포넌트입니다.
 *
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-31        sangmuk         최초 생성
 */

import { useState } from "react"
import { request } from "@/services/apiRequest"
import { ResponseStatus } from "@/types"
import { useDispatch } from "react-redux"
import { clearAccessToken } from "@/redux/store"
import { removeRefreshToken } from "@/utils/iDBUtil"
import useAppNavigation from "@/hooks/useAppNavigation"

/**
 * 회원탈퇴 기능을 관리하는 컴포넌트 입니다.
 * @returns
 */
function DeleteAccount () {
  const [isModalOpen, setIsModalOpen] = useState(false)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)

  const dispatch = useDispatch()
  const { goToLogin } = useAppNavigation()

  const openModal = () => {
    setError(null)
    setIsModalOpen(true)
  }
  const closeModal = () => setIsModalOpen(false)

  /**
   * 회원탈퇴를 진행합니다.
   */
  const handleDeleteAccount = async () => {
    setLoading(true)
    setError(null)

    const response = await request.delete("/api/hospitals/me")

    if (response.status === ResponseStatus.SUCCESS) {
      dispatch(clearAccessToken())
      await removeRefreshToken()
      goToLogin()
    } else {
      setError("회원탈퇴 처리 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.")
      setLoading(false)
    }
  }
  
  /**
   * 모달 컨텐츠 내부 클릭 시 이벤트 버블링을 방지합니다.
   * @param e 
   */
  const handleContentClick = (e: React.MouseEvent<HTMLDivElement>) => {
    e.stopPropagation()
  }

  return (
    <div className="mt-4">
      <p className="w-fit text-sm text-neutral-500 cursor-pointer" onClick={openModal} role="button">회원탈퇴</p>
      {error && <div className="mt-1 text-sm text-red-500">{error}</div>}

      {isModalOpen && (
        <div className="fixed inset-0 flex items-center justify-center bg-black bg-opacity-50 z-50" onClick={closeModal}>
          <div className="bg-white p6 rounded-md shadow-xl max-w-md w-full p-4" onClick={handleContentClick}>
            <h4 className="text-lg font-bold mb-4">회원탈퇴</h4>
            <p className="mb-4 text-md">정말 탈퇴하시겠습니까? 이 작업은 돌이킬 수 없습니다.</p>
            <div className="flex justify-end space-x-2">
              <button
                type="button"
                onClick={closeModal}
                className="px-4 py-2 text-md bg-neutral-200 rounded-md hover:bg-neutral:300"
                disabled={loading}
              >
                취소
              </button>
              <button
                type="button"
                onClick={handleDeleteAccount}
                className="px-4 py-2 text-md bg-red-500 text-white rounded-md hover:bg-red-600"
                disabled={loading}
              >
                {loading ? "탈퇴 처리 중.." : "탈퇴하기"}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}

export default DeleteAccount
