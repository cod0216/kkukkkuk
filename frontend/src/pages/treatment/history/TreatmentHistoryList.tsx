import { useState, useEffect, forwardRef, useImperativeHandle, useMemo, useRef } from 'react';
import RecordItem from '@/pages/treatment/history/RecordItem';
import RecordDetail from '@/pages/treatment/history/RecordDetail';
import RecordEditForm from '@/pages/treatment/form/RecordEditForm';
import RecordByOwnerEditForm from '@/pages/treatment/form/RecordByOwnerEditForm';
import { BlockChainRecord } from '@/interfaces';
import { getLatestPetRecords } from '@/services/treatmentRecordService';
import { getAccountAddress, getContractAddresses } from '@/services/blockchainAuthService';
import { getDoctors } from '@/services/doctorService';
import { Doctor } from '@/interfaces';
import { ResponseStatus } from '@/types';

/**
 * 정렬 기준 타입
 */
type SortField = 'timestamp' | 'diagnosis' | 'hospitalName' | 'doctorName';

/**
 * 정렬 방향 타입
 */
type SortDirection = 'asc' | 'desc';

/**
 * @module TreatmentHistoryList
 * @file TreatmentHistoryList.tsx
 * @author haelim
 * @date 2025-03-26
 * @author seonghun
 * @date 2025-03-28
 * @description 반려동물 의료 기록의 목록을 조회하는 UI 컴포넌트 
 * 
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-26        haelim           최초 생성
 * 2025-03-28        seonghun         블록체인 서비스 연동
 * 2025-04-01        seonghun         인덱스 기반 선택에서 ID 기반 선택으로 변경
 * 2025-04-02        seonghun         정렬 기능 추가, 상태에 따른 RecordItem 표시 개선
 */

/**
 * TreatmentHistoryList 컴포넌트의 Props 타입 정의
 * @param setSelectedRecordId Detail 을 보여줄 의료 기록의 ID
 * @param selectedPetDid 상위 컴포넌트에서 선택된 반려동물의 DID
 */
interface TreatmentHistoryListProps {
  setSelectedRecordId?: (id: string) => void;
  selectedPetDid?: string; // 상위 컴포넌트에서 선택된 반려동물 DID
}

/**
 * 병원이 접근 가능한 반려동물 정보 인터페이스
 */
interface HospitalPet {
  petDID: string;
  name: string;
  birth?: string;
  gender?: string;
  breed?: string;
  records: BlockChainRecord[];
}

/**
 * 외부에서 접근 가능한 함수들의 타입 정의
 */
export interface TreatmentHistoryListRef {
  refreshRecords: () => Promise<void>;
}

/**
 * 반려동물 의료 기록의 목록을 조회하는 UI 컴포넌트 
*/
const TreatmentHistoryList = forwardRef<TreatmentHistoryListRef, TreatmentHistoryListProps>(({ 
  setSelectedRecordId: parentSetSelectedRecordId = () => {},
  selectedPetDid
}, ref) => {
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);
  const [hospitalPets, setHospitalPets] = useState<HospitalPet[]>([]);
  const [blockchainRecords, setBlockchainRecords] = useState<BlockChainRecord[]>([]);
  const [currentUserAddress, setCurrentUserAddress] = useState<string | null>(null);
  const [didRegistryAddress, setDidRegistryAddress] = useState<string>('');
  const [selectedRecordId, setSelectedRecordId] = useState<string>('');
  const [sortField, setSortField] = useState<SortField>('timestamp');
  const [sortDirection, setSortDirection] = useState<SortDirection>('desc');
  const [showOnlyMyHospitalRecords, setShowOnlyMyHospitalRecords] = useState<boolean>(false);
  const [myHospitalAddress, setMyHospitalAddress] = useState<string | null>(null);
  const [searchQuery, setSearchQuery] = useState<string>('');
  const [currentPage, setCurrentPage] = useState<number>(1);
  const [itemsPerPage, setItemsPerPage] = useState<number>(10);
  
  // 수정 모드 상태
  const [editingRecord, setEditingRecord] = useState<BlockChainRecord | null>(null);
  const [isEditSuccess, setIsEditSuccess] = useState<boolean>(false);
  const [editError, setEditError] = useState<string | null>(null);
  
  // 의사 목록
  const [doctors, setDoctors] = useState<Doctor[]>([]);
  
  // 선택된 반려동물 DID 변경 추적을 위한 ref
  const prevPetDidRef = useRef<string | undefined>(undefined);
  const prevHospitalPetsLengthRef = useRef<number>(0);
  
  // 정렬 방향 토글 핸들러
  const toggleSort = (field: SortField) => {
    if (sortField === field) {
      // 같은 필드를 다시 클릭하면 정렬 방향만 전환
      setSortDirection(prev => prev === 'asc' ? 'desc' : 'asc');
    } else {
      // 다른 필드를 클릭하면 해당 필드를 기준으로 기본 내림차순 정렬(최신순)
      setSortField(field);
      // timestamp는 기본이 내림차순(최신순), 나머지는 기본이 오름차순
      setSortDirection(field === 'timestamp' ? 'desc' : 'asc');
    }
  };
  
  // 정렬된 의료 기록 목록 계산
  const sortedRecords = useMemo(() => {
    // 취소된 진료 기록(진단명에 CANCELED 포함)과 삭제된 기록(isDeleted가 true) 필터링
    let filteredRecords = blockchainRecords.filter(record => 
      (!record.diagnosis || !record.diagnosis.includes('CANCELED')) && 
      !record.isDeleted
    );
    
    // 검색어로 진단명 필터링
    if (searchQuery.trim() !== '') {
      filteredRecords = filteredRecords.filter(record => 
        record.diagnosis && record.diagnosis.toLowerCase().includes(searchQuery.toLowerCase())
      );
    }
    
    // '우리 병원 기록만 보기' 필터링 개선
    if (showOnlyMyHospitalRecords && myHospitalAddress) {
      filteredRecords = filteredRecords.filter(record => {
        // 1. 일반적인 hospitalAddress 비교 (대소문자 무시)
        if (record.hospitalAddress && 
            record.hospitalAddress.toLowerCase() === myHospitalAddress.toLowerCase()) {
          return true;
        }
        
        // 2. ID에서 주소 추출하여 비교 (hospitalAddress가 없는 경우)
        if (!record.hospitalAddress && record.id && record.id.includes('_')) {
          const parts = record.id.split('_');
          if (parts.length >= 3) {
            const addressFromId = parts[parts.length - 1];
            return addressFromId.toLowerCase() === myHospitalAddress.toLowerCase();
          }
        }
        
        return false;
      });
    }
    
    // 현재 선택된 기록이 필터링으로 제거된 경우, 첫 번째 기록 선택
    if (selectedRecordId && filteredRecords.length > 0) {
      const recordExists = filteredRecords.some(record => record.id === selectedRecordId);
      if (!recordExists) {
        const firstRecordId = filteredRecords[0].id;
        if (firstRecordId) {
          setTimeout(() => setSelectedRecordId(firstRecordId), 0);
        }
      }
    }
    
    // 정렬 적용
    return [...filteredRecords].sort((a, b) => {
      let compared = 0;
      
      switch (sortField) {
        case 'timestamp':
          compared = a.timestamp - b.timestamp;
          break;
        case 'diagnosis':
          compared = (a.diagnosis || '').localeCompare(b.diagnosis || '');
          break;
        case 'hospitalName':
          compared = (a.hospitalName || '').localeCompare(b.hospitalName || '');
          break;
        case 'doctorName':
          compared = (a.doctorName || '').localeCompare(b.doctorName || '');
          break;
        default:
          compared = 0;
      }
      
      // 정렬 방향에 따라 비교 결과 반전
      return sortDirection === 'asc' ? compared : -compared;
    });
  }, [blockchainRecords, sortField, sortDirection, selectedRecordId, showOnlyMyHospitalRecords, myHospitalAddress, searchQuery]);
  
  // 선택된 기록 ID 변경 추적
  useEffect(() => {
    console.log('선택된 기록 ID 변경:', selectedRecordId);
    
    // 선택된 기록 ID로 해당 기록 찾기
    if (selectedRecordId) {
      const record: BlockChainRecord | undefined = blockchainRecords.find(r => r.id === selectedRecordId) ||
                   sortedRecords.find(r => r.id === selectedRecordId);
      
      if (record) {
        console.log('선택된 기록 정보:', {
          id: record.id,
          diagnosis: record.diagnosis,
          isOriginal: record.id?.startsWith('medical_record_'),
          hasId: !!record.id
        });
      } else {
        console.warn('선택된 ID에 해당하는 기록을 찾을 수 없음:', selectedRecordId);
      }
    }
  }, [selectedRecordId, blockchainRecords, sortedRecords]);
  
  // 컨트랙트 주소 가져오기
  useEffect(() => {
    try {
      const addresses = getContractAddresses();
      if (addresses && addresses.didRegistry) {
        setDidRegistryAddress(addresses.didRegistry);
      } else {
        console.warn('DID 레지스트리 주소를 가져올 수 없습니다. 기본값을 사용합니다.');
      }
    } catch (error) {
      console.error('컨트랙트 주소 가져오기 오류:', error);
    }
  }, []);
  
  // MetaMask 계정 정보 가져오기
  useEffect(() => {
    const fetchUserAddress = async () => {
      const address = await getAccountAddress();
      setCurrentUserAddress(address);
      setMyHospitalAddress(address);
    };
    
    fetchUserAddress();
  }, []);
  
  // 의사 목록 불러오기
  useEffect(() => {
    const fetchDoctors = async () => {
      try {
        const response = await getDoctors();
        if (response.status === ResponseStatus.SUCCESS && response.data) {
          setDoctors(response.data);
        }
      } catch (error) {
        console.error('의사 목록을 불러오는 중 오류가 발생했습니다:', error);
      }
    };
    
    fetchDoctors();
  }, []);
  
  // 병원이 접근 가능한 반려동물 목록 조회
  useEffect(() => {
    // 계정 정보와 컨트랙트 주소가 준비되면 반려동물 목록 조회
    if (currentUserAddress && didRegistryAddress) {
      fetchHospitalPets();
    }
  }, [currentUserAddress, didRegistryAddress, selectedPetDid]);
  
  // 상위 컴포넌트에서 선택된 반려동물이 변경될 때 해당 반려동물의 의료 기록을 불러옵니다
  useEffect(() => {
    if (selectedPetDid && hospitalPets.length > 0) {
      // 반려동물 DID로 인덱스 찾기
      const petIndex = hospitalPets.findIndex(pet => pet.petDID === selectedPetDid);
      
      if (petIndex !== -1) {
        const petRecords = hospitalPets[petIndex].records;
        
        // 해당 반려동물의 의료 기록 표시
        setBlockchainRecords(petRecords);
        
        // 의료 기록이 있는 경우
        if (petRecords.length > 0) {
          // 현재 선택된 id가 새 레코드 목록에 없는 경우에만 첫 번째 레코드 선택
          const recordExists = selectedRecordId && petRecords.some(record => record.id === selectedRecordId);
          if (!recordExists) {
            const firstRecordId = petRecords[0].id;
            if (firstRecordId) {
              setSelectedRecordId(firstRecordId);
            }
          }
        } else {
          // 레코드가 없는 경우 선택 초기화
          setSelectedRecordId('');
        }
      } else {
        // 해당 반려동물이 없는 경우도 기록 초기화
        setBlockchainRecords([]);
        setSelectedRecordId('');
      }
      
      // 기록이 변경되면 페이지를 1페이지로 초기화 (조건부)
      // 1. 반려동물이 변경되었거나
      // 2. 반려동물 목록의 길이가 변경되었을 때만 페이지 초기화
      const petDidChanged = prevPetDidRef.current !== selectedPetDid;
      const hospitalPetsChanged = prevHospitalPetsLengthRef.current !== hospitalPets.length;
      
      if (petDidChanged || hospitalPetsChanged) {
        console.log('반려동물 변경 또는 목록 변경으로 인한 페이지 초기화');
        setCurrentPage(1);
      }
      
      // 현재 값을 이전 값으로 저장
      prevPetDidRef.current = selectedPetDid;
      prevHospitalPetsLengthRef.current = hospitalPets.length;
    } else if (!selectedPetDid) {
      // 선택된 반려동물이 없으면 빈 기록 설정
      setBlockchainRecords([]);
      setSelectedRecordId('');
    }
  }, [selectedPetDid, hospitalPets, selectedRecordId]);
  
  // 선택된 id가 변경될 때만 상위 컴포넌트에 알림
  useEffect(() => {
    // 선택된 ID가 유효한 경우에만 상위 컴포넌트에 전달
    if (selectedRecordId) {
      // 정렬된 기록이나 전체 기록 중에 존재하면 상위 컴포넌트에 알림
      const existsInSorted = sortedRecords.some(record => record.id === selectedRecordId);
      const existsInAll = blockchainRecords.some(record => record.id === selectedRecordId);
      
      if (existsInSorted || existsInAll) {
        console.log('상위 컴포넌트에 선택된 ID 전달:', selectedRecordId);
        parentSetSelectedRecordId(selectedRecordId);
      } else {
        console.warn('유효하지 않은 ID가 선택됨:', selectedRecordId);
      }
    }
  }, [selectedRecordId, sortedRecords, blockchainRecords, parentSetSelectedRecordId]);
  
  const fetchHospitalPets = async () => {
    setLoading(true);
    setError(null);
    
    try {
      const response = await getLatestPetRecords();
      
      if (response.success) {
        console.log('받아온 반려동물 데이터:', response.pets);
        
        // 모든 기록 ID 확인 및 필요하면 ID 생성
        response.pets.forEach(pet => {
          if (pet.records && Array.isArray(pet.records)) {
            pet.records.forEach((record: BlockChainRecord, index: number) => {
              // ID가 없는 기록에 임시 ID 할당
              if (!record.id) {
                const timestamp = record.timestamp || Math.floor(Date.now() / 1000);
                const diagnosisHash = record.diagnosis ? 
                  record.diagnosis.split('').reduce((acc: number, char: string) => acc + char.charCodeAt(0), 0) : 
                  0;
                const tempId = `temp_${timestamp}_${diagnosisHash}_${index}`;
                console.log(`반려동물(${pet.name})의 기록에 임시 ID 할당:`, tempId, record.diagnosis);
                record.id = tempId;
              }
            });
          }
        });
        
        // 모든 기록 ID 확인 (디버깅용)
        const allRecordIds = response.pets
          .flatMap(pet => pet.records.map((record: BlockChainRecord) => ({ 
            id: record.id, 
            isOriginal: record.id?.startsWith('medical_record_'),
            hasId: !!record.id,
            petName: pet.name
          })));
        console.log('전체 기록 ID 현황:', allRecordIds);
        
        setHospitalPets(response.pets);
        
        // selectedPetDid가 있을 때만 해당 반려동물의 기록을 표시
        if (selectedPetDid && response.pets.length > 0) {
          // 선택된 반려동물 찾기
          const selectedPet = response.pets.find(pet => pet.petDID === selectedPetDid);
          if (selectedPet) {
            console.log('선택된 반려동물의 기록:', selectedPet.records);
            setBlockchainRecords(selectedPet.records);
            
            // 기록이 있으면 첫 번째 기록 선택
            if (selectedPet.records.length > 0 && selectedPet.records[0].id) {
              console.log('첫 번째 기록 선택:', selectedPet.records[0].id);
              setSelectedRecordId(selectedPet.records[0].id);
            } else {
              console.log('기록이 없거나 첫 번째 기록에 ID가 없음');
              setSelectedRecordId('');
            }
          }
        } else {
          // 선택된 반려동물이 없으면 빈 기록 설정
          setBlockchainRecords([]);
          setSelectedRecordId('');
        }
      } else {
        setError(response.error || '반려동물 목록을 불러오는데 실패했습니다.');
        setHospitalPets([]);
      }
    } catch (err: any) {
      setError(err.message || '반려동물 목록을 불러오는 중 오류가 발생했습니다.');
      setHospitalPets([]);
    } finally {
      setLoading(false);
    }
  };
  
  // 기록 선택 핸들러
  const handleRecordSelect = (id: string) => {
    console.log('기록 선택 시도:', id);
    
    // 먼저 정렬된 기록에서 검색 (실제 화면에 표시된 기록에서 검색)
    const existsInSorted = sortedRecords.some(record => record.id === id);
    // 필요한 경우 전체 기록에서도 검색
    const existsInAll = blockchainRecords.some(record => record.id === id);
    
    console.log('선택한 기록 존재 여부:', { 
      existsInSorted, 
      existsInAll,
      id
    });
    
    if (id) {
      // 정렬된 기록이나 전체 기록 중에 존재하면 선택 (조건 완화)
      if (existsInSorted || existsInAll) {
        console.log('기록 선택 성공:', id);
        setSelectedRecordId(id);
        // 상위 컴포넌트 알림은 useEffect에서 처리됨
      } else {
        console.warn('존재하지 않는 기록 ID:', id);
      }
    }
  };
  
  // 기록 수정 모드 핸들러
  const handleEditRecord = (record: BlockChainRecord) => {
    setEditingRecord(record);
    setIsEditSuccess(false);
    setEditError(null);
  };
  
  // 수정 취소 핸들러
  const handleCancelEdit = () => {
    setEditingRecord(null);
    setIsEditSuccess(false);
    setEditError(null);
  };
  
  // 외부에서 호출 가능한 함수들 노출
  useImperativeHandle(ref, () => ({
    // 의료 기록 새로고침
    refreshRecords: async () => {
      await fetchHospitalPets();
    }
  }));

  // 취소되지 않은 유효한 기록이 있는지 확인하는 계산값 추가
  const validRecordsExist = useMemo(() => {
    // 취소된 진료 기록(진단명에 CANCELED 포함)과 삭제된 기록(isDeleted가 true) 제외한 유효한 기록이 있는지 확인
    return blockchainRecords.some(record => 
      (!record.diagnosis || !record.diagnosis.includes('CANCELED')) &&
      !record.isDeleted
    );
  }, [blockchainRecords]);

  // 알림 자동 사라짐 처리
  useEffect(() => {
    let timer: NodeJS.Timeout;
    
    if (isEditSuccess || editError) {
      timer = setTimeout(() => {
        if (isEditSuccess) setIsEditSuccess(false);
        if (editError) setEditError(null);
      }, 2000); // 2초 후 사라짐 (0.5초는 너무 빨라서 2초로 설정)
    }
    
    return () => {
      if (timer) clearTimeout(timer);
    };
  }, [isEditSuccess, editError]);

  // 페이지네이션된 의료 기록 목록 계산
  const paginatedRecords = useMemo(() => {
    const startIndex = (currentPage - 1) * itemsPerPage;
    const endIndex = startIndex + itemsPerPage;
    return sortedRecords.slice(startIndex, endIndex);
  }, [sortedRecords, currentPage, itemsPerPage]);

  // 총 페이지 수 계산
  const totalPages = useMemo(() => {
    return Math.ceil(sortedRecords.length / itemsPerPage);
  }, [sortedRecords, itemsPerPage]);

  // 페이지 이동 함수
  const goToPage = (page: number) => {
    if (page >= 1 && page <= totalPages) {
      setCurrentPage(page);
    }
  };

  // 이전/다음 페이지 이동 함수
  const goToPrevPage = () => {
    if (currentPage > 1) {
      setCurrentPage(prev => prev - 1);
    }
  };

  const goToNextPage = () => {
    if (currentPage < totalPages) {
      setCurrentPage(prev => prev + 1);
    }
  };

  // 페이지 번호 배열 생성 (최대 5개 표시)
  const pageNumbers = useMemo(() => {
    const pages = [];
    const maxVisiblePages = 5;
    
    // 시작 페이지와 끝 페이지 계산
    let startPage = Math.max(1, currentPage - Math.floor(maxVisiblePages / 2));
    let endPage = startPage + maxVisiblePages - 1;
    
    if (endPage > totalPages) {
      endPage = totalPages;
      startPage = Math.max(1, endPage - maxVisiblePages + 1);
    }
    
    for (let i = startPage; i <= endPage; i++) {
      pages.push(i);
    }
    
    return pages;
  }, [currentPage, totalPages]);

  return (
    <div className="flex flex-col md:flex-row flex-1 h-full gap-5">
      {/* 좌측: 의료 기록 목록 */}
      <div className="flex flex-col flex-1 h-full">
        <div className="flex-1 flex flex-col bg-white border border-gray-200 rounded-md h-full">
          {/* 헤더 및 정보 행 (고정 높이) */}
          <div className="flex-shrink-0">
            <div className="flex justify-between">
              <h3 className="font-bold text-gray-800 m-1 p-3">반려동물 진료 기록</h3>
            </div>
            
            {/* 반려동물 선택 UI */}
            {(blockchainRecords.length > 0 && (validRecordsExist || searchQuery.trim() !== '')) && (
              <div className="p-3 border-b">
                <div className="flex items-center justify-between mb-2">
                  <div className="flex items-center">
                    <div className="text-xs text-gray-500 mr-2">
                      총 {sortedRecords.length}개의 진료기록
                    </div>
                    
                    {/* 검색창 위치 변경 */}
                    <div className="relative">
                      <input
                        type="text"
                        className="w-40 pl-6 pr-6 py-0.5 text-xs border rounded-md focus:outline-none focus:ring-1 focus:ring-primary-500"
                        placeholder="진단명 검색..."
                        value={searchQuery}
                        onChange={(e) => setSearchQuery(e.target.value)}
                      />
                      <div className="absolute left-1.5 top-1/2 -translate-y-1/2">
                        <svg className="w-2.5 h-2.5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path>
                        </svg>
                      </div>
                      {searchQuery && (
                        <button
                          className="absolute right-1.5 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600"
                          onClick={() => setSearchQuery('')}
                        >
                          <svg className="w-2.5 h-2.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" d="M6 18L18 6M6 6l12 12"></path>
                          </svg>
                        </button>
                      )}
                    </div>
                  </div>
                  
                  <div className="flex items-center gap-2">
                    {/* 페이지당 항목 수 선택 */}
                    <div className="flex items-center gap-1">
                      <span className="text-xs text-gray-600">항목/페이지</span>
                      <select
                        className="text-xs border rounded p-0.5"
                        value={itemsPerPage}
                        onChange={(e) => {
                          setItemsPerPage(Number(e.target.value));
                          setCurrentPage(1); // 항목 수 변경 시 1페이지로 이동
                        }}
                      >
                        <option value={5}>5</option>
                        <option value={10}>10</option>
                        <option value={20}>20</option>
                        <option value={50}>50</option>
                      </select>
                    </div>
                    
                    <div className="flex items-center gap-1">
                      <span className="text-xs text-gray-600">우리 병원 기록만</span>
                      <label className="relative inline-block w-8 h-4" title="우리 병원 기록만 보기 On/Off">
                        <input
                          type="checkbox"
                          className="opacity-0 w-0 h-0"
                          checked={showOnlyMyHospitalRecords}
                          onChange={() => setShowOnlyMyHospitalRecords(prev => !prev)}
                          disabled={!myHospitalAddress}
                        />
                        <span
                          className={`absolute cursor-pointer top-0 left-0 right-0 bottom-0 bg-gray-300 rounded-full transition-colors duration-300 ease-in-out 
                            ${showOnlyMyHospitalRecords ? 'bg-primary-500' : 'bg-gray-300'}`}
                        >
                          <span
                            className={`absolute left-0.5 top-0.5 bg-white w-3 h-3 rounded-full transition-transform duration-300 ease-in-out 
                              ${showOnlyMyHospitalRecords ? 'translate-x-4' : 'translate-x-0'}`}
                          ></span>
                        </span>
                      </label>
                    </div>
                  </div>
                </div>
              </div>
            )}
            
            {/* 로딩 상태 표시 */}
            {loading && (
              <div className="p-4 text-center text-gray-500">
                진료 기록을 불러오는 중...
              </div>
            )}
            
            {/* 오류 상태 표시 */}
            {error && (
              <div className="p-4 text-center text-red-500">
                {error}
              </div>
            )}
            
            {/* 데이터가 없는 경우 - 실제 기록이 없거나 모두 취소된 경우 동일 메시지 표시 */}
            {!loading && !error && !selectedPetDid && hospitalPets.length > 0 && (
              <div className="p-4 text-center text-gray-500">
                선택한 반려동물의 진료기록이 여기에 표시됩니다.
              </div>
            )}
            
            {/* 검색 결과가 없을 때와 기록이 없을 때 분리 */}
            {!loading && !error && selectedPetDid && blockchainRecords.length > 0 && sortedRecords.length === 0 && searchQuery.trim() !== '' && (
              <div className="p-4 text-center text-gray-500">
                '{searchQuery}' 검색어에 맞는 진료기록이 없습니다.
              </div>
            )}
            
            {!loading && !error && selectedPetDid && blockchainRecords.length === 0 && (
              <div className="p-4 text-center text-gray-500">
                진료 기록이 없습니다.
              </div>
            )}
            
            {!loading && !error && hospitalPets.length === 0 && (
              <div className="p-4 text-center text-gray-500">
                병원에 등록된 반려동물이 없습니다.
              </div>
            )}
            
            {/* 취소 기록만 존재하고 다른 기록이 없는 경우 메시지 추가 */}
            {!loading && !error && selectedPetDid && blockchainRecords.length > 0 && !validRecordsExist && searchQuery.trim() === '' && (
              <div className="p-4 text-center text-gray-500">
                유효한 진료기록이 없습니다.
              </div>
            )}
          </div>
          
          {/* 의료 기록 목록 (스크롤 영역) */}
          {!loading && !error && sortedRecords.length > 0 && (
            <div className="flex-1 overflow-y-auto flex flex-col">
              <div className="flex-1">
                <RecordItem 
                  records={paginatedRecords}
                  onRecordSelect={handleRecordSelect}
                  selectedRecordId={selectedRecordId}
                  onSort={toggleSort}
                  sortField={sortField}
                  sortDirection={sortDirection}
                />
              </div>
              
              {/* 페이지네이션 UI */}
              {totalPages > 1 && (
                <div className="flex justify-center items-center py-3 border-t">
                  <button
                    className={`flex items-center px-2 py-1 text-xs rounded ${
                      currentPage === 1 ? 'text-gray-400 cursor-not-allowed' : 'text-primary-600 hover:bg-primary-50'
                    }`}
                    onClick={goToPrevPage}
                    disabled={currentPage === 1}
                  >
                    <svg className="w-3 h-3 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M15 19l-7-7 7-7"></path>
                    </svg>
                    이전
                  </button>
                  
                  <div className="flex mx-2">
                    {pageNumbers.map(page => (
                      <button
                        key={page}
                        className={`w-6 h-6 flex items-center justify-center text-xs mx-0.5 rounded-full ${
                          currentPage === page
                            ? 'bg-primary-500 text-white'
                            : 'text-gray-600 hover:bg-gray-100'
                        }`}
                        onClick={() => goToPage(page)}
                      >
                        {page}
                      </button>
                    ))}
                  </div>
                  
                  <button
                    className={`flex items-center px-2 py-1 text-xs rounded ${
                      currentPage === totalPages ? 'text-gray-400 cursor-not-allowed' : 'text-primary-600 hover:bg-primary-50'
                    }`}
                    onClick={goToNextPage}
                    disabled={currentPage === totalPages}
                  >
                    다음
                    <svg className="w-3 h-3 ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M9 5l7 7-7 7"></path>
                    </svg>
                  </button>
                </div>
              )}
            </div>
          )}
        </div>
      </div>
      
      {/* 통합된 RecordDetail - 상세 보기 모드일 때만 표시 */}
      {selectedRecordId && !editingRecord && (
        <div className="md:max-w-sm flex-shrink-0 mt-4 md:mt-0 h-[500px] md:h-[calc(100vh-216px)] relative">
          <div className="h-full overflow-auto">
            {(() => {
              // 먼저 현재 정렬된 기록에서 찾고, 없으면 전체 기록에서 찾음
              const record = sortedRecords.find(record => record.id === selectedRecordId) ||
                           blockchainRecords.find(record => record.id === selectedRecordId);
              
              // 디버깅: 레코드를 찾지 못하는 경우 로그 출력
              if (!record) {
                console.error('레코드를 찾을 수 없음:', { 
                  selectedRecordId, 
                  sortedRecordsCount: sortedRecords.length,
                  blockchainRecordsCount: blockchainRecords.length
                });
                return (
                  <div className="p-4 text-center text-red-500">
                    선택한 기록을 찾을 수 없습니다.
                  </div>
                );
              }
              
              // 취소된 기록(CANCELED)인 경우 표시하지 않음
              if (record.diagnosis?.includes('CANCELED')) {
                return (
                  <div className="p-4 text-center text-gray-500">
                    취소된 진료 기록입니다.
                  </div>
                );
              }
              
              // 상세 정보 표시
              return (
                <RecordDetail 
                  key={`record-detail-${selectedRecordId}`} 
                  record={record}
                  onEditRecord={handleEditRecord}
                  blockchainRecords={blockchainRecords}
                  selectedPetDid={selectedPetDid}
                />
              );
            })()}
          </div>
        </div>
      )}

      {/* 통합된 RecordEditForm - 편집 모드일 때만 표시 */}
      {editingRecord && (
        <div className="md:max-w-sm flex-shrink-0 mt-4 md:mt-0 h-[500px] md:h-[calc(100vh-216px)] relative">
          {(() => {
            // flagCertificated가 false인 경우 RecordByOwnerEditForm 사용
            if (editingRecord.flagCertificated === false) {
              return (
                <RecordByOwnerEditForm 
                  record={editingRecord}
                  onSave={async (_updatedRecord) => {
                    // 성공 후 처리: 목록 새로고침
                    await fetchHospitalPets();
                    // 편집 모드 종료
                    setEditingRecord(null);
                  }}
                  onCancel={handleCancelEdit}
                  petDid={selectedPetDid}
                />
              );
            }
            
            // 일반적인 경우 기존 RecordEditForm 사용
            return (
              <RecordEditForm 
                key={editingRecord.id}
                record={editingRecord}
                pictures={editingRecord.pictures}
                onSave={async (_updatedRecord) => {
                  // 기록 새로고침
                  await fetchHospitalPets();
                  
                  // 편집 모드 종료
                  setEditingRecord(null);
                }}
                onCancel={handleCancelEdit}
                doctors={doctors}
                petDid={selectedPetDid}
                blockchainRecords={blockchainRecords}
              />
            );
          })()}
          
          {/* 알림 메시지를 위한 고정 위치 컨테이너 - 가운데 정렬 및 너비 축소 */}
          <div className="absolute bottom-0 left-1/2 transform -translate-x-1/2 z-10 w-4/5 max-w-xs">
            {/* 성공 메시지 */}
            {isEditSuccess && (
              <div className="p-2 bg-green-50 border border-green-200 rounded-md text-xs text-green-600 shadow-md mb-2 text-center">
                진료 기록이 성공적으로 수정되었습니다.
              </div>
            )}
            
            {/* 오류 메시지 */}
            {editError && (
              <div className="p-2 bg-red-50 border border-red-200 rounded-md text-xs text-red-600 shadow-md mb-2 text-center">
                {editError}
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  );
});

export default TreatmentHistoryList;
