import { useState, useEffect, useRef, useCallback, forwardRef, useImperativeHandle } from 'react';
import { FaSearch, FaSortAmountDown, FaSortAmountUp, FaFont, FaCalendarAlt, FaTimesCircle } from 'react-icons/fa';
import PetListItem from '@/pages/treatment/layout/PetListItem';
import { Treatment, TreatmentState } from '@/interfaces';
import { hasTreatmentRecords, getPetBasicInfo, getLatestTreatmentStatus } from '@/services/treatmentService';
import { getHospitalPetsWithRecords } from '@/services/treatmentRecordService';
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
 * 정렬 기준 타입
 */
type SortBy = 'state' | 'name' | 'date';

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
    onSharingComplete?: (petAddress: string, petName: string) => void; // 반려동물 공유 완료 시 호출되는 콜백
}

/**
 * 외부에서 접근 가능한 함수들의 타입 정의
 */
export interface TreatmentSidebarRef {
  fetchPetsData: () => Promise<void>;
  refreshPetState: (petDid: string) => Promise<void>;
}

/**
 * 진단 페이지 내부의 좌측 사이드바 역할을 수행합니다. 
 * 병원에 진료했던 반려동물를 출력하는 UI 컴포넌트입니다.  
 */
const TreatmentSidebar = forwardRef<TreatmentSidebarRef, SidebarProps>(({
    treatments,
    selectedPetId,
    setSelectedPetId,
    getStateBadgeColor,
    getStateColor,
    onBlockchainPetsLoad,
    onStateChanged,
    onSharingComplete,
}, ref) => {
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
    
    // 정렬 방향 상태 (기본값: 오름차순)
    const [sortDirection, setSortDirection] = useState<SortDirection>('asc');
    
    // 정렬 기준 상태 (기본값: 진료 상태)
    const [sortBy, setSortBy] = useState<SortBy>('state');
    
    // 필터 적용 여부
    const [isFilterApplied, setIsFilterApplied] = useState(false);
    
    // 날짜 유효성 검사 메시지
    const [dateError, setDateError] = useState<string | null>(null);
    
    // 상태 표시 여부 (기본값: 진료완료와 진료취소 숨김)
    const [showCompleted, setShowCompleted] = useState(false);
    const [showCancelled, setShowCancelled] = useState(false);

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

    /**
     * 재시도 로직을 포함하여 반려동물 기본 정보를 가져옵니다.
     * @param petAddress 반려동물 DID 주소
     * @param retryCount 현재 시도 횟수
     * @param maxRetries 최대 시도 횟수
     * @returns 조회 결과 (성공 시 petInfo 포함, 실패 시 error 포함)
     */
    const fetchPetInfoWithRetry = async (
      petAddress: string,
      retryCount: number = 0,
      maxRetries: number = 3 // 초기 호출 + 2번 재시도 = 총 3번 시도
    ): Promise<{ success: boolean; petInfo?: any; error?: string }> => {
      
      const delay = (ms: number) => new Promise(resolve => setTimeout(resolve, ms));
      
      try {
        console.log(`반려동물 정보 조회 시도 ${retryCount + 1}/${maxRetries} (DID: ${petAddress})`);
        const result = await getPetBasicInfo(petAddress);
        console.log(`시도 ${retryCount + 1} 결과:`, result);

        if (result.success && result.petInfo) {
          return { success: true, petInfo: result.petInfo };
        } else {
          if (retryCount < maxRetries - 1) {
            const retryDelay = 1000 + retryCount * 1000; // 1초, 2초 간격
            console.log(`시도 ${retryCount + 1} 실패: ${result.error}. ${retryDelay / 1000}초 후 재시도...`);
            await delay(retryDelay);
            return fetchPetInfoWithRetry(petAddress, retryCount + 1, maxRetries);
          } else {
            console.log(`모든 ${maxRetries} 시도 실패 (DID: ${petAddress}). 오류: ${result.error}`);
            return { success: false, error: `최대 시도(${maxRetries}) 후 실패: ${result.error}` };
          }
        }
      } catch (error: any) {
        console.error(`시도 ${retryCount + 1} 중 오류 (DID: ${petAddress}):`, error);
        if (retryCount < maxRetries - 1) {
          const retryDelay = 1000 + retryCount * 1000;
          console.log(`오류 발생. ${retryDelay / 1000}초 후 재시도...`);
          await delay(retryDelay);
          return fetchPetInfoWithRetry(petAddress, retryCount + 1, maxRetries);
        } else {
          console.log(`모든 ${maxRetries} 시도 실패 (DID: ${petAddress}).`);
          return { success: false, error: `최대 시도(${maxRetries}) 후 오류 발생: ${error.message || error}` };
        }
      }
    };

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
                // 먼저 임시 알림 표시 (이름 없이)
                setNewNotification({
                  message: `새로운 반려동물이 공유되었습니다. 정보를 불러오는 중...`,
                  timestamp: timestamp || Date.now()
                });
                
                // 읽지 않은 항목으로 추가
                setUnreadPets(prev => new Set([...prev, petAddress]));
                
                // 5초 지연 후 정보 조회 시작 (블록체인 전파 시간 고려)
                setTimeout(async () => {
                  console.log(`초기 지연 후 ${petAddress} 정보 조회 시작 (재시도 포함)`);
                  const finalResult = await fetchPetInfoWithRetry(petAddress);

                  const petName = finalResult.success && finalResult.petInfo ? finalResult.petInfo.name : '알 수 없는 반려동물';
                  const message = finalResult.success
                      ? `새로운 반려동물 "${petName}"이(가) 공유되었습니다.`
                      : `새로운 반려동물 공유 확인 (정보 조회 실패) 새로고침버튼을 눌러주세요`; // 실패 시 간단 메시지
              
                  setNewNotification({
                    message: message,
                    timestamp: timestamp || Date.now()
                  });
              
                  fetchPetsData(); // 결과와 관계없이 목록 새로고침
                  console.log('공유 이벤트: 목록 새로고침 완료.');
              
                  if (onSharingComplete) {
                    onSharingComplete(petAddress, petName);
                  }
                  setIsLoading(false); // 로딩 상태 해제
                }, 5000); // 5초 지연
              }
            });
            
            // 공유 계약 취소 이벤트 구독
            subscribeSharingRevoked(async (event: SharingAgreementEvent) => {
              const { petAddress, hospitalAddress, timestamp } = event;
              
              // 현재 병원에 대한 이벤트인 경우에만 처리
              if (hospitalAddress === currentHospitalAddress.current) {
                // 2초 지연 후 취소 정보 처리 (이름 포함)
                setTimeout(async () => {
                  console.log(`초기 지연 후 취소된 반려동물 ${petAddress} 정보 조회 시작`);
                  const finalResult = await fetchPetInfoWithRetry(petAddress, 0, 2); // 취소 시에는 최대 2번만 시도

                  const petName = finalResult.success && finalResult.petInfo ? finalResult.petInfo.name : '알 수 없는 반려동물';
                  const message = `반려동물 "${petName}"의 공유가 취소되었습니다.`;
              
                  setNewNotification({
                    message: message,
                    timestamp: timestamp || Date.now()
                  });
              
                  fetchPetsData(); // 목록 새로고침
                  console.log('취소 이벤트: 목록 새로고침 완료.');
                  setIsLoading(false); // 로딩 상태 해제
                }, 2000); // 2초 지연
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
    }, []); // onSharingComplete 의존성 제거, useCallback 불필요

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
                    
                    // 3. 가장 최근 진료 기록의 상태 확인 (API 호출 추가 필요)
                    let latestRecordStatus: 'IN_PROGRESS' | 'COMPLETED' | 'NONE' | null = null;
                    
                    try {
                        // 블록체인 또는 API에서 가장 최근 진료 기록 상태 조회
                        // 임시 Mock 데이터: 실제로는 API 호출로 대체되어야 함
                        const statusResult = await getLatestTreatmentStatus(pet.petDid);
                        
                        if (statusResult.success) {
                            latestRecordStatus = statusResult.status;
                        }
                    } catch (statusError) {
                        console.error('최근 진료 상태 조회 중 오류:', statusError);
                        // 오류 시 기본값 사용 (null)
                    }
                    
                    // 4. 상태 결정 로직 (개선된 버전)
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
                            // 진료 기록이 있는 경우
                            if (latestRecordStatus === 'COMPLETED') {
                                // 마지막 진료가 완료 상태면 전체 완료
                                newState = TreatmentState.COMPLETED;
                            } else if (latestRecordStatus === 'NONE') {
                                // 마지막 진료가 NONE 상태면 진료 전
                                newState = TreatmentState.WAITING;
                            } else {
                                // 그렇지 않으면 진행 중
                                newState = TreatmentState.IN_PROGRESS;
                            }
                        } else {
                            // 진료 기록이 없는 경우 대기 중
                            newState = TreatmentState.WAITING;
                        }
                    } else if (recordsResult.success && recordsResult.hasTreatment) {
                        // 취소 없이 진료 기록이 있는 경우
                        isCancelled = false;
                        
                        if (latestRecordStatus === 'COMPLETED') {
                            // 마지막 진료가 완료 상태면 전체 완료
                            newState = TreatmentState.COMPLETED;
                        } else if (latestRecordStatus === 'NONE') {
                            // 마지막 진료가 NONE 상태면 진료 전
                            newState = TreatmentState.WAITING;
                        } else {
                            // 그렇지 않으면 진행 중 (추가 진료 가능)
                            newState = TreatmentState.IN_PROGRESS;
                        }
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
                        isCancelled,
                        latestTreatmentStatus: latestRecordStatus // 디버깅 및 UI 표시용으로 추가
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
    
    // 정렬 기준 변경
    const changeSortBy = (newSortBy: SortBy) => {
      if (sortBy === newSortBy) {
        // 이미 선택된 기준이면 기본 정렬(상태)로 초기화
        setSortBy('state');
      } else {
        // 새로운 정렬 기준 적용
        setSortBy(newSortBy);
      }
    };
    
    // 날짜 필터 적용
    const applyDateFilter = () => {
      // 시작일이 종료일보다 뒤인 경우 확인
      if (dateRange.start && dateRange.end && new Date(dateRange.start) > new Date(dateRange.end)) {
        setDateError('시작일은 종료일보다 빠른 날짜여야 합니다.');
        return;
      }
      
      setDateError(null);
      setIsFilterApplied(true);
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

      // 상태에 따른 필터링 (상태별 포함/제외)
      filteredPets = filteredPets.filter(pet => {
        const state = pet.calculatedState || (pet.agreementInfo ? TreatmentState.SHARED : pet.state);
        
        // 진료완료 상태 필터링
        if (state === TreatmentState.COMPLETED && !showCompleted) {
          return false; // 진료완료 숨김
        }
        
        // 진료취소 상태 필터링
        if (state === TreatmentState.CANCELLED && !showCancelled) {
          return false; // 진료취소 숨김
        }
        
        return true; // 나머지 상태는 항상 표시
      });

      // 날짜 범위로 필터링
      if (isFilterApplied && (dateRange.start || dateRange.end)) {
        filteredPets = filteredPets.filter(pet => {
          const createdAtValue = pet.agreementInfo?.createdAt || pet.createdAt;
          if (!createdAtValue) return false;
          
          // createdAt 값을 Date 객체로 변환
          let petDate: Date;
          
          if (typeof createdAtValue === 'number') {
            // Unix 타임스탬프(초 단위)인 경우 1000을 곱해 밀리초로 변환
            petDate = new Date(createdAtValue * 1000);
          } else if (typeof createdAtValue === 'string') {
            // ISO 문자열인 경우 직접 Date 객체로 변환
            petDate = new Date(createdAtValue);
          } else {
            console.error('Unexpected createdAt format:', createdAtValue);
            return false;
          }
          
          // 시작일과 종료일 Date 객체 생성
          const startDate = dateRange.start ? new Date(dateRange.start) : null;
          const endDate = dateRange.end ? new Date(dateRange.end) : null;
          
          // 날짜 범위 필터링
          if (startDate && endDate) {
            // 종료일은 해당 일의 마지막 시간으로 설정 (23:59:59.999)
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

      // 정렬 기준에 따라 정렬
      let sortedPets: Treatment[];
      
      switch (sortBy) {
        case 'name':
          // 이름 기준 정렬
          sortedPets = [...filteredPets].sort((a, b) => {
            const nameA = a.name.toLowerCase();
            const nameB = b.name.toLowerCase();
            
            if (sortDirection === 'asc') {
              return nameA.localeCompare(nameB);
            } else {
              return nameB.localeCompare(nameA);
            }
          });
          break;
          
        case 'date':
          // 접수일 기준 정렬
          sortedPets = [...filteredPets].sort((a, b) => {
            // 값 자체를 비교하는 대신 Date 객체를 생성하여 비교
            const dateAValue = a.agreementInfo?.createdAt || a.createdAt || 0;
            const dateBValue = b.agreementInfo?.createdAt || b.createdAt || 0;
            
            let dateATime: number;
            let dateBTime: number;
            
            // dateAValue가 숫자(Unix 타임스탬프)인 경우 1000을 곱해 밀리초로 변환
            if (typeof dateAValue === 'number') {
              dateATime = dateAValue * 1000;
            } else {
              dateATime = new Date(dateAValue).getTime();
            }
            
            // dateBValue가 숫자(Unix 타임스탬프)인 경우 1000을 곱해 밀리초로 변환
            if (typeof dateBValue === 'number') {
              dateBTime = dateBValue * 1000;
            } else {
              dateBTime = new Date(dateBValue).getTime();
            }
            
            if (sortDirection === 'asc') {
              return dateATime - dateBTime; // 오름차순 (과거 → 최신)
            } else {
              return dateBTime - dateATime; // 내림차순 (최신 → 과거)
            }
          });
          break;
          
        case 'state':
        default:
          // 상태와 접수일 기준으로 정렬 (기본 정렬)
          sortedPets = sortByStateAndDate(filteredPets);
          break;
      }
      
      return sortedPets;
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
        
        console.log('반려동물 목록 새로고침 시작...');
        
        // treatmentRecordService의 getHospitalPetsWithRecords 함수 사용
        const petsWithRecords = await getHospitalPetsWithRecords();
        
        if (petsWithRecords && petsWithRecords.length >= 0) {
          // 디버깅: 블록체인에서 받아온 원본 데이터 확인
          console.log('블록체인에서 받아온 반려동물 원본 데이터:', petsWithRecords);
          
          // 각 반려동물에 대해 공유 계약 정보 조회 및 처리
          const treatments = await Promise.all(
              petsWithRecords.map(async (pet, index) => {
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
                          // PetWithAgreement를 Treatment 형식으로 변환
                          const treatmentObj = convertPetToTreatment(petWithAgreement, index);
                          
                          // 의료 기록 정보 추가 (이미 getHospitalPetsWithRecords에서 가져온 정보)
                          return {
                              ...treatmentObj,
                              records: pet.records || [] // 추가: 의료 기록 정보
                          };
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
          
          // 디버깅 로그 추가
          console.log('블록체인 반려동물 목록 새로고침 완료. 처리된 항목 수:', validTreatments.length);
          
          // 정렬된 상태로 저장
          const sortedTreatments = sortByStateAndDate(updatedTreatments);
          
          // 상태 업데이트
          setBlockchainPets(sortedTreatments);
          hasLoadedData.current = true;
          
          // 상위 컴포넌트로 블록체인 반려동물 목록 전달
          if (onBlockchainPetsLoad) {
            onBlockchainPetsLoad(sortedTreatments);
          }
        } else {
          setError('반려동물 목록을 가져오는데 실패했습니다.');
        }
      } catch (err: any) {
        console.error('반려동물 목록 가져오기 오류:', err);
        setError(err.message || '반려동물 목록을 가져오는 중 오류가 발생했습니다.');
      } finally {
        setIsLoading(false);
      }
    };

    // 특정 반려동물 상태 갱신 함수
    const refreshPetState = async (petDid: string) => {
      if (!petDid || !currentHospitalAddress.current) {
        console.warn('반려동물 ID 또는 병원 주소가 없습니다.');
        return;
      }
      
      try {
        // 해당 반려동물의 최신 정보 조회
        const petWithAgreement = await getPetWithAgreementInfo(
          petDid, 
          currentHospitalAddress.current
        );
        
        if (!petWithAgreement) {
          console.warn(`반려동물 정보 조회 실패(${petDid})`);
          return;
        }
        
        // Treatment 형식으로 변환
        const updatedPet = convertPetToTreatment(petWithAgreement, 0);
        
        // 진료 상태 계산
        const updatedPets = await updatePetTreatmentState([updatedPet]);
        const updatedPet2 = updatedPets[0];
        
        // 블록체인 펫 목록에서 해당 반려동물 찾아 교체
        setBlockchainPets(prev => {
          const index = prev.findIndex(p => p.petDid === petDid);
          if (index === -1) {
            console.log(`새로운 반려동물 정보 추가(${petDid})`);
            return sortByStateAndDate([...prev, updatedPet2]);
          } else {
            console.log(`기존 반려동물 정보 업데이트(${petDid})`);
            const newPets = [...prev];
            newPets[index] = updatedPet2;
            return sortByStateAndDate(newPets);
          }
        });
        
        console.log(`반려동물 상태 갱신 완료(${petDid}): ${updatedPet2.calculatedState}`);
      } catch (error) {
        console.error(`반려동물 상태 갱신 중 오류(${petDid}):`, error);
      }
    };
    
    // 외부에서 호출 가능한 함수들 노출
    useImperativeHandle(ref, () => ({
      // 전체 목록 새로고침
      fetchPetsData: async () => {
        await fetchPetsData();
      },
      
      // 특정 반려동물 상태 갱신
      refreshPetState: async (petDid: string) => {
        await refreshPetState(petDid);
      }
    }));
    
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
                  새로고침
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
                <div className="flex flex-col gap-2">
                  <div className="flex items-center gap-2">
                  <input
                  type="date"
                      value={dateRange.start}
                      onChange={(e) => setDateRange(prev => ({ ...prev, start: e.target.value }))}
                      className={`text-xs py-1 px-2 bg-gray-50 border rounded-md flex-1 ${dateError ? 'border-red-500' : ''}`}
                      placeholder="시작일"
                    />
                    <span className="text-xs text-gray-500">~</span>
                  <input
                  type="date"
                      value={dateRange.end}
                      onChange={(e) => setDateRange(prev => ({ ...prev, end: e.target.value }))}
                      className={`text-xs py-1 px-2 bg-gray-50 border rounded-md flex-1 ${dateError ? 'border-red-500' : ''}`}
                      placeholder="종료일"
                  />
              </div>

                  {/* 버튼 그룹 */}
                  <div className="flex items-center gap-2">
                    {/* 기간 검색 버튼 */}
                    <button
                      onClick={applyDateFilter}
                      className={`flex-1 h-[26px] text-xs px-2 py-1 rounded-md flex items-center justify-center gap-1 ${
                        isFilterApplied 
                          ? 'bg-primary-100 text-primary-700' 
                          : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
                      }`}
                      title="기간 검색"
                    >
                      <FaSearch className="h-3 w-3" />
                      <span>기간 검색</span>
                    </button>
                    
                    {/* 기간 설정 초기화 버튼 */}
                    <button
                      onClick={() => {
                        setDateRange({ start: '', end: '' });
                        setIsFilterApplied(false);
                        setDateError(null);
                      }}
                      className="flex-1 h-[26px] text-xs px-2 py-1 rounded-md bg-gray-100 text-gray-700 hover:bg-gray-200 flex items-center justify-center gap-1"
                      title="기간 설정 초기화"
                    >
                      <FaTimesCircle className="h-3 w-3" />
                      <span>기간 설정 초기화</span>
                    </button>
                  </div>
                </div>
                {/* 날짜 에러 메시지 */}
                {dateError && (
                  <p className="text-xs text-red-500 mt-1">{dateError}</p>
                )}
              </div>
              
              {/* 정렬 버튼 그룹 */}
              <div className="flex items-center gap-2 mb-3">
                <span className="text-xs font-medium text-gray-700 mr-1">정렬:</span>
                
                {/* 이름 정렬 버튼 */}
                <button
                  onClick={() => changeSortBy('name')}
                  className={`text-xs px-2 py-1 rounded flex items-center ${
                    sortBy === 'name' 
                      ? 'bg-primary-100 text-primary-700' 
                      : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
                  }`}
                  title="이름 기준 정렬"
                >
                  <FaFont className="h-3 w-3 mr-1" /> 이름
                </button>
                
                {/* 접수일 정렬 버튼 */}
                <button
                  onClick={() => changeSortBy('date')}
                  className={`text-xs px-2 py-1 rounded flex items-center ${
                    sortBy === 'date' 
                      ? 'bg-primary-100 text-primary-700' 
                      : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
                  }`}
                  title="접수일 기준 정렬"
                >
                  <FaCalendarAlt className="h-3 w-3 mr-1" /> 접수일
                </button>
                
                {/* 정렬 방향 토글 버튼 */}
                <button
                  onClick={toggleSortDirection}
                  disabled={sortBy === 'state'}
                  className={`text-xs px-2 py-1 rounded flex items-center ${
                    sortBy !== 'state'
                      ? 'bg-gray-100 text-gray-700 hover:bg-gray-200' 
                      : 'bg-gray-50 text-gray-400 cursor-not-allowed'
                  }`}
                  title={sortDirection === 'asc' ? '오름차순' : '내림차순'}
                >
                  {sortDirection === 'asc' ? (
                    <><FaSortAmountUp className="h-3 w-3 mr-1" /> 오름차순</>
                  ) : (
                    <><FaSortAmountDown className="h-3 w-3 mr-1" /> 내림차순</>
                  )}
                </button>
              </div>
          </div>

          {/* 제목과 토글 버튼 */}
          <div className="flex justify-between items-center mb-3">
            <h2 className="font-semibold text-gray-700">
              목록 
              <span className="text-xs font-normal text-gray-500 ml-1">
                ({filteredAndSortedPets.length}건)
              </span>
            </h2>
            
            {/* 상태 표시 토글 버튼 */}
            <div className="flex items-center gap-3">
              {/* 진료완료 포함 */}
              <div className="flex items-center">
                <span className="text-xs text-gray-600 mr-1">진료완료</span>
                <label className="relative inline-block w-8 h-4" title="진료완료 상태 포함/제외">
                  <input
                    type="checkbox"
                    className="opacity-0 w-0 h-0"
                    checked={showCompleted}
                    onChange={() => setShowCompleted(prev => !prev)}
                  />
                  <span
                    className={`absolute cursor-pointer top-0 left-0 right-0 bottom-0 rounded-full transition-colors duration-300 ease-in-out 
                      ${showCompleted ? 'bg-primary-500' : 'bg-gray-300'}`}
                  >
                    <span
                      className={`absolute left-0.5 top-0.5 bg-white w-3 h-3 rounded-full transition-transform duration-300 ease-in-out 
                        ${showCompleted ? 'translate-x-4' : 'translate-x-0'}`}
                    ></span>
                  </span>
                </label>
              </div>
              
              {/* 진료취소 포함 */}
              <div className="flex items-center">
                <span className="text-xs text-gray-600 mr-1">진료취소</span>
                <label className="relative inline-block w-8 h-4" title="진료취소 상태 포함/제외">
                  <input
                    type="checkbox"
                    className="opacity-0 w-0 h-0"
                    checked={showCancelled}
                    onChange={() => setShowCancelled(prev => !prev)}
                  />
                  <span
                    className={`absolute cursor-pointer top-0 left-0 right-0 bottom-0 rounded-full transition-colors duration-300 ease-in-out 
                      ${showCancelled ? 'bg-primary-500' : 'bg-gray-300'}`}
                  >
                    <span
                      className={`absolute left-0.5 top-0.5 bg-white w-3 h-3 rounded-full transition-transform duration-300 ease-in-out 
                        ${showCancelled ? 'translate-x-4' : 'translate-x-0'}`}
                    ></span>
                  </span>
                </label>
              </div>
            </div>
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
          <div className="flex flex-col gap-3 overflow-y-auto max-h-[calc(100vh-370px)]">
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
});

export default TreatmentSidebar;

