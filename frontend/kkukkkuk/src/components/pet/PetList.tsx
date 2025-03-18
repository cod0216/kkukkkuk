import React, { useState, useEffect, useCallback } from 'react';
import { useAppDispatch, useAppSelector } from '../../redux/store';
import { 
  Pet,
  fetchPetsStart, 
  fetchPetsSuccess, 
  fetchPetsFailure,
  selectPet, 
  updateTreatmentStatus,
  setSortField,
  SortField,
  SortOrder,
  toggleHideCompleted,
  clearSelectedPet,
  TreatmentStatus,
  setCustomOrder
} from '../../redux/slices/petSlice';
import { 
  FiSearch, 
  FiUser, 
  FiPlus, 
  FiMoreVertical, 
  FiRefreshCw, 
  FiArrowUp, 
  FiArrowDown, 
  FiCheck,
  FiFilter,
  FiClock,
  FiDatabase,
  FiCrosshair
} from 'react-icons/fi';
import { toast } from 'react-toastify';
import {
  DndContext,
  closestCenter,
  KeyboardSensor,
  PointerSensor,
  useSensor,
  useSensors,
  DragEndEvent
} from '@dnd-kit/core';
import {
  arrayMove,
  SortableContext,
  sortableKeyboardCoordinates,
  useSortable,
  verticalListSortingStrategy
} from '@dnd-kit/sortable';
import { CSS } from '@dnd-kit/utilities';
import { fetchPets } from '../../services/petService';

// 아이콘 props 인터페이스 정의
interface IconProps extends React.SVGProps<SVGSVGElement> {
  size?: number;
  color?: string;
  className?: string;
}

// 아이콘 컴포넌트를 위한 타입 단언
const IconSearch = FiSearch as unknown as React.ComponentType<IconProps>;
const IconUser = FiUser as unknown as React.ComponentType<IconProps>;
const IconPlus = FiPlus as unknown as React.ComponentType<IconProps>;
const IconMoreVertical = FiMoreVertical as unknown as React.ComponentType<IconProps>;
const IconRefresh = FiRefreshCw as unknown as React.ComponentType<IconProps>;
const IconArrowUp = FiArrowUp as unknown as React.ComponentType<IconProps>;
const IconArrowDown = FiArrowDown as unknown as React.ComponentType<IconProps>;
const IconCheck = FiCheck as unknown as React.ComponentType<IconProps>;
const IconFilter = FiFilter as unknown as React.ComponentType<IconProps>;
const IconClock = FiClock as unknown as React.ComponentType<IconProps>;
const IconDatabase = FiDatabase as unknown as React.ComponentType<IconProps>;
const IconTarget = FiCrosshair as unknown as React.ComponentType<IconProps>;

// 정렬 가능한 반려동물 아이템 컴포넌트
interface SortablePetItemProps {
  pet: Pet;
  isSelected: boolean;
  onSelect: (petId: string) => void;
  onUpdateTreatmentStatus: (petId: string, status: TreatmentStatus) => void;
  blockchainStatus: 'synced' | 'pending' | 'error' | 'none';
}

const SortablePetItem: React.FC<SortablePetItemProps> = ({ 
  pet,
  isSelected, 
  onSelect,
  onUpdateTreatmentStatus,
  blockchainStatus
}) => {
  const {
    attributes,
    listeners,
    setNodeRef,
    transform,
    transition,
    isDragging
  } = useSortable({ id: pet.id });

  // 진료 상태에 따른 스타일 설정
  const getTreatmentStatusStyle = (status: TreatmentStatus) => {
    switch (status) {
      case 'waiting':
        return 'bg-yellow-100 text-yellow-800 dark:bg-yellow-900 dark:text-yellow-300';
      case 'inProgress':
        return 'bg-blue-100 text-blue-800 dark:bg-blue-900 dark:text-blue-300';
      case 'completed':
        return 'bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-300';
      default:
        return 'bg-gray-100 text-gray-800 dark:bg-gray-700 dark:text-gray-300';
    }
  };

  // 진료 상태 텍스트 변환
  const getTreatmentStatusText = (status: TreatmentStatus) => {
    switch (status) {
      case 'waiting': return '진료대기중';
      case 'inProgress': return '진료중';
      case 'completed': return '진료완료';
      default: return '상태없음';
    }
  };

  // 다음 상태로 순환하는 함수
  const getNextStatus = (currentStatus: TreatmentStatus): TreatmentStatus => {
    switch (currentStatus) {
      case 'waiting': return 'inProgress';
      case 'inProgress': return 'completed';
      case 'completed': return 'waiting';
      default: return 'waiting';
    }
  };

  // 만료일까지 남은 시간 계산
  const getRemainingTime = () => {
    const now = new Date();
    const expiryDate = new Date(pet.expiryDate);
    
    // 이미 만료된 경우
    if (expiryDate < now) {
      return { isExpired: true, text: '만료됨' };
    }
    
    // 남은 일수 계산
    const timeDiff = expiryDate.getTime() - now.getTime();
    const daysDiff = Math.ceil(timeDiff / (1000 * 3600 * 24));
    
    if (daysDiff < 1) {
      const hoursDiff = Math.ceil(timeDiff / (1000 * 3600));
      return { isExpired: false, text: `${hoursDiff}시간 남음`, isUrgent: true };
    }
    
    return { isExpired: false, text: `${daysDiff}일 남음`, isUrgent: daysDiff <= 2 };
  };
  
  const remainingTime = getRemainingTime();

  // 날짜 포맷팅 함수
  const formatDate = (dateString: string) => {
    const date = new Date(dateString);
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
  };

  // 블록체인 상태에 따른 색상 설정
  const getBlockchainStatusColor = () => {
    switch (blockchainStatus) {
      case 'synced': return 'bg-green-500';
      case 'pending': return 'bg-yellow-500';
      case 'error': return 'bg-red-500';
      default: return 'bg-gray-400';
    }
  };

  const style = {
    transform: CSS.Transform.toString(transform),
    transition,
    zIndex: isDragging ? 10 : 1,
    opacity: isDragging ? 0.8 : 1,
    position: 'relative' as 'relative'
  };

  return (
    <li className={`${isSelected ? 'bg-blue-50 dark:bg-blue-900/20' : 'bg-white dark:bg-gray-800'} 
      rounded-lg shadow-sm mb-3 cursor-pointer transition-all hover:shadow-md dark:border dark:border-gray-700
      ${pet.treatmentStatus === 'inProgress' ? 'animate-blink' : ''}`}
      style={style}
      onClick={() => onSelect(pet.id)}>
      <div className="p-4">
        <div className="flex flex-col gap-2">
          <div className="flex items-center justify-between">
            {/* 무버블 핸들 추가 - 리스트 앞쪽에 위치 */}
            <div 
              {...attributes} 
              {...listeners}
              className="mr-2 p-1.5 text-gray-400 cursor-grab hover:bg-gray-100 rounded dark:hover:bg-gray-700 flex items-center justify-center"
              onClick={(e) => e.stopPropagation()} // 핸들을 클릭할 때 선택 이벤트 중지
              title="순서 변경하기"
            >
              <IconMoreVertical size={16} />
            </div>
            
            {/* 반려동물 정보 (메인 포커스) */}
            <div className="flex-1 min-w-0">
              <h3 className="text-base font-bold text-gray-800 dark:text-white">
                {pet.name} <span className="font-normal text-sm text-gray-500 dark:text-gray-400">{pet.breed}</span>
              </h3>
              
              {/* 보호자 정보 (작게 표시) */}
              <div className="text-xs text-gray-600 dark:text-gray-400 mt-1">
                보호자 {pet.guardianName}
              </div>
            </div>

            {/* 진료 상태 표시 */}
            <div 
              onClick={(e) => {
                e.stopPropagation();
                onUpdateTreatmentStatus(pet.id, getNextStatus(pet.treatmentStatus));
              }}
              className={`px-2 py-1 rounded-full text-xs font-medium flex items-center ${getTreatmentStatusStyle(pet.treatmentStatus)}`}
            >
              {pet.treatmentStatus === 'completed' && <IconCheck size={12} className="mr-1" />}
              {pet.treatmentStatus === 'waiting' && <IconClock size={12} className="mr-1" />}
              {pet.treatmentStatus === 'inProgress' && <IconTarget size={12} className="mr-1" />}
              {getTreatmentStatusText(pet.treatmentStatus)}
            </div>
          </div>
          
          {/* 날짜 정보 */}
          <div className="flex items-center justify-between text-xs">
            <div className="flex items-center text-gray-500 dark:text-gray-400">
              <span className="mr-1">등록일:</span>
              <span>{formatDate(pet.registeredDate)}</span>
            </div>
            
            <div className={`flex items-center ${
              remainingTime.isExpired 
                ? 'text-red-500 dark:text-red-400' 
                : remainingTime.isUrgent
                  ? 'text-yellow-500 dark:text-yellow-400'
                  : 'text-green-500 dark:text-green-400'
            }`}>
              <IconClock size={10} className="mr-1" />
              <span>{remainingTime.text}</span>
            </div>
          </div>
        </div>
      </div>
    </li>
  );
};

// 반려동물 정렬 함수
const sortPets = (pets: Pet[], sortField: SortField, sortOrder: SortOrder, customOrder: string[] = []) => {
  // 커스텀 정렬인 경우
  if (sortField === 'custom' && customOrder.length > 0) {
    return [...pets].sort((a, b) => {
      const indexA = customOrder.indexOf(a.id);
      const indexB = customOrder.indexOf(b.id);
      
      // 커스텀 목록에 없는 항목은 맨 뒤로
      if (indexA === -1) return 1;
      if (indexB === -1) return -1;
      
      return indexA - indexB;
    });
  }
  
  return [...pets].sort((a, b) => {
    let comparison = 0;
    
    switch (sortField) {
      case 'name':
        comparison = a.name.localeCompare(b.name);
        break;
      case 'registeredDate':
        comparison = new Date(a.registeredDate).getTime() - new Date(b.registeredDate).getTime();
        break;
      case 'expiryDate':
        comparison = new Date(a.expiryDate).getTime() - new Date(b.expiryDate).getTime();
        break;
      case 'treatmentStatus':
        // 진료 상태에 따른 우선순위 부여 (진료중 > 진료대기 > 진료완료)
        const statusPriority = {
          'inProgress': 0,
          'waiting': 1,
          'completed': 2
        };
        comparison = statusPriority[a.treatmentStatus] - statusPriority[b.treatmentStatus];
        
        // 같은 진료 상태면 등록일 기준 정렬
        if (comparison === 0) {
          comparison = new Date(a.registeredDate).getTime() - new Date(b.registeredDate).getTime();
        }
        break;
      default:
        return 0;
    }
    
    return sortOrder === 'asc' ? comparison : -comparison;
  });
};

// 블록체인 상태 확인 함수
const getPetBlockchainStatus = (pet: Pet): 'synced' | 'pending' | 'error' | 'none' => {
  // API 연동 후 실제 블록체인 상태 확인 로직으로 대체 필요
  return 'synced';
};

const PetList: React.FC = () => {
  const [searchTerm, setSearchTerm] = useState('');
  const [localPets, setLocalPets] = useState<Pet[]>([]);
  const dispatch = useAppDispatch();
  const { 
    pets: reduxPets, 
    selectedPet: reduxSelectedPet, 
    loading, 
    error, 
    sortField, 
    sortOrder,
    hideCompleted,
    customOrder
  } = useAppSelector((state) => state.pet);

  // 정렬을 위한 센서 설정
  const sensors = useSensors(
    useSensor(PointerSensor, { activationConstraint: { distance: 5 } }),
    useSensor(KeyboardSensor, { coordinateGetter: sortableKeyboardCoordinates })
  );

  const loadPets = useCallback(async () => {
    if (loading) return;
    
    try {
      dispatch(fetchPetsStart());
      
      // API 호출
      const response = await fetchPets();
      if (response.status === 'SUCCESS') {
        dispatch(fetchPetsSuccess(response.data));
        
        // 초기 선택 설정
        if (response.data.length > 0) {
          const previousSelectedId = localStorage.getItem('selectedPetId');
          const petToSelect = previousSelectedId 
            ? response.data.find((p: Pet) => p.id === previousSelectedId) ?? response.data[0]
            : response.data[0];
            
          dispatch(selectPet(petToSelect.id));
          localStorage.setItem('selectedPetId', petToSelect.id);
        }
      } else {
        throw new Error(response.message || '반려동물 목록을 불러오는데 실패했습니다.');
      }
    } catch (err) {
      const errorMessage = err instanceof Error ? err.message : '반려동물 목록을 불러오는데 실패했습니다.';
      dispatch(fetchPetsFailure(errorMessage));
      toast.error(errorMessage);
    }
  }, [dispatch, loading]);

  useEffect(() => {
    loadPets();
  }, [loadPets]);

  // Redux 상태가 변경되면 로컬 상태 업데이트 및 정렬 적용
  useEffect(() => {
    const sortedPets = sortPets(reduxPets, sortField, sortOrder, customOrder);
    setLocalPets(sortedPets);
  }, [reduxPets, sortField, sortOrder, customOrder]);

  // 반려동물 선택 핸들러
  const handlePetSelect = (petId: string) => {
    // 선택한 반려동물을 찾음
    const pet = reduxPets.find(p => p.id === petId);
    
    if (pet) {
      // 선택한 반려동물 ID를 상태에 저장
      dispatch(selectPet(petId));
      
      // 로컬 스토리지에 선택한 반려동물 ID 저장
      localStorage.setItem('selectedPetId', petId);
    }
  };

  const handleUpdateTreatmentStatus = (petId: string, status: TreatmentStatus) => {
    dispatch(updateTreatmentStatus({ petId, status }));
    toast.info(`진료 상태가 "${status === 'waiting' ? '진료대기중' : status === 'inProgress' ? '진료중' : '진료완료'}"로 변경되었습니다.`);
  };

  // 드래그 종료 시 처리 함수
  const handleDragEnd = (event: DragEndEvent) => {
    const { active, over } = event;
    
    if (over && active.id !== over.id) {
      setLocalPets((items) => {
        const oldIndex = items.findIndex(item => item.id === active.id);
        const newIndex = items.findIndex(item => item.id === over.id);
        
        const newOrder = arrayMove(items, oldIndex, newIndex);
        
        // 새로운 순서의 ID 배열을 생성하여 저장
        const newCustomOrder = newOrder.map(item => item.id);
        dispatch(setCustomOrder(newCustomOrder));
        
        toast.info('목록 순서가 변경되었습니다.');
        return newOrder;
      });
    }
  };

  // 필터링된 반려동물 목록 (완료 상태인 경우에만 숨김)
  let filteredPets = localPets.filter((pet: Pet) => 
    (pet.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
    pet.guardianName.toLowerCase().includes(searchTerm.toLowerCase())) &&
    (!hideCompleted || pet.treatmentStatus !== 'completed')
  );

  return (
    <div className="h-full flex flex-col bg-white dark:bg-gray-800 shadow-sm">
      {/* 헤더: 제목 및 새로고침 버튼 */}
      <div className="px-4 py-3 bg-gray-50 dark:bg-gray-700 border-b dark:border-gray-600 flex items-center justify-between">
        <h2 className="text-lg font-semibold text-gray-800 dark:text-white flex items-center">
          <IconUser className="mr-2" />
          <span>반려동물 목록</span>
        </h2>
        
        <div className="flex space-x-2">
          {/* 필터 토글 버튼 */}
          <button 
            onClick={() => dispatch(toggleHideCompleted())}
            className={`p-1.5 rounded-full transition-colors ${
              hideCompleted 
                ? 'bg-blue-500 text-white' 
                : 'bg-gray-200 text-gray-700 dark:bg-gray-600 dark:text-gray-300'
            }`}
            title={hideCompleted ? '완료된 진료 숨김' : '모든 진료 표시'}
          >
            <IconFilter size={14} />
          </button>

          {/* 새로고침 버튼 */}
          <button 
            onClick={() => loadPets()}
            className="p-1.5 bg-gray-200 text-gray-700 rounded-full hover:bg-gray-300 dark:bg-gray-600 dark:text-gray-300 dark:hover:bg-gray-500"
            disabled={loading}
            title="목록 새로고침"
          >
            <IconRefresh size={14} className={loading ? 'animate-spin' : ''} />
          </button>
        </div>
      </div>
      
      {/* 검색 영역 */}
      <div className="px-4 py-2 bg-white dark:bg-gray-800 border-b dark:border-gray-700">
        <div className="relative">
          <input
            type="text"
            placeholder="반려동물 또는 보호자 검색..."
            value={searchTerm}
            onChange={e => setSearchTerm(e.target.value)}
            className="w-full pl-9 pr-3 py-1.5 bg-gray-100 border-0 rounded-md text-sm text-gray-800 placeholder-gray-500 focus:ring-2 focus:ring-blue-500 dark:bg-gray-700 dark:text-white dark:placeholder-gray-400"
          />
          <div className="absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none">
            <IconSearch size={14} className="text-gray-500 dark:text-gray-400" />
          </div>
        </div>
      </div>
      
      {/* 정렬 옵션 */}
      <div className="flex items-center text-xs px-4 py-1.5 bg-gray-50 dark:bg-gray-700 border-b dark:border-gray-600">
        <span className="text-gray-600 dark:text-gray-300 mr-2">정렬:</span>
        
        {/* 커스텀 정렬 표시 */}
        {sortField === 'custom' && (
          <span className="mr-2 px-1.5 py-0.5 rounded bg-purple-500 text-white">
            사용자 정렬
          </span>
        )}
        
        <button 
          onClick={() => dispatch(setSortField('name'))} 
          className={`mr-2 px-1.5 py-0.5 rounded ${
            sortField === 'name' 
              ? 'bg-blue-500 text-white' 
              : sortField === 'custom'
                ? 'text-gray-400 bg-gray-200 dark:bg-gray-600 dark:text-gray-500' 
                : 'text-gray-700 bg-gray-200 dark:bg-gray-600 dark:text-gray-300'
          }`}
          disabled={sortField === 'custom'}
        >
          이름
          {sortField === 'name' && (
            sortOrder === 'asc' ? <IconArrowUp size={10} className="ml-1 inline" /> : <IconArrowDown size={10} className="ml-1 inline" />
          )}
        </button>
        <button 
          onClick={() => dispatch(setSortField('registeredDate'))} 
          className={`mr-2 px-1.5 py-0.5 rounded ${
            sortField === 'registeredDate' 
              ? 'bg-blue-500 text-white' 
              : sortField === 'custom'
                ? 'text-gray-400 bg-gray-200 dark:bg-gray-600 dark:text-gray-500' 
                : 'text-gray-700 bg-gray-200 dark:bg-gray-600 dark:text-gray-300'
          }`}
          disabled={sortField === 'custom'}
        >
          등록일
          {sortField === 'registeredDate' && (
            sortOrder === 'asc' ? <IconArrowUp size={10} className="ml-1 inline" /> : <IconArrowDown size={10} className="ml-1 inline" />
          )}
        </button>
        <button 
          onClick={() => dispatch(setSortField('expiryDate'))} 
          className={`mr-2 px-1.5 py-0.5 rounded ${
            sortField === 'expiryDate' 
              ? 'bg-blue-500 text-white' 
              : sortField === 'custom'
                ? 'text-gray-400 bg-gray-200 dark:bg-gray-600 dark:text-gray-500' 
                : 'text-gray-700 bg-gray-200 dark:bg-gray-600 dark:text-gray-300'
          }`}
          disabled={sortField === 'custom'}
        >
          만료일
          {sortField === 'expiryDate' && (
            sortOrder === 'asc' ? <IconArrowUp size={10} className="ml-1 inline" /> : <IconArrowDown size={10} className="ml-1 inline" />
          )}
        </button>
        <button 
          onClick={() => dispatch(setSortField('treatmentStatus'))} 
          className={`px-1.5 py-0.5 rounded ${
            sortField === 'treatmentStatus' 
              ? 'bg-blue-500 text-white' 
              : sortField === 'custom'
                ? 'text-gray-400 bg-gray-200 dark:bg-gray-600 dark:text-gray-500' 
                : 'text-gray-700 bg-gray-200 dark:bg-gray-600 dark:text-gray-300'
          }`}
          disabled={sortField === 'custom'}
        >
          진료상태
          {sortField === 'treatmentStatus' && (
            sortOrder === 'asc' ? <IconArrowUp size={10} className="ml-1 inline" /> : <IconArrowDown size={10} className="ml-1 inline" />
          )}
        </button>
      </div>
      
      {/* 반려동물 목록 */}
      <div className="flex-1 overflow-y-auto px-3 py-2">
        {/* 로딩 상태 표시 */}
        {loading && (
          <div className="flex justify-center items-center py-4">
            <div className="animate-spin rounded-full h-6 w-6 border-b-2 border-blue-500"></div>
            <span className="ml-2 text-gray-600 dark:text-gray-300">로딩 중...</span>
          </div>
        )}
        
        {/* 에러 표시 */}
        {error && (
          <div className="bg-red-100 text-red-700 p-3 rounded-md text-sm dark:bg-red-900 dark:text-red-200">
            <p>{error}</p>
            <button 
              onClick={() => loadPets()} 
              className="mt-2 text-red-700 dark:text-red-200 hover:underline flex items-center"
            >
              <IconRefresh size={12} className="mr-1" />
              다시 시도
            </button>
          </div>
        )}
        
        {/* 목록 데이터 */}
        {!loading && !error && (
          <>
            {/* 드래그 앤 드롭 컨텍스트 */}
            <DndContext
              sensors={sensors}
              collisionDetection={closestCenter}
              onDragEnd={handleDragEnd}
            >
              <SortableContext
                items={filteredPets.map(pet => pet.id)}
                strategy={verticalListSortingStrategy}
              >
                <ul>
                  {filteredPets.map(pet => {
                    const blockchainStatus = getPetBlockchainStatus(pet);
                    
                    return (
                      <SortablePetItem
                        key={pet.id}
                        pet={pet}
                        isSelected={reduxSelectedPet?.id === pet.id}
                        onSelect={handlePetSelect}
                        onUpdateTreatmentStatus={handleUpdateTreatmentStatus}
                        blockchainStatus={blockchainStatus}
                      />
                    );
                  })}
                </ul>
              </SortableContext>
            </DndContext>
            
            {/* 결과 없음 표시 */}
            {filteredPets.length === 0 && (
              <div className="text-center py-6 text-gray-500 dark:text-gray-400">
                {searchTerm ? (
                  <p>검색 결과가 없습니다.</p>
                ) : hideCompleted ? (
                  <p>진행 중인 진료가 없습니다.</p>
                ) : (
                  <p>반려동물이 없습니다.</p>
                )}
              </div>
            )}
          </>
        )}
      </div>
    </div>
  );
};

export default PetList; 