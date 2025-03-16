import React, { useState } from "react";
import { toast } from "react-toastify";
import { verifyDoctor } from "../../services/hospitalService";

// 의사 정보 인터페이스
export interface Doctor {
  id: string;
  name: string;
  licenseNumber: string;
  isVerified: boolean;
}

interface DoctorRegistrationProps {
  doctors: Doctor[];
  setDoctors: React.Dispatch<React.SetStateAction<Doctor[]>>;
}

const DoctorRegistration: React.FC<DoctorRegistrationProps> = ({
  doctors,
  setDoctors,
}) => {
  const [doctorName, setDoctorName] = useState("");
  const [licenseNumber, setLicenseNumber] = useState("");
  const [isVerifying, setIsVerifying] = useState(false);

  // 의사 추가 함수
  const addDoctor = async () => {
    // 유효성 검사
    if (!doctorName.trim()) {
      toast.error("의사 이름을 입력해주세요.");
      return;
    }

    if (!licenseNumber.trim()) {
      toast.error("면허번호를 입력해주세요.");
      return;
    }

    // 중복 검사
    if (doctors.some((doctor) => doctor.licenseNumber === licenseNumber)) {
      toast.error("이미 추가된 면허번호입니다.");
      return;
    }

    try {
      setIsVerifying(true);

      // 면허 인증 API 호출
      const result = await verifyDoctor({ name: doctorName, licenseNumber });

      if (result.success && result.data.isVerified) {
        // 새 의사 추가
        const newDoctor: Doctor = {
          id: Date.now().toString(),
          name: doctorName,
          licenseNumber: licenseNumber,
          isVerified: true,
        };

        setDoctors([...doctors, newDoctor]);
        setDoctorName("");
        setLicenseNumber("");
        toast.success("의사 정보가 추가되었습니다.");
      } else {
        toast.error("의사 인증에 실패했습니다. 정확한 정보를 입력해주세요.");
      }
    } catch (error) {
      toast.error("의사 정보 추가 중 오류가 발생했습니다.");
      console.error("의사 추가 오류:", error);
    } finally {
      setIsVerifying(false);
    }
  };

  // 의사 삭제 함수
  const removeDoctor = (id: string) => {
    setDoctors(doctors.filter((doctor) => doctor.id !== id));
    toast.info("의사 정보가 삭제되었습니다.");
  };

  return (
    <div className="space-y-4">
      <h3 className="text-lg font-medium text-gray-900 dark:text-white">
        의사 등록
      </h3>

      <div className="bg-blue-50 p-4 rounded-lg border border-blue-200 mb-4 dark:bg-blue-900/20 dark:border-blue-800">
        <p className="text-sm text-blue-700 dark:text-blue-400">
          최소 1명 이상의 의사를 등록해야 합니다. 각 의사의 이름과 면허번호를
          입력하세요.
        </p>
      </div>

      <div className="grid grid-cols-1 gap-4 md:grid-cols-4">
        <div className="md:col-span-1">
          <label
            htmlFor="doctorName"
            className="block text-sm font-medium text-gray-700 dark:text-gray-300"
          >
            의사 이름
          </label>
          <input
            id="doctorName"
            type="text"
            value={doctorName}
            onChange={(e) => setDoctorName(e.target.value)}
            placeholder="이름"
            className="block w-full px-3 py-2 mt-1 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-primary focus:border-primary dark:bg-gray-700 dark:border-gray-600 dark:text-white"
          />
        </div>

        <div className="md:col-span-2">
          <label
            htmlFor="licenseNumber"
            className="block text-sm font-medium text-gray-700 dark:text-gray-300"
          >
            면허번호
          </label>
          <input
            id="licenseNumber"
            type="text"
            value={licenseNumber}
            onChange={(e) => setLicenseNumber(e.target.value)}
            placeholder="수의사 면허번호"
            className="block w-full px-3 py-2 mt-1 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-primary focus:border-primary dark:bg-gray-700 dark:border-gray-600 dark:text-white"
          />
        </div>

        <div className="md:col-span-1 flex items-end">
          <button
            type="button"
            onClick={addDoctor}
            disabled={isVerifying}
            className="w-full px-4 py-2 text-white bg-primary rounded-md hover:bg-primary-dark focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary disabled:opacity-50"
          >
            {isVerifying ? (
              <span className="flex flex-row items-center justify-center whitespace-nowrap">
                <span className="animate-pulse">⏳</span>
                <span className="ml-2">확인중</span>
              </span>
            ) : (
              <span className="flex flex-row items-center justify-center whitespace-nowrap">
                <span className="mr-2">➕</span>
                추가
              </span>
            )}
          </button>
        </div>
      </div>

      <div className="mt-6">
        <h4 className="text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
          등록된 의사 목록
        </h4>
        {doctors.length === 0 ? (
          <div className="text-sm text-gray-500 dark:text-gray-400 p-4 border border-dashed border-gray-300 dark:border-gray-600 rounded-md">
            등록된 의사가 없습니다. 최소 1명 이상의 의사를 등록해주세요.
          </div>
        ) : (
          <div className="space-y-2">
            {doctors.map((doctor) => (
              <div
                key={doctor.id}
                className="flex items-center justify-between p-3 bg-gray-50 dark:bg-gray-700 rounded-md"
              >
                <div>
                  <div className="flex items-center">
                    <span className="text-sm font-medium text-gray-700 dark:text-gray-300">
                      {doctor.name}
                    </span>
                    <span className="ml-2 px-2 py-0.5 text-xs font-medium bg-green-100 text-green-800 dark:bg-green-800 dark:text-green-100 rounded-full flex items-center">
                      <span className="mr-1">✓</span> 인증됨
                    </span>
                  </div>
                  <div className="text-xs text-gray-500 dark:text-gray-400 mt-1">
                    면허번호: {doctor.licenseNumber}
                  </div>
                </div>
                <button
                  type="button"
                  onClick={() => removeDoctor(doctor.id)}
                  className="text-gray-500 hover:text-red-500 dark:text-gray-400 dark:hover:text-red-400"
                >
                  <span className="text-xl">×</span>
                </button>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
};

export default DoctorRegistration;
