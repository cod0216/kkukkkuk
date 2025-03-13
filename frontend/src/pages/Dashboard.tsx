import React, { useState, useEffect, useRef } from 'react';
import { useAppDispatch, useAppSelector, store } from '../redux/store';
import TreatmentForm from '../components/treatment/TreatmentForm';
import TreatmentHistory from '../components/treatment/TreatmentHistory';
import QRCodeGenerator from '../components/did/QRCodeGenerator';
import { generateHospitalDID } from '../redux/slices/didSlice';
import { toast } from 'react-toastify';
import { fetchGuardiansStart, fetchGuardiansSuccess, fetchGuardiansFailure, selectGuardian } from '../redux/slices/guardianSlice';
import { fetchPetsStart, fetchPetsSuccess, fetchPetsFailure, selectPet, fetchPetsByGuardian } from '../redux/slices/petSlice';
import { fetchTreatmentsStart, fetchTreatmentsSuccess, fetchTreatmentsFailure } from '../redux/slices/treatmentSlice';
import { preloadMockDataForAllPets, selectDevModeEnabled, initializeDevModeData } from '../redux/slices/devModeSlice';
import { FiColumns, FiGrid, FiMaximize, FiMinimize, FiMove, FiRefreshCw, FiRotateCcw, FiTablet } from 'react-icons/fi';
import { DndContext, closestCenter, KeyboardSensor, PointerSensor, useSensor, useSensors, DragEndEvent } from '@dnd-kit/core';
import { arrayMove, SortableContext, sortableKeyboardCoordinates, useSortable } from '@dnd-kit/sortable';
import { CSS } from '@dnd-kit/utilities';

// 아이콘 props 인터페이스 정의
interface IconProps extends React.SVGProps<SVGSVGElement> {
  size?: number;
  color?: string;
  className?: string;
}

// 아이콘 컴포넌트를 위한 타입 단언
const IconColumns = FiColumns as unknown as React.ComponentType<IconProps>;
const IconTablet = FiTablet as unknown as React.ComponentType<IconProps>;
const IconRotateCcw = FiRotateCcw as unknown as React.ComponentType<IconProps>;
const IconRefreshCw = FiRefreshCw as unknown as React.ComponentType<IconProps>;
const IconMove = FiMove as unknown as React.ComponentType<IconProps>;

// 레이아웃 타입 정의
type LayoutMode = 'tab' | 'column' | 'flexible';
type ActiveTab = 'treatment' | 'history';

// 컴포넌트 아이디 타입
type ComponentId = 'treatment' | 'history';

interface AuthState {
  user: {
    id: string;
    username: string;
    hospitalName?: string;
  } | null;
}

interface DIDState {
  didInfo: {
    did: string;
    hospitalName: string;
    createdAt: string;
  } | null;
  showQRCode: boolean;
}

// 드래그 가능한 섹션 타입
interface DraggableSectionProps {
  id: ComponentId;
  title: string;
  children: React.ReactNode;
  width: string;
}

// 드래그 가능한 섹션 컴포넌트 - 중첩 최소화
const DraggableSection = ({ id, title, children, width }: DraggableSectionProps) => {
  const {
    attributes,
    listeners,
    setNodeRef,
    transform,
    transition,
    isDragging
  } = useSortable({ id });

  const style = {
    transform: CSS.Transform.toString(transform),
    transition,
    opacity: isDragging ? 0.5 : 1,
    flex: `0 0 ${width}`,
    maxHeight: '80vh'
  };

  return (
    <div ref={setNodeRef} style={style} className="md:overflow-auto relative">
      <div className="absolute top-2 right-2 z-10 text-gray-400 hover:text-gray-600 dark:text-gray-500 dark:hover:text-gray-400 cursor-grab" 
        {...attributes} {...listeners}>
        <IconMove size={16} />
      </div>
      <div className="p-4">
        <h2 className="text-lg font-medium text-gray-800 dark:text-gray-200 mb-4">
          {title}
        </h2>
        {children}
      </div>
    </div>
  );
};

// 드래그 가능한 컴포넌트 래퍼
interface DraggableWrapperProps {
  id: ComponentId;
  children: React.ReactNode;
  width: string;
  mode: LayoutMode;
}

// 최소화된 드래그 가능한 래퍼 - 시각적 중첩 없이 기능만 제공
const DraggableWrapper = ({ id, children, width, mode }: DraggableWrapperProps) => {
  const {
    attributes,
    listeners,
    setNodeRef,
    transform,
    transition,
    isDragging
  } = useSortable({ id });

  const style = {
    transform: CSS.Transform.toString(transform),
    transition,
    opacity: isDragging ? 0.5 : 1,
    flex: `0 0 ${width}`,
    maxHeight: '80vh'
  };

  // 모드에 따라 드래그 핸들 표시 여부 결정
  const showDragHandle = mode === 'column';

  return (
    <div ref={setNodeRef} style={style} className="md:overflow-auto relative rounded-sm">
      {/* 드래그 핸들 - 컬럼 모드에서만 표시 */}
      {showDragHandle && (
        <div className="absolute top-2 right-2 z-10 text-gray-400 hover:text-gray-600 dark:text-gray-500 dark:hover:text-gray-400 cursor-grab" 
          {...attributes} {...listeners}>
          <IconMove size={16} />
        </div>
      )}
      <div className="p-4">
        {children}
      </div>
    </div>
  );
};

const Dashboard: React.FC = () => {
  const dispatch = useAppDispatch();
  const [activePetId, setActivePetId] = useState<string | null>(null);
  const [initialDataLoaded, setInitialDataLoaded] = useState(false);
  const { user } = useAppSelector(state => state.auth as AuthState);
  const { didInfo } = useAppSelector(state => state.did as DIDState);
  const { selectedGuardian } = useAppSelector(state => state.guardian);
  const { selectedPet } = useAppSelector(state => state.pet);

  // 스크롤바로 인한 레이아웃 이동 방지
  useEffect(() => {
    // 스크롤바 항상 표시 강제 적용
    document.documentElement.style.overflowY = 'scroll';
    return () => {
      document.documentElement.style.overflowY = '';
    };
  }, []);

  // 개발 모드 상태 확인
  const devModeEnabled = useAppSelector(selectDevModeEnabled);

  // 레이아웃 관련 상태
  const [layoutMode, setLayoutMode] = useState<LayoutMode>('column');
  const [activeTab, setActiveTab] = useState<ActiveTab>('treatment');
  const [isResizing, setIsResizing] = useState(false);
  const [splitPosition, setSplitPosition] = useState(50); // 분할 위치 (%)
  
  // 드래그 앤 드롭을 위한 상태
  const [componentOrder, setComponentOrder] = useState<ComponentId[]>(['treatment', 'history']);
  
  // 센서 설정
  const sensors = useSensors(
    useSensor(PointerSensor),
    useSensor(KeyboardSensor, {
      coordinateGetter: sortableKeyboardCoordinates,
    })
  );
  
  // 리사이징을 위한 참조
  const containerRef = useRef<HTMLDivElement>(null);
  const resizerRef = useRef<HTMLDivElement>(null);
  const startXRef = useRef<number>(0);
  const startSplitRef = useRef<number>(50);
  
  // 레이아웃 설정 저장 및 복원
  useEffect(() => {
    // 로컬 스토리지에서 설정 로드
    const savedLayoutMode = localStorage.getItem('dashboardLayoutMode') as LayoutMode;
    const savedSplitPosition = localStorage.getItem('dashboardSplitPosition');
    const savedActiveTab = localStorage.getItem('dashboardActiveTab') as ActiveTab;
    const savedComponentOrder = localStorage.getItem('dashboardComponentOrder');
    
    if (savedLayoutMode) setLayoutMode(savedLayoutMode);
    if (savedSplitPosition) setSplitPosition(parseInt(savedSplitPosition));
    if (savedActiveTab) setActiveTab(savedActiveTab);
    if (savedComponentOrder) {
      try {
        const order = JSON.parse(savedComponentOrder) as ComponentId[];
        if (order.length === 2) {
          setComponentOrder(order);
        }
      } catch (error) {
        console.error('컴포넌트 순서 로드 오류:', error);
      }
    }
  }, []);
  
  // 레이아웃 설정 변경 시 저장
  useEffect(() => {
    localStorage.setItem('dashboardLayoutMode', layoutMode);
    localStorage.setItem('dashboardSplitPosition', splitPosition.toString());
    localStorage.setItem('dashboardActiveTab', activeTab);
    localStorage.setItem('dashboardComponentOrder', JSON.stringify(componentOrder));
  }, [layoutMode, splitPosition, activeTab, componentOrder]);
  
  // 리사이징 이벤트 핸들러
  const handleResizeStart = (e: React.MouseEvent) => {
    e.preventDefault(); // 이벤트 전파 방지 추가
    setIsResizing(true);
    startXRef.current = e.clientX;
    startSplitRef.current = splitPosition;
    document.body.style.cursor = 'ew-resize';
    
    // 이벤트 리스너 추가
    document.addEventListener('mousemove', handleResizeMove);
    document.addEventListener('mouseup', handleResizeEnd);
    
    // 텍스트 선택 방지
    document.body.style.userSelect = 'none';
  };
  
  const handleResizeMove = (e: MouseEvent) => {
    if (!isResizing || !containerRef.current) return;
    
    const containerWidth = containerRef.current.offsetWidth;
    const deltaX = e.clientX - startXRef.current;
    const deltaPercent = (deltaX / containerWidth) * 100;
    
    // 최소 20%, 최대 80%로 제한
    const newSplitPosition = Math.min(Math.max(20, startSplitRef.current + deltaPercent), 80);
    
    setSplitPosition(newSplitPosition);
    
    e.preventDefault(); // 이벤트 전파 방지 추가
  };
  
  const handleResizeEnd = (e?: MouseEvent) => {
    if (e) e.preventDefault(); // 이벤트 전파 방지 추가
    
    setIsResizing(false);
    document.body.style.cursor = '';
    document.body.style.userSelect = '';
    
    // 이벤트 리스너 제거
    document.removeEventListener('mousemove', handleResizeMove);
    document.removeEventListener('mouseup', handleResizeEnd);
  };
  
  // 레이아웃 모드 변경
  const toggleLayoutMode = () => {
    if (layoutMode === 'tab') {
      setLayoutMode('column');
    } else if (layoutMode === 'column') {
      setLayoutMode('tab');
      // 한화면 모드로 전환 시 탭 순서를 기본값으로 복원
      setComponentOrder(['treatment', 'history']);
      setActiveTab('treatment');
    }
  };

  // 진료 기록 새로고침 - 토스트 알림 유지
  const refreshTreatments = () => {
    if (selectedPet) {
      dispatch(fetchTreatmentsStart());
      // 실제 API 호출 대신 시뮬레이션
      setTimeout(() => {
        const treatments = store.getState().treatment.treatments;
        dispatch(fetchTreatmentsSuccess(treatments));
        toast.info('진료 기록이 새로고침되었습니다.');
      }, 300);
    }
  };

  // 앱 시작 시 모든 데이터 초기화 및 로드
  const initializeAppData = async () => {
    try {
      // 보호자 데이터 로드
      dispatch(fetchGuardiansStart());
      const guardians = store.getState().guardian.guardians;
      dispatch(fetchGuardiansSuccess(guardians));
      
      // 이전에 선택된 보호자가 있으면 해당 보호자 선택, 없으면 첫 번째 보호자 선택
      const previousSelectedId = localStorage.getItem('selectedGuardianId');
      if (guardians.length > 0) {
        const guardianToSelect = previousSelectedId 
          ? guardians.find(g => g.id === previousSelectedId) || guardians[0]
          : guardians[0];
        
        dispatch(selectGuardian(guardianToSelect.id));
      }
      
      // 반려동물 데이터 로드
      dispatch(fetchPetsStart());
      const pets = store.getState().pet.pets;
      dispatch(fetchPetsSuccess(pets));
      
      // 선택된 보호자가 있으면 해당 보호자의 반려동물 데이터 로드
      if (selectedGuardian) {
        dispatch(fetchPetsByGuardian(selectedGuardian.id));
      }
      
      // 진료 내역 데이터 로드
      dispatch(fetchTreatmentsStart());
      const treatments = store.getState().treatment.treatments;
      dispatch(fetchTreatmentsSuccess(treatments));
      
      setInitialDataLoaded(true);
    } catch (err) {
      toast.error('데이터 초기화 중 오류가 발생했습니다.');
      console.error('App initialization error:', err);
    }
  };

  // 컴포넌트 마운트 시 초기 데이터 로드
  useEffect(() => {
    // 항상 데이터 로드 시도
    initializeAppData();
  }, []);

  // 개발 모드 상태가 변경되면 데이터 다시 로드
  useEffect(() => {
    console.log(`[Dashboard] Development mode changed to: ${devModeEnabled}`);
    
    // 개발 모드가 켜지면 모든 데이터 초기화
    if (devModeEnabled && initialDataLoaded) {
      initializeDevModeData();
      dispatch(preloadMockDataForAllPets());
      toast.info('개발 모드로 전환되었습니다. 가짜 데이터를 사용합니다.');
    } else if (!devModeEnabled && initialDataLoaded) {
      initializeAppData();
      toast.info('실제 모드로 전환되었습니다.');
    }
  }, [devModeEnabled, initialDataLoaded, dispatch]);

  // 데이터 로드 완료 시 로컬 스토리지에서 선택 상태 확인 및 복원
  useEffect(() => {
    if (initialDataLoaded) {
      // 선택된 보호자 ID 확인
      const savedGuardianId = localStorage.getItem('selectedGuardianId');
      
      // 선택된 반려동물 ID 확인
      const savedPetId = localStorage.getItem('selectedPetId');
      
      // 보호자와 반려동물 선택 상태 복원
      if (savedGuardianId && !selectedGuardian) {
        const allGuardians = store.getState().guardian.guardians;
        const guardian = allGuardians.find(g => g.id === savedGuardianId);
        if (guardian) {
          dispatch(selectGuardian(guardian.id));
          
          // 보호자가 변경되면 해당 보호자의 반려동물 목록 가져오기
          dispatch(fetchPetsByGuardian(guardian.id));
        }
      }
      
      if (savedPetId && !selectedPet) {
        const allPets = store.getState().pet.pets;
        const pet = allPets.find(p => p.id === savedPetId);
        if (pet) {
          dispatch(selectPet(pet.id));
          setActivePetId(pet.id);
        }
      }
    }
  }, [initialDataLoaded, selectedGuardian, selectedPet, dispatch]);

  // 선택된 반려동물이 변경될 때 활성 반려동물 ID 설정
  useEffect(() => {
    if (selectedPet) {
      setActivePetId(selectedPet.id);
      localStorage.setItem('selectedPetId', selectedPet.id);
    }
  }, [selectedPet]);

  // 드래그 앤 드롭 처리 함수
  const handleDragEnd = (event: DragEndEvent) => {
    const { active, over } = event;
    
    if (over && active.id !== over.id) {
      setComponentOrder((items) => {
        const oldIndex = items.indexOf(active.id as ComponentId);
        const newIndex = items.indexOf(over.id as ComponentId);
        
        const newOrder = arrayMove(items, oldIndex, newIndex);
        
        // 활성 탭도 현재 첫 번째 컴포넌트로 설정
        setActiveTab(newOrder[0]);
        
        return newOrder;
      });
    }
  };

  // 탭 변경 처리 함수
  const handleTabChange = (tab: ActiveTab) => {
    setActiveTab(tab);
    
    // 컬럼 모드에서는 탭 선택에 따라 컴포넌트 순서도 변경
    if (layoutMode === 'column' && componentOrder[0] !== tab) {
      setComponentOrder(prev => [tab, prev.find(id => id !== tab) as ComponentId]);
    }
  };

  // 레이아웃 모드에 따른 콘텐츠 렌더링
  const renderContent = () => {
    if (!selectedPet) {
      return (
        <div className="p-8 bg-white rounded-lg shadow text-center dark:bg-gray-800">
          <h2 className="text-xl font-semibold text-gray-700 dark:text-gray-300 mb-4">
            반려동물을 선택해주세요
          </h2>
          <p className="text-gray-600 dark:text-gray-400">
            왼쪽 사이드바에서 보호자 선택 후 반려동물을 선택하면 진료 내역을 확인하고 작성할 수 있습니다.
          </p>
        </div>
      );
    }

    const petName = selectedPet ? selectedPet.name : '';

    // 공통된 탭 헤더와 모드에 따른 콘텐츠 렌더링
    return (
      <div className="bg-white rounded-lg shadow dark:bg-gray-800">
        {/* 한화면 모드와 컬럼 모드에 따라 다르게 탭 헤더 표시 */}
        <div className="border-b dark:border-gray-700 relative">
          {/* 한화면 모드일 때의 탭 */}
          {layoutMode === 'tab' && (
            <div className="flex border-b dark:border-gray-700" style={{ paddingLeft: '4px' }}>
              <button
                onClick={() => handleTabChange('treatment')}
                className={`px-4 py-1.5 text-sm font-medium rounded-t-md mx-1 mt-1 border border-gray-300 dark:border-gray-600 
                ${
                  activeTab === 'treatment'
                    ? 'border-b-2 border-b-blue-500 bg-white dark:bg-gray-700 text-blue-600 dark:text-blue-400 shadow-md'
                    : 'border-b border-gray-300 dark:border-gray-600 text-gray-600 hover:text-gray-800 dark:text-gray-400 dark:hover:text-gray-300 bg-gray-100 dark:bg-gray-800'
                }`}
              >
                진료 입력
              </button>
              <button
                onClick={() => handleTabChange('history')}
                className={`px-4 py-1.5 text-sm font-medium rounded-t-md mx-1 mt-1 border border-gray-300 dark:border-gray-600
                ${
                  activeTab === 'history'
                    ? 'border-b-2 border-b-blue-500 bg-white dark:bg-gray-700 text-blue-600 dark:text-blue-400 shadow-md'
                    : 'border-b border-gray-300 dark:border-gray-600 text-gray-600 hover:text-gray-800 dark:text-gray-400 dark:hover:text-gray-300 bg-gray-100 dark:bg-gray-800'
                }`}
              >
                진료 내역
              </button>
              <div className="flex-grow"></div>
            </div>
          )}
          
          {/* 컬럼 모드일 때의 탭 */}
          {layoutMode === 'column' && (
            <div className="flex relative border-b dark:border-gray-700">
              <div className="flex" style={{ width: `${splitPosition}%`, paddingLeft: '4px' }}>
                {/* 첫 번째 컴포넌트에 해당하는 탭 */}
                <div 
                  className={`px-4 py-1.5 text-sm font-medium rounded-t-md mx-1 mt-1 border border-gray-300 dark:border-gray-600 
                    ${componentOrder[0] === 'treatment' 
                      ? 'border-b-2 border-b-blue-500 bg-white dark:bg-gray-700 text-blue-600 dark:text-blue-400 shadow-md' 
                      : 'border-b border-gray-300 dark:border-gray-600 text-gray-600 hover:text-gray-800 dark:text-gray-400 dark:hover:text-gray-300 bg-gray-100 dark:bg-gray-800'}`}
                >
                  {componentOrder[0] === 'treatment' ? '진료 입력' : '진료 내역'}
                </div>
                <div className="flex-grow"></div>
              </div>
              
              <div className="flex" style={{ width: `${100 - splitPosition}%`, paddingLeft: '8px' }}>
                {/* 두 번째 컴포넌트에 해당하는 탭 */}
                <div 
                  className={`px-4 py-1.5 text-sm font-medium rounded-t-md mx-1 mt-1 border border-gray-300 dark:border-gray-600
                    ${componentOrder[1] === 'treatment' 
                      ? 'border-b-2 border-b-blue-500 bg-white dark:bg-gray-700 text-blue-600 dark:text-blue-400 shadow-md' 
                      : 'border-b border-gray-300 dark:border-gray-600 text-gray-600 hover:text-gray-800 dark:text-gray-400 dark:hover:text-gray-300 bg-gray-100 dark:bg-gray-800'}`}
                >
                  {componentOrder[1] === 'treatment' ? '진료 입력' : '진료 내역'}
                </div>
                <div className="flex-grow"></div>
              </div>
            </div>
          )}
          
          {/* 공통 컨트롤 영역 - 모든 모드에서 표시 */}
          <div className="absolute right-0 top-0 flex items-center py-1 z-20">
            {/* 컬럼 모드일 때 추가 컨트롤 */}
            {layoutMode === 'column' && (
              <button
                onClick={refreshTreatments}
                className="px-2 py-1 text-gray-600 hover:text-gray-800 dark:text-gray-400 dark:hover:text-gray-300"
                title="진료 기록 새로고침"
              >
                <IconRefreshCw size={14} />
              </button>
            )}
            <button
              onClick={toggleLayoutMode}
              className="px-3 py-1 mr-2 text-gray-600 hover:text-gray-800 dark:text-gray-400 dark:hover:text-gray-300"
              title={layoutMode === 'tab' ? "컬럼 모드로 전환" : "한화면 모드로 전환"}
            >
              {layoutMode === 'tab' ? <IconColumns size={16} /> : <IconTablet size={16} />}
            </button>
          </div>
        </div>

        {/* 탭 모드 콘텐츠 */}
        {layoutMode === 'tab' && (
          <div className="p-4 overflow-hidden">
            <div className="w-full">
              {activeTab === 'treatment' && activePetId && (
                <TreatmentForm petId={activePetId} />
              )}
              {activeTab === 'history' && (
                <TreatmentHistory />
              )}
            </div>
          </div>
        )}

        {/* 컬럼 모드 콘텐츠 */}
        {layoutMode === 'column' && (
          <DndContext 
            sensors={sensors}
            collisionDetection={closestCenter}
            onDragEnd={handleDragEnd}
          >
            <div ref={containerRef} className="relative w-full">
              <SortableContext items={componentOrder}>
                <div className="flex flex-col md:flex-row w-full bg-white dark:bg-gray-800 relative min-h-[500px]">
                  {/* 첫 번째 컴포넌트 */}
                  <DraggableWrapper 
                    id={componentOrder[0]}
                    width={`${splitPosition}%`}
                    mode={layoutMode}
                  >
                    {componentOrder[0] === 'treatment' ? (
                      activePetId && <TreatmentForm petId={activePetId} />
                    ) : (
                      <TreatmentHistory />
                    )}
                  </DraggableWrapper>

                  {/* 두 번째 컴포넌트 */}
                  <DraggableWrapper 
                    id={componentOrder[1]}
                    width={`${100 - splitPosition}%`}
                    mode={layoutMode}
                  >
                    {componentOrder[1] === 'treatment' ? (
                      activePetId && <TreatmentForm petId={activePetId} />
                    ) : (
                      <TreatmentHistory />
                    )}
                  </DraggableWrapper>
                </div>
              </SortableContext>
            </div>
          </DndContext>
        )}
      </div>
    );
  };

  return (
    <div className="flex flex-col h-full bg-gray-50 dark:bg-gray-900">
      <main className="flex-1 p-4">
        <div className="container mx-auto max-w-[1400px]">
          <div className="grid grid-cols-12 gap-4">
            {/* 컨텐츠 영역: 전체 너비 사용 */}
            <div className="col-span-12">
              {renderContent()}
            </div>
          </div>
        </div>
      </main>
      
      {/* QR 코드 모달 */}
      <QRCodeGenerator />
    </div>
  );
};

export default Dashboard; 