import React, { useState, useEffect } from "react";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import {
  faUserMd,
  faSpinner,
  faPlus,
  faTimes,
  faPencilAlt,
  faCheck,
  faTrashAlt,
  faExclamationTriangle,
} from "@fortawesome/free-solid-svg-icons";
import {
  fetchDoctors,
  addDoctor,
  fetchDoctorDetail,
  updateDoctor,
  deleteDoctor,
} from "../../services/hospitalService";
import { toast } from "react-toastify";
import { useNavigate } from "react-router-dom";
import { useAppSelector } from "../../redux/store";
import { selectLoggedInHospital } from "../../redux/slices/authSlice";
import { Doctor as ApiDoctor } from "@/interfaces/index";

// 컴포넌트에서 사용할 의사 정보 인터페이스
export interface Doctor {
  id: string | number;
  name: string;
  specialization: string;
  licenseNumber?: string;
}

// 의사 상세 정보 모달 컴포넌트
interface DoctorDetailModalProps {
  isOpen: boolean;
  onClose: () => void;
  doctorId: string | number | null;
}

const DoctorDetailModal: React.FC<DoctorDetailModalProps> = ({
  isOpen,
  onClose,
  doctorId,
}) => {
  const [isLoading, setIsLoading] = useState(false);
  const [doctor, setDoctor] = useState<ApiDoctor | null>(null);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchDetail = async () => {
      if (!doctorId) return;

      try {
        setIsLoading(true);
        setError(null);

        const response = await fetchDoctorDetail(doctorId);

        if (response.status === "SUCCESS" && response.data) {
          setDoctor(response.data);
        } else {
          setError(response.message || "의사 정보를 가져오는데 실패했습니다.");
        }
      } catch (error) {
        console.error("의사 상세 정보 조회 오류:", error);
        setError("의사 정보를 가져오는데 실패했습니다.");
      } finally {
        setIsLoading(false);
      }
    };

    if (isOpen && doctorId) {
      fetchDetail();
    }
  }, [isOpen, doctorId]);

  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 flex items-center justify-center z-50">
      <div
        className="fixed inset-0 bg-black opacity-50"
        onClick={onClose}
      ></div>
      <div className="bg-white dark:bg-gray-800 rounded-lg p-6 w-full max-w-md mx-auto relative z-10">
        <div className="flex justify-between items-center mb-4">
          <h2 className="text-xl font-bold text-gray-800 dark:text-gray-200">
            수의사 상세 정보
          </h2>
          <button
            onClick={onClose}
            className="text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200"
          >
            <FontAwesomeIcon icon={faTimes} />
          </button>
        </div>

        {isLoading ? (
          <div className="flex justify-center items-center py-8">
            <FontAwesomeIcon
              icon={faSpinner}
              spin
              className="mr-2 text-blue-500"
            />
            <p className="text-gray-600 dark:text-gray-400">
              정보를 불러오는 중...
            </p>
          </div>
        ) : error ? (
          <div className="text-center py-6">
            <p className="text-red-500 dark:text-red-400">{error}</p>
          </div>
        ) : doctor ? (
          <div className="space-y-4">
            <div className="bg-gray-100 dark:bg-gray-700 p-4 rounded-lg">
              <p className="text-sm text-gray-500 dark:text-gray-400">아이디</p>
              <p className="text-lg font-medium text-gray-800 dark:text-gray-200">
                {doctor.id}
              </p>
            </div>
            <div className="bg-gray-100 dark:bg-gray-700 p-4 rounded-lg">
              <p className="text-sm text-gray-500 dark:text-gray-400">이름</p>
              <p className="text-lg font-medium text-gray-800 dark:text-gray-200">
                {doctor.name}
              </p>
            </div>
            {/* 향후 추가될 필드를 위한 주석 처리 */}
            {/* 
            <div className="bg-gray-100 dark:bg-gray-700 p-4 rounded-lg">
              <p className="text-sm text-gray-500 dark:text-gray-400">면허 번호</p>
              <p className="text-lg font-medium text-gray-800 dark:text-gray-200">{doctor.licenseNumber || "-"}</p>
            </div>
            */}
            <p className="text-xs text-gray-500 dark:text-gray-400 text-center mt-4">
              * 현재 서비스에서는 기본 정보만 제공됩니다. 추가 정보는 향후
              업데이트될 예정입니다.
            </p>
          </div>
        ) : (
          <div className="text-center py-6">
            <p className="text-gray-600 dark:text-gray-400">정보가 없습니다.</p>
          </div>
        )}
      </div>
    </div>
  );
};

// 의사 정보 수정 모달 컴포넌트
interface EditDoctorModalProps {
  isOpen: boolean;
  onClose: () => void;
  doctor: Doctor | null;
  onSave: (id: string | number, name: string) => Promise<void>;
}

const EditDoctorModal: React.FC<EditDoctorModalProps> = ({
  isOpen,
  onClose,
  doctor,
  onSave,
}) => {
  const [name, setName] = useState("");
  const [isProcessing, setIsProcessing] = useState(false);

  // 모달이 열릴 때 의사 이름 초기화
  useEffect(() => {
    if (isOpen && doctor) {
      setName(doctor.name);
    }
  }, [isOpen, doctor]);

  if (!isOpen || !doctor) return null;

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    if (!name.trim()) {
      toast.error("의사 이름을 입력해주세요.");
      return;
    }

    try {
      setIsProcessing(true);
      await onSave(doctor.id, name);
      onClose();
    } finally {
      setIsProcessing(false);
    }
  };

  return (
    <div className="fixed inset-0 flex items-center justify-center z-50">
      <div
        className="fixed inset-0 bg-black opacity-50"
        onClick={onClose}
      ></div>
      <div className="bg-white dark:bg-gray-800 rounded-lg p-6 w-full max-w-md mx-auto relative z-10">
        <div className="flex justify-between items-center mb-4">
          <h2 className="text-xl font-bold text-gray-800 dark:text-gray-200">
            수의사 정보 수정
          </h2>
          <button
            onClick={onClose}
            className="text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200"
            disabled={isProcessing}
          >
            <FontAwesomeIcon icon={faTimes} />
          </button>
        </div>

        <form onSubmit={handleSubmit}>
          <div className="mb-4">
            <label className="block text-sm font-medium text-gray-700 mb-1 dark:text-gray-300">
              이름
            </label>
            <input
              type="text"
              value={name}
              onChange={(e) => setName(e.target.value)}
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:text-white"
              placeholder="의사 이름"
              disabled={isProcessing}
            />
          </div>

          <div className="flex justify-end space-x-3 mt-4">
            <button
              type="button"
              onClick={onClose}
              className="px-4 py-2 bg-gray-200 hover:bg-gray-300 rounded-md text-gray-800 dark:bg-gray-700 dark:hover:bg-gray-600 dark:text-gray-200"
              disabled={isProcessing}
            >
              취소
            </button>
            <button
              type="submit"
              disabled={isProcessing || !name.trim()}
              className="px-4 py-2 bg-blue-500 hover:bg-blue-600 rounded-md text-white disabled:opacity-50 disabled:cursor-not-allowed flex items-center"
            >
              {isProcessing ? (
                <>
                  <FontAwesomeIcon icon={faSpinner} spin className="mr-2" />
                  <span>저장 중...</span>
                </>
              ) : (
                <>
                  <FontAwesomeIcon icon={faCheck} className="mr-2" />
                  <span>저장</span>
                </>
              )}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};

// 의사 삭제 확인 모달 컴포넌트
interface DeleteDoctorModalProps {
  isOpen: boolean;
  onClose: () => void;
  doctor: Doctor | null;
  onConfirm: (id: string | number) => Promise<void>;
}

const DeleteDoctorModal: React.FC<DeleteDoctorModalProps> = ({
  isOpen,
  onClose,
  doctor,
  onConfirm,
}) => {
  const [isProcessing, setIsProcessing] = useState(false);

  if (!isOpen || !doctor) return null;

  const handleConfirm = async () => {
    try {
      setIsProcessing(true);
      await onConfirm(doctor.id);
      onClose();
    } finally {
      setIsProcessing(false);
    }
  };

  return (
    <div className="fixed inset-0 flex items-center justify-center z-50">
      <div
        className="fixed inset-0 bg-black opacity-50"
        onClick={onClose}
      ></div>
      <div className="bg-white dark:bg-gray-800 rounded-lg p-6 w-full max-w-md mx-auto relative z-10">
        <div className="flex justify-between items-center mb-4">
          <h2 className="text-xl font-bold text-red-600 dark:text-red-400 flex items-center">
            <FontAwesomeIcon icon={faExclamationTriangle} className="mr-2" />
            수의사 삭제 확인
          </h2>
          <button
            onClick={onClose}
            className="text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200"
            disabled={isProcessing}
          >
            <FontAwesomeIcon icon={faTimes} />
          </button>
        </div>

        <div className="mb-6">
          <p className="text-gray-700 dark:text-gray-300 mb-4">
            정말로 <span className="font-bold">{doctor.name}</span> 수의사를
            삭제하시겠습니까?
          </p>
          <p className="text-gray-700 dark:text-gray-300 mb-4">
            이 작업은 되돌릴 수 없으며, 해당 수의사의 모든 정보가 삭제됩니다.
          </p>
          <p className="text-sm text-amber-600 dark:text-amber-400 bg-amber-100 dark:bg-amber-900/30 p-3 rounded-md">
            주의: 동물병원에는 최소 1명 이상의 수의사가 필요합니다. 현재
            수의사가 1명뿐이라면 삭제할 수 없습니다.
          </p>
        </div>

        <div className="flex justify-end space-x-3 mt-4">
          <button
            type="button"
            onClick={onClose}
            className="px-4 py-2 bg-gray-200 hover:bg-gray-300 rounded-md text-gray-800 dark:bg-gray-700 dark:hover:bg-gray-600 dark:text-gray-200"
            disabled={isProcessing}
          >
            취소
          </button>
          <button
            type="button"
            onClick={handleConfirm}
            disabled={isProcessing}
            className="px-4 py-2 bg-red-600 hover:bg-red-700 rounded-md text-white disabled:opacity-50 disabled:cursor-not-allowed flex items-center"
          >
            {isProcessing ? (
              <>
                <FontAwesomeIcon icon={faSpinner} spin className="mr-2" />
                <span>처리 중...</span>
              </>
            ) : (
              <>
                <FontAwesomeIcon icon={faTrashAlt} className="mr-2" />
                <span>삭제</span>
              </>
            )}
          </button>
        </div>
      </div>
    </div>
  );
};

const DoctorManagement: React.FC = () => {
  const [doctors, setDoctors] = useState<Doctor[]>([]);
  const [newDoctor, setNewDoctor] = useState({
    name: "",
    specialization: "",
    licenseNumber: "",
  });
  const [isLoading, setIsLoading] = useState(false);
  const [isAddingDoctor, setIsAddingDoctor] = useState(false);
  const [selectedDoctorId, setSelectedDoctorId] = useState<
    string | number | null
  >(null);
  const [isDetailModalOpen, setIsDetailModalOpen] = useState(false);
  const [isEditModalOpen, setIsEditModalOpen] = useState(false);
  const [doctorToEdit, setDoctorToEdit] = useState<Doctor | null>(null);
  const [isDeleteModalOpen, setIsDeleteModalOpen] = useState(false);
  const [doctorToDelete, setDoctorToDelete] = useState<Doctor | null>(null);

  const navigate = useNavigate();
  const hospital = useAppSelector(selectLoggedInHospital);

  // 페이지 로드 시 의사 목록 가져오기
  useEffect(() => {
    const loadDoctors = async () => {
      try {
        setIsLoading(true);
        const response = await fetchDoctors();

        if (response.status === "SUCCESS" && response.data) {
          // API에서 가져온 의사 목록을 컴포넌트에 맞게 변환
          const formattedDoctors = response.data.map((doctor: ApiDoctor) => ({
            id: doctor.id,
            name: doctor.name,
            specialization: "", // API에서 제공하지 않음
            // licenseNumber: doctor.licenseNumber // 향후 추가될 예정
          }));

          setDoctors(formattedDoctors);
        } else if (response.status === "FAILURE") {
          toast.error(
            response.message || "의사 목록을 가져오는데 실패했습니다."
          );

          // 인증 오류인 경우 로그인 페이지로 리디렉션
          if (response.message?.includes("token")) {
            navigate("/login");
          }
        }
      } catch (error) {
        console.error("의사 목록 조회 오류:", error);
        toast.error("의사 목록을 가져오는데 실패했습니다.");
      } finally {
        setIsLoading(false);
      }
    };

    loadDoctors();
  }, [navigate]);

  // 새 의사 정보 변경 핸들러
  const handleDoctorChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setNewDoctor((prev) => ({ ...prev, [name]: value }));
  };

  // 의사 추가 핸들러 - API 연동
  const handleAddDoctor = async () => {
    if (!newDoctor.name) {
      toast.error("의사 이름을 입력해주세요.");
      return;
    }

    // 병원 ID가 없으면 오류 처리
    if (!hospital?.id) {
      toast.error("병원 정보를 찾을 수 없습니다. 다시 로그인해주세요.");
      return;
    }

    try {
      setIsAddingDoctor(true);

      // API 호출하여 의사 추가
      const response = await addDoctor(newDoctor.name, hospital.id);

      if (response.status === "SUCCESS" && response.data) {
        // API 응답으로 받은 의사 정보를 목록에 추가
        const newDoctorInfo: Doctor = {
          id: response.data.id,
          name: response.data.name,
          specialization: newDoctor.specialization || "", // API에서는 받지 않지만 UI에서는 보여줌
          licenseNumber: newDoctor.licenseNumber || "",
        };

        setDoctors((prev) => [...prev, newDoctorInfo]);
        setNewDoctor({ name: "", specialization: "", licenseNumber: "" });

        toast.success(response.message || "새로운 수의사가 등록되었습니다.");
      } else {
        toast.error(response.message || "의사 추가에 실패했습니다.");
      }
    } catch (error) {
      console.error("의사 추가 오류:", error);
      toast.error("의사 추가 중 오류가 발생했습니다.");
    } finally {
      setIsAddingDoctor(false);
    }
  };

  // 의사 삭제 핸들러 (아직 API 연동 없음)
  const handleRemoveDoctor = (id: string | number) => {
    setDoctors(doctors.filter((doctor: Doctor) => doctor.id !== id));
    toast.info("의사가 삭제되었습니다. (참고: 현재 서버에 반영되지 않습니다)");
  };

  // 의사 상세 정보 모달 열기
  const handleOpenDetailModal = (id: string | number) => {
    setSelectedDoctorId(id);
    setIsDetailModalOpen(true);
  };

  // 의사 상세 정보 모달 닫기
  const handleCloseDetailModal = () => {
    setIsDetailModalOpen(false);
    setSelectedDoctorId(null);
  };

  // 의사 수정 모달 열기
  const handleOpenEditModal = (doctor: Doctor) => {
    setDoctorToEdit(doctor);
    setIsEditModalOpen(true);
  };

  // 의사 수정 모달 닫기
  const handleCloseEditModal = () => {
    setIsEditModalOpen(false);
    setDoctorToEdit(null);
  };

  // 의사 정보 수정 처리
  const handleUpdateDoctor = async (id: string | number, name: string) => {
    try {
      const response = await updateDoctor(id, name);

      if (response.status === "SUCCESS" && response.data) {
        // 성공 시 해당 의사 정보 업데이트
        setDoctors((prev) =>
          prev.map((doctor) =>
            doctor.id === id ? { ...doctor, name: response.data!.name } : doctor
          )
        );

        toast.success("수의사 정보가 업데이트되었습니다.");
      } else {
        toast.error(response.message || "수의사 정보 수정에 실패했습니다.");
      }
    } catch (error) {
      console.error("의사 정보 수정 오류:", error);
      toast.error("수의사 정보 수정 중 오류가 발생했습니다.");
    }
  };

  // 의사 삭제 모달 열기
  const handleOpenDeleteModal = (doctor: Doctor) => {
    setDoctorToDelete(doctor);
    setIsDeleteModalOpen(true);
  };

  // 의사 삭제 모달 닫기
  const handleCloseDeleteModal = () => {
    setIsDeleteModalOpen(false);
    setDoctorToDelete(null);
  };

  // 의사 삭제 처리
  const handleDeleteDoctor = async (id: string | number) => {
    try {
      const response = await deleteDoctor(id);

      if (response.status === "SUCCESS") {
        // 성공 시 해당 의사 목록에서 제거
        setDoctors((prev) => prev.filter((doctor) => doctor.id !== id));
        toast.success(
          response.message || "수의사가 성공적으로 삭제되었습니다."
        );
      } else {
        toast.error(response.message || "수의사 삭제에 실패했습니다.");
      }
    } catch (error) {
      console.error("의사 삭제 오류:", error);
      toast.error("수의사 삭제 중 오류가 발생했습니다.");
    }
  };

  return (
    <div className="bg-white shadow-md rounded-lg p-6 dark:bg-gray-800">
      <h2 className="text-xl font-semibold mb-4 text-gray-700 flex items-center dark:text-gray-200">
        <FontAwesomeIcon icon={faUserMd} className="mr-2 text-blue-500" />
        의사 관리
      </h2>

      {isLoading ? (
        <div className="flex justify-center items-center py-8">
          <FontAwesomeIcon
            icon={faSpinner}
            spin
            className="mr-2 text-blue-500"
          />
          <p className="text-gray-600 dark:text-gray-400">
            의사 목록을 불러오는 중...
          </p>
        </div>
      ) : (
        <>
          <div className="mb-6">
            <div className="grid md:grid-cols-3 gap-4 mb-3">
              <div>
                <input
                  type="text"
                  name="name"
                  value={newDoctor.name}
                  onChange={handleDoctorChange}
                  className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:text-white"
                  placeholder="의사 이름 *"
                  disabled={isAddingDoctor}
                />
              </div>
              <div>
                <input
                  type="text"
                  name="specialization"
                  value={newDoctor.specialization}
                  onChange={handleDoctorChange}
                  className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:text-white"
                  placeholder="전문 분야 (선택)"
                  disabled={isAddingDoctor}
                />
              </div>
              <div>
                <input
                  type="text"
                  name="licenseNumber"
                  value={newDoctor.licenseNumber}
                  onChange={handleDoctorChange}
                  className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:text-white"
                  placeholder="면허 번호 (선택)"
                  disabled={isAddingDoctor}
                />
              </div>
            </div>

            <button
              type="button"
              onClick={handleAddDoctor}
              disabled={!newDoctor.name || isAddingDoctor}
              className="mt-2 bg-green-500 hover:bg-green-600 text-white py-1 px-3 rounded-md text-sm transition-colors dark:bg-green-600 dark:hover:bg-green-700 disabled:opacity-50 disabled:cursor-not-allowed flex items-center"
            >
              {isAddingDoctor ? (
                <>
                  <FontAwesomeIcon icon={faSpinner} spin className="mr-1" />
                  <span>등록 중...</span>
                </>
              ) : (
                <>
                  <FontAwesomeIcon icon={faPlus} className="mr-1" />
                  <span>의사 추가</span>
                </>
              )}
            </button>
            <p className="mt-1 text-xs text-gray-500 dark:text-gray-400">
              * 필수 입력 항목
            </p>
          </div>

          {doctors.length > 0 ? (
            <div className="overflow-x-auto">
              <table className="min-w-full divide-y divide-gray-200 dark:divide-gray-700">
                <thead className="bg-gray-50 dark:bg-gray-700">
                  <tr>
                    <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider dark:text-gray-300">
                      이름
                    </th>
                    <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider dark:text-gray-300">
                      전문 분야
                    </th>
                    <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider dark:text-gray-300">
                      면허 번호
                    </th>
                    <th className="px-4 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider dark:text-gray-300">
                      관리
                    </th>
                  </tr>
                </thead>
                <tbody className="bg-white divide-y divide-gray-200 dark:bg-gray-800 dark:divide-gray-700">
                  {doctors.map((doctor: Doctor) => (
                    <tr
                      key={doctor.id}
                      className="hover:bg-gray-50 dark:hover:bg-gray-700"
                    >
                      <td className="px-4 py-3 text-sm text-gray-900 dark:text-gray-100">
                        <button
                          onClick={() => handleOpenDetailModal(doctor.id)}
                          className="hover:text-blue-500 hover:underline focus:outline-none dark:hover:text-blue-400"
                        >
                          {doctor.name}
                        </button>
                      </td>
                      <td className="px-4 py-3 text-sm text-gray-900 dark:text-gray-100">
                        {doctor.specialization || "-"}
                      </td>
                      <td className="px-4 py-3 text-sm text-gray-900 dark:text-gray-100">
                        {doctor.licenseNumber || "-"}
                      </td>
                      <td className="px-4 py-3 text-sm text-right">
                        <div className="flex justify-end space-x-2">
                          <button
                            onClick={() => handleOpenEditModal(doctor)}
                            className="text-blue-500 hover:text-blue-700 transition-colors dark:text-blue-400 dark:hover:text-blue-300"
                            title="수정"
                          >
                            <FontAwesomeIcon icon={faPencilAlt} />
                          </button>
                          <button
                            onClick={() => handleOpenDeleteModal(doctor)}
                            className="text-red-500 hover:text-red-700 transition-colors dark:text-red-400 dark:hover:text-red-300"
                            title="삭제"
                          >
                            <FontAwesomeIcon icon={faTrashAlt} />
                          </button>
                        </div>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          ) : (
            <div className="text-center py-4 text-gray-500 dark:text-gray-400">
              등록된 의사가 없습니다. 의사 정보를 추가해주세요.
            </div>
          )}

          {doctors.length > 0 && (
            <div className="mt-4 text-xs text-gray-500 dark:text-gray-400 bg-gray-100 dark:bg-gray-700 p-3 rounded-md">
              <p className="flex items-center">
                <FontAwesomeIcon
                  icon={faExclamationTriangle}
                  className="mr-2 text-amber-500"
                />
                동물병원에는 최소 1명 이상의 수의사가 필요합니다.
              </p>
            </div>
          )}
        </>
      )}

      {/* 의사 상세 정보 모달 */}
      <DoctorDetailModal
        isOpen={isDetailModalOpen}
        onClose={handleCloseDetailModal}
        doctorId={selectedDoctorId}
      />

      {/* 의사 정보 수정 모달 */}
      <EditDoctorModal
        isOpen={isEditModalOpen}
        onClose={handleCloseEditModal}
        doctor={doctorToEdit}
        onSave={handleUpdateDoctor}
      />

      {/* 의사 삭제 확인 모달 */}
      <DeleteDoctorModal
        isOpen={isDeleteModalOpen}
        onClose={handleCloseDeleteModal}
        doctor={doctorToDelete}
        onConfirm={handleDeleteDoctor}
      />
    </div>
  );
};

export default DoctorManagement;
