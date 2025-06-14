/**
 * @module SignUp
 * @file SignUp.tsx
 * @author sangmuk
 * @date 2025-03-26
 * @description 회원가입 페이지입니다.
 *
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-26        sangmuk         회원가입 페이지 구현
 * 2025-03-26        sangmuk         비밀번호 유효성 검사 추가
 * 2025-03-27        sangmuk         아이디 유효성 검사 추가
 * 2025-03-31        sangmuk         ui 개선
 */

import { useState } from "react";
import { SignUpRequest, HospitalBase } from "@/interfaces";
import axios from "axios";
import HospitalSearchModal from "./HospitalSearchModal";
import { FaPaw, FaUser, FaLock, FaHospital, FaEnvelope, FaEye, FaEyeSlash } from "react-icons/fa";
import useAppNavigation from "@/hooks/useAppNavigation";

const BASE_URL = import.meta.env.VITE_SERVER_URL;
const SIGNUP_ENDPOINT = "/api/auths/hospitals/signup";
const SEND_EMAIL_VERIFICATION_ENDPOINT = "/api/auths/emails/send";
const VERIFY_EMAIL_VERIFICATION_ENDPOINT = "/api/auths/emails/verify";
const CHECK_ACCOUNT_DUPLICATE_ENDPOINT = "/api/hospitals/account";

/**
 * 아이디 유효성을 검사하는 함수
 * @param {string} account - 검사할 사용자 아이디
 * @returns {boolean} 유효성 검사 결과 (5~10자의 영문 소문자, 숫자, 밑줄 조합이면 true)
 */
const validateAccount = (account: string): boolean => {
  const accountRegex = /^[a-z0-9_]{5,10}$/;
  return accountRegex.test(account);
};

/**
 * 이메일 유효성을 검사하는 함수
 * @param {string} email - 검사할 이메일 주소
 * @returns {boolean} 유효성 검사 결과 (올바른 이메일 형식이면 true)
 */
const validateEmail = (email: string): boolean => {
  const emailRegex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;
  return emailRegex.test(email);
};

/**
 * 비밀번호 유효성을 검사하는 함수
 * @param {string} password - 검사할 비밀번호
 * @returns {boolean} 유효성 검사 결과 (6~20자의 영문 대소문자, 숫자, 특수문자 조합이면 true)
 */
const validatePassword = (password: string): boolean => {
  const passwordRegex =
    /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&])[A-Za-z\d!@#$%^&]{6,20}$/;
  return passwordRegex.test(password);
};

/**
 * 회원가입 컴포넌트
 * @returns {JSX.Element} 회원가입 폼 컴포넌트
 */
function SignUp() {
  const [signUpRequestForm, setSignUpRequestForm] = useState<SignUpRequest>({
    account: "",
    password: "",
    email: "",
    id: "",
    doctorName: "",
  });

  const [error, setError] = useState<string | null>(null);
  const [showPassword, setShowPassword] = useState<boolean>(false);

  const [isAccountAvailable, setIsAccountAvailable] = useState<boolean>(false);
  const [accountError, setAccountError] = useState<string | null>(null);

  const [emailVerificationCode, setEmailVerificationCode] =
    useState<string>("");
  const [isEmailVerificationCodeSent, setIsEmailVerificationCodeSent] =
    useState<boolean>(false);
  const [isEmailVerified, setIsEmailVerified] = useState<boolean>(false);
  const [emailVerificationError, setEmailVerificationError] = useState<
    string | null
  >(null);
  const [emailError, setEmailError] = useState<string | null>(null);
  const [isSendingVerification, setIsSendingVerification] =
    useState<boolean>(false);

  const [passwordError, setPasswordError] = useState<string | null>(null);

  const [isModalOpen, setIsModalOpen] = useState<boolean>(false);
  const [selectedHospital, setSelectedHospital] = useState<HospitalBase | null>(
    null
  );

  const { goToLogin } = useAppNavigation();

  /**
   * 입력 필드 값 변경을 처리하는 함수
   * @param {React.ChangeEvent<HTMLInputElement>} e - 입력 필드 변경 이벤트
   * @returns {void}
   */
  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setSignUpRequestForm((prevData) => ({ ...prevData, [name]: value }));

    if (name === "email") {
      setIsEmailVerified(false);
      setIsEmailVerificationCodeSent(false);
      setEmailVerificationCode("");
      setEmailVerificationError(null);
      setEmailError(null);
    }

    if (name === "account") {
      setIsAccountAvailable(false);
      setAccountError(null);
    }

    if (name === "password") {
      setPasswordError(null);
    }

    if (name === "id" && selectedHospital) {
      setSelectedHospital(null);
    }
  };

  /**
   * 이메일 인증 코드 입력값 변경을 처리하는 함수
   * @param {React.ChangeEvent<HTMLInputElement>} e - 입력 필드 변경 이벤트
   * @returns {void}
   */
  const handleEmailVerificationCodeChange = (
    e: React.ChangeEvent<HTMLInputElement>
  ) => {
    setEmailVerificationCode(e.target.value);
    setEmailVerificationError(null);
  };

  /**
   * 이메일 인증번호 발송 요청을 처리하는 함수
   * @returns {Promise<void>} 인증번호 발송 결과
   * @throws {Error} 인증번호 발송 실패 시 에러
   */
  const handleSendEmailVerificationCode = async () => {
    if (!signUpRequestForm.email) {
      setEmailError("이메일을 입력해주세요.");
      return;
    }

    if (!validateEmail(signUpRequestForm.email)) {
      setEmailError("유효한 이메일 주소를 입력해주세요.");
      return;
    }

    setEmailError(null);
    setEmailVerificationError(null);
    setIsEmailVerificationCodeSent(false);
    setIsSendingVerification(true);

    try {
      await axios.post(`${BASE_URL}${SEND_EMAIL_VERIFICATION_ENDPOINT}`, {
        email: signUpRequestForm.email,
      });
      setIsEmailVerificationCodeSent(true);
    } catch (error) {
      console.error("인증번호 발송 실패", error);
      setEmailError("인증번호 발송에 실패했습니다. 다시 시도해주세요.");
      setIsEmailVerificationCodeSent(false);
    } finally {
      setIsSendingVerification(false);
    }
  };

  /**
   * 이메일 인증번호 확인을 처리하는 함수
   * @returns {Promise<void>} 인증번호 확인 결과
   * @throws {Error} 인증번호 확인 실패 시 에러
   */
  const handleEmailVerifyCode = async () => {
    if (!emailVerificationCode) {
      setEmailVerificationError("인증번호를 입력해주세요.");
      return;
    }
    setEmailVerificationError(null);

    try {
      await axios.post(`${BASE_URL}${VERIFY_EMAIL_VERIFICATION_ENDPOINT}`, {
        email: signUpRequestForm.email,
        code: emailVerificationCode,
      });
      setIsEmailVerified(true);
    } catch (error) {
      console.error("이메일 인증 실패", error);
      setEmailVerificationError("인증번호가 일치하지 않습니다.");
      setIsEmailVerified(false);
    }
  };

  /**
   * 아이디 중복 확인을 처리하는 함수
   * @returns {Promise<void>} 아이디 중복 확인 결과
   * @throws {Error} 아이디 중복 확인 실패 시 에러
   */
  const handleCheckAccountDuplicate = async () => {
    if (!signUpRequestForm.account) {
      setAccountError("아이디를 입력해주세요.");
      return;
    }

    if (!validateAccount(signUpRequestForm.account)) {
      setAccountError("5~10자의 영문 소문자, 숫자, 밑줄(_)만 사용 가능합니다.");
      return;
    }

    setAccountError(null);

    try {
      const response = await axios.get(
        `${BASE_URL}${CHECK_ACCOUNT_DUPLICATE_ENDPOINT}/${signUpRequestForm.account}`
      );

      if (response.data.data) {
        setIsAccountAvailable(true);
        setAccountError(null);
      } else {
        setIsAccountAvailable(false);
        setAccountError("이미 사용 중인 아이디입니다.");
      }
    } catch (error) {
      console.error("아이디 중복 확인 실패", error);
      setAccountError("아이디 중복 확인에 실패했습니다. 다시 시도해주세요.");
      setIsAccountAvailable(false);
    }
  };

  /**
   * 병원 선택 처리 함수
   * @param {HospitalBase} hospital - 선택된 병원 정보
   * @returns {void}
   */
  const handleHospitalSelect = (hospital: HospitalBase) => {
    setSelectedHospital(hospital);
    setSignUpRequestForm((prevData) => ({
      ...prevData,
      id: hospital.id.toString(),
    }));
  };

  /**
   * 병원 검색 모달 열기 함수
   * @returns {void}
   */
  const openModal = () => {
    setIsModalOpen(true);
  };

  /**
   * 병원 검색 모달 닫기 함수
   * @returns {void}
   */
  const closeModal = () => {
    setIsModalOpen(false);
  };

  /**
   * 회원가입 폼 유효성 검사 함수
   * @returns {boolean} 폼 유효성 검사 결과 (모든 필드가 유효하면 true)
   */
  const validateForm = (): boolean => {
    if (!validateAccount(signUpRequestForm.account)) {
      setAccountError("5~10자의 영문 소문자, 숫자, 밑줄(_)만 사용 가능합니다.");
      return false;
    }

    if (!isAccountAvailable) {
      setError("아이디 중복 확인을 완료해주세요.");
      return false;
    }

    if (!validatePassword(signUpRequestForm.password)) {
      setPasswordError(
        "6~20자의 영문 대소문자, 숫자, 특수문자(!@#$%^&) 조합이어야 합니다."
      );
      return false;
    }

    if (!validateEmail(signUpRequestForm.email)) {
      setEmailError("올바른 이메일 주소를 입력해주세요.");
      return false;
    }

    if (!isEmailVerified) {
      setError("이메일 인증을 완료해주세요.");
      return false;
    }

    if (isNaN(parseInt(String(signUpRequestForm.id), 10))) {
      setError("병원 인허가 번호는 숫자만 입력 가능합니다.");
      return false;
    }

    return true;
  };

  /**
   * 회원가입 폼 제출 처리 함수
   * @param {React.FormEvent<HTMLFormElement>} e - 폼 제출 이벤트
   * @returns {Promise<void>} 회원가입 요청 결과
   * @throws {Error} 회원가입 요청 실패 시 에러
   */
  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();

    if (!validateForm()) {
      return;
    }

    const idString = signUpRequestForm.id;
    const idAsNumber = parseInt(String(idString), 10);
    const doctor_name = signUpRequestForm.doctorName;
    const payload = {
      ...signUpRequestForm,
      doctor_name: doctor_name,
      id: idAsNumber,
    };

    setError(null);

    try {
      await axios.post(`${BASE_URL}${SIGNUP_ENDPOINT}`, payload);
      goToLogin();
    } catch (error) {
      console.error("회원가입 실패", error);
      setError("회원가입 실패");
    }
  };

  /**
   * 비밀번호 표시 상태를 토글하는 함수
   * @returns {void}
   */
  const togglePasswordVisibility = () => {
    setShowPassword(!showPassword);
  };

  return (
    <div className="min-h-screen flex justify-center items-center">
      <div className="w-full max-w-sm flex flex-col items-center">
        <h1 className="my-4 text-3xl text-primary-500 text-center font-bold flex items-center justify-center">
          <FaPaw className="mr-2 text-2xl" />
          KKUK KKUK
        </h1>
        <form onSubmit={handleSubmit} className="flex flex-col">
          <div className="mb-2">
            <div className="flex gap-2">
              <div className="relative flex-1">
                <FaUser className="absolute left-3 top-1/2 transform -translate-y-1/2 text-neutral-400 pointer-events-none" />
                <input
                  type="text"
                  name="account"
                  id="account"
                  className="w-full pl-10 px-3 py-2 text-sm block border border-gray-300 placeholder-gray-500 text-gray-900 rounded-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500"
                  onChange={handleChange}
                  value={signUpRequestForm.account}
                  placeholder="아이디"
                  required
                />
              </div>  
              <button
                type="button"
                onClick={handleCheckAccountDuplicate}
                className="px-3 py-2 text-sm bg-primary-500 text-white rounded-md hover:bg-primary-600 transition-colors"
              >
                중복 확인
              </button>
            </div>
            {accountError && (
              <p className="text-secondary-500 text-sm mt-1">{accountError}</p>
            )}
            {isAccountAvailable && (
              <p className="text-primary-500 text-sm mt-1">
                사용 가능한 아이디입니다.
              </p>
            )}
          </div>

          <div className="mb-2">
            <div className="relative">
              <FaLock className="absolute left-3 top-1/2 transform -translate-y-1/2 text-neutral-400 pointer-events-none" />
              <input
                type={showPassword ? "text" : "password"}
                name="password"
                id="password"
                className="w-full pl-10 px-3 py-2 text-sm border border-gray-300 placeholder-gray-500 text-gray-900 rounded-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500"
                onChange={handleChange}
                value={signUpRequestForm.password}
                placeholder="비밀번호"
                required
              />
              <button
                type="button"
                onClick={togglePasswordVisibility}
                className="absolute right-3 top-1/2 transform -translate-y-1/2 text-neutral-500 hover:text-neutral-700 z-20"
              >
                {showPassword ? <FaEyeSlash /> : <FaEye />}
              </button>
            </div>
            {passwordError && (
              <p className="text-secondary-500 text-sm mt-1">{passwordError}</p>
            )}
          </div>

          <div className="mb-2">
            <div className="flex gap-2">
              <div className="relative flex-1">
                <FaEnvelope className="absolute left-3 top-1/2 transform -translate-y-1/2 text-neutral-400 pointer-events-none" />
                <input
                  type="email"
                  name="email"
                  id="email"
                  className="w-full pl-10 px-3 py-2 text-sm border border-gray-300 placeholder-gray-500 text-gray-900 rounded-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500"
                  onChange={handleChange}
                  value={signUpRequestForm.email}
                  placeholder="이메일"
                  required
                />
              </div>
              <button
                type="button"
                onClick={handleSendEmailVerificationCode}
                disabled={isSendingVerification || isEmailVerificationCodeSent}
                className={`w-32 px-4 py-2 text-white text-sm rounded-md transition-colors ${
                  isSendingVerification
                    ? "bg-neutral-400 cursor-not-allowed"
                    : isEmailVerificationCodeSent
                    ? "bg-neutral-500 cursor-not-allowed"
                    : "bg-primary-500 hover:bg-primary-600"
                }`}
              >
                {isSendingVerification
                  ? "발송 중..."
                  : isEmailVerificationCodeSent
                  ? "발송 완료"
                  : "인증번호 발송"}
              </button>
            </div>
            {emailError && (
              <p className="text-secondary-500 text-sm mt-1">{emailError}</p>
            )}
            {isEmailVerified && (
              <p className="text-primary-500 text-sm mt-1">
                이메일이 인증되었습니다.
              </p>
            )}
          </div>

          {isEmailVerificationCodeSent && !isEmailVerified && (
            <div className="mb-2">
              <div className="flex gap-2">
                <div className="relative flex-1">
                  <FaLock className="absolute left-3 top-1/2 transform -translate-y-1/2 text-neutral-400 pointer-events-none" />
                  <input
                    type="text"
                    name="emailVerificationCode"
                    id="emailVerificationCode"
                    className="w-full pl-10 p-2 text-sm border border-gray-300 placeholder-gray-500 text-gray-900 rounded-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500"
                    onChange={handleEmailVerificationCodeChange}
                    value={emailVerificationCode}
                    placeholder="인증번호"
                    required
                  />
                </div>
                <button
                  type="button"
                  onClick={handleEmailVerifyCode}
                  className="px-3 py-2 text-sm bg-primary-500 text-white rounded-md hover:bg-primary-600 transition-colors"
                >
                  인증 확인
                </button>
              </div>
              {emailVerificationError && (
                <p className="text-secondary-500 text-sm mt-1 overflow-hidden break-words">
                  {emailVerificationError}
                </p>
              )}
            </div>
          )}

          <div className="mb-2">
            <div className="flex gap-2">
              <div className="relative flex-1">
                <FaHospital className="absolute left-3 top-1/2 transform -translate-y-1/2 text-neutral-400 pointer-events-none" />
                <input
                  type="text"
                  name="id"
                  id="id"
                  className="w-full pl-10 p-2 text-sm border border-gray-300 placeholder-gray-500 text-gray-900 rounded-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500"
                  onChange={handleChange}
                  value={signUpRequestForm.id}
                  placeholder="병원 인허가 번호"
                  required
                  disabled={true}
                />
              </div>
              <button
                type="button"
                onClick={openModal}
                className="px-3 py-2 text-sm bg-primary-500 text-white rounded-md hover:bg-primary-600 transition-colors"
              >
                병원 검색
              </button>
            </div>
          </div>

          {selectedHospital && (
            <div className="mb-4 p-3 bg-gray-50 rounded-md border">
              <h3 className="font-medium mb-1">선택된 병원 정보</h3>
              <p>
                <span className="font-medium">이름:</span> {selectedHospital.name}
              </p>
              <p>
                <span className="font-medium">주소:</span>{" "}
                {selectedHospital.address}
              </p>
              <p>
                <span className="font-medium">전화번호:</span>{" "}
                {selectedHospital.phone_number}
              </p>
            </div>
          )}

          <div className="mb-2">
            <div className="relative">
              <FaUser className="absolute left-3 top-1/2 transform -translate-y-1/2 text-neutral-400 pointer-events-none" />
              <input
                type="text"
                name="doctorName"
                id="doctorName"
                className="w-full pl-10 p-2 text-sm border border-gray-300 placeholder-gray-500 text-gray-900 rounded-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500"
                onChange={handleChange}
                value={signUpRequestForm.doctorName}
                placeholder="수의사 이름"
                required
              />
            </div>
          </div>

          {error && <p className="text-secondary-500 text-sm mb-2">{error}</p>}
          <button
            className="mt-8 w-full flex justify-center py-2 px-4 text-sm border border-transparent text-md font-medium rounded-md text-white bg-primary-500 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
            type="submit"
          >
            회원가입
          </button>
        </form>

        <HospitalSearchModal
          isOpen={isModalOpen}
          onClose={closeModal}
          onSelect={handleHospitalSelect}
        />
      </div>
    </div>
  );
}

export default SignUp;
