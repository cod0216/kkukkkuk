import { useState, FormEvent } from "react";
import { FaUserAlt } from "react-icons/fa";
import { findId } from "@/services/authService";
import { ResponseStatus } from "@/types";
import { useNavigate } from "react-router-dom";

/**
 * @module FindIw
 * @file /src/pages/auth/FindId.tsx
 * @author eunchang
 * @date 2025-03-26
 * @description 아이디를 조회하는 모듈입니다.
 *
 * 이 모듈은 이메일을 통해 아이디를 조회하는 페이지 입니다.
 *
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-28        eunchang         최초 생성
 */

const FindId = () => {
  const [email, setEmail] = useState("");
  const [feedback, setFeedback] = useState("");
  const [loading, setLoading] = useState(false);
  const [foundId, setFoundId] = useState<string | null>(null);
  const navigate = useNavigate();

  const handleSubmit = async (e: FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    setLoading(true);
    setFeedback("");
    try {
      const response = await findId(email);
      if (response.status === ResponseStatus.SUCCESS && response.data) {
        setFoundId(response.data.account);
      } else {
        setFeedback(response.message || "아이디 조회에 실패했습니다.");
      }
    } catch (error) {
      setFeedback("오류가 발생했습니다. 다시 시도해주세요.");
    } finally {
      setLoading(false);
    }
  };

  const goToLogin = () => {
    navigate("/login");
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-gray-50 px-4">
      <div className="max-w-md w-full space-y-8">
        <div>
          <h2 className="mt-6 text-center text-3xl font-bold text-primary-500">
            <FaUserAlt className="inline-block mr-2 text-primary-500" />
            아이디 조회
          </h2>
        </div>
        {foundId ? (
          <>
            <div className="text-center text-lg text-gray-700">
              {`찾은 아이디: ${foundId}`}
            </div>
            <div className="text-center">
              <button
                onClick={goToLogin}
                className="mt-4 w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-lg font-bold text-white bg-primary-500 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500"
              >
                로그인 하러 가기
              </button>
            </div>
          </>
        ) : (
          <>
            <div className="text-center text-sm text-gray-600">
              {feedback || "가입 시 사용한 이메일을 입력해주세요."}
            </div>
            <form onSubmit={handleSubmit} className="mt-8 space-y-6">
              <div className="rounded-md shadow-sm">
                <div>
                  <input
                    id="email"
                    name="email"
                    type="email"
                    autoComplete="email"
                    required
                    value={email}
                    onChange={(e) => setEmail(e.target.value)}
                    className="appearance-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-md focus:outline-none focus:ring-primary-500 focus:border-primary-500 sm:text-sm"
                    placeholder="이메일 주소"
                  />
                </div>
              </div>
              <div>
                <button
                  type="submit"
                  disabled={loading}
                  className={`w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-lg font-bold text-white focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 ${
                    loading
                      ? "bg-gray-400 cursor-not-allowed"
                      : "bg-primary-500 hover:bg-primary-700"
                  }`}
                >
                  {loading ? "조회중..." : "조회"}
                </button>
              </div>
            </form>
          </>
        )}
      </div>
    </div>
  );
};

export default FindId;
