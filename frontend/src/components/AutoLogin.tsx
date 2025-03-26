// AutoLogin.tsx
import React, { useEffect, useState } from "react";
import { useDispatch } from "react-redux";
import { setAccessToken, setHospital, clearAccessToken } from "@/redux/store";
import {
  getRefreshToken,
  setRefreshtoken,
  removeRefreshToken,
} from "@/utils/iDBUtil";
import { refreshToken } from "@/services/authService";

interface AutoLoginProps {
  children: React.ReactNode;
}

const AutoLogin = ({ children }: AutoLoginProps) => {
  const dispatch = useDispatch();
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const autoLogin = async () => {
      const storedRefreshToken = await getRefreshToken();
      if (storedRefreshToken) {
        try {
          const response = await refreshToken({
            refreshToken: storedRefreshToken,
          });
          if (response.status === "SUCCESS" && response.data) {
            const {
              tokens: { accessToken, refreshToken: newRefreshToken },
              hospital,
            } = response.data;

            dispatch(setAccessToken(accessToken));
            dispatch(setHospital(hospital));
            await setRefreshtoken(newRefreshToken);
          } else {
            dispatch(clearAccessToken());
            await removeRefreshToken();
          }
        } catch (error) {
          console.error("자동 로그인 실패", error);
          dispatch(clearAccessToken());
          await removeRefreshToken();
        }
      }
      setLoading(false);
    };

    autoLogin();
  }, [dispatch]);

  if (loading) {
    return <div>자동 로그인 처리 중...</div>;
  }

  return <>{children}</>;
};

export default AutoLogin;
