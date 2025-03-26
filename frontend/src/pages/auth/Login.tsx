import React, { useState } from 'react';
import { FaPaw } from 'react-icons/fa';
import { Link, useNavigate } from 'react-router-dom';
import { useDispatch } from 'react-redux';
import { login } from "@/services/authService"
import { setAccessToken } from '@/redux/store';
import { setRefreshtoken } from '@/utils/iDBUtil';

const Login = () => {
  const dispatch = useDispatch();
  const navigate = useNavigate();

  const [account, setAccount] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    setError(null);
    setLoading(true);

    try {
      const response = await login({ account, password });
      if (response.status === "SUCCESS" && response.data) {
        const {
          tokens: { accessToken, refreshToken },
        } = response.data;

        // accessToken은 redux RefreshToken은 indexedDB에 저장
        dispatch(setAccessToken(accessToken));
        await setRefreshtoken(refreshToken);

        navigate("/TreatmentMain");
      } else {
        setError(response.message);
      }
    } catch (err) {
      setError("로그인 중 오류가 발생했습니다.");
    }
    setLoading(false);
  };


  return (
    <div className="min-h-screen flex items-center justify-center bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
      <div className="max-w-md text-center w-full space-y-8">
        <div className="flex flex-col items-center">
          <div className="flex items-center text-2xl justify-center">
            <FaPaw className="text-primary-500 text-2xl mr-2" />
            <div className="text-3xl font-bold text-primary-500">KKUK KKUK</div>
          </div>
          {error && <p className="mt-2 text-sm text-red-500">{error}</p>}
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
                placeholder="계정"
              />
            </div>
            <div>
              <input
                id="password"
                name="password"
                type="password"
                autoComplete="current-password"
                required
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                className="appearance-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm"
                placeholder="비밀번호"
              />
            </div>
          </div>
          <div className="flex items-center justify-between">
            <div className="flex items-center">
              <input
                id="remember-me"
                name="remember-me"
                type="checkbox"
                className="h-4 w-4 text-indigo-600 focus:ring-indigo-500 border-gray-300 rounded"
              />
              <label htmlFor="remember-me" className="ml-2 block text-sm text-gray-900">
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
          <Link to="/find-id" className="font-medium text-gray-500 hover:text-indigo-500">
              아이디 찾기
            </Link>
            <Link to="/find-password" className="font-medium text-gray-500 hover:text-indigo-500">
              비밀번호 찾기
            </Link>
            <Link to="/register" className="font-medium text-gray-500 hover:text-indigo-500">
              병원 계정 등록
            </Link>
          </div>
        </form>
      </div>
    </div>
  );
};

export default Login;
