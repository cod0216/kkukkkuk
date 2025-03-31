import React, { useState, useEffect, useRef, useCallback } from 'react';
import { FaSearch, FaSortAmountDown, FaSortAmountUp, FaFilter } from 'react-icons/fa';
import PetListItem from '@/pages/treatment/layout/PetListItem';
import { Treatment, TreatmentState } from '@/interfaces';
import { getHospitalPetsWithRecords, hasTreatmentRecords, getPetBasicInfo } from '@/services/treatmentService';
import { DID_REGISTRY_ADDRESS } from '@/utils/constants';
import { getAccountAddress } from '@/services/blockchainAuthService';
import { 
  initWebSocketProvider, 
  subscribeSharingCreated,
  subscribeSharingRevoked,
  unsubscribeFromAllEvents,
  SharingAgreementEvent
} from '@/services/blockchainAlarmService';
import {
  getPetWithAgreementInfo,
  convertPetToTreatment,
  checkCancellationStatus
} from '@/services/blockchainAgreementService';

/**
 * @module TreatmentSidebar
 * @file TreatmentSidebar.tsx
 * @author haelim
 * @date 2025-03-26
 * @author seonghun
 * @date 2025-03-28
 * @description 진단 페이지 내부의 좌측 사이드바 역할을 수행합니다. 
 *              병원에 진료했던 반려동물를 출력하는 UI 컴포넌트입니다.   
 *              
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-26        haelim           최초 생성
 * 2025-03-28        seonghun         블록체인 서비스 연동
 * 2025-03-31        seonghun         블록체인 기반 공유계약 생성 알림 추가, 진료기록 상태 확인, 진료전/ 진료완료/진료취소 순의 정렬 반영
 */

/**
 * 정렬 방향 타입
 */
type SortDirection = 'asc' | 'desc';

/**
 * TreatmentSidebar 컴포넌트의 Props 타입 정의
 */
interface SidebarProps {
    treatments: Treatment[];
    selectedPetId: string;  // 인덱스 대신 ID로 변경
    setSelectedPetId: (id: string) => void;  // 인덱스 대신 ID 설정 함수로 변경
    getStateBadgeColor: (state: TreatmentState) => string;
    getStateColor: (state: TreatmentState) => string;
    onBlockchainPetsLoad?: (pets: Treatment[]) => void; // 블록체인 반려동물 목록을 상위 컴포넌트로 전달하는 콜백
    onStateChanged?: (petId: string, newState: TreatmentState, isCancelled: boolean) => void; // 상태 변경 시 호출되는 콜백
}


/**
 * 진단 페이지 내부의 좌측 사이드바 역할을 수행합니다. 
 * 병원에 진료했던 반려동물를 출력하는 UI 컴포넌트입니다.  
 */
const TreatmentSidebar: React.FC<SidebarProps> = ({
    treatments,
    selectedPetId,
    setSelectedPetId,
    getStateBadgeColor,
    getStateColor,
    onBlockchainPetsLoad,
    onStateChanged,
}) => {
    const [searchTerm, setSearchTerm] = useState('');
    const [dateRange, setDateRange] = useState({
      start: '',
      end: ''
    });
    
    const [blockchainPets, setBlockchainPets] = useState<Treatment[]>([]);
    const [isLoading, setIsLoading] = useState(false);
    const [error, setError] = useState<string | null>(null);
    const hasLoadedData = useRef(false);
    const currentHospitalAddress = useRef<string>('');
    
    // 새로 추가된 항목 추적을 위한 상태
    const [unreadPets, setUnreadPets] = useState<Set<string>>(new Set());
    // 새로운 알림 표시 상태
    const [newNotification, setNewNotification] = useState<{message: string, timestamp: number} | null>(null);
    
    // 정렬 방향 상태 (기본값: 내림차순 - 최신순)
    const [sortDirection, setSortDirection] = useState<SortDirection>('desc');
    
    // 필터 적용 여부
    const [isFilterApplied, setIsFilterApplied] = useState(false);
    

    // 브라우저 알림 권한 요청
    useEffect(() => {
      // 브라우저 알림 지원 여부 확인
      if ("Notification" in window) {
        // 알림 권한이 'default'인 경우 권한 요청
        if (Notification.permission === "default") {
          Notification.requestPermission();
        }
      }
    }, []);
    
    // 브라우저 알림 표시 함수
    const showNotification = (title: string, body: string) => {
      // 브라우저 알림 지원 여부 확인
      if (!("Notification" in window)) {
        console.log("이 브라우저는 알림을 지원하지 않습니다.");
        return;
      }
      
      // 알림 권한 확인
      if (Notification.permission === "granted") {
        // 알림 생성
        const notification = new Notification(title, {
          body: body,
          icon: "/favicon.ico"
        });
        
        // 알림 클릭 시 현재 페이지로 포커스
        notification.onclick = () => {
          window.focus();
        };
      } else if (Notification.permission !== "denied") {
        // 권한이 거부되지 않았다면 권한 요청
        Notification.requestPermission().then(permission => {
          if (permission === "granted") {
            showNotification(title, body);
          }
        });
      }
    };

    // 병원 정보 가져오기
    useEffect(() => {
      const fetchHospitalInfo = async () => {
        try {
          // 현재 연결된 계정 주소를 DID로 사용
          const accountAddress = await getAccountAddress();
          
          if (accountAddress) {
            currentHospitalAddress.current = accountAddress;
          }
        } catch (error) {
          console.error('병원 정보 가져오기 오류:', error);
        }
      };
      
      fetchHospitalInfo();
    }, []);

    // 블록체인 WebSocket 연결 초기화
    useEffect(() => {
      const setupWebSocketConnection = async () => {
        try {
          const connected = await initWebSocketProvider();
          if (connected) {
            console.log('WebSocket 연결 성공 - 이벤트 구독 시작');
            
            // 공유 계약 생성 이벤트 구독
            subscribeSharingCreated(async (event: SharingAgreementEvent) => {
              const { petAddress, hospitalAddress, timestamp } = event;
              
              // 현재 병원에 대한 이벤트인 경우에만 처리
              if (hospitalAddress === currentHospitalAddress.current) {
                try {
                  // 반려동물 기본 정보 조회
                  const result = await getPetBasicInfo(petAddress);
                  const petName = result.success && result.petInfo ? result.petInfo.name : '알 수 없는 반려동물';
                  
                  // 새로운 공유 계약 알림 표시
                  setNewNotification({
                    message: `새로운 반려동물 "${petName}"이(가) 공유되었습니다.`,
                    timestamp: timestamp || Date.now()
                  });
                  
                  // 읽지 않은 항목으로 추가
                  setUnreadPets(prev => new Set([...prev, petAddress]));
                  
                  // 목록 새로고침
                  fetchPetsData();
                  
                  // 브라우저 알림 표시
                  showNotification(
                    '새로운 공유 계약',
                    `새로운 반려동물 "${petName}"이(가) 공유되었습니다.`
                  );
                } catch (error) {
                  console.error('반려동물 정보 조회 중 오류:', error);
                  // 기본 메시지로 표시
                  setNewNotification({
                    message: `새로운 반려동물이 공유되었습니다.`,
                    timestamp: timestamp || Date.now()
                  });
                  
                  setUnreadPets(prev => new Set([...prev, petAddress]));
                  fetchPetsData();
                  
                  showNotification(
                    '새로운 공유 계약',
                    '새로운 반려동물이 공유되었습니다.'
                  );
                }
              }
            });
            
            // 공유 계약 취소 이벤트 구독
            subscribeSharingRevoked(async (event: SharingAgreementEvent) => {
              const { petAddress, hospitalAddress, timestamp } = event;
              
              // 현재 병원에 대한 이벤트인 경우에만 처리
              if (hospitalAddress === currentHospitalAddress.current) {
                try {
                  // 반려동물 기본 정보 조회
                  const result = await getPetBasicInfo(petAddress);
                  const petName = result.success && result.petInfo ? result.petInfo.name : '알 수 없는 반려동물';
                  
                  // 공유 계약 취소 알림 표시
                  setNewNotification({
                    message: `반려동물 "${petName}"의 공유가 취소되었습니다.`,
                    timestamp: timestamp || Date.now()
                  });
                  
                  // 목록 새로고침
                  fetchPetsData();
                  
                  // 브라우저 알림 표시
                  showNotification(
                    '공유 계약 취소',
                    `반려동물 "${petName}"의 공유가 취소되었습니다.`
                  );
                } catch (error) {
                  console.error('반려동물 정보 조회 중 오류:', error);
                  // 기본 메시지로 표시
                  setNewNotification({
                    message: `반려동물의 공유가 취소되었습니다.`,
                    timestamp: timestamp || Date.now()
                  });
                  
                  fetchPetsData();
                  
                  showNotification(
                    '공유 계약 취소',
                    '반려동물의 공유가 취소되었습니다.'
                  );
                }
              }
            });
          } else {
            console.error('WebSocket 연결 실패');
          }
        } catch (error) {
          console.error('WebSocket 연결 중 오류 발생:', error);
        }
      };

      setupWebSocketConnection();

      // 컴포넌트 언마운트 시 이벤트 구독 해제
      return () => {
        unsubscribeFromAllEvents();
      };
    }, []);

    // 진료 상태 계산 및 업데이트 함수
    const updatePetTreatmentState = async (pets: Treatment[]) => {
        if (!pets.length) return pets;
        
        // 현재 병원 주소 가져오기
        let hospitalAddress;
        try {
            hospitalAddress = await getAccountAddress();
            if (!hospitalAddress) {
                console.error('병원 주소를 가져올 수 없습니다.');
                return pets;
            }
        } catch (error) {
            console.error('계정 주소 가져오기 오류:', error);
            return pets;
        }
        
        // 각 반려동물에 대해 진료 상태 계산
        const updatedPets = await Promise.all(
            pets.map(async (pet) => {
                // 공유 계약 정보가 없거나 반려동물 DID가 없는 경우 원래 상태 유지
                if (!pet.agreementInfo || !pet.petDid || 
                    !pet.agreementInfo.createdAt || !pet.agreementInfo.expireDate) {
                    return pet;
                }
                
                try {
                    // 1. 취소 상태 확인
                    const cancellationResult = await checkCancellationStatus(
                        pet.petDid,
                        hospitalAddress
                    );
                    
                    // 2. 접수일자와 만료일 사이에 진료기록이 있는지 확인
                    const recordsResult = await hasTreatmentRecords(
                        pet.petDid,
                        pet.agreementInfo.createdAt,
                        pet.agreementInfo.expireDate
                    );
                    
                    // 3. 상태 결정 로직
                    let newState: TreatmentState;
                    let isCancelled = false;
                    
                    if (cancellationResult.isCancelled) {
                        // 취소됨
                        newState = TreatmentState.CANCELLED;
                        isCancelled = true;
                    } else if (cancellationResult.hasNewSharingAfterCancellation) {
                        // 취소 후 새 계약
                        isCancelled = false;
                        if (recordsResult.success && recordsResult.hasTreatment) {
                            newState = TreatmentState.COMPLETED;
                        } else {
                            newState = TreatmentState.WAITING;
                        }
                    } else if (recordsResult.success && recordsResult.hasTreatment) {
                        // 취소 없이 진료 완료
                        isCancelled = false;
                        newState = TreatmentState.COMPLETED;
                    } else {
                        // 취소 없이 진료 전
                        isCancelled = false;
                        newState = TreatmentState.WAITING;
                    }
                    
                    // 상태 변경 콜백 호출
                    if (onStateChanged && newState !== pet.calculatedState) {
                        onStateChanged(pet.petDid, newState, isCancelled);
                    }
                    
                    // 업데이트된 상태 반환
                    return {
                        ...pet,
                        calculatedState: newState,
                        isCancelled
                    };
                } catch (error) {
                    console.error('진료 상태 계산 중 오류:', error);
                    return pet;
                }
            })
        );
        
        return updatedPets;
    };
    
    // 정렬 방향 토글
    const toggleSortDirection = () => {
      setSortDirection(prev => prev === 'asc' ? 'desc' : 'asc');
    };
    
    // 필터 적용
    const applyFilter = () => {
      setIsFilterApplied(true);
    };
    
    // 필터 초기화
    const resetFilter = () => {
      setDateRange({ start: '', end: '' });
      setIsFilterApplied(false);
    };
    
    // 진료 상태의 우선순위를 반환합니다.
    const getStatePriority = (state: TreatmentState): number => {
      switch (state) {
        case TreatmentState.WAITING:
          return 0; // 진료전
        case TreatmentState.IN_PROGRESS:
          return 1; // 진료중
        case TreatmentState.COMPLETED:
          return 2; // 진료완료
        case TreatmentState.CANCELLED:
          return 3; // 진료취소
        case TreatmentState.SHARED:
          return 4; // 공유중
        case TreatmentState.NONE:
        default:
          return 5; // 기타
      }
    };

    /**
     * 반려동물 목록을 상태와 접수일 기준으로 정렬합니다.
     */
    const sortByStateAndDate = useCallback((pets: Treatment[]): Treatment[] => {
      return [...pets].sort((a, b) => {
        // 상태 우선순위 비교
        const stateA = a.calculatedState || (a.agreementInfo ? TreatmentState.SHARED : a.state);
        const stateB = b.calculatedState || (b.agreementInfo ? TreatmentState.SHARED : b.state);
        const priorityDiff = getStatePriority(stateA) - getStatePriority(stateB);
        
        if (priorityDiff !== 0) {
          return priorityDiff;
        }
        
        // 같은 상태일 경우 접수일 기준 내림차순 정렬 (최신순)
        const dateA = a.agreementInfo?.createdAt || a.createdAt || 0;
        const dateB = b.agreementInfo?.createdAt || b.createdAt || 0;
        return dateB - dateA;
      });
    }, []);

    /**
     * 접수일시 기준으로 정렬 및 필터링 적용
     */
    const getFilteredAndSortedPets = () => {
      // 모든 반려동물 목록 (블록체인 + 일반)
      const allPets = [...blockchainPets, ...treatments];
      
      // 검색어로 필터링
      let filteredPets = allPets.filter(pet => 
        searchTerm ? (
          pet.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
          pet.breedName.toLowerCase().includes(searchTerm.toLowerCase())
        ) : true
      );

      // 날짜 범위로 필터링
      if (isFilterApplied && (dateRange.start || dateRange.end)) {
        filteredPets = filteredPets.filter(pet => {
          const createdAt = pet.agreementInfo?.createdAt || pet.createdAt;
          if (!createdAt) return false;
          
          const petDate = new Date(createdAt);
          const startDate = dateRange.start ? new Date(dateRange.start) : null;
          const endDate = dateRange.end ? new Date(dateRange.end) : null;
          
          if (startDate && endDate) {
            endDate.setHours(23, 59, 59, 999);
            return petDate >= startDate && petDate <= endDate;
          } else if (startDate) {
            return petDate >= startDate;
          } else if (endDate) {
            endDate.setHours(23, 59, 59, 999);
            return petDate <= endDate;
          }
          
          return true;
        });
      }

      // 상태와 접수일 기준으로 정렬
      return sortByStateAndDate(filteredPets);
    };
    
    // 필터링 및 정렬된 반려동물 목록
    const filteredAndSortedPets = getFilteredAndSortedPets();
    
    // 고유 식별자 가져오기 함수
    const getPetIdentifier = (pet: Treatment): string => {
      // 블록체인 반려동물은 DID로, 일반 반려동물은 ID로 식별
      return pet.petDid || `local-${pet.id}`;
    };

    // 블록체인에서 병원에 공유된 반려동물 목록 가져오기 (최초 1회만)
    useEffect(() => {
      // 이미 데이터를 불러왔으면 다시 불러오지 않음
      if (hasLoadedData.current) {
        return;
      }
      
      fetchPetsData();
    }, []); // 의존성 배열 비움 - 최초 1회만 실행
    
    // 항목 선택 시 읽음 처리 함수
    const handlePetSelect = (petId: string) => {
      setSelectedPetId(petId);
      
      // 선택한 항목 읽음 처리
      if (petId) {
        setUnreadPets(prev => {
          const newSet = new Set(prev);
          newSet.delete(petId);
          return newSet;
        });
      }
    };
    
    // 알림 닫기
    const dismissNotification = () => {
      setNewNotification(null);
    };
    
    // 블록체인 데이터 불러오기 함수 수정
    const fetchPetsData = async () => {
      try {
        setIsLoading(true);
        setError(null);
        
        const result = await getHospitalPetsWithRecords(DID_REGISTRY_ADDRESS);
        
        if (result.success) {
          // 디버깅: 블록체인에서 받아온 원본 데이터 확인
          console.log('블록체인에서 받아온 반려동물 원본 데이터:', result.pets);
          
          // 각 반려동물에 대해 공유 계약 정보 조회 및 처리
          const treatments = await Promise.all(
              result.pets.map(async (pet, index) => {
                  if (!pet.petDID) {
                      console.warn('반려동물 DID 주소 누락:', pet);
                      return null;
                  }
                  
                  try {
                      // 반려동물 기본 정보와 공유 계약 정보 조회
                      const petWithAgreement = await getPetWithAgreementInfo(
                          pet.petDID, 
                          currentHospitalAddress.current
                      );
                      
                      if (petWithAgreement) {
                          // Treatment 형식으로 변환
                          return convertPetToTreatment(petWithAgreement, index);
                      }
                  } catch (error) {
                      console.error(`반려동물 처리 중 오류(${pet.petDID}):`, error);
                  }
                  
                  return null;
              })
          );
          
          // null 제거 및 필터링
          const validTreatments = treatments.filter(pet => pet !== null) as Treatment[];
          
          // 진료 상태 계산 및 업데이트
          const updatedTreatments = await updatePetTreatmentState(validTreatments);
          
          // 정렬된 상태로 저장
          const sortedTreatments = sortByStateAndDate(updatedTreatments);
          setBlockchainPets(sortedTreatments);
          hasLoadedData.current = true;
          
          // 상위 컴포넌트로 블록체인 반려동물 목록 전달
          if (onBlockchainPetsLoad) {
            onBlockchainPetsLoad(sortedTreatments);
          }
        } else {
          setError(result.error || '반려동물 목록을 가져오는데 실패했습니다.');
        }
      } catch (err: any) {
        console.error('반려동물 목록 가져오기 오류:', err);
        setError(err.message || '반려동물 목록을 가져오는 중 오류가 발생했습니다.');
      } finally {
        setIsLoading(false);
      }
    };
    
  return (
    <>
      <div className="w-80 bg-white rounded-lg border p-4 mr-6">
          <div className="mb-6">
              {/* 검색 및 새로고침 */}
              <div className="flex items-center gap-2 mb-3">
                <FaSearch className="text-gray-400" />
                <input
                  className="text-xs p-1 bg-gray-50 border rounded-md flex-1 focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                  type="search"
                  placeholder="환자 검색"
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                />
                <button
                  onClick={fetchPetsData}
                  disabled={isLoading}
                  className="bg-primary-50 hover:bg-primary-100 text-primary-700 text-xs px-2 py-1 rounded"
                  title="목록 새로고침"
                >
                  {isLoading ? '로딩중' : '새로고침'}
                </button>
              </div>
              
              {/* 알림 표시 영역 */}
              {newNotification && (
                <div className="bg-blue-50 text-blue-700 text-xs p-2 rounded-md mb-3 relative">
                  <button 
                    onClick={dismissNotification} 
                    className="absolute top-1 right-1 text-blue-700 hover:text-blue-900"
                    title="알림 닫기"
                  >
                    ×
                  </button>
                  <p>{newNotification.message}</p>
                  <p className="text-blue-500 text-xs mt-1">
                    {new Date(newNotification.timestamp).toLocaleTimeString()}
                  </p>
                </div>
              )}
              
              {/* 날짜 필터링 */}
              <div className="flex flex-col gap-2 mb-3">
                <div className="flex items-center justify-between">
                  <span className="text-xs font-medium text-gray-700">접수일시 필터</span>
                  
                  <div className="flex items-center gap-1">
                    {/* 정렬 방향 토글 버튼 */}
                    <button
                      onClick={toggleSortDirection}
                      className="text-xs p-1 text-gray-600 hover:text-primary-600"
                      title={sortDirection === 'asc' ? '오름차순 (과거→최신)' : '내림차순 (최신→과거)'}
                    >
                      {sortDirection === 'asc' ? (
                        <FaSortAmountUp className="h-3 w-3" />
                      ) : (
                        <FaSortAmountDown className="h-3 w-3" />
                      )}
                    </button>
                    
                    {/* 필터 초기화 버튼 */}
                    {isFilterApplied && (
                      <button
                        onClick={resetFilter}
                        className="text-xs p-1 text-gray-600 hover:text-red-600"
                        title="필터 초기화"
                      >
                        ×
                      </button>
                    )}
                  </div>
                </div>
                
                <div className="flex items-center gap-2">
                  <input
                    type="date"
                    value={dateRange.start}
                    onChange={(e) => setDateRange(prev => ({ ...prev, start: e.target.value }))}
                    className="text-xs py-1 px-2 bg-gray-50 border rounded-md flex-1"
                    placeholder="시작일"
                  />
                  <span className="text-xs text-gray-500">~</span>
                  <input
                    type="date"
                    value={dateRange.end}
                    onChange={(e) => setDateRange(prev => ({ ...prev, end: e.target.value }))}
                    className="text-xs py-1 px-2 bg-gray-50 border rounded-md flex-1"
                    placeholder="종료일"
                  />
                  
                  {/* 필터 적용 버튼 */}
                  <button
                    onClick={applyFilter}
                    className={`text-xs px-2 py-1 rounded ${
                      isFilterApplied 
                        ? 'bg-primary-100 text-primary-700' 
                        : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
                    }`}
                    title="필터 적용"
                  >
                    <FaFilter className="h-3 w-3" />
                  </button>
                </div>
              </div>
          </div>

          {/* 제목과 QR 코드 버튼 */}
          <div className="flex justify-between items-center mb-3">
            <h2 className="font-semibold text-gray-700">
              목록 
              <span className="text-xs font-normal text-gray-500 ml-1">
                ({filteredAndSortedPets.length}건)
              </span>
            </h2>
          </div>

          {/* 로딩 상태 표시 */}
          {isLoading && (
            <div className="text-center text-gray-500 text-sm py-4">
              반려동물 목록을 불러오는 중...
            </div>
          )}
          
          {/* 에러 메시지 표시 */}
          {error && (
            <div className="text-center text-red-500 text-sm py-2 px-3 bg-red-50 rounded-md mb-3">
              {error}
            </div>
          )}

          {/* 동물 목록 List */}
          <div className="flex flex-col gap-3 overflow-y-auto max-h-[calc(100vh-320px)]">
            {filteredAndSortedPets.length > 0 ? (
              filteredAndSortedPets.map((treatment) => {
                const petId = getPetIdentifier(treatment);
                return (
                  <PetListItem
                    key={petId}
                    treatment={treatment}
                    isSelected={selectedPetId === petId}
                    onSelect={() => handlePetSelect(petId)}
                    getStateColor={getStateColor}
                    getStateBadgeColor={getStateBadgeColor}
                    isUnread={treatment.petDid ? unreadPets.has(treatment.petDid) : false}
                  />
                );
              })
            ) : (
              <div className="text-center text-gray-500 text-sm py-4">
                {isLoading ? '반려동물 목록을 불러오는 중...' : '반려동물 목록이 없습니다.'}
              </div>
            )}
          </div>
      </div>
          </>
  );
};

export default TreatmentSidebar;

