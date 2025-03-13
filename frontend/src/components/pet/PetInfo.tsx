import React, { useEffect, useState, useRef } from 'react';
import { useAppDispatch, useAppSelector } from '../../redux/store';
import { fetchPetsStart, fetchPetsSuccess, fetchPetsFailure, selectPet, Pet, BlockchainInfo, fetchBlockchainDataStart, fetchBlockchainDataSuccess, fetchBlockchainDataFailure, clearSelectedPet } from '../../redux/slices/petSlice';
import { FiPlus, FiRefreshCw, FiDatabase, FiAlertCircle, FiCheck, FiClock, FiAlertTriangle, FiChevronDown, FiChevronUp } from 'react-icons/fi';
import { toast } from 'react-toastify';
import { Guardian } from '../../redux/slices/guardianSlice';
import { store } from '../../redux/store';
import { DEV_USE_MOCK_BLOCKCHAIN, getBlockchainData } from '../../utils/blockchainUtils';
import { selectDevModeEnabled, selectMockDataForPet, generateMockDataForPet } from '../../redux/slices/devModeSlice';

// 아이콘 props 인터페이스 정의
interface IconProps extends React.SVGProps<SVGSVGElement> {
  size?: number;
  color?: string;
  className?: string;
}

// 아이콘 컴포넌트를 위한 타입 단언
const IconPlus = FiPlus as unknown as React.ComponentType<IconProps>;
const IconRefresh = FiRefreshCw as unknown as React.ComponentType<IconProps>;
const IconDatabase = FiDatabase as unknown as React.ComponentType<IconProps>;
const IconAlert = FiAlertCircle as unknown as React.ComponentType<IconProps>;
const IconCheck = FiCheck as unknown as React.ComponentType<IconProps>;
const IconClock = FiClock as unknown as React.ComponentType<IconProps>;
const IconAlertTriangle = FiAlertTriangle as unknown as React.ComponentType<IconProps>;
const IconChevronDown = FiChevronDown as unknown as React.ComponentType<IconProps>;
const IconChevronUp = FiChevronUp as unknown as React.ComponentType<IconProps>;

// 미니 카드 컴포넌트
interface PetMiniCardProps {
  pet: Pet;
  isSelected: boolean;
  onClick: () => void;
}

const PetMiniCard: React.FC<PetMiniCardProps> = ({ pet, isSelected, onClick }) => {
  // 블록체인 상태 아이콘 및 색상 결정
  const getBlockchainStatus = () => {
    if (!pet.blockchainData) {
      return { icon: <IconClock size={12} />, color: 'text-gray-400', text: '미동기화' };
    }
    
    const dataDate = new Date(pet.blockchainData.timestamp);
    const now = new Date();
    const daysSinceUpdate = Math.floor((now.getTime() - dataDate.getTime()) / (1000 * 60 * 60 * 24));
    
    if (daysSinceUpdate > 7) {
      return { icon: <IconAlertTriangle size={12} />, color: 'text-red-500', text: '업데이트 필요' };
    } else if (daysSinceUpdate > 3) {
      return { icon: <IconAlertTriangle size={12} />, color: 'text-yellow-500', text: '확인 필요' };
    } else {
      return { icon: <IconCheck size={12} />, color: 'text-green-500', text: '동기화됨' };
    }
  };
  
  const status = getBlockchainStatus();
  
  return (
    <div 
      onClick={onClick}
      className={`cursor-pointer py-1 px-2 rounded-md flex items-center space-x-2 ${
        isSelected 
          ? 'bg-primary bg-opacity-20 border-l-2 border-primary' 
          : 'hover:bg-gray-100 dark:hover:bg-gray-700'
      }`}
    >
      <div className="flex-shrink-0 w-6 h-6 rounded-full bg-gray-200 dark:bg-gray-600 flex items-center justify-center text-xs text-gray-600 dark:text-gray-300">
        {pet.species === '개' ? '🐕' : pet.species === '고양이' ? '🐈' : '🐾'}
      </div>
      <div className="flex-1 min-w-0">
        <div className="flex items-center">
          <p className="font-medium text-sm text-gray-700 dark:text-gray-300 truncate">{pet.name}</p>
          <span className="ml-1 text-xs text-gray-500 dark:text-gray-400">({pet.species})</span>
        </div>
      </div>
      <div className={`flex-shrink-0 ${status.color}`} title={status.text}>
        {status.icon}
      </div>
    </div>
  );
};

interface PetInfoProps {
  onNewTreatment: (petId: string) => void;
}

interface GuardianState {
  selectedGuardian: Guardian | null;
}

interface PetState {
  pets: Pet[];
  selectedPet: Pet | null;
  loading: boolean;
  error: string | null;
  blockchainLoading: boolean;
  blockchainError: string | null;
}

const PetInfo: React.FC<PetInfoProps> = ({ onNewTreatment }) => {
  const dispatch = useAppDispatch();
  const { selectedGuardian } = useAppSelector(state => state.guardian as GuardianState);
  const { pets, selectedPet, loading, error, blockchainLoading, blockchainError } = useAppSelector(state => state.pet as PetState);
  const [showBlockchainInfo, setShowBlockchainInfo] = useState(false);
  
  // 개발 모드 상태 확인
  const devModeEnabled = useAppSelector(selectDevModeEnabled);
  
  // 이전 블록체인 데이터 저장용 ref
  const prevBlockchainDataRef = useRef<{[key: string]: BlockchainInfo}>({});

  // 반려동물 정보 로드 함수 수정
  const loadPets = async (guardian: Guardian) => {
    try {
      dispatch(fetchPetsStart());
      
      // 실제 API 호출 대신 Redux 초기 상태 사용
      // TODO: 실제 API 연동 시 수정 필요
      setTimeout(() => {
        // Redux 초기 상태의 pets를 사용
        const statePets = store.getState().pet.pets;
        // guardianId로 필터링
        const guardianPets = statePets.filter(pet => pet.guardianId === guardian.id);
        dispatch(fetchPetsSuccess(guardianPets));
        
        // 이전에 선택된 반려동물이 있으면 해당 반려동물 유지, 아니면 첫 번째 반려동물 선택
        if (guardianPets.length > 0) {
          const previousSelectedPetId = localStorage.getItem('selectedPetId');
          const petToSelect = previousSelectedPetId && guardianPets.some(p => p.id === previousSelectedPetId)
            ? previousSelectedPetId
            : guardianPets[0].id;
          
          dispatch(selectPet(petToSelect));
          // 선택된 반려동물 ID를 로컬 스토리지에 저장
          localStorage.setItem('selectedPetId', petToSelect);
          
          // 자동으로 새 진료 기록 작성 컴포넌트 표시
          onNewTreatment(petToSelect);
          
          // 블록체인 데이터 자동 로드
          loadBlockchainData(petToSelect);
        }
      }, 300);
    } catch (err) {
      dispatch(fetchPetsFailure('반려동물 정보를 불러오는데 실패했습니다.'));
      toast.error('반려동물 정보를 불러오는데 실패했습니다.');
    }
  };

  // 블록체인 데이터 로드 함수 수정
  const loadBlockchainData = async (petId: string) => {
    try {
      console.log(`[PetInfo] Loading blockchain data for pet ID: ${petId}, devMode: ${devModeEnabled}`);
      dispatch(fetchBlockchainDataStart());
      
      // 실제 블록체인 API 호출 대신 유틸리티 함수 사용
      setTimeout(() => {
        // getBlockchainData 함수는 이미 개발 모드 상태를 확인하고 적절한 데이터를 반환함
        const blockchainData = getBlockchainData(petId);
        console.log(`[PetInfo] Received blockchain data:`, blockchainData);
        
        if (blockchainData) {
          // 이전 데이터와 비교
          const prevData = prevBlockchainDataRef.current[petId];
          
          // 새 데이터 저장
          dispatch(fetchBlockchainDataSuccess({
            petId,
            blockchainData
          }));
          
          // 데이터 비교 및 알림 표시
          if (!prevData) {
            // 이전 데이터가 없는 경우만 알림 표시
            toast.success('블록체인 데이터를 불러왔습니다.');
            // 새 데이터 저장
            prevBlockchainDataRef.current[petId] = { ...blockchainData };
          } else if (
            prevData.transactionId !== blockchainData.transactionId || 
            prevData.timestamp !== blockchainData.timestamp ||
            prevData.blockNumber !== blockchainData.blockNumber
          ) {
            // 데이터가 변경된 경우에만 알림 표시
            toast.success('새로운 블록체인 데이터를 불러왔습니다.');
            // 새 데이터 저장
            prevBlockchainDataRef.current[petId] = { ...blockchainData };
          }
        } else {
          dispatch(fetchBlockchainDataFailure('블록체인 데이터를 찾을 수 없습니다.'));
          toast.warning('블록체인 데이터를 찾을 수 없습니다. (개발 모드 활성화 필요)');
        }
      }, 500);
    } catch (err) {
      dispatch(fetchBlockchainDataFailure('블록체인 데이터를 불러오는데 실패했습니다.'));
      toast.error('블록체인 데이터를 불러오는데 실패했습니다.');
    }
  };

  useEffect(() => {
    if (selectedGuardian) {
      loadPets(selectedGuardian);
    } else {
      // selectedGuardian이 없을 경우 localStorage에서 이전에 선택된 보호자 ID 확인
      const savedGuardianId = localStorage.getItem('selectedGuardianId');
      if (savedGuardianId) {
        // 모든 보호자 목록에서 저장된 ID로 보호자 찾기
        const allGuardians = store.getState().guardian.guardians;
        const savedGuardian = allGuardians.find(g => g.id === savedGuardianId);
        
        if (savedGuardian) {
          // 보호자 선택 상태 복원
          dispatch({ type: 'guardian/selectGuardian', payload: savedGuardianId });
          
          // 해당 보호자의 반려동물 로드
          loadPets(savedGuardian);
        }
      }
    }
  }, [selectedGuardian, dispatch]);

  useEffect(() => {
    if (selectedPet) {
      loadBlockchainData(selectedPet.id);
    }
  }, [selectedPet]);

  // 반려동물 선택 핸들러 수정
  const handlePetChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
    const petId = e.target.value;
    if (petId) {
      dispatch(selectPet(petId));
      // 선택된 반려동물 ID를 로컬 스토리지에 저장
      localStorage.setItem('selectedPetId', petId);
      // 자동으로 새 진료 기록 작성 컴포넌트 표시
      onNewTreatment(petId);
    }
  };

  const handlePetSelect = (petId: string) => {
    dispatch(selectPet(petId));
    onNewTreatment(petId);
    loadBlockchainData(petId);
  };

  // 블록체인 데이터 새로고침 핸들러 수정
  const handleRefreshBlockchain = () => {
    if (selectedPet) {
      // 강제 새로고침으로 간주 - 이전 데이터 삭제
      if (prevBlockchainDataRef.current[selectedPet.id]) {
        delete prevBlockchainDataRef.current[selectedPet.id];
      }
      loadBlockchainData(selectedPet.id);
    }
  };

  const formatDate = (dateString?: string) => {
    if (!dateString) return '미상';
    
    const date = new Date(dateString);
    return date.toLocaleDateString('ko-KR', { 
      year: 'numeric', 
      month: 'long', 
      day: 'numeric' 
    });
  };

  const formatTimestamp = (timestamp?: string) => {
    if (!timestamp) return '';
    
    const date = new Date(timestamp);
    return date.toLocaleString('ko-KR', { 
      year: 'numeric', 
      month: 'long', 
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit',
      second: '2-digit'
    });
  };

  const formatGender = (gender: string) => {
    switch (gender) {
      case 'male': return '수컷';
      case 'female': return '암컷';
      default: return '미상';
    }
  };

  // 블록체인 상태 뱃지 컴포넌트
  const BlockchainStatusBadge: React.FC<{ pet: Pet }> = ({ pet }) => {
    if (!pet.blockchainData) {
      return (
        <div className="flex items-center text-gray-500 bg-gray-100 text-xs rounded-full px-2 py-0.5 dark:bg-gray-700 dark:text-gray-400">
          <IconClock size={10} className="mr-1" />
          <span>미동기화</span>
        </div>
      );
    }

    const dataDate = new Date(pet.blockchainData.timestamp);
    const now = new Date();
    const daysSinceUpdate = Math.floor((now.getTime() - dataDate.getTime()) / (1000 * 60 * 60 * 24));
    
    if (daysSinceUpdate > 7) {
      return (
        <div className="flex items-center text-red-800 bg-red-100 text-xs rounded-full px-2 py-0.5 dark:bg-red-900/30 dark:text-red-400">
          <IconAlertTriangle size={10} className="mr-1" />
          <span>업데이트 필요</span>
        </div>
      );
    } else if (daysSinceUpdate > 3) {
      return (
        <div className="flex items-center text-yellow-800 bg-yellow-100 text-xs rounded-full px-2 py-0.5 dark:bg-yellow-900/30 dark:text-yellow-400">
          <IconAlertTriangle size={10} className="mr-1" />
          <span>확인 필요</span>
        </div>
      );
    } else {
      return (
        <div className="flex items-center text-green-800 bg-green-100 text-xs rounded-full px-2 py-0.5 dark:bg-green-900/30 dark:text-green-400">
          <IconCheck size={10} className="mr-1" />
          <span>동기화됨</span>
        </div>
      );
    }
  };

  if (!selectedGuardian) {
    return (
      <div className="h-full p-4 bg-white rounded-lg shadow-md dark:bg-gray-800">
        <div className="flex items-center justify-center h-full text-gray-500 dark:text-gray-400">
          <p className="text-lg">보호자를 선택해주세요</p>
        </div>
      </div>
    );
  }

  return (
    <div className="bg-white rounded-lg shadow dark:bg-gray-800">
      <div className="p-4">
        {loading ? (
          <div className="h-64 flex items-center justify-center">
            <div className="w-8 h-8 border-t-2 border-b-2 border-primary rounded-full animate-spin"></div>
          </div>
        ) : error ? (
          <div className="h-64 flex items-center justify-center text-red-500">
            <IconAlert size={20} className="mr-2" />
            <span>{error}</span>
          </div>
        ) : !selectedGuardian ? (
          <div className="h-64 flex items-center justify-center text-gray-500 dark:text-gray-400">
            <p>보호자를 선택해주세요.</p>
          </div>
        ) : pets.length === 0 ? (
          <div className="h-64 flex items-center justify-center text-gray-500 dark:text-gray-400">
            <p>등록된 반려동물이 없습니다.</p>
          </div>
        ) : (
          <div>
            {/* 반려동물 선택 및 정보 */}
            <div className="flex items-center justify-between mb-4">
              <div className="flex items-center">
                <h2 className="text-lg font-semibold text-gray-800 dark:text-white mr-4">
                  {selectedGuardian.name}님의 반려동물
                </h2>
                {selectedPet && (
                  <button
                    onClick={handleRefreshBlockchain}
                    className={`p-1 text-gray-500 rounded-md hover:bg-gray-100 dark:text-gray-400 dark:hover:bg-gray-700 ${blockchainLoading ? 'opacity-50 cursor-not-allowed' : ''}`}
                    disabled={blockchainLoading}
                    title="블록체인 데이터 새로고침"
                  >
                    <IconRefresh size={14} className={blockchainLoading ? 'animate-spin' : ''} />
                  </button>
                )}
              </div>
            </div>

            {/* 반려동물 정보 (줄글 형태) */}
            {selectedPet ? (
              <div className="p-4 bg-gray-50 dark:bg-gray-700 rounded-md mb-4">
                <div className="flex items-center space-x-4">
                  <div className="flex-initial w-48 flex items-center">
                    <select
                      id="pet-select"
                      className="w-full p-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent dark:bg-gray-700 dark:border-gray-600 dark:text-white"
                      value={selectedPet?.id || ''}
                      onChange={handlePetChange}
                    >
                      {pets.map(pet => (
                        <option key={pet.id} value={pet.id}>
                          {pet.name}
                        </option>
                      ))}
                    </select>
                  </div>
                  <div className="flex-initial">
                    <span className="font-medium text-gray-700 dark:text-gray-300">종류:</span>
                    <span className="ml-1 text-gray-800 dark:text-white">{selectedPet.species || '미상'}</span>
                  </div>
                  <div className="flex-initial">
                    <span className="font-medium text-gray-700 dark:text-gray-300">품종:</span>
                    <span className="ml-1 text-gray-800 dark:text-white">{selectedPet.breed || '미상'}</span>
                  </div>
                  <div className="flex-initial">
                    <span className="font-medium text-gray-700 dark:text-gray-300">성별:</span>
                    <span className="ml-1 text-gray-800 dark:text-white">{formatGender(selectedPet.gender)}</span>
                  </div>
                  <div className="flex-initial">
                    <span className="font-medium text-gray-700 dark:text-gray-300">출생일:</span>
                    <span className="ml-1 text-gray-800 dark:text-white">{formatDate(selectedPet.birthDate)}</span>
                  </div>
                </div>
              </div>
            ) : (
              <div className="p-4 bg-gray-50 dark:bg-gray-700 rounded-md mb-4">
                <label htmlFor="pet-select" className="block mb-1 text-sm font-medium text-gray-700 dark:text-gray-300">
                  반려동물 선택
                </label>
                <select
                  id="pet-select"
                  className="w-full p-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent dark:bg-gray-700 dark:border-gray-600 dark:text-white"
                  value=""
                  onChange={handlePetChange}
                >
                  <option value="">반려동물을 선택하세요</option>
                  {pets.map(pet => (
                    <option key={pet.id} value={pet.id}>
                      {pet.name}
                    </option>
                  ))}
                </select>
              </div>
            )}

            {/* 접을 수 있는 블록체인 정보 섹션 */}
            {selectedPet && (
              <div className="border dark:border-gray-700 rounded-md overflow-hidden">
                <div 
                  className="p-3 bg-gray-50 dark:bg-gray-700 flex items-center justify-between cursor-pointer" 
                  onClick={() => setShowBlockchainInfo(!showBlockchainInfo)}
                >
                  <div className="flex items-center">
                    <IconDatabase size={16} className="text-primary mr-2" />
                    <h4 className="font-medium text-gray-800 dark:text-white">블록체인 정보</h4>
                  </div>
                  {showBlockchainInfo ? 
                    <IconChevronUp size={16} className="text-gray-500 dark:text-gray-400" /> : 
                    <IconChevronDown size={16} className="text-gray-500 dark:text-gray-400" />
                  }
                </div>
                
                {showBlockchainInfo && (
                  <div className="p-3 border-t dark:border-gray-700">
                    {blockchainLoading ? (
                      <div className="flex items-center justify-center py-3">
                        <div className="w-5 h-5 border-t-2 border-b-2 border-primary rounded-full animate-spin mr-2"></div>
                        <span className="text-sm text-gray-500 dark:text-gray-400">블록체인 데이터 로딩 중...</span>
                      </div>
                    ) : blockchainError ? (
                      <div className="flex items-center text-sm text-red-500 mt-2">
                        <IconAlert size={14} className="mr-1" />
                        <span>{blockchainError}</span>
                      </div>
                    ) : selectedPet.blockchainData ? (
                      <div className="text-xs space-y-1.5">
                        <div className="flex flex-col">
                          <span className="text-gray-500 dark:text-gray-400">트랜잭션 ID:</span>
                          <span className="text-gray-800 dark:text-white font-mono overflow-hidden text-ellipsis">{selectedPet.blockchainData.transactionId}</span>
                        </div>
                        <div className="flex flex-col">
                          <span className="text-gray-500 dark:text-gray-400">타임스탬프:</span>
                          <span className="text-gray-800 dark:text-white">{formatTimestamp(selectedPet.blockchainData.timestamp)}</span>
                        </div>
                        <div className="flex flex-col">
                          <span className="text-gray-500 dark:text-gray-400">블록 번호:</span>
                          <span className="text-gray-800 dark:text-white">{selectedPet.blockchainData.blockNumber}</span>
                        </div>
                        <div className="flex flex-col">
                          <span className="text-gray-500 dark:text-gray-400">의료 기록 수:</span>
                          <span className="text-gray-800 dark:text-white">{selectedPet.medicalRecords?.length || 0}개</span>
                        </div>
                      </div>
                    ) : (
                      <div className="flex items-center justify-center py-3">
                        <span className="text-sm text-gray-500 dark:text-gray-400">블록체인 데이터가 없습니다.</span>
                      </div>
                    )}
                  </div>
                )}
              </div>
            )}
          </div>
        )}
      </div>
    </div>
  );
};

export default PetInfo; 