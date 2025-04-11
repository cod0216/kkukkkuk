import { useState } from "react";
import { FaPaw } from "react-icons/fa";
import { findPassword } from "@/services/authService"; // 경로에 맞게 수정해주세요
import { ResponseStatus } from "@/types";
import { FormEvent } from "react";

/**
 * @module FindPw
 * @file FindPw.tsx
 * @author eunchang
 * @date 2025-03-26
 * @description 비밀번호 임시 발급 페이지 모듈 입니다.
 *
 * 이 모듈은 임시 비밀번호를 발급해주는 페이지 입니다.
 *
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-26        eunchang         최초 생성
 */

const FindPw = () => {
  const [account, setAccount] = useState("");
  const [email, setEmail] = useState("");
  const [feedback, setFeedback] = useState("");

  const handleSubmit = async (e: FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    try {
      const res = await findPassword({ account, email });
      if (res.status === ResponseStatus.SUCCESS) {
        setFeedback(res.message); // "비밀번호가 이메일로 발송되었습니다."
      } else {
        setFeedback(res.message);
      }
    } catch (err) {
      setFeedback("오류가 발생했습니다. 다시 시도해주세요.");
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
      <div className="max-w-sm text-center w-full space-y-8">
        <div className="flex flex-col items-center">
          <div className="flex items-center text-2xl justify-center">
            <FaPaw className="text-primary-500 text-2xl mr-2" />
            <div className="text-3xl font-bold text-primary-500">
              임시 비밀번호 발급
            </div>
          </div>
        </div>
        <form onSubmit={handleSubmit} className="mt-8 space-y-6">
          <div className="flex items-stretch space-x-2">
            <div className="flex-grow rounded-md shadow-sm space-y-4">
              <div>
                <input
                  id="account"
                  name="account"
                  type="text"
                  autoComplete="username"
                  required
                  value={account}
                  onChange={(e) => setAccount(e.target.value)}
                  className="appearance-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                  placeholder="아이디"
                />
              </div>
              <div>
                <input
                  id="email"
                  name="email"
                  type="email"
                  autoComplete="email"
                  required
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  className="appearance-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                  placeholder="이메일 주소"
                />
              </div>
            </div>
            <button
              type="submit"
              className="self-stretch font-bold text-lg px-4 py-2 bg-primary-500 text-white hover:bg-primary-700 rounded flex items-center justify-center"
              style={{ writingMode: "vertical-rl" }}
            >
              발급
            </button>
          </div>
        </form>
        {feedback && (
          <div className="mt-4 text-sm text-gray-600">{feedback}</div>
        )}
      </div>
    </div>
  );
};

export default FindPw;
