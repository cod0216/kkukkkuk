/**
 * @module SideBar
 * @file SideBar.tsx
 * @author sangmuk
 * @date 2025-03-30
 * @description 마이페이지의 사이드바 컴포넌트입니다.
 *
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-30        sangmuk         최초 생성
 */

import { NavLink } from "react-router-dom"

function SideBar() {
  const menuItems = [
    { path: "/my-page", label: "회원정보", end: true },
    { path: "edit-profile", label: "회원정보 수정", end: false },
    { path: "doctor-management", label: "의료진 관리", end: false },
  ]

  return (
    <nav className="p-4">
      <ul>
        {menuItems.map((item) => (
          <li key={item.path} className="mb-2">
            <NavLink
              to={item.path}
              end={item.end}
              className={({ isActive }) =>
                `block w-full text-left px-4 py-2 rounded hover:bg-primary-100 ${
                  isActive ? "bg-primary-100 font-semibold" : ""
                }`
              }
            >
            {item.label}
          </NavLink>
        </li>
        ))}
      </ul>
    </nav>
  )
}

export default SideBar