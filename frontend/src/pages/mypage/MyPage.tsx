/**
 * @module MyPage
 * @file MyPage.tsx
 * @author sangmuk
 * @date 2025-03-30
 * @description 마이페이지 레이아웃 컴포넌트입니다.
 *
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-30        sangmuk         최초 생성
 * 2025-04-02        seonghun        헤더 높이 80px로 변경하고 calc(100vh - 80px)로 변경
 */

import SideBar from "./SideBar"
import { Outlet } from "react-router-dom"

/**
 * 마이 페이지 레이아웃에 관한 컴포넌트입니다.
 * @returns 
 */
function MyPage() {
  return (
    <div className="w-full flex">
      <div className="w-1/5 border-r border-neutral-200 flex-shrink-0 min-h-[calc(100vh-80px)]"> {/* 헤더 높이가 80px라고 가정 */}
        <h1 className="text-xl font-bold p-8 border-b border-neutral-200">
          마이페이지
        </h1>
        <SideBar />
      </div>
      <div className="w-4/5 p-8 overflow-y-auto">
        <Outlet />
      </div>
    </div>
  )
}

export default MyPage