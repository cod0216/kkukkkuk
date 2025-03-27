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
              const {
                accessToken: newAccessToken,
                refreshToken: newRefreshToken,
              } = response.data;
              dispatch(setAccessToken(newAccessToken));
              await setRefreshtoken(newRefreshToken);
            } else {
              dispatch(clearAccessToken());
              await removeRefreshToken();
              navigate("/Login");
            }
          } catch (error) {
            console.error("헤더에서 토큰 재발급 실패", error);
            dispatch(clearAccessToken());
            await removeRefreshToken();
            navigate("/Login");
          } finally {
            setRefreshAttempted(true);
          }
        } else {
          dispatch(clearAccessToken());
          navigate("Login");
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
