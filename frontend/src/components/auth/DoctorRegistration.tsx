import React, { useState } from "react";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faPlus, faTrash } from "@fortawesome/free-solid-svg-icons";
import { DoctorRegister } from "@/interfaces/doctor";

interface DoctorRegistrationProps {
  doctors: DoctorRegister[];
  setDoctors: React.Dispatch<React.SetStateAction<DoctorRegister[]>>;
}

const DoctorRegistration: React.FC<DoctorRegistrationProps> = ({
  doctors,
  setDoctors,
}) => {
  const [doctorName, setDoctorName] = useState("");
  const [doctorLicense, setDoctorLicense] = useState("");
  const [error, setError] = useState("");

  // 의사 정보 추가
  const addDoctor = () => {
    // 유효성 검사
    if (!doctorName.trim()) {
      setError("의사 이름을 입력해주세요.");
      return;
    }

    if (!doctorLicense.trim()) {
      setError("의사 면허번호를 입력해주세요.");
      return;
    }

    // 면허번호 중복 확인
    if (doctors.some((doc) => doc.licenseNumber === doctorLicense)) {
      setError("이미 등록된 면허번호입니다.");
      return;
    }

    // 의사 정보 추가
    const newDoctor: DoctorRegister = {
      id: Date.now().toString(),
      name: doctorName,
      licenseNumber: doctorLicense,
    };

    setDoctors([...doctors, newDoctor]);

    // 입력 필드 초기화
    setDoctorName("");
    setDoctorLicense("");
    setError("");
  };

  // 의사 정보 삭제
  const removeDoctor = (id: string) => {
    setDoctors(doctors.filter((doc) => doc.id !== id));
  };

  return (
    <div>
      <h3 className="text-lg font-medium text-gray-900 dark:text-white mb-4">
        의사 정보 등록
      </h3>

      <div className="mb-4">
        <p className="text-sm text-gray-600 dark:text-gray-400 mb-2">
          병원에 소속된 의사 정보를 등록해주세요. 최소 1명 이상의 의사 정보가
          필요합니다.
        </p>
      </div>

      {/* 입력 폼 */}
      <div className="grid grid-cols-1 gap-4 md:grid-cols-5 mb-4">
        <div className="md:col-span-2">
          <label
            htmlFor="doctorName"
            className="block text-sm font-medium text-gray-700 dark:text-gray-300"
          >
            의사 이름 *
          </label>
          <input
            id="doctorName"
            type="text"
            value={doctorName}
            onChange={(e) => setDoctorName(e.target.value)}
            className="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-primary focus:border-primary dark:bg-gray-700 dark:border-gray-600 dark:text-white"
            placeholder="의사 이름"
          />
        </div>

        <div className="md:col-span-2">
          <label
            htmlFor="doctorLicense"
            className="block text-sm font-medium text-gray-700 dark:text-gray-300"
          >
            의사 면허번호 *
          </label>
          <input
            id="doctorLicense"
            type="text"
            value={doctorLicense}
            onChange={(e) => setDoctorLicense(e.target.value)}
            className="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-primary focus:border-primary dark:bg-gray-700 dark:border-gray-600 dark:text-white"
            placeholder="의사 면허번호"
          />
        </div>

        <div className="md:col-span-1 flex items-end">
          <button
            type="button"
            onClick={addDoctor}
            className="w-full inline-flex justify-center items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md text-white bg-primary hover:bg-primary-dark focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary"
          >
            <FontAwesomeIcon icon={faPlus} className="mr-2" />
            추가
          </button>
        </div>
      </div>

      {/* 에러 메시지 */}
      {error && (
        <div className="mb-4 p-2 bg-red-100 text-red-700 text-sm rounded-md dark:bg-red-900 dark:text-red-100">
          {error}
        </div>
      )}

      {/* 등록된 의사 목록 */}
      <div className="border rounded-md overflow-hidden dark:border-gray-700">
        <table className="min-w-full divide-y divide-gray-200 dark:divide-gray-700">
          <thead className="bg-gray-50 dark:bg-gray-800">
            <tr>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider dark:text-gray-300">
                의사 이름
              </th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider dark:text-gray-300">
                면허번호
              </th>
              <th className="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider dark:text-gray-300">
                작업
              </th>
            </tr>
          </thead>
          <tbody className="bg-white divide-y divide-gray-200 dark:bg-gray-900 dark:divide-gray-700">
            {doctors.length > 0 ? (
              doctors.map((doctor) => (
                <tr key={doctor.id}>
                  <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900 dark:text-gray-300">
                    {doctor.name}
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900 dark:text-gray-300">
                    {doctor.licenseNumber}
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                    <button
                      type="button"
                      onClick={() => removeDoctor(doctor.id)}
                      className="text-red-600 hover:text-red-800 dark:text-red-400 dark:hover:text-red-300"
                    >
                      <FontAwesomeIcon icon={faTrash} className="mr-1" />
                      삭제
                    </button>
                  </td>
                </tr>
              ))
            ) : (
              <tr>
                <td
                  colSpan={3}
                  className="px-6 py-4 text-center text-sm text-gray-500 dark:text-gray-400"
                >
                  등록된 의사가 없습니다. 최소 1명 이상의 의사를 등록해주세요.
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default DoctorRegistration;
