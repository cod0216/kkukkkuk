import React from "react";
import { FaPaw } from "react-icons/fa";
import { useDispatch, useSelector } from "react-redux";
import { RootState } from "@/redux/store";
import { logout as logoutApi } from "@/services/authService";
import { clearAccessToken } from "@/redux/store";
import { removeRefreshToken } from "@/utils/iDBUtil";
import { useNavigate } from "react-router-dom";
import useAppNavigation from "@/hooks/useAppNavigation"

/**
 * @module Header
 * @file Header.tsx
 * @author eunchang
 * @date 2025-03-26
 * @description 상단에 헤더를 표시하는 모듈입니다.
 *
 * 이 모듈은 해더를 보여줍니다.
 *
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-26        haelim           최초 생성
 * 2025-03-26        eunchang         로그아웃 버튼 생성
 * 2025-03-27        eunchang         로그인 표시 및 토큰 미 존재 시 리다이렉션
 * 2025-03-28        eunchang         토큰 name으로 사용자 이름 표시
 * 2025-03-30        sangmuk          헤더 병원 이름 클릭 시 마이페이지로 이동하도록 수정
 */

const Header: React.FC = () => {
  const dispatch = useDispatch();
  const navigate = useNavigate();
  const accessToken = useSelector((state: RootState) => state.auth.accessToken);

  const { goToMyPage } = useAppNavigation()

  const decodeTokenPayload = (token: string) => {
    try {
      const payloadBase64 = token.split(".")[1];
      const decoded = decodeURIComponent(
        atob(payloadBase64)
          .split("")
          .map((c) => "%" + ("00" + c.charCodeAt(0).toString(16)).slice(-2))
          .join("")
      );
      return JSON.parse(decoded);
    } catch (error) {
      console.error("Token decoding failed", error);
      return null;
    }
  };

  let userName = "사용자";
  if (accessToken) {
    const payload = decodeTokenPayload(accessToken);
    if (payload && payload.name) {
      userName = payload.name;
    }
  }

  const handleLogout = async () => {
    try {
      await logoutApi();
      dispatch(clearAccessToken());
      await removeRefreshToken();
      navigate("/login");
    } catch (error) {
      console.error(error);
    }
  };

  return (
    <header className="bg-white border border-gray-100 border-2 py-1">
      <div className="container mx-auto px-3 py-2 flex justify-between items-center">
        <div className="flex items-center cursor-pointer">
          <FaPaw className="text-primary-500 text-2xl mr-2" />
          <div className="text-xl font-bold text-primary-500">KKUK KKUK</div>
        </div>
        <div className="flex items-center space-x-4">
          <div className="text-sm font-medium cursor-pointer" onClick={goToMyPage}>{userName}</div>
          {accessToken ? (
            <button
              onClick={handleLogout}
              className="px-2 py-1 border rounded-md text-xs font-medium text-nowrap w-20 justify-center hover:bg-neutral-200"
            >
              로그아웃
            </button>
          ) : (
            <button
              onClick={() => navigate("/login")}
              className="px-2 py-1 border rounded-md text-xs font-medium text-nowrap w-20 justify-center hover:bg-neutral-200"
            >
              로그인
            </button>
          )}
        </div>
      </div>
    </header>
  );
};

export default Header;
