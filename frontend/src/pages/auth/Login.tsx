import React, { useState } from "react";
import { FaPaw, FaEye, FaEyeSlash } from "react-icons/fa";
import { Link, useNavigate } from "react-router-dom";
import { useDispatch } from "react-redux";
import { login } from "@/services/authService";
import { setAccessToken, setHospital } from "@/redux/store";
import {
  setRefreshtoken,
  getRefreshToken,
  removeRefreshToken,
} from "@/utils/iDBUtil";
import { ResponseStatus } from "@/types";

/**
 * @module Login
 * @file Login.tsx
 * @author eunchang
 * @date 2025-03-26
 * @description 로그인 페이지 모듈 입니다.
 *
 * 이 모듈은 로그인 폼을 보여주고 로그인을 수행합니다.
 *
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-26        eunchang         최초 생성
 * 2025-03-26        eunchang         자동 로그인 체크박스
 */

const Login = () => {
  const dispatch = useDispatch();
  const navigate = useNavigate();

  const [account, setAccount] = useState("");
  const [password, setPassword] = useState("");
  const [showPassword, setShowPassword] = useState(false);
  const [rememberMe, setRememberMe] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    setError(null);
    setLoading(true);

    try {
      const response = await login({ account, password });
      if (response.status === ResponseStatus.SUCCESS && response.data) {
        const {
          tokens: { accessToken, refreshToken },
          hospital,
        } = response.data;

        dispatch(setAccessToken(accessToken));
        dispatch(setHospital(hospital));

        const existingRefreshToken = await getRefreshToken();
        if (existingRefreshToken) {
          await removeRefreshToken();
        }
        await setRefreshtoken(refreshToken);

        localStorage.setItem("autoLogin", rememberMe ? "true" : "false");

        navigate("/");
      } else {
        setError(response.message);
      }
    } catch (err) {
      setError("로그인 중 오류가 발생했습니다.");
    }
    setLoading(false);
  };

  /**
   * 비밀번호 표시 상태를 토글하는 함수
   * @returns {void}
   */
  const togglePasswordVisibility = () => {
    setShowPassword(!showPassword);
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
      <div className="max-w-sm text-center w-full space-y-8">
        <div className="flex flex-col items-center">
          <div className="flex items-center text-2xl justify-center">
            <FaPaw className="text-primary-500 text-2xl mr-2" />
            <div className="text-3xl font-bold text-primary-500">KKUK KKUK</div>
          </div>
        </div>
        <form className="mt-8 space-y-6" onSubmit={handleSubmit}>
          <div className="rounded-md shadow-sm space-y-4">
            <div>
              <input
                id="account"
                name="account"
                type="text"
                autoComplete="username"
                required
                value={account}
                onChange={(e) => setAccount(e.target.value)}
                className="appearance-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm"
                placeholder="아이디"
              />
            </div>
            <div className="relative">
              <input
                id="password"
                name="password"
                type={showPassword ? "text" : "password"}
                autoComplete="off"
                data-ms-reveal="false"
                required
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                className="appearance-none block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                placeholder="비밀번호"
              />
              <button
                type="button"
                onClick={togglePasswordVisibility}
                tabIndex={-1}
                aria-label={showPassword ? "비밀번호 숨기기" : "비밀번호 표시"}
                className="absolute right-3 top-1/2 transform -translate-y-1/2 text-neutral-500 hover:text-neutral-700 z-10"
              >
                {showPassword ? <FaEyeSlash /> : <FaEye />}
              </button>
            </div>
          </div>
          {error && <p className="mt-2 text-sm text-red-500">{error}</p>}
          <div className="flex items-center justify-between">
            <div className="flex items-center">
              <input
                id="remember-me"
                name="remember-me"
                type="checkbox"
                className="h-4 w-4 text-indigo-600 focus:ring-indigo-500 border-gray-300 rounded"
                checked={rememberMe}
                onChange={(e) => setRememberMe(e.target.checked)}
              />
              <label
                htmlFor="remember-me"
                className="ml-2 block text-sm text-gray-900"
              >
                로그인 상태 유지
              </label>
            </div>
          </div>
          <div>
            <button
              type="submit"
              disabled={loading}
              className="group relative w-full flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-primary-500 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
            >
              {loading ? "로그인 중..." : "로그인"}
            </button>
          </div>
          <div className="text-center flex justify-center space-x-4">
            <Link
              to="/find-id"
              className="font-medium text-sm text-gray-500 hover:text-indigo-500"
            >
              아이디 찾기
            </Link>
            <Link
              to="/find-password"
              className="font-medium text-sm text-gray-500 hover:text-indigo-500"
            >
              비밀번호 찾기
            </Link>
            <Link
              to="/sign-up"
              className="font-medium text-sm text-gray-500 hover:text-indigo-500"
            >
              병원 계정 등록
            </Link>
          </div>
        </form>
      </div>
    </div>
  );
};

export default Login;
