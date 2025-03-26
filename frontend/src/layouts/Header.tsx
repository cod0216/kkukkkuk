import React, { useEffect, useState } from "react";
import { FaPaw } from "react-icons/fa";
import { useDispatch, useSelector } from "react-redux";
import { RootState } from "@/redux/store";
import { logout as logoutApi, refreshToken } from "@/services/authService";
import { setAccessToken, clearAccessToken } from "@/redux/store";
import {
  getRefreshToken,
  setRefreshtoken,
  removeRefreshToken,
} from "@/utils/iDBUtil";
import { useNavigate } from "react-router-dom";
import { ResponseStatus } from "@/types";

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
 */

const Header: React.FC = () => {
  const dispatch = useDispatch();
  const navigate = useNavigate();
  const hospital = useSelector((state: RootState) => state.auth.hospital);
  const accessToken = useSelector((state: RootState) => state.auth.accessToken);
  const [refreshAttempted, setRefreshAttempted] = useState(false);

  // 만약 accessToken이 없으면 IndexedDB에서 refreshToken을 꺼내서 재발급 시도
  useEffect(() => {
    const checkAndRefresh = async () => {
      if (!accessToken && !refreshAttempted) {
        const storedRefreshToken = await getRefreshToken();
        if (storedRefreshToken) {
          try {
            const response = await refreshToken({
              refreshToken: storedRefreshToken,
            });
            if (response.status === ResponseStatus.SUCCESS && response.data) {
              // refreshToken API 응답 구조에 맞게 새 토큰을 구조 분해합니다.
              const {
                accessToken: newAccessToken,
                refreshToken: newRefreshToken,
              } = response.data;
              dispatch(setAccessToken(newAccessToken));
              // hospital 정보는 로그인 시 설정되었거나 별도 로직으로 처리 가능하므로 여기선 토큰만 업데이트
              await setRefreshtoken(newRefreshToken);
            } else {
              dispatch(clearAccessToken());
              await removeRefreshToken();
              navigate("/");
            }
          } catch (error) {
            console.error("헤더에서 토큰 재발급 실패", error);
            dispatch(clearAccessToken());
            await removeRefreshToken();
            navigate("/");
          } finally {
            setRefreshAttempted(true);
          }
        } else {
          dispatch(clearAccessToken());
          navigate("/");
        }
      }
    };

    checkAndRefresh();
  }, [accessToken, dispatch, navigate, refreshAttempted]);

  const handleLogout = async () => {
    try {
      await logoutApi();
      dispatch(clearAccessToken());
      await removeRefreshToken();
      navigate("/");
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
          <div className="text-sm font-medium">
            {hospital ? hospital.name : "사용자"}
          </div>
          <button
            onClick={handleLogout}
            className="px-2 py-1 border rounded-md text-xs font-medium text-nowrap w-20 justify-center hover:bg-neutral-200"
          >
            로그아웃
          </button>
        </div>
      </div>
    </header>
  );
};

export default Header;
