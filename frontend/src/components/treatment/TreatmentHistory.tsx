import React, { useEffect, useState } from 'react';
import { useAppDispatch, useAppSelector, RootState } from '../../redux/store';
import { store } from '../../redux/store';
import { fetchTreatmentsStart, fetchTreatmentsSuccess, fetchTreatmentsFailure, setEditMode } from '../../redux/slices/treatmentSlice';
import { FiFileText, FiCheck, FiEdit2, FiLock } from 'react-icons/fi';
import { toast } from 'react-toastify';
import { Treatment } from '../../redux/slices/treatmentSlice';

// 아이콘 props 인터페이스 정의
interface IconProps extends React.SVGProps<SVGSVGElement> {
  size?: number;
  color?: string;
  className?: string;
}

// 아이콘 컴포넌트를 위한 타입 단언
const IconFileText = FiFileText as unknown as React.ComponentType<IconProps>;
const IconCheck = FiCheck as unknown as React.ComponentType<IconProps>;
const IconEdit = FiEdit2 as unknown as React.ComponentType<IconProps>;
const IconLock = FiLock as unknown as React.ComponentType<IconProps>;

// 임시 데이터 제거 (Redux 스토어 사용)
// const mockTreatments: Treatment[] = [ ... ] 부분 제거

interface TreatmentState {
  treatments: Treatment[];
  loading: boolean;
  error: string | null;
}

interface PetState {
  selectedPet: {
    id: string;
    name: string;
  } | null;
}

interface AuthState {
  user: {
    id: string;
    username: string;
    hospitalName?: string;
    hospitalId?: string;
  } | null;
}

const TreatmentHistory: React.FC = () => {
  const dispatch = useAppDispatch();
  const { treatments, loading, error } = useAppSelector((state: RootState) => state.treatment);
  const { selectedPet } = useAppSelector((state: RootState) => state.pet);
  const { user } = useAppSelector((state: RootState) => state.auth as AuthState);
  
  // 현재 로그인한 사용자 정보 (임시 목적으로 병원ID 하드코딩)
  const [currentUser, setCurrentUser] = useState({
    id: 'user-1',
    username: '병원 관리자',
    hospitalName: '싸피 병원',
    hospitalId: 'hospital-1'
  });

  // 진료 내역 로드 함수 수정
  const loadTreatments = async (petId: string) => {
    try {
      dispatch(fetchTreatmentsStart());
      
      // 실제 API 호출 대신 Redux 초기 상태 사용
      // TODO: 실제 API 연동 시 수정 필요
      setTimeout(() => {
        // Redux 초기 상태의 treatments를 사용
        const stateTreatments = store.getState().treatment.treatments;
        // petId로 필터링
        const petTreatments = stateTreatments.filter(treatment => treatment.petId === petId);
        
        if (petTreatments.length > 0) {
          dispatch(fetchTreatmentsSuccess(petTreatments));
        } else {
          dispatch(fetchTreatmentsSuccess([]));
        }
        
        // 로드한 반려동물 ID 저장
        localStorage.setItem('lastLoadedPetId', petId);
      }, 500);
    } catch (err) {
      dispatch(fetchTreatmentsFailure('진료 내역을 불러오는데 실패했습니다.'));
      // toast.error('진료 내역을 불러오는데 실패했습니다.'); // 토스트 알림 제거
    }
  };

  useEffect(() => {
    // selectedPet이 있으면 해당 반려동물의 진료 내역 로드
    if (selectedPet) {
      loadTreatments(selectedPet.id);
      return;
    }
    
    // selectedPet이 없을 경우 localStorage에서 이전에 선택된 반려동물 ID 확인
    const savedPetId = localStorage.getItem('selectedPetId') || localStorage.getItem('lastLoadedPetId');
    if (savedPetId) {
      loadTreatments(savedPetId);
      
      // 반려동물 상태가 초기화된 경우 Redux 스토어에서 반려동물 정보 다시 불러오기
      const allPets = store.getState().pet.pets;
      const savedPet = allPets.find(p => p.id === savedPetId);
      if (savedPet) {
        // 반려동물 선택 상태 복원
        dispatch({ type: 'pet/selectPet', payload: savedPetId });
        
        // 해당 반려동물의 보호자 정보도 복원
        const guardianId = savedPet.guardianId;
        if (guardianId) {
          // 보호자 상태 복원
          dispatch({ type: 'guardian/selectGuardian', payload: guardianId });
          localStorage.setItem('selectedGuardianId', guardianId);
          
          // 보호자에 속한 반려동물 목록도 다시 로드
          const allPets = store.getState().pet.pets;
          const guardianPets = allPets.filter(pet => pet.guardianId === guardianId);
          dispatch({ type: 'pet/fetchPetsSuccess', payload: guardianPets });
        }
      }
    }
  }, [selectedPet, dispatch]);

  const formatDate = (dateString: string) => {
    const date = new Date(dateString);
    return date.toLocaleDateString('ko-KR', {
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
      hour: '2-digit',
      minute: '2-digit'
    });
  };

  // 진료 내역 수정 가능 여부 확인
  const canEditTreatment = (treatment: Treatment) => {
    if (!currentUser || !treatment) return false;
    return treatment.hospitalId === currentUser.hospitalId;
  };

  // 진료 내역 수정 모드 시작
  const handleEditTreatment = (treatmentId: string) => {
    dispatch(setEditMode({ isEditing: true, treatmentId }));
    // 여기서 진료 수정 페이지로 이동하거나 모달을 표시할 수 있음
    // toast.info('진료 내역 수정 모드를 시작합니다.'); // 토스트 알림 제거
  };

  if (!selectedPet) {
    return (
      <div className="h-full p-4 bg-white rounded-lg shadow-md dark:bg-gray-800">
        <div className="flex flex-col items-center justify-center h-full text-gray-500 dark:text-gray-400">
          <p>반려동물을 선택해주세요.</p>
        </div>
      </div>
    );
  }

  return (
    <div className="h-full bg-white rounded-lg shadow-md dark:bg-gray-800">
      <div className="p-4 border-b dark:border-gray-700">
        <div className="flex items-center justify-between">
          <h2 className="text-lg font-semibold text-gray-800 dark:text-white">
            {selectedPet.name} 진료 내역 조회
          </h2>
          {/* PDF 버튼과 높이 맞추기 위한 빈 영역 */}
          <div className="h-8"></div>
        </div>
      </div>
      
      <div className="p-4 overflow-y-auto h-[calc(100vh-22rem)]">
        {loading ? (
          <div className="flex items-center justify-center h-32">
            <div className="w-8 h-8 border-t-2 border-b-2 border-primary rounded-full animate-spin"></div>
          </div>
        ) : error ? (
          <div className="p-4 mb-4 text-sm text-red-700 bg-red-100 rounded-lg dark:bg-red-200 dark:text-red-800">
            {error}
          </div>
        ) : treatments.length === 0 ? (
          <div className="flex flex-col items-center justify-center h-32 text-gray-500 dark:text-gray-400">
            <IconFileText size={24} className="mb-2" />
            <p>진료 내역이 없습니다.</p>
          </div>
        ) : (
          <div className="space-y-4">
            <div className="mb-4 p-3 bg-blue-50 dark:bg-blue-900/20 rounded-md">
              <div className="flex items-center text-sm text-blue-700 dark:text-blue-300">
                <IconFileText size={16} className="mr-2" />
                <span>
                  현재 <span className="font-semibold">{currentUser.hospitalName}</span>으로 로그인되어 있습니다. 본 병원에서 작성한 기록만 수정할 수 있습니다.
                </span>
              </div>
            </div>
            
            {treatments.map((treatment: Treatment) => (
              <div 
                key={treatment.id} 
                className="p-4 border border-gray-200 rounded-lg dark:border-gray-700 mb-4"
              >
                <div className="flex items-start justify-between mb-3">
                  <div>
                    <div className="flex items-center">
                      <h3 className="text-lg font-medium text-gray-800 dark:text-white">
                        {treatment.hospitalName}
                      </h3>
                      {treatment.blockchainVerified && (
                        <span className="flex items-center ml-2 text-xs text-green-600 bg-green-100 px-2 py-0.5 rounded-full dark:bg-green-900 dark:text-green-300">
                          <IconCheck size={12} className="mr-1" />
                          블록체인 검증됨
                        </span>
                      )}
                    </div>
                    <p className="text-sm text-gray-500 dark:text-gray-400">
                      {formatDate(treatment.treatmentDate)}
                    </p>
                  </div>
                </div>
                
                <div className="p-3 mb-4 bg-gray-50 rounded dark:bg-gray-700">
                  <h4 className="mb-1 text-sm font-medium text-gray-700 dark:text-gray-300">진단</h4>
                  <p className="text-gray-800 dark:text-white">{treatment.diagnosis}</p>
                </div>
                
                <div>
                  <h4 className="mb-2 text-sm font-medium text-gray-700 dark:text-gray-300">진료 항목</h4>
                  <div className="space-y-2">
                    {treatment.items.map((item, index) => (
                      <div key={index} className="flex justify-between text-sm">
                        <div className="flex">
                          <span className="text-gray-800 dark:text-white">{item.name}</span>
                          {item.quantity > 1 && (
                            <span className="ml-1 text-gray-500 dark:text-gray-400">x{item.quantity}</span>
                          )}
                          {item.dosage && (
                            <span className="ml-2 text-gray-500 dark:text-gray-400">({item.dosage})</span>
                          )}
                          {item.frequency && (
                            <span className="ml-2 text-gray-500 dark:text-gray-400">{item.frequency}</span>
                          )}
                        </div>
                        <span className="text-gray-800 dark:text-white">
                          {item.description || '-'}
                        </span>
                      </div>
                    ))}
                  </div>
                </div>
                
                <div className="flex justify-between pt-3 mt-4 border-t border-gray-200 dark:border-gray-700">
                  <span className="font-medium text-gray-700 dark:text-gray-300">진료 항목 수</span>
                  <span className="font-bold text-gray-800 dark:text-white">
                    {treatment.items.length}개
                  </span>
                </div>
                
                <div className="flex items-center justify-end mt-3">
                  <div className="flex items-center">
                    {canEditTreatment(treatment) ? (
                      <button
                        onClick={() => handleEditTreatment(treatment.id)}
                        className="p-1 text-blue-600 rounded hover:bg-blue-100 dark:text-blue-400 dark:hover:bg-blue-900/20"
                        title="진료 내역 수정"
                      >
                        <IconEdit size={16} />
                      </button>
                    ) : (
                      <div
                        className="p-1 text-gray-400 dark:text-gray-600"
                        title="수정 권한 없음"
                      >
                        <IconLock size={16} />
                      </div>
                    )}
                  </div>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
};

export default TreatmentHistory; 