import React, { useState, useEffect } from "react";
import { Link, useNavigate } from "react-router-dom";
import { toast } from "react-toastify";
import { useAppDispatch, useAppSelector } from "../redux/store";
import {
  registerStart,
  registerSuccess,
  registerFailure,
  selectLoading,
  selectError,
} from "../redux/slices/authSlice";
import DoctorRegistration from "../components/auth/DoctorRegistration";

import { DoctorRegister } from "@/interfaces/doctor";
import {
  fetchHospitalInfo,
  registerHospital,
  checkAccountAvailability,
  checkLicenseAvailability,
} from "../services/hospitalService";

import {
  HospitalSignupRequest,
  HospitalAuthorizationResponse,
} from "@/interfaces/index";

interface HospitalFormData {
  hospitalName: string;
  address: string;
  phoneNumber: string;
  licenseNumber: string;
  username: string;
  password: string;
  confirmPassword: string;
  email: string;
  hospitalId?: number;
}

// 병원 정보 API 응답 인터페이스
interface HospitalInfoResponse {
  success: boolean;
  data?: {
    hospitalName: string;
    address: string;
    phoneNumber: string;
    id: number;
  };
  message?: string;
}

const HospitalRegister: React.FC = () => {
  const [formData, setFormData] = useState<HospitalFormData>({
    hospitalName: "",
    address: "",
    phoneNumber: "",
    licenseNumber: "",
    username: "",
    password: "",
    confirmPassword: "",
    email: "",
  });

  const [doctors, setDoctors] = useState<DoctorRegister[]>([]);
  const [isSearching, setIsSearching] = useState(false);
  const [licenseFound, setLicenseFound] = useState(false);
  const [isCheckingAccount, setIsCheckingAccount] = useState(false);
  const [accountAvailable, setAccountAvailable] = useState<boolean | null>(
    null
  );
  const [accountMessage, setAccountMessage] = useState<string>("");
  const [isCheckingLicense, setIsCheckingLicense] = useState(false);
  const [licenseAvailable, setLicenseAvailable] = useState<boolean | null>(
    null
  );
  const [licenseMessage, setLicenseMessage] = useState<string>("");

  const dispatch = useAppDispatch();
  const navigate = useNavigate();
  const loading = useAppSelector(selectLoading);
  const error = useAppSelector(selectError);

  // 입력 필드 변경 핸들러
  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setFormData((prev) => ({
      ...prev,
      [name]: value,
    }));

    // 병원 정보가 검색된 후 라이센스 번호가 변경되면 검색 상태 초기화
    if (name === "licenseNumber") {
      if (licenseFound) {
        setLicenseFound(false);
      }
      if (licenseAvailable !== null) {
        setLicenseAvailable(null);
        setLicenseMessage("");
      }
    }

    // 이메일이 변경되면 중복 확인 상태 초기화
    if (name === "email" && accountAvailable !== null) {
      setAccountAvailable(null);
      setAccountMessage("");
    }
  };

  // 라이센스 중복 확인
  const checkLicenseDuplicate = async () => {
    const { licenseNumber } = formData;
    if (!licenseNumber) {
      setLicenseMessage("인허가 번호를 입력해주세요.");
      return;
    }

    setIsCheckingLicense(true);
    setLicenseMessage("");

    try {
      const result = await checkLicenseAvailability(licenseNumber);

      if (result.status === "SUCCESS") {
        setLicenseAvailable(result.data || false);
        setLicenseMessage(result.message);

        // 사용 가능한 라이센스인 경우에만 병원 정보 검색 진행
        if (result.data) {
          await searchHospitalInfo();
        }
      } else {
        setLicenseAvailable(false);
        setLicenseMessage(result.message);
      }
    } catch (error) {
      console.error("라이센스 중복 확인 오류:", error);
      setLicenseAvailable(false);
      setLicenseMessage("중복 확인 중 오류가 발생했습니다.");
    } finally {
      setIsCheckingLicense(false);
    }
  };

  // 병원 정보 검색 핸들러
  const searchHospitalInfo = async () => {
    const { licenseNumber } = formData;

    if (!licenseNumber.trim()) {
      toast.error("인허가 번호를 입력해주세요.");
      return;
    }

    try {
      setIsSearching(true);
      const result = await fetchHospitalInfo(licenseNumber);

      if (result.status === "SUCCESS" && result.data) {
        const { id, name, address, phone_number } =
          result.data as HospitalAuthorizationResponse;

        setFormData((prev) => ({
          ...prev,
          hospitalName: name,
          address: address,
          phoneNumber: phone_number,
          hospitalId: id,
        }));

        setLicenseFound(true);
        toast.success(result.message || "병원 정보를 찾았습니다.");
      } else {
        toast.error(result.message || "병원 정보를 찾을 수 없습니다.");
      }
    } catch (error) {
      toast.error("병원 정보 검색 중 오류가 발생했습니다.");
      console.error("병원 정보 검색 오류:", error);
    } finally {
      setIsSearching(false);
    }
  };

  // 이메일 중복 확인
  const checkAccountDuplicate = async () => {
    const { email } = formData;
    if (!email) {
      setAccountMessage("이메일을 입력해주세요.");
      return;
    }

    setIsCheckingAccount(true);
    setAccountMessage("");

    try {
      const result = await checkAccountAvailability(email);

      if (result.status === "SUCCESS") {
        setAccountAvailable(result.data || false);
        setAccountMessage(result.message);
      } else {
        setAccountAvailable(false);
        setAccountMessage(result.message);
      }
    } catch (error) {
      console.error("이메일 중복 확인 오류:", error);
      setAccountAvailable(false);
      setAccountMessage("중복 확인 중 오류가 발생했습니다.");
    } finally {
      setIsCheckingAccount(false);
    }
  };

  // 회원가입 제출 핸들러
  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    const {
      hospitalName,
      address,
      phoneNumber,
      licenseNumber,
      username,
      password,
      confirmPassword,
      email,
      hospitalId,
    } = formData;

    if (!licenseFound || !hospitalId) {
      toast.error("인허가 번호 검증이 필요합니다.");
      return;
    }

    if (licenseAvailable !== true) {
      toast.error("인허가 번호 중복 확인이 필요합니다.");
      return;
    }

    if (password !== confirmPassword) {
      toast.error("비밀번호가 일치하지 않습니다.");
      return;
    }

    if (doctors.length === 0) {
      toast.error("최소 1명 이상의 의사를 등록해야 합니다.");
      return;
    }

    if (accountAvailable !== true) {
      toast.error("이메일 중복 확인이 필요합니다.");
      return;
    }

    try {
      dispatch(registerStart());

      // 새로운 API 명세에 맞게 요청 데이터 구성
      const requestData: HospitalSignupRequest = {
        account: username,
        password: password,
        id: hospitalId,
        did: `did:hospital:${hospitalId}:${Date.now().toString(36)}`, // 임시 DID 생성
        license_number: licenseNumber,
        doctor_name: doctors[0].name, // 첫 번째 의사를 대표 의사로 등록
      };

      const result = await registerHospital(requestData);

      if (result.status === "SUCCESS") {
        dispatch(registerSuccess(result.data));
        toast.success(
          "병원 등록이 완료되었습니다! 로그인 페이지로 이동합니다."
        );
        navigate("/login");
      } else {
        dispatch(registerFailure(result.message));
        toast.error(result.message || "회원가입에 실패했습니다.");
      }
    } catch (err) {
      dispatch(registerFailure("회원가입 중 오류가 발생했습니다."));
      toast.error("회원가입 실패. 다시 시도해주세요.");
    }
  };

  return (
    <div className="flex items-center justify-center min-h-screen bg-gray-100 dark:bg-gray-900">
      <div className="w-full max-w-4xl p-8 space-y-8 bg-white rounded-lg shadow-md dark:bg-gray-800 my-8">
        <div className="flex items-center justify-between">
          <div className="text-center flex-1">
            <h1 className="text-4xl font-extrabold text-primary">KKuK KKuK</h1>
            <p className="mt-2 text-gray-600 dark:text-gray-300">
              동물병원 회원가입
            </p>
          </div>
          <button
            onClick={() => navigate("/")}
            className="text-gray-500 hover:text-primary dark:text-gray-400 dark:hover:text-primary flex items-center"
          >
            <span className="mr-1">🏠</span>
            홈으로
          </button>
        </div>

        {error && (
          <div className="p-4 text-sm text-red-700 bg-red-100 rounded-lg dark:bg-red-200 dark:text-red-800">
            {error}
          </div>
        )}

        <form className="mt-8 space-y-6" onSubmit={handleSubmit}>
          <div className="bg-blue-50 p-4 rounded-lg border border-blue-200 mb-6 dark:bg-blue-900/20 dark:border-blue-800">
            <h3 className="text-md font-medium text-blue-800 dark:text-blue-300 mb-2">
              병원 기본 정보
            </h3>
            <p className="text-sm text-blue-700 dark:text-blue-400">
              인허가 번호를 입력한 후 검색 버튼을 클릭하면 병원 정보가 자동으로
              조회됩니다.
            </p>
          </div>

          <div className="grid grid-cols-1 gap-6 md:grid-cols-4">
            <div className="md:col-span-3">
              <label
                htmlFor="licenseNumber"
                className="block text-sm font-medium text-gray-700 dark:text-gray-300"
              >
                인허가 번호 *
              </label>
              <div className="mt-1 flex rounded-md shadow-sm">
                <input
                  id="licenseNumber"
                  name="licenseNumber"
                  type="text"
                  required
                  value={formData.licenseNumber}
                  onChange={handleChange}
                  className={`block w-full px-3 py-2 border ${
                    licenseAvailable === true
                      ? "border-green-300 focus:ring-green-500 focus:border-green-500"
                      : licenseAvailable === false
                      ? "border-red-300 focus:ring-red-500 focus:border-red-500"
                      : "border-gray-300 focus:ring-primary focus:border-primary"
                  } rounded-l-md shadow-sm focus:outline-none dark:bg-gray-700 dark:border-gray-600 dark:text-white`}
                  placeholder="보건복지부 인허가 번호"
                />
                <button
                  type="button"
                  onClick={checkLicenseDuplicate}
                  disabled={isCheckingLicense || !formData.licenseNumber}
                  className="inline-flex items-center px-4 py-2 border border-l-0 border-gray-300 bg-gray-50 text-sm font-medium text-gray-700 rounded-r-md hover:bg-gray-100 focus:outline-none focus:ring-1 focus:ring-primary focus:border-primary disabled:opacity-50 disabled:cursor-not-allowed dark:bg-gray-600 dark:border-gray-500 dark:text-gray-200 dark:hover:bg-gray-500"
                >
                  {isCheckingLicense ? "확인 중..." : "중복 확인"}
                </button>
              </div>
              {licenseMessage && (
                <p
                  className={`mt-1 text-sm ${
                    licenseAvailable === true
                      ? "text-green-600 dark:text-green-400"
                      : "text-red-600 dark:text-red-400"
                  }`}
                >
                  {licenseMessage}
                </p>
              )}
            </div>

            <div className="md:col-span-1 flex items-end">
              <div className="w-full text-center">
                {licenseFound && licenseAvailable ? (
                  <span className="inline-flex items-center px-3 py-2 rounded-md text-sm font-medium bg-green-100 text-green-800 dark:bg-green-800 dark:text-green-100">
                    <span className="mr-1">✓</span> 인증완료
                  </span>
                ) : licenseAvailable === false ? (
                  <span className="inline-flex items-center px-3 py-2 rounded-md text-sm font-medium bg-red-100 text-red-800 dark:bg-red-800 dark:text-red-100">
                    <span className="mr-1">✗</span> 사용불가
                  </span>
                ) : (
                  <span className="inline-flex items-center px-3 py-2 rounded-md text-sm font-medium bg-gray-100 text-gray-800 dark:bg-gray-700 dark:text-gray-300">
                    미인증
                  </span>
                )}
              </div>
            </div>
          </div>

          <div className="grid grid-cols-1 gap-6 md:grid-cols-3">
            <div>
              <label
                htmlFor="hospitalName"
                className="block text-sm font-medium text-gray-700 dark:text-gray-300"
              >
                병원명 *
              </label>
              <input
                id="hospitalName"
                name="hospitalName"
                type="text"
                required
                value={formData.hospitalName}
                onChange={handleChange}
                disabled={!licenseFound}
                className="block w-full px-3 py-2 mt-1 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-primary focus:border-primary disabled:bg-gray-100 disabled:text-gray-500 dark:bg-gray-700 dark:border-gray-600 dark:text-white dark:disabled:bg-gray-800 dark:disabled:text-gray-400"
                placeholder="병원명은 자동으로 입력됩니다"
              />
            </div>

            <div>
              <label
                htmlFor="address"
                className="block text-sm font-medium text-gray-700 dark:text-gray-300"
              >
                주소 *
              </label>
              <input
                id="address"
                name="address"
                type="text"
                required
                value={formData.address}
                onChange={handleChange}
                disabled={!licenseFound}
                className="block w-full px-3 py-2 mt-1 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-primary focus:border-primary disabled:bg-gray-100 disabled:text-gray-500 dark:bg-gray-700 dark:border-gray-600 dark:text-white dark:disabled:bg-gray-800 dark:disabled:text-gray-400"
                placeholder="주소는 자동으로 입력됩니다"
              />
            </div>

            <div>
              <label
                htmlFor="phoneNumber"
                className="block text-sm font-medium text-gray-700 dark:text-gray-300"
              >
                전화번호 *
              </label>
              <input
                id="phoneNumber"
                name="phoneNumber"
                type="tel"
                required
                value={formData.phoneNumber}
                onChange={handleChange}
                disabled={!licenseFound}
                className="block w-full px-3 py-2 mt-1 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-primary focus:border-primary disabled:bg-gray-100 disabled:text-gray-500 dark:bg-gray-700 dark:border-gray-600 dark:text-white dark:disabled:bg-gray-800 dark:disabled:text-gray-400"
                placeholder="전화번호는 자동으로 입력됩니다"
              />
            </div>
          </div>

          <div className="pt-4 border-t border-gray-200 dark:border-gray-700">
            <h3 className="text-lg font-medium text-gray-900 dark:text-white mb-4">
              계정 정보
            </h3>

            <div className="grid grid-cols-1 gap-6 md:grid-cols-2">
              <div>
                <label
                  htmlFor="username"
                  className="block text-sm font-medium text-gray-700 dark:text-gray-300"
                >
                  아이디 *
                </label>
                <input
                  id="username"
                  name="username"
                  type="text"
                  required
                  value={formData.username}
                  onChange={handleChange}
                  className="block w-full px-3 py-2 mt-1 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-primary focus:border-primary dark:bg-gray-700 dark:border-gray-600 dark:text-white"
                />
              </div>

              <div>
                <label
                  htmlFor="email"
                  className="block text-sm font-medium text-gray-700 dark:text-gray-300"
                >
                  이메일 *
                </label>
                <div className="flex mt-1">
                  <input
                    id="email"
                    name="email"
                    type="email"
                    autoComplete="email"
                    required
                    value={formData.email}
                    onChange={handleChange}
                    className={`block w-full px-3 py-2 border ${
                      accountAvailable === true
                        ? "border-green-300 focus:ring-green-500 focus:border-green-500"
                        : accountAvailable === false
                        ? "border-red-300 focus:ring-red-500 focus:border-red-500"
                        : "border-gray-300 focus:ring-primary focus:border-primary"
                    } rounded-l-md shadow-sm focus:outline-none dark:bg-gray-700 dark:border-gray-600 dark:text-white`}
                  />
                  <button
                    type="button"
                    onClick={checkAccountDuplicate}
                    disabled={isCheckingAccount || !formData.email}
                    className="inline-flex items-center px-4 py-2 border border-l-0 border-gray-300 bg-gray-50 text-sm font-medium text-gray-700 rounded-r-md hover:bg-gray-100 focus:outline-none focus:ring-1 focus:ring-primary focus:border-primary disabled:opacity-50 disabled:cursor-not-allowed dark:bg-gray-600 dark:border-gray-500 dark:text-gray-200 dark:hover:bg-gray-500"
                  >
                    {isCheckingAccount ? "확인 중..." : "중복 확인"}
                  </button>
                </div>
                {accountMessage && (
                  <p
                    className={`mt-1 text-sm ${
                      accountAvailable === true
                        ? "text-green-600 dark:text-green-400"
                        : "text-red-600 dark:text-red-400"
                    }`}
                  >
                    {accountMessage}
                  </p>
                )}
              </div>

              <div>
                <label
                  htmlFor="password"
                  className="block text-sm font-medium text-gray-700 dark:text-gray-300"
                >
                  비밀번호 *
                </label>
                <input
                  id="password"
                  name="password"
                  type="password"
                  required
                  value={formData.password}
                  onChange={handleChange}
                  className="block w-full px-3 py-2 mt-1 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-primary focus:border-primary dark:bg-gray-700 dark:border-gray-600 dark:text-white"
                />
              </div>

              <div>
                <label
                  htmlFor="confirmPassword"
                  className="block text-sm font-medium text-gray-700 dark:text-gray-300"
                >
                  비밀번호 확인 *
                </label>
                <input
                  id="confirmPassword"
                  name="confirmPassword"
                  type="password"
                  required
                  value={formData.confirmPassword}
                  onChange={handleChange}
                  className="block w-full px-3 py-2 mt-1 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-primary focus:border-primary dark:bg-gray-700 dark:border-gray-600 dark:text-white"
                />
              </div>
            </div>
          </div>

          <div className="pt-4 border-t border-gray-200 dark:border-gray-700">
            <DoctorRegistration doctors={doctors} setDoctors={setDoctors} />
          </div>

          <div className="pt-6">
            <p className="text-sm text-gray-500 dark:text-gray-400 mb-4">
              * 병원 계정 등록 시 DID(Decentralized Identifier)가 자동으로
              생성됩니다. 이는 블록체인 네트워크에서 병원을 식별하는 고유 번호로
              사용됩니다.
            </p>

            <button
              type="submit"
              disabled={loading || !licenseFound || doctors.length === 0}
              className="w-full px-4 py-2 text-white bg-blue-600 rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 disabled:opacity-50 disabled:cursor-not-allowed"
            >
              {loading ? (
                <span className="flex items-center justify-center">
                  <span className="animate-spin mr-2 h-5 w-5">⏳</span>
                  처리 중...
                </span>
              ) : (
                "병원 등록하기"
              )}
            </button>
          </div>

          <div className="text-center">
            <span className="text-sm text-gray-600 dark:text-gray-400">
              이미 계정이 있으신가요?{" "}
              <Link
                to="/login"
                className="font-medium text-primary hover:text-primary-dark"
              >
                로그인하기
              </Link>
            </span>
          </div>
        </form>
      </div>
    </div>
  );
};

export default HospitalRegister;
