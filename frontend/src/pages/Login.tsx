import React, { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import { toast } from "react-toastify";
import { useAppDispatch, useAppSelector } from "../redux/store";
import {
  loginStart,
  loginSuccess,
  loginFailure,
} from "../redux/slices/authSlice";
import {
  setDevModeEnabled,
  selectDevModeEnabled,
  initializeDevModeData,
} from "../redux/slices/devModeSlice";
import { login as apiLogin } from "../api/authApi";

const Login: React.FC = () => {
  const navigate = useNavigate();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const dispatch = useAppDispatch();
  const { loading, error } = useAppSelector((state) => state.auth);
  const devModeEnabled = useAppSelector(selectDevModeEnabled);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    if (!email || !password) {
      toast.error("이메일과 비밀번호를 모두 입력해주세요.");
      return;
    }

    dispatch(loginStart());
    try {
      const response = await apiLogin(email, password);

      dispatch(
        loginSuccess({
          user: response.hospital,
          token: response.tokens.access_token,
        })
      );
      toast.success("로그인 성공!");
      navigate("/");
    } catch (err: any) {
      dispatch(loginFailure(err.message));
      toast.error("로그인 실패: $(err.message}");
    }
  };

  return (
    <div className="flex items-center justify-center min-h-screen bg-gray-100 dark:bg-gray-900">
      <div className="w-full max-w-md p-8 space-y-8 bg-white rounded-lg shadow-md dark:bg-gray-800">
        <div className="text-center">
          <h1 className="text-4xl font-extrabold text-primary">KKuK KKuK</h1>
          <p className="mt-2 text-gray-600 dark:text-gray-300">
            동물병원 진료 기록 시스템
          </p>
        </div>

        {error && (
          <div className="p-4 text-sm text-red-700 bg-red-100 rounded-lg dark:bg-red-200 dark:text-red-800">
            {error}
          </div>
        )}

        <form className="mt-8 space-y-6" onSubmit={handleSubmit}>
          <div>
            <label
              htmlFor="email"
              className="block text-sm font-medium text-gray-700 dark:text-gray-300"
            >
              이메일
            </label>
            <input
              id="email"
              name="email"
              type="email"
              autoComplete="email"
              required
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              className="block w-full px-3 py-2 mt-1 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-primary focus:border-primary dark:bg-gray-700 dark:border-gray-600 dark:text-white"
            />
          </div>

          <div>
            <label
              htmlFor="password"
              className="block text-sm font-medium text-gray-700 dark:text-gray-300"
            >
              비밀번호
            </label>
            <input
              id="password"
              name="password"
              type="password"
              autoComplete="current-password"
              required
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              className="block w-full px-3 py-2 mt-1 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-primary focus:border-primary dark:bg-gray-700 dark:border-gray-600 dark:text-white"
            />
          </div>

          <div>
            <button
              type="submit"
              disabled={loading}
              className="flex justify-center w-full px-4 py-2 text-sm font-medium text-white bg-primary border border-transparent rounded-md shadow-sm hover:bg-opacity-90 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary disabled:opacity-50"
            >
              {loading ? "로그인 중..." : "로그인"}
            </button>
          </div>
        </form>

        <div className="text-center mt-4">
          <p className="text-sm text-gray-600 dark:text-gray-400">
            계정이 없으신가요?{" "}
            <Link
              to="/register"
              className="font-medium text-primary hover:text-opacity-80"
            >
              병원 회원가입
            </Link>
          </p>
        </div>
      </div>
    </div>
  );
};

export default Login;
