import React, { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { useAppSelector, useAppDispatch } from "../redux/store";
import {
  selectLoggedInHospital,
  updateHospitalInfoAction,
  setHospitalInfo,
  logout as logoutAction,
} from "../redux/slices/authSlice";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import {
  faHospital,
  faIdCard,
  faPhone,
  faMapMarkerAlt,
  faEnvelope,
  faHome,
  faLock,
  faTrashAlt,
} from "@fortawesome/free-solid-svg-icons";
import {
  updateHospitalInfo,
  fetchHospitalMe,
  deleteHospitalAccount,
} from "../services/hospitalService";

import { UpdateHospitalRequest } from "@/interfaces/index";

import { toast } from "react-toastify";
import DoctorManagement from "../components/hospital/DoctorManagement";
import WithdrawalModal from "../components/hospital/WithdrawalModal";

interface HospitalData {
  id?: string | number;
  name: string;
  did: string;
  address: string;
  phone?: string;
  phone_number?: string;
  email?: string;
  account?: string;
  license_number?: string;
  doctor_name?: string;
  authoriazation_number?: string;
  x_axis?: number;
  y_axis?: number;
  public_key?: string | null;
  doctors: any[];
}

const HospitalSettings: React.FC = () => {
  const dispatch = useAppDispatch();
  const navigate = useNavigate();

  // 로그인한 병원 정보 가져오기
  const hospital = useAppSelector(selectLoggedInHospital) || {
    name: "",
    did: "",
    address: "",
    phone: "",
    email: "",
    doctors: [],
  };

  const [formData, setFormData] = useState({
    name: hospital.name,
    address: hospital.address,
    phone: hospital.phone || hospital.phone_number || "",
    email: hospital.email || "",
    password: "",
    confirmPassword: "",
  });

  // doctors 상태 제거 (DoctorManagement에서 자체적으로 관리)
  const [isLoading, setIsLoading] = useState(false);
  const [isFetching, setIsFetching] = useState(false);
  const [showPassword, setShowPassword] = useState(false);
  const [isWithdrawalModalOpen, setIsWithdrawalModalOpen] = useState(false);

  // 페이지 로드 시 병원 정보 API 호출
  useEffect(() => {
    const fetchHospitalData = async () => {
      try {
        setIsFetching(true);
        const response = await fetchHospitalMe();

        if (response.status === "SUCCESS" && response.data) {
          // 병원 정보 받아서 Redux에 저장
          const hospitalData: HospitalData = {
            id: response.data.id,
            name: response.data.name,
            did: response.data.did,
            address: response.data.address,
            phone_number: response.data.phone_number,
            account: response.data.account,
            license_number: response.data.license_number,
            doctor_name: response.data.doctor_name,
            authoriazation_number: response.data.authoriazation_number,
            x_axis: response.data.x_axis,
            y_axis: response.data.y_axis,
            public_key: response.data.public_key,
            doctors: [], // doctors 필드는 비워둠 (별도로 관리)
          };

          dispatch(setHospitalInfo(hospitalData));
        } else if (response.status === "FAILURE") {
          toast.error(
            response.message || "병원 정보를 가져오는데 실패했습니다."
          );

          // 인증 오류인 경우 로그인 페이지로 리디렉션
          if (response.message.includes("token")) {
            navigate("/login");
          }
        }
      } catch (error) {
        console.error("병원 정보 조회 오류:", error);
        toast.error("병원 정보를 가져오는데 실패했습니다.");
      } finally {
        setIsFetching(false);
      }
    };

    fetchHospitalData();
  }, [dispatch, navigate]);

  // 병원 정보가 업데이트되면 폼 데이터 업데이트
  useEffect(() => {
    if (hospital) {
      setFormData({
        name: hospital.name || "",
        address: hospital.address || "",
        phone: hospital.phone || hospital.phone_number || "",
        email: hospital.email || "",
        password: "",
        confirmPassword: "",
      });
    }
  }, [hospital]);

  // 폼 데이터 변경 핸들러
  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setFormData((prev) => ({ ...prev, [name]: value }));
  };

  // 폼 제출 핸들러
  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    // 비밀번호 입력 시 확인 비밀번호가 일치하는지 검증
    if (formData.password && formData.password !== formData.confirmPassword) {
      toast.error("비밀번호가 일치하지 않습니다.");
      return;
    }

    try {
      setIsLoading(true);

      // API 요청 데이터 구성
      const updateData: UpdateHospitalRequest = {
        did: hospital.did,
      };

      // 변경된 필드만 요청에 포함
      if (formData.name !== hospital.name) {
        updateData.name = formData.name;
      }

      const currentPhone = hospital.phone || hospital.phone_number || "";
      if (formData.phone !== currentPhone) {
        updateData.phone_number = formData.phone;
      }

      if (formData.password) {
        updateData.password = formData.password;
      }

      // API 호출하여 병원 정보 업데이트
      const result = await updateHospitalInfo(updateData);

      if (result.status === "SUCCESS" && result.data) {
        // Redux 상태 업데이트
        const updatedHospital: HospitalData = {
          ...hospital,
          name: result.data.name,
          did: result.data.did,
          address: result.data.address,
          phone: result.data.phone_number,
          phone_number: result.data.phone_number,
          doctors: [], // 의사 목록 현재 값 유지
        };

        dispatch(updateHospitalInfoAction(updatedHospital));

        // 비밀번호 필드 초기화
        setFormData((prev) => ({
          ...prev,
          password: "",
          confirmPassword: "",
        }));

        toast.success(
          result.message || "병원 정보가 성공적으로 업데이트되었습니다."
        );
      } else {
        toast.error(result.message || "병원 정보 업데이트에 실패했습니다.");
      }
    } catch (error) {
      console.error("병원 정보 업데이트 오류:", error);
      toast.error("오류가 발생했습니다. 다시 시도해주세요.");
    } finally {
      setIsLoading(false);
    }
  };

  // 회원 탈퇴 처리 핸들러
  const handleWithdrawal = async () => {
    try {
      const response = await deleteHospitalAccount();

      if (response.status === "SUCCESS") {
        toast.success(response.message || "회원 탈퇴가 완료되었습니다.");

        // Redux 상태 초기화 (로그아웃)
        dispatch(logoutAction());

        // 로그인 페이지로 리디렉션
        navigate("/login");
      } else {
        toast.error(response.message || "회원 탈퇴에 실패했습니다.");
        setIsWithdrawalModalOpen(false);
      }
    } catch (error) {
      console.error("회원 탈퇴 처리 오류:", error);
      toast.error("회원 탈퇴 중 오류가 발생했습니다.");
      setIsWithdrawalModalOpen(false);
    }
  };

  return (
    <div className="container mx-auto py-8 px-4 max-w-4xl">
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-2xl font-bold text-gray-800 dark:text-gray-100">
          병원 설정
        </h1>
        <button
          onClick={() => navigate("/dashboard")}
          className="flex items-center px-4 py-2 bg-blue-500 hover:bg-blue-600 text-white rounded-md transition-colors dark:bg-blue-600 dark:hover:bg-blue-700"
        >
          <FontAwesomeIcon icon={faHome} className="mr-2" />
          대시보드로 돌아가기
        </button>
      </div>

      {isFetching ? (
        <div className="flex justify-center items-center py-16">
          <div className="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-blue-500"></div>
          <p className="ml-3 text-lg text-gray-700 dark:text-gray-300">
            병원 정보를 불러오는 중...
          </p>
        </div>
      ) : (
        <>
          <div className="bg-white shadow-md rounded-lg p-6 mb-8 dark:bg-gray-800">
            <h2 className="text-xl font-semibold mb-4 text-gray-700 flex items-center dark:text-gray-200">
              <FontAwesomeIcon
                icon={faHospital}
                className="mr-2 text-blue-500"
              />
              기본 정보
            </h2>

            <form onSubmit={handleSubmit}>
              <div className="grid md:grid-cols-2 gap-4 mb-6">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1 dark:text-gray-300">
                    병원명
                  </label>
                  <div className="relative">
                    <span className="absolute inset-y-0 left-0 flex items-center pl-3 text-gray-500 dark:text-gray-400">
                      <FontAwesomeIcon icon={faHospital} />
                    </span>
                    <input
                      type="text"
                      name="name"
                      value={formData.name}
                      onChange={handleChange}
                      className="w-full pl-10 pr-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:text-white"
                      placeholder="병원 이름"
                    />
                  </div>
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1 dark:text-gray-300">
                    DID 식별자
                  </label>
                  <div className="relative">
                    <span className="absolute inset-y-0 left-0 flex items-center pl-3 text-gray-500 dark:text-gray-400">
                      <FontAwesomeIcon icon={faIdCard} />
                    </span>
                    <input
                      type="text"
                      value={hospital.did || "자동 생성됨"}
                      className="w-full pl-10 pr-3 py-2 border border-gray-300 rounded-md bg-gray-100 cursor-not-allowed dark:bg-gray-600 dark:border-gray-600 dark:text-gray-300"
                      readOnly
                    />
                  </div>
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1 dark:text-gray-300">
                    연락처
                  </label>
                  <div className="relative">
                    <span className="absolute inset-y-0 left-0 flex items-center pl-3 text-gray-500 dark:text-gray-400">
                      <FontAwesomeIcon icon={faPhone} />
                    </span>
                    <input
                      type="text"
                      name="phone"
                      value={formData.phone}
                      onChange={handleChange}
                      className="w-full pl-10 pr-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:text-white"
                      placeholder="병원 연락처"
                    />
                  </div>
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1 dark:text-gray-300">
                    이메일
                  </label>
                  <div className="relative">
                    <span className="absolute inset-y-0 left-0 flex items-center pl-3 text-gray-500 dark:text-gray-400">
                      <FontAwesomeIcon icon={faEnvelope} />
                    </span>
                    <input
                      type="email"
                      name="email"
                      value={formData.email}
                      onChange={handleChange}
                      className="w-full pl-10 pr-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:text-white"
                      placeholder="hospital@example.com"
                      disabled // 이메일은 API에서 변경 지원하지 않음
                    />
                  </div>
                  <p className="mt-1 text-xs text-gray-500 dark:text-gray-400">
                    이메일은 변경할 수 없습니다.
                  </p>
                </div>
              </div>

              <div className="mb-6">
                <label className="block text-sm font-medium text-gray-700 mb-1 dark:text-gray-300">
                  주소
                </label>
                <div className="relative">
                  <span className="absolute inset-y-0 left-0 flex items-center pl-3 text-gray-500 dark:text-gray-400">
                    <FontAwesomeIcon icon={faMapMarkerAlt} />
                  </span>
                  <input
                    type="text"
                    name="address"
                    value={formData.address}
                    onChange={handleChange}
                    className="w-full pl-10 pr-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:text-white"
                    placeholder="병원 주소"
                    disabled // 주소는 API에서 변경 지원하지 않음
                  />
                </div>
                <p className="mt-1 text-xs text-gray-500 dark:text-gray-400">
                  주소는 변경할 수 없습니다.
                </p>
              </div>

              <div className="mb-6 border-t pt-6 border-gray-200 dark:border-gray-700">
                <h3 className="text-lg font-medium text-gray-700 mb-4 dark:text-gray-300">
                  비밀번호 변경
                </h3>

                <div className="grid md:grid-cols-2 gap-4">
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-1 dark:text-gray-300">
                      새 비밀번호
                    </label>
                    <div className="relative">
                      <span className="absolute inset-y-0 left-0 flex items-center pl-3 text-gray-500 dark:text-gray-400">
                        <FontAwesomeIcon icon={faLock} />
                      </span>
                      <input
                        type={showPassword ? "text" : "password"}
                        name="password"
                        value={formData.password}
                        onChange={handleChange}
                        className="w-full pl-10 pr-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:text-white"
                        placeholder="새 비밀번호 (변경 시에만 입력)"
                      />
                    </div>
                  </div>

                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-1 dark:text-gray-300">
                      비밀번호 확인
                    </label>
                    <div className="relative">
                      <span className="absolute inset-y-0 left-0 flex items-center pl-3 text-gray-500 dark:text-gray-400">
                        <FontAwesomeIcon icon={faLock} />
                      </span>
                      <input
                        type={showPassword ? "text" : "password"}
                        name="confirmPassword"
                        value={formData.confirmPassword}
                        onChange={handleChange}
                        className="w-full pl-10 pr-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:text-white"
                        placeholder="비밀번호 확인"
                      />
                    </div>
                  </div>
                </div>

                <div className="mt-2">
                  <label className="inline-flex items-center">
                    <input
                      type="checkbox"
                      className="form-checkbox h-4 w-4 text-blue-600 transition duration-150 ease-in-out"
                      checked={showPassword}
                      onChange={() => setShowPassword(!showPassword)}
                    />
                    <span className="ml-2 text-sm text-gray-600 dark:text-gray-400">
                      비밀번호 보이기
                    </span>
                  </label>
                </div>
              </div>

              <div className="flex justify-between items-center">
                <button
                  type="submit"
                  disabled={isLoading}
                  className="bg-blue-500 hover:bg-blue-600 text-white py-2 px-4 rounded-md transition-colors dark:bg-blue-600 dark:hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  {isLoading ? "저장 중..." : "정보 저장"}
                </button>

                <button
                  type="button"
                  onClick={() => setIsWithdrawalModalOpen(true)}
                  className="text-red-600 hover:text-red-800 border border-red-600 hover:border-red-800 rounded-md py-2 px-4 flex items-center transition-colors dark:text-red-400 dark:hover:text-red-300 dark:border-red-400 dark:hover:border-red-300"
                >
                  <FontAwesomeIcon icon={faTrashAlt} className="mr-2" />
                  회원 탈퇴
                </button>
              </div>
            </form>
          </div>

          {/* 의사 관리 컴포넌트 - props 제거 */}
          <DoctorManagement />
        </>
      )}

      {/* 회원 탈퇴 확인 모달 */}
      <WithdrawalModal
        isOpen={isWithdrawalModalOpen}
        onClose={() => setIsWithdrawalModalOpen(false)}
        onConfirm={handleWithdrawal}
        hospitalName={hospital.name}
      />
    </div>
  );
};

export default HospitalSettings;
